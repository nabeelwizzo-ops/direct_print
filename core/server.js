require("dotenv").config({
  path: require("path").join(__dirname, "../.env"),
});

const express = require("express");
const fs = require("fs");
const path = require("path");
const cors = require("cors");
const net = require("net");

const { ThermalPrinter, PrinterTypes } = require("node-thermal-printer");
//
const axios = require("axios");
// const sharp = require("sharp");
const { log } = require("console");




const app = express();
app.use(cors());
app.use(express.json());

app.use(express.urlencoded({ extended: true }));
// Get the root project directory (DIRECT_PRINT)
const projectRoot = path.join(__dirname, '..');

// Serve static files from 'public' directory
app.use(express.static(path.join(projectRoot, 'public')));


/* ===============================
   ENV
================================ */

const PORT = process.env.PORT || 3000;
const ENABLE_AUTH = process.env.ENABLE_AUTH === "true";

/* ===============================
   PATHS
================================ */

const ROOT = path.join(__dirname, "..");
const CONFIG = path.join(ROOT, "config");

const PRINTER_FILE = path.join(CONFIG, "printer.json");
const CLIENT_FILE = path.join(CONFIG, "clients.json");
const SERVER_ID_FILE = path.join(CONFIG, "server.id");

/* ===============================
   LOGS
================================ */

// let clients = [];

// wss.on("connection", (ws) => {
//   clients.push(ws);
//   ws.on("close", () => {
//     clients = clients.filter(c => c !== ws);
//   });
// });

// function sendLogToClients(message) {
//   clients.forEach(ws => {
//     ws.send(message);
//   });
// }

/* ===============================
   HELPERS
================================ */

function safeRead(file, fallback) {
  try {
    if (!fs.existsSync(file)) return fallback;
    return JSON.parse(fs.readFileSync(file, "utf8"));
  } catch {
    return fallback;
  }
}

function loadPrinters() {
  const data = safeRead(PRINTER_FILE, { printers: [] });
  return data.printers || [];
}

function loadClients() {
  const file = path.join(__dirname, "..", "config", "clients.json");

  try {
    if (!fs.existsSync(file)) return [];

    const raw = fs.readFileSync(file, "utf8").trim();
    if (!raw) return [];

    const parsed = JSON.parse(raw);

    // ✅ IMPORTANT: return ARRAY ONLY
    if (Array.isArray(parsed)) return parsed;
    if (parsed.clients && Array.isArray(parsed.clients)) {
      return parsed.clients;
    }

    return [];
  } catch (err) {
    console.error("loadClients error:", err.message);
    return [];
  }
}

function getServerId() {
  if (fs.existsSync(SERVER_ID_FILE)) {
    return fs.readFileSync(SERVER_ID_FILE, "utf8").trim();
  }
  const id = "srv-" + Math.random().toString(36).slice(2);
  fs.writeFileSync(SERVER_ID_FILE, id);
  return id;
}

const SERVER_ID = getServerId();

/* ===============================
   AUTH
================================ */

function authRequired(req, res, next) {
  if (!ENABLE_AUTH) return next();

  const id = req.headers["x-client-id"];
  const key = req.headers["x-print-key"];

  if (!id || !key) {
    return res.status(401).json({ error: "Client auth required" });
  }

  const clients = loadClients(); // ✅ now ALWAYS array

  const ok = clients.find(
    (c) => c.id === id && c.pin === key && c.enabled === true,
  );

  if (!ok) {
    return res.status(403).json({ error: "Invalid client" });
  }

  next();
}

/* ===============================
   PRINTER STATUS
================================ */

function isPrinterOnline(ip, port) {
  return new Promise((resolve) => {
    const socket = new net.Socket();
    socket.setTimeout(1500);
    socket.once("connect", () => {
      socket.destroy();
      resolve(true);
    });
    socket.once("error", () => resolve(false));
    socket.once("timeout", () => resolve(false));
    socket.connect(port, ip);
  });
}

/* ===============================
   API : PRINTERS
================================ */

app.get("/api/printers", async (req, res) => {
  const printers = loadPrinters();

  const result = await Promise.all(
    printers.map(async (p) => ({
      ...p,
      online: await isPrinterOnline(p.connection.ip, p.connection.port),
    })),
  );

  res.json({ printers: result });
});

/* ===============================
   PRINT ROUTE (AUTO MODE)
================================ */

// app.post("/print", authRequired, async (req, res) => {
//   try {
//     const printerId = req.headers["x-printer-id"];
//     if (!printerId) {
//       return res.status(400).json({ error: "x-printer-id missing" });
//     }

//     const printerCfg = loadPrinters().find(
//       (p) =>
//         p.enabled &&
//         (p.id.toLowerCase() === printerId.toLowerCase() ||
//           p.name?.toLowerCase() === printerId.toLowerCase())
//     );

//     if (!printerCfg) {
//       return res.status(404).json({ error: "Printer not found or disabled" });
//     }

//     const printer = new ThermalPrinter({
//       type: PrinterTypes.EPSON,
//       interface: `tcp://${printerCfg.connection.ip}:${printerCfg.connection.port}`,
//       timeout: 15000,
//     });

//     if (!(await printer.isPrinterConnected())) {
//       return res.status(500).json({ error: "Printer offline" });
//     }

//     const body = req.body || {};

//     /* ========= AUTO DETECT ========= */

//     // 1️⃣ INVOICE JSON
//     if (body.isInvoiceData?.isInvoice) {
//       await printInvoice(printer, body);
//       return res.json({ success: true, mode: "invoice" });
//     }

//     // 2️⃣ TEXT
//     if (body.text) {
//       printer.println(body.text);
//       printer.cut();
//       await printer.execute();
//       return res.json({ success: true, mode: "text" });
//     }

//     return res.status(400).json({
//       error: "Unsupported print payload",
//     });
//   } catch (err) {
//     console.error("PRINT ERROR:", err);
//     res.status(500).json({ error: err.message });
//   }
// });

// NEW TIME OUT

app.post("/print", authRequired, (req, res) => {
  const start = Date.now();

  console.log("\n========== /print START ==========");

  try {
    const printerId = req.headers["x-printer-id"];
    console.log("Printer ID:", printerId);

    if (!printerId) {
      console.log("❌ Missing x-printer-id");
      return res.status(400).json({ error: "x-printer-id missing" });
    }

    const printerCfg = loadPrinters().find(
      (p) =>
        p.enabled &&
        (p.id.toLowerCase() === printerId.toLowerCase() ||
          p.name?.toLowerCase() === printerId.toLowerCase()),
    );

    if (!printerCfg) {
      console.log("❌ Printer not found");
      return res.status(404).json({ error: "Printer not found or disabled" });
    }
      
    // ✅ RESPOND IMMEDIATELY
    res.json({
      success: true,
      message: "Print accepted",
      printer: printerCfg.id,
    });

    console.log("✅ HTTP response sent in", Date.now() - start, "ms");

    // 🔥 PRINT IN BACKGROUND
    processPrintJob(printerCfg, req.body);

    // processPrintJob2(printerCfg, req.body);
  } catch (err) {
    console.error("❌ API ERROR:", err);
  }
});



async function processPrintJob(printerCfg, body) {
  console.log("\n--- PRINT JOB START ---");

  try {
    /* ========= AUTO DETECT ========= */

    if (body.isInvoiceData?.isInvoice) {
      console.log("Mode: INVOICE");
      const printer = await createPrinter(printerCfg);
      if (!printer) return;
      await printInvoice(printer, body);
    } else if (body.isInvoiceData?.isKot) {
      // Handle ALL KOT cases with smart routing
      console.log("Mode: KOT ROUTING (KOT or ALL KOT or BOTH)");
      await routeKotToPrinters(body);
      return; // Return here since routeKotToPrinters handles its own printing
    } else if (body.text) {
      console.log("Mode: TEXT");
      const printer = await createPrinter(printerCfg);
      if (!printer) return;

      printer.println(body.text);
      printer.cut();
      await printer.execute();
    } else {
      console.log("❌ Unsupported payload", JSON.stringify(body, null, 2));
      return;
    }

    console.log("✅ PRINT SUCCESS");
  } catch (err) {
    console.error("❌ PRINT FAILED:", err.message);
  }

  console.log("--- PRINT JOB END ---\n");
}

// Helper function to create printer and check connection
async function createPrinter(printerCfg) {
  const printer = new ThermalPrinter({
    type: PrinterTypes.EPSON,
    interface: `tcp://${printerCfg.connection.ip}:${printerCfg.connection.port}`,
    options: { timeout: 15000 },
  });

  const connected = await printer.isPrinterConnected();
  console.log("Printer connected:", connected);

  if (!connected) {
    console.log("❌ Printer offline");
    return null;
  }

  return printer;
}

//-------------------------------------------------------------------------

/* ===============================
   INVOICE PRINTER
================================ */

function fmt(val, digits = 2) {
  const num = Number(val);
  return isNaN(num) ? Number(0).toFixed(digits) : num.toFixed(digits);
}

async function printInvoice(printer, data) {
  const {
    company = [],
    master = {},
    table = [],
    isInvoiceData = {},
    kotTableData = [],
  } = data;
  const comp = company[0] || {};

  const typ = data?.typ ?? "";
  const qr_data = data?.qrData ?? "";
  const logo = data?.logo ?? "";
  const bill_form = data?.bill_form ?? "SALES B2B";
  const lang_mode = data?.lang_mode ?? "ENGLISH";
  const tax_mode = data?.bill_form ?? "GST";

  printer.alignCenter();

  /* =========================
     LOGO PRINT
  ========================= */
  if (logo) {
    try {
      const logoPath = await downloadImage(logo);
      await printer.printImage(logoPath);
      printer.newLine();
    } catch (e) {
      console.error("Logo print failed:", e.message);
    }
  }

  printer.bold(true);
  printer.println(comp.Name || "COMPANY");
  printer.bold(false);

  if (comp.Place) printer.println(comp.Place);
  if (comp.Ph) printer.println("Ph: " + comp.Ph);

  printer.bold(true);
  if (bill_form === "SALES B2B") {
    printer.println("TAX INVOICE");
  } else if (bill_form === "SALES B2C") {
    printer.println("SIMPLIFIED TAX INVOICE");
  } else if (bill_form === "SALES RETURN") {
    printer.println("CREDIT NOTE");
  } else {
    printer.println("TAX INVOICE");
  }
  printer.bold(false);

  if (tax_mode === "GST") {
    if (comp.gst) printer.println("GST IN: " + comp.gst);
  } else {
    if (comp.gst) printer.println("VAT IN: " + comp.gst);
  }

  printer.drawLine();

  printer.alignLeft();
  printer.println("Bill No : " + (master.BillNo ?? ""));
  printer.println(
    "Date    : " + (master.BillDate || "") + " " + (master.BillTime || ""),
  );

  if (master.BillPartyName) {
    printer.println("Party   : " + master.BillPartyName);
  }
  // if (master.BillPartyName !== "Cash") {
  //   printer.println("Add: " + master.Address1, "");
  //   printer.println("Contact: " + master.Ph, "");
  //   printer.println("Tax-No: " + master.TinNo, "");
  // }
  // if (master.BillPartyName !== "3") {
  //   printer.println("Add: " + master.Address1, "");
  //   printer.println("Contact: " + master.Ph, "");
  //   printer.println("Tax-No: " + master.TinNo, "");
  // }


  if (master.BillPartyName !== "Cash" || master.BillPartyName !== "3") {
    printer.println("Add: " + master.Address1, "");
    printer.println("Contact: " + master.Ph, "");
    printer.println("Tax-No: " + master.TinNo, "");
  }
 

  printer.drawLine();

  printer.tableCustom([
    { text: "#", align: "LEFT", cols: 3, bold: true },
    {
      text: "Item Name",
      align: "LEFT",
      cols: 15,
      bold: true,
    },
    {
      text: "Qty",
      align: "CENTER",
      cols: 3,
      bold: true,
    },
    { text: "Rate", align: "RIGHT", cols: 9, bold: true },
    { text: "Tax-Amt", align: "RIGHT", cols: 9, bold: true },
    { text: "Net-Amt", align: "RIGHT", cols: 9, bold: true },
  ]);
  printer.drawLine();

  table.forEach((it, i) => {
    printer.tableCustom([
      { text: i + 1, cols: 3, align: "LEFT" },
      {
        text: String(it.ItemNameTextField || "").substring(0, 30),
        cols: 45,
        align: "LEFT",
      },
    ]);

    printer.tableCustom([
      { text: "", cols: 3 },
      { text: "", cols: 15 },
      { text: it.qty ?? 0, cols: 3, align: "CENTER" },
      { text: fmt(it.Rate1, 2), cols: 9, align: "RIGHT" },
      { text: fmt(it.taxAmt, 2), cols: 9, align: "RIGHT" },
      { text: fmt(it.total, 2), cols: 9, align: "RIGHT" },
    ]);
  });

  printer.drawLine();

  /* ===== TOTALS ===== */
  printer.leftRight("Sub Total", fmt(master.BillTotalField, 2));
  printer.leftRight("Discount", fmt(master.BillDiscAmtField, 2));
  printer.leftRight("Tax", fmt(master.TItTaxAmt, 2));
  printer.leftRight("Net Total", fmt(master.BillNetTotalField, 2));

  printer.drawLine();

  printer.bold(true);
  printer.alignRight();
  printer.println("NET TOTAL : " + fmt(master.BillNetTotalField, 2));
  printer.bold(false);

  printer.drawLine("-");

  /* =========================
       7. QR CODE (ZATCA / EINVOICE)
    ========================= */
  if (typ === "Direct Print 3Inch" && isInvoiceData?.isInvoice && qr_data) {
    printer.alignCenter();

    if (qr_data) {
      printer.printQR(qr_data, {
        cellSize: 6,
        correction: "M",
      });
    }

    printer.newLine();
  }
  /* =========================
       8. FOOTER
    ========================= */
  printer.alignCenter();
  printer.println("Thank you for shopping with us!");

  printer.newLine();
  printer.cut();
  printer.beep();
  printer.beep();
  printer.beep();

  await printer.execute();
}

// ALL KOT PRINT

async function all_kot_print(printer, data) {
  const { company = [], master = {}, kotTableData = [], logo = "" } = data;

  /* =========================
     LOGO (optional)
  ========================= */
  printer.alignCenter();

  if (logo) {
    try {
      const logoPath = await downloadImage(logo);
      await printer.printImage(logoPath);
      printer.newLine();
    } catch (e) {
      console.log("Logo print error:", e.message);
    }
  }

  /* =========================
     TITLE
  ========================= */
  printer.setTextDoubleHeight();
  printer.setTextDoubleWidth();
  printer.bold(true);
  printer.println("ALL KOT");
  printer.bold(false);
  printer.setTextNormal();

  printer.drawLine();

  /* =========================
     KOT NO + DATE (same line)
  ========================= */
  printer.tableCustom([
    {
      text: "KOT NO: " + (master.OrderNo ?? "0"),
      align: "LEFT",
      cols: 24,
    },
    {
      text: "Date: " + (master.BillDate || "") + " " + (master.BillTime || ""),
      align: "RIGHT",
      cols: 28,
    },
  ]);

  /* =========================
     STAFF & TABLE
  ========================= */
  printer.alignLeft();
  printer.println("STAFF: " + (master.Lorry || "NIL"));
  printer.println("TABLE NO: " + (master.table || "0"));

  printer.drawLine();

  /* =========================
     HEADER
     48 columns split: 3 | 37 | 8
  ========================= */
  printer.bold(true);
  printer.tableCustom([
    { text: "#", align: "LEFT", cols: 3 },
    { text: "Item Name", align: "LEFT", cols: 37 },
    { text: "Qty", align: "CENTER", cols: 8 },
  ]);
  printer.bold(false);

  printer.drawLine();

  /* =========================
     ITEMS (single row per item)
  ========================= */
  kotTableData.forEach((it, i) => {
    const nameLines = wrapText(String(it.itemname || ""), 37);

    nameLines.forEach((line, idx) => {
      printer.tableCustom([
        {
          text: idx === 0 ? String(i + 1) : "",
          align: "LEFT",
          cols: 3,
        },
        {
          text: line,
          align: "LEFT",
          cols: 37,
        },
        {
          text: idx === 0 ? String(it.qty ?? 0) : "",
          align: "CENTER",
          cols: 8,
        },
      ]);
    });
  });

  printer.drawLine();
  printer.newLine();

  /* =========================
     CUT + BEEP
  ========================= */
  printer.cut();
  printer.beep();
  printer.beep();

  // await printer.execute();
}

async function kot_print(printer, data) {
  const { company = [], master = {}, kotTableData = [], logo = "" } = data;

  /* =========================
     LOGO (optional)
  ========================= */
  printer.alignCenter();

  if (logo) {
    try {
      const logoPath = await downloadImage(logo);
      await printer.printImage(logoPath);
      printer.newLine();
    } catch (e) {
      console.log("Logo print error:", e.message);
    }
  }

  /* =========================
     TITLE
  ========================= */
  printer.setTextDoubleHeight();
  printer.setTextDoubleWidth();
  printer.bold(true);
  printer.println(" KOT ");
  printer.bold(false);
  printer.setTextNormal();

  printer.drawLine();

  /* =========================
     KOT NO + DATE (same line)
  ========================= */
  printer.tableCustom([
    {
      text: "KOT NO: " + (master.OrderNo ?? "0"),
      align: "LEFT",
      cols: 24,
    },
    {
      text: "Date: " + (master.BillDate || "") + " " + (master.BillTime || ""),
      align: "RIGHT",
      cols: 28,
    },
  ]);

  /* =========================
     STAFF & TABLE
  ========================= */
  printer.alignLeft();
  printer.println("STAFF: " + (master.Lorry || "NIL"));
  printer.println("TABLE NO: " + (master.table || "0"));

  printer.drawLine();

  /* =========================
     HEADER
     48 columns split: 3 | 37 | 8
  ========================= */
  printer.bold(true);
  printer.tableCustom([
    { text: "#", align: "LEFT", cols: 3 },
    { text: "Item Name", align: "LEFT", cols: 37 },
    { text: "Qty", align: "CENTER", cols: 8 },
  ]);
  printer.bold(false);

  printer.drawLine();

  /* =========================
     ITEMS (single row per item)
  ========================= */
  kotTableData.forEach((it, i) => {
    printer.tableCustom([
      {
        text: String(i + 1),
        align: "LEFT",
        cols: 3,
      },
      {
        text: String(it.itemname || "").substring(0, 37),
        align: "LEFT",
        cols: 37,
      },
      {
        text: String(it.qty ?? 0),
        align: "CENTER",
        cols: 8,
      },
    ]);
  });

  printer.drawLine();
  printer.newLine();

  /* =========================
     CUT + BEEP
  ========================= */
  printer.cut();
  printer.beep();
  printer.beep();

  // await printer.execute();
}

async function downloadImage(url) {
  const filePath = path.join(__dirname, "logo.png");

  const response = await axios({
    url,
    method: "GET",
    responseType: "stream",
  });

  await new Promise((resolve, reject) => {
    const stream = fs.createWriteStream(filePath);
    response.data.pipe(stream);
    stream.on("finish", resolve);
    stream.on("error", reject);
  });

  return filePath;
}

/*********************************
 * ARABIC IMAGE PRINT (WASM)
 *********************************/
// async function printArabicAsImage(printer, text) {
//   const svg = `
// <svg width="576" height="120" xmlns="http://www.w3.org/2000/svg">
//   <style>
//     text {
//       font-size: 28px;
//       font-family: Arial;
//       direction: rtl;
//       unicode-bidi: bidi-override;
//       fill: black;
//     }
//   </style>
//   <text x="560" y="70" text-anchor="end">${text}</text>
// </svg>
// `;

//   const img = await sharp(Buffer.from(svg)).png().toBuffer();

//   printer.alignCenter();
//   printer.printImageBuffer(img);
//   printer.cut();
//   await printer.execute();
// }

// function containsArabic(text = "") {
//   return /[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]/.test(text);
// }

//New

async function processPrintJob2(printerCfg, body) {
  console.log("\n--- PRINT JOB START ---");

  try {
    const printer = new ThermalPrinter({
      type: PrinterTypes.EPSON,
      interface: `tcp://${printerCfg.connection.ip}:${printerCfg.connection.port}`,
      options: { timeout: 15000 },
    });

    // ✅ SET ENCODING (CRITICAL)
    printer.removeSpecialCharacters(false);

    const connected = await printer.isPrinterConnected();
    console.log("Printer connected:", connected);

    if (!connected) {
      console.log("❌ Printer offline");
      return;
    }

    /* ========= AUTO DETECT ========= */

    if (body.isInvoiceData?.isInvoice) {
      console.log("Mode: INVOICE");
      await printInvoice(printer, body);
    } else if (body.text) {
      // Arabic → Image mode

      // if (containsArabic(body.text)) {
      //   await printArabicAsImage(printer, body.text);
      //   console.log("Mode: ARABIC IMAGE");
      //   return;
      // }

      console.log("Mode: TEXT");
      printer.println(body.text);
      printer.setCharacterSet("CP864");
      printer.println("السلام عليكم");
      printer.cut();
      await printer.execute();
    } else {
      console.log("❌ Unsupported payload");
      return;
    }

    console.log("✅ PRINT SUCCESS");
  } catch (err) {
    console.error("❌ PRINT FAILED:", err.message);
  }

  console.log("--- PRINT JOB END ---\n");
}

// --------------- TEST MULTPLE PRINT CASE---------------

app.post("/testprint", authRequired, (req, res) => {
  const start = Date.now();

  console.log("\n========== /testprint START ==========");

  try {
    const printerHeader = req.headers["x-printer-id"];

    if (!printerHeader) {
      return res.status(400).json({ error: "x-printer-id missing" });
    }

    // ✅ SUPPORT MULTIPLE PRINTERS
    const printerIds = printerHeader
      .split(",")
      .map((p) => p.trim().toLowerCase());

    const printers = loadPrinters().filter(
      (p) =>
        p.enabled &&
        (printerIds.includes(p.id.toLowerCase()) ||
          printerIds.includes(p.name?.toLowerCase())),
    );

    if (!printers.length) {
      return res.status(404).json({ error: "No matching printers found" });
    }

    // ✅ RESPOND IMMEDIATELY
    res.json({
      success: true,
      message: "Print accepted",
      printers: printers.map((p) => p.name),
    });

    console.log("✅ HTTP response sent in", Date.now() - start, "ms");

    // 🔥 PRINT IN BACKGROUND
    printers.forEach((printerCfg) => {
      test_processPrintJob(printerCfg, req.body);
    });
  } catch (err) {
    console.error("❌ API ERROR:", err);
  }
});

async function test_processPrintJob(printerCfg, body) {
  console.log(`\n--- PRINT JOB START (${printerCfg.name}) ---`);
  console.log(`--- ROLE: ${printerCfg.role} ---`);

  try {
    const printer = new ThermalPrinter({
      type: PrinterTypes.EPSON,
      interface: `tcp://${printerCfg.connection.ip}:${printerCfg.connection.port}`,
      options: { timeout: 15000 },
    });

    const connected = await printer.isPrinterConnected();
    console.log(`[${printerCfg.name}] Connected:`, connected);

    if (!connected) {
      console.log(`[${printerCfg.name}] ❌ Printer offline`);
      return;
    }

    // 🔀 ROLE BASED TEXT SELECTION
    let textToPrint = "";

    if (printerCfg.role === "CASHIER") {
      textToPrint = body.invoiceText;
    } else if (printerCfg.role === "KITCHEN") {
      textToPrint = body.kotText;
    }

    if (!textToPrint || typeof textToPrint !== "string") {
      console.log(
        `[${printerCfg.name}] ❌ No text for role ${printerCfg.role}`,
      );
      return;
    }

    printer.println(textToPrint);

    if (printerCfg.printSettings?.cut) {
      printer.cut();
    }

    await printer.execute();

    console.log(`[${printerCfg.name}] ✅ PRINT SUCCESS`);
  } catch (err) {
    console.error(`[${printerCfg.name}] ❌ PRINT FAILED:`, err.message);
  }

  console.log(`--- PRINT JOB END (${printerCfg.name}) ---\n`);
}

// WRAP TEXT-------

function wrapText(text, width) {
  const words = text.split(" ");
  const lines = [];
  let line = "";

  words.forEach((word) => {
    if ((line + word).length > width) {
      lines.push(line.trim());
      line = word + " ";
    } else {
      line += word + " ";
    }
  });

  if (line.trim()) lines.push(line.trim());
  return lines;
}

// PRINTER WISE PRINT  //


async function routeKotToPrinters(body) {
  console.log("🔀 Routing KOT by product printer...");

  body = attachPrinterToKotItems(body);

  const printerWiseItems = {};

  // Group by printer IP
  body.kotTableData.forEach((item) => {
    const ip = item.printer || item.printer_ip; // Try both fields

    if (!ip) {
      console.log("❌ No printer IP found for item:", item.itemname);
      return;
    }

    if (!printerWiseItems[ip]) {
      printerWiseItems[ip] = {
        items: [],
        printerCfg: findPrinterByIp(ip),
      };
    }

    printerWiseItems[ip].items.push(item);
  });

  // Print per printer
  for (const ip in printerWiseItems) {
    const { items, printerCfg } = printerWiseItems[ip];

    if (!printerCfg) {
      console.log("❌ No printer configuration found for IP:", ip);
      continue;
    }

    console.log(
      `🖨️ Printing ${items.length} items to ${printerCfg.name} (${ip})`,
    );

    try {
      const printer = await createPrinter(printerCfg);
      if (!printer) continue;

      const newBody = {
        ...body,
        kotTableData: items,
      };

      // When BOTH isKot AND isALLKot are true, print BOTH formats
      if (body.isInvoiceData?.isKot && body.isInvoiceData?.isALLKot) {
        console.log(`📋 Printing BOTH KOT + ALL KOT for ${printerCfg.name}`);

        // Print KOT format
        await kot_print(printer, newBody);

        // Add a separator between KOT and ALL KOT
        printer.drawLine();
        printer.newLine();

        // Print ALL KOT format
        await all_kot_print(printer, newBody);
      }
      // When only ALL KOT is true
      else if (body.isInvoiceData?.isALLKot) {
        console.log(`📋 Printing ALL KOT format for ${printerCfg.name}`);
        await all_kot_print(printer, newBody);
      }
      // When only KOT is true (or default case)
      else {
        console.log(`📋 Printing KOT format for ${printerCfg.name}`);
        await kot_print(printer, newBody);
      }

      await printer.execute();
      console.log(`✅ Printed successfully to ${printerCfg.name}`);
    } catch (err) {
      console.error(`❌ Failed to print to ${printerCfg.name}:`, err.message);
    }
  }
}

function findPrinterByIp(ip) {
  const printers = loadPrinters();

  return printers.find(
    (p) => p.enabled && p.role === "KITCHEN" && p.connection.ip === ip,
  );
}


function attachPrinterToKotItems(body) {
  const tableMap = {};

  // Map item name -> printer_ip from the table array
  if (body.table && Array.isArray(body.table)) {
    body.table.forEach((t) => {
      const itemName = (t.ItemNameTextField || "").trim();
      if (itemName && t.printer_ip) {
        tableMap[itemName] = t.printer_ip;
      }
    });
  }

  // Inject printer into kot items
  if (body.kotTableData && Array.isArray(body.kotTableData)) {
    body.kotTableData.forEach((k) => {
      const name = (k.itemname || "").trim();
      if (name && tableMap[name]) {
        k.printer = tableMap[name];
      } else {
        console.log(`⚠️ No printer found for item: ${name}`);
      }
    });
  }

  return body;
}



/* ===============================
   API : PRINTERS IN APP
================================ */

app.get("/api/printers_app", async (req, res) => {
  const printers = loadPrinters();

  const result = await Promise.all(
    printers.map(async (p) => ({
      ...p,
      online: await isPrinterOnline(p.connection.ip, p.connection.port),
    })),
  );

  res.json({ printers: result });
});


// app.post("/set_printer_app", authRequired, (req, res) => {
//   console.log("=== RAW REQUEST DEBUG ===");
//   console.log("Content-Type:", req.headers["content-type"]);
//   console.log("Raw body:", JSON.stringify(req.body, null, 2));
//   console.log("Is Array?", Array.isArray(req.body));
//   console.log("=======================");
  
//   try {
//     let printersData = [];
    
//     // Check if request body is an array
//     if (Array.isArray(req.body)) {
//       console.log("Received array of printers:", req.body.length);
//       printersData = req.body;
//     } else {
//       // Single printer (wrap in array)
//       console.log("Received single printer");
//       printersData = [req.body];
//     }
    
//     // Validate each printer in the array
//     const results = [];
//     const errors = [];
    
//     for (let i = 0; i < printersData.length; i++) {
//       const printer = printersData[i];
//       console.log(`Processing printer ${i + 1}:`, printer);
      
//       const { printerName, printerIp, role } = printer;
      
//       // Validate required fields for this printer
//       if (!printerName || !printerIp || !role) {
//         errors.push({
//           index: i,
//           error: "Missing required fields",
//           printer,
//           missing: {
//             printerName: !printerName,
//             printerIp: !printerIp,
//             role: !role
//           }
//         });
//         continue;
//       }
      
//       // Validate IP format
//       const ipRegex = /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/;
//       if (!ipRegex.test(printerIp)) {
//         errors.push({
//           index: i,
//           error: "Invalid IP address format",
//           printerIp
//         });
//         continue;
//       }
      
//       // Save/process the printer
//       // TODO: Your save logic here
      
//       results.push({
//         index: i,
//         status: "success",
//         printer: {
//           printerName,
//           printerIp,
//           role
//         }
//       });
      
//       console.log(`Printer ${i + 1} validated:`, printerName);
//     }
    
//     // Check if all printers failed
//     if (results.length === 0 && errors.length > 0) {
//       return res.status(400).json({
//         status: "error",
//         message: "All printers failed validation",
//         totalReceived: printersData.length,
//         errors: errors
//       });
//     }
    
//     // Mixed results (some success, some errors)
//     if (errors.length > 0) {
//       return res.status(207).json({  // 207 Multi-Status
//         status: "partial_success",
//         message: `Processed ${printersData.length} printers`,
//         summary: {
//           total: printersData.length,
//           successful: results.length,
//           failed: errors.length
//         },
//         results: results,
//         errors: errors
//       });
//     }
    
//     // All printers successful
//     res.json({
//       status: "success",
//       message: `Successfully processed ${printersData.length} printer(s)`,
//       total: printersData.length,
//       results: results.map(r => r.printer)
//     });
    
//   } catch (error) {
//     console.error("Error processing printers:", error);
//     res.status(500).json({
//       error: "Internal server error",
//       message: error.message
//     });
//   }
// });



// app.post("/api/printer/save", authRequired, (req, res) => {
//   const printers = loadPrinters();
//   const incomingData = req.body;
  
//   // Generate ID from printerName
//   const generateIdFromName = (printerName) => {
//     // Example: "KITCHEN 5" -> "kitchen-5-166558"
//     const cleanName = printerName.toLowerCase()
//       .replace(/\s+/g, '-')
//       .replace(/[^a-z0-9-]/g, '');
    
//     // Add timestamp (similar to your example format)
//     const timestamp = Date.now().toString().slice(-6);
    
//     return `${cleanName}-${timestamp}`;
//   };
  
//   // Handle both single and array input
//   const printersToSave = Array.isArray(incomingData) ? incomingData : [incomingData];
  
//   printersToSave.forEach(simplePrinter => {
//     // Validate required fields
//     if (!simplePrinter.printerName || !simplePrinter.printerIp) {
//       return; // Skip invalid entries
//     }
    
//     // Create the full printer object
//     const fullPrinter = {
//       id: generateIdFromName(simplePrinter.printerName),
//       name: simplePrinter.printerName,
//       role: simplePrinter.role || "KITCHEN",
//       enabled: simplePrinter.enabled !== undefined ? simplePrinter.enabled : true,
//       connection: {
//         ip: simplePrinter.printerIp,
//         port: simplePrinter.port || 9100
//       },
//       paper: {
//         name: simplePrinter.paperName || "RECIEPT(72mm)",
//         width: simplePrinter.paperWidth || 576
//       },
//       printSettings: {
//         cut: simplePrinter.cut !== undefined ? simplePrinter.cut : true,
//         // Add other print settings if needed
//         openCashDrawer: simplePrinter.openCashDrawer || false,
//         beep: simplePrinter.beep || false
//       }
//     };
    
//     // Check if printer with same IP already exists (update it)
//     const existingIndex = printers.findIndex(
//       p => p.connection.ip === fullPrinter.connection.ip
//     );
    
//     if (existingIndex >= 0) {
//       printers[existingIndex] = fullPrinter;
//     } else {
//       printers.push(fullPrinter);
//     }
//   });
  
//   savePrinters(printers);
//   res.json({ 
//     success: true, 
//     message: `Saved ${printersToSave.length} printer(s)`,
//     data: printers
//   });
// });


// app.post("/api/printer/save", authRequired, (req, res) => {
//   const printers = loadPrinters();
//   const p = req.body;

//   const index = printers.findIndex(x => x.id === p.id);
//   if (index >= 0) printers[index] = p;
//   else printers.push(p);

//   savePrinters(printers);
//   res.json({ success: true });
// });


function savePrinters(printers) {
  safeWrite(PRINTER_FILE, { printers });
}



function safeWrite(file, data) {
  fs.writeFileSync(file, JSON.stringify(data, null, 2));
}

//-----------------------------------------------------

//   try {
//       // Debug logging
//   console.log("=== RAW REQUEST DEBUG ===");
//   console.log("Content-Type:", req.headers["content-type"]);
//   console.log("Raw body:", req.body);
//   console.log("Body type:", typeof req.body);
//   console.log("Body keys:", Object.keys(req.body || {}));
//   console.log("=======================");
  
//   const { printerName, printerIp, role } = req.body;
  
//   // More detailed logging
//   console.log("Parsed values:");
//   console.log("printerName:", printerName, "Type:", typeof printerName);
//   console.log("printerIp:", printerIp, "Type:", typeof printerIp);
//   console.log("role:", role, "Type:", typeof role);
  
//   // Your existing validation...
//   if (!printerName || !printerIp || !role) {
//     console.log("MISSING FIELDS DETECTED!");
//     return res.status(400).json({
//       error: "Missing required fields",
//       required: ["printerName", "printerIp", "role"],
//       received: {
//         printerName: printerName || "undefined",
//         printerIp: printerIp || "undefined", 
//         role: role || "undefined"
//       }
//     });
//   }
    
//     // Validate IP address format
//     const ipRegex = /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/;
//     if (!ipRegex.test(printerIp)) {
//       return res.status(400).json({
//         error: "Invalid IP address format"
//       });
//     }
    
//     // Check if printer name already exists
//     const existingByName = printers.find(p => 
//       p.printerName.toLowerCase() === printerName.toLowerCase()
//     );
    
//     if (existingByName) {
//       // Update existing printer if name matches
//       existingByName.printerIp = printerIp;
//       existingByName.role = role;
//       existingByName.lastSeen = new Date().toISOString();
      
//       console.log("Updated existing printer:", printerName);
      
//       return res.json({
//         status: "success",
//         message: "Printer updated successfully",
//         action: "updated",
//         printer: existingByName
//       });
//     }
    
//     // Check if IP already exists (prevent duplicates)
//     const existingByIp = printers.find(p => p.printerIp === printerIp);
//     if (existingByIp) {
//       return res.status(409).json({
//         error: "IP address already assigned to another printer",
//         existingPrinter: {
//           name: existingByIp.printerName,
//           role: existingByIp.role
//         }
//       });
//     }
    
//     // Create new printer object
//     const newPrinter = {
//       printerName,
//       printerIp,
//       role: role.toUpperCase(), // Normalize role to uppercase
//       isActive: true,
//       createdAt: new Date().toISOString(),
//       lastSeen: new Date().toISOString()
//     };
    
//     // Add to printers array
//     printers.push(newPrinter);
    
//     console.log("Registered new printer:", newPrinter);
    
//     res.status(201).json({
//       status: "success",
//       message: "Printer registered successfully",
//       action: "created",
//       printer: newPrinter
//     });
    
//   } catch (error) {
//     console.error("Error setting printer:", error);
//     res.status(500).json({
//       error: "Internal server error",
//       message: error.message
//     });
//   }
// });




// Route for the root URL - serve your dashboard.html
app.get('/', (req, res) => {
    // If your HTML file is named dashboard.html
    res.sendFile(path.join(__dirname, 'dashboard.html'));
    // If your HTML file has a different name, change it accordingly
});

//-----------------------------------------------------------------------


// ============== GET SET PRINTER =======================//

// Update your existing /api/printer/save endpoint
app.post("/api/printer/save_printers", authRequired, (req, res) => {
  const printers = loadPrinters();
  console.log(req.body, "tttttttttttttt");
  const incomingData = req.body;
  
  // Generate ID from printerName (keep consistent if updating)
  const generateIdFromName = (printerName, existingId = null) => {
    if (existingId) return existingId; // Keep existing ID when updating
    
    const cleanName = printerName.toLowerCase()
      .replace(/\s+/g, '-')
      .replace(/[^a-z0-9-]/g, '');
    const timestamp = Date.now().toString().slice(-6);
    return `${cleanName}-${timestamp}`;
  };
  
  // Handle both single and array input
  const printersToSave = Array.isArray(incomingData) ? incomingData : [incomingData];
  const results = [];
  
  printersToSave.forEach(data => {
    let fullPrinter;
    let isSimpleFormat = false;
    
    // Check if it's in simple format (from /set_printer_app)
    if (data.printerName && data.printerIp) {
      isSimpleFormat = true;
      fullPrinter = {
        id: generateIdFromName(data.printerName),
        name: data.printerName,
        role: data.role || "KITCHEN",
        enabled: data.enabled !== undefined ? data.enabled : true,
        connection: {
          ip: data.printerIp,
          port: data.port || 9100
        },
        paper: {
          name: data.paperName || "RECIEPT(72mm)",
          width: data.paperWidth || 576
        },
        printSettings: {
          cut: data.cut !== undefined ? data.cut : true
        }
      };
    } 
    // Check if it's in full format
    else if (data.name && data.connection && data.connection.ip) {
      fullPrinter = { ...data };
      if (!fullPrinter.id) {
        fullPrinter.id = generateIdFromName(data.name);
      }
    } 
    // Invalid format
    else {
      results.push({
        status: "error",
        error: "Invalid printer format",
        data: data
      });
      return;
    }
    
    // Check if printer with same name already exists
    const existingIndexByName = printers.findIndex(
      p => p.name.toLowerCase() === fullPrinter.name.toLowerCase()
    );
    
    // Check if printer with same IP already exists (optional)
    const existingIndexByIp = printers.findIndex(
      p => p.connection.ip === fullPrinter.connection.ip
    );
    
    let action = "created";
    let existingIndex = -1;
    
    // Priority 1: Update by name (if same printer name exists)
    if (existingIndexByName >= 0) {
      existingIndex = existingIndexByName;
      action = "updated";
      // Keep the existing ID when updating by name
      fullPrinter.id = printers[existingIndex].id;
    }
    // Priority 2: Update by IP (optional - uncomment if needed)
    // else if (existingIndexByIp >= 0) {
    //   existingIndex = existingIndexByIp;
    //   action = "updated";
    //   fullPrinter.id = printers[existingIndex].id;
    // }
    
    if (existingIndex >= 0) {
      // Update existing printer
      printers[existingIndex] = fullPrinter;
      console.log(`Updated printer "${fullPrinter.name}" (IP: ${fullPrinter.connection.ip})`);
    } else {
      // Add new printer
      printers.push(fullPrinter);
      console.log(`Created new printer "${fullPrinter.name}" (IP: ${fullPrinter.connection.ip})`);
    }
    
    results.push({
      status: "success",
      action: action,
      printer: fullPrinter
    });
  });
  
  // Save all changes
  savePrinters(printers);
  
  // Check if there were any errors
  const hasErrors = results.some(r => r.status === "error");
  
  if (hasErrors) {
    return res.status(207).json({
      success: true,
      message: `Processed with some errors`,
      results: results
    });
  }
  
  res.json({
    success: true,
    message: `Successfully saved ${results.length} printer(s)`,
    results: results
  });
});










/* ===============================
   START SERVER
================================ */

app.listen(PORT, () => {
  console.log("================================");
  console.log("ANDROPRINT SERVER RUNNING");
  console.log("Local URL :", `http://localhost:${PORT}`);
  console.log("Server ID :", SERVER_ID);
  console.log("Auth      :", ENABLE_AUTH ? "ENABLED" : "DISABLED");
  console.log("================================");
});
