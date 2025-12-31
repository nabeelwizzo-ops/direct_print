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
//

const app = express();
app.use(cors());
app.use(express.json());

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
    (c) => c.id === id && c.pin === key && c.enabled === true
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
    }))
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
          p.name?.toLowerCase() === printerId.toLowerCase())
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
  } catch (err) {
    console.error("❌ API ERROR:", err);
  }
});

async function processPrintJob(printerCfg, body) {
  console.log("\n--- PRINT JOB START ---");

  try {
    const printer = new ThermalPrinter({
      type: PrinterTypes.EPSON,
      interface: `tcp://${printerCfg.connection.ip}:${printerCfg.connection.port}`,
      options: { timeout: 15000 },
    });

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
      console.log("Mode: TEXT");
      printer.println(body.text);
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

/* ===============================
   INVOICE PRINTER
================================ */

// async function printInvoice(printer, data) {
//   const { company = [], master = {}, table = [] } = data;
//   const comp = company[0] || {};

//   printer.alignCenter();
//   printer.bold(true);
//   printer.println(comp.Name || "COMPANY");
//   printer.bold(false);

//   if (comp.Place) printer.println(comp.Place);
//   if (comp.Ph) printer.println("Ph: " + comp.Ph);
//   if (comp.gst) printer.println("GSTIN: " + comp.gst);

//   printer.drawLine();

//   printer.alignLeft();
//   printer.println("Bill No : " + (master.BillNo ?? ""));
//   printer.println(
//     "Date    : " +
//     (master.BillDate || "") +
//     " " +
//     (master.BillTime || "")
//   );

//   if (master.BillPartyName) {
//     printer.println("Party   : " + master.BillPartyName);
//   }

//   printer.drawLine();

//   table.forEach((it, i) => {
//     printer.tableCustom([
//       { text: String(i + 1), cols: 3 },
//       { text: String(it.ItemNameTextField || "").substring(0, 18), cols: 18 },
//       { text: String(it.qty || 0), cols: 4, align: "RIGHT" },
//       {
//         text: Number(it.total || 0).toFixed(2),
//         cols: 7,
//         align: "RIGHT"
//       }
//     ]);
//   });

//   printer.drawLine();
//   printer.alignRight();
//   printer.bold(true);
//   printer.println(
//     "NET TOTAL : " +
//     Number(master.BillNetTotalField || 0).toFixed(2)
//   );
//   printer.bold(false);

//   printer.newLine();
//   printer.alignCenter();
//   printer.println("Thank you!");
//   printer.cut();

//   await printer.execute();
// }

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
  if (comp.gst) printer.println("GSTIN: " + comp.gst);

  printer.drawLine();

  printer.alignLeft();
  printer.println("Bill No : " + (master.BillNo ?? ""));
  printer.println(
    "Date    : " + (master.BillDate || "") + " " + (master.BillTime || "")
  );

  if (master.BillPartyName) {
    printer.println("Party   : " + master.BillPartyName);
  }
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
  // printer.leftRight("Other Chrg", fmt(master.BillPackageField, 2));
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

    printer.printQR(qr_data, {
      cellSize: 6,
      correction: "M",
    });

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
