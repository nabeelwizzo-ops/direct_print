require("dotenv").config({
  path: require("path").join(__dirname, "../.env"),
});

const express = require("express");
const fs = require("fs");
const path = require("path");
const cors = require("cors");
const net = require("net");
const os = require("os");

const { ThermalPrinter, PrinterTypes } = require("node-thermal-printer");

const PUBLIC_FOLDER = path.join(__dirname, "..", "public");

function getNetworkIps() {
  const interfaces = os.networkInterfaces();
  const ips = [];
  for (const name of Object.keys(interfaces)) {
    for (const netIf of interfaces[name]) {
      if (netIf.family === "IPv4" && !netIf.internal) {
        ips.push(netIf.address);
      }
    }
  }
  return ips;
}

// #######----------------CUSTOM_INVOICE enable this Log----------######
// your public folder
// console.log("__dirname:", __dirname);
// console.log("Correct public path:", PUBLIC_FOLDER);

// resized output file
const RESIZED_LOGO = path.join(PUBLIC_FOLDER, "logo_print.png");
const allowedExt = [".png", ".jpg", ".jpeg", ".webp", ".bmp"];

//
const axios = require("axios");
const { log } = require("console");
const sharp = require("sharp");

const app = express();
app.use(cors());
app.use(express.json());

app.use(express.urlencoded({ extended: true }));
// Get the root project directory (DIRECT_PRINT)
const projectRoot = path.join(__dirname, "..");

// Serve static files from 'public' directory
app.use(express.static(path.join(projectRoot, "public")));

/* ===============================
   ENV
================================ */

const PORT = process.env.PORT || 3000;
const HOST = process.env.HOST || "0.0.0.0";
const DOMAIN = process.env.DOMAIN || process.env.BASE_URL || "";
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
   SYSTEM LOGGING ENGINE
================================ */

const LOG_FILE = path.join(CONFIG, "system.log");
const MAX_IN_MEMORY_LOGS = 500;
let systemLogs = [];

function loadLogHistory() {
  try {
    if (fs.existsSync(LOG_FILE)) {
      const lines = fs.readFileSync(LOG_FILE, "utf8").split("\n").filter(Boolean);
      systemLogs = lines.slice(-MAX_IN_MEMORY_LOGS).map((line) => {
        try {
          return JSON.parse(line);
        } catch {
          return null;
        }
      }).filter(Boolean);
    }
  } catch (err) {
    console.error("Error loading log history:", err.message);
  }
}

loadLogHistory();

function addLogEntry(level, type, message, details = {}) {
  const entry = {
    id: `log_${Date.now()}_${Math.floor(Math.random() * 1000)}`,
    timestamp: new Date().toISOString(),
    level: String(level).toUpperCase(),
    type: String(type).toUpperCase(),
    message: message,
    details: details,
  };

  const timeStr = new Date().toLocaleTimeString();
  console.log(`[${timeStr}] [${entry.level}] [${entry.type}] ${message}`);

  systemLogs.unshift(entry);
  if (systemLogs.length > MAX_IN_MEMORY_LOGS) {
    systemLogs = systemLogs.slice(0, MAX_IN_MEMORY_LOGS);
  }

  try {
    fs.appendFile(LOG_FILE, JSON.stringify(entry) + "\n", (err) => {
      if (err) console.error("Error appending log:", err.message);
    });
  } catch (err) {
    console.error("Log append error:", err.message);
  }

  return entry;
}

function analyzePrintFailure(printerIp, printerPort, originalError = "") {
  const systemIps = getNetworkIps();
  const systemIp = systemIps[0] || "0.0.0.0";

  let subnetMismatch = false;
  if (printerIp && systemIp && systemIp !== "0.0.0.0") {
    const sysParts = systemIp.split(".").slice(0, 3).join(".");
    const prnParts = printerIp.split(".").slice(0, 3).join(".");
    if (sysParts !== prnParts) {
      subnetMismatch = true;
    }
  }

  return {
    printerIp: printerIp,
    printerPort: printerPort || 9100,
    systemIp: systemIp,
    allSystemIps: systemIps,
    subnetMismatch: subnetMismatch,
    errorReason: originalError || "Printer Connection Failed",
    possibleCause: subnetMismatch
      ? `Subnet Mismatch! System is on (${systemIp}) while printer is on (${printerIp}).`
      : systemIp === "0.0.0.0" || systemIps.length === 0
        ? "No active Wi-Fi / Ethernet connection on server."
        : `TCP Port ${printerPort || 9100} unreachable. Check printer IP & power.`,
  };
}

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
   CLOUD PRINT AGENT (MODE 1: MQTT PAIR CODE)
================================ */
const CloudPrintAgent = require("./cloud_agent");

const cloudAgent = new CloudPrintAgent({
  serverId: SERVER_ID,
  brokerUrl: process.env.MQTT_BROKER || "wss://broker.emqx.io:8084/mqtt",
  addLogEntry: addLogEntry,
  onPrintJob: async ({ printerId, data }) => {
    try {
      const printers = loadPrinters();
      let targetPrinter = null;
      if (printerId) {
        targetPrinter = printers.find(
          (p) =>
            p.enabled &&
            (p.id.toLowerCase() === printerId.toLowerCase() ||
              p.name?.toLowerCase() === printerId.toLowerCase())
        );
      }
      if (!targetPrinter) {
        targetPrinter = printers.find((p) => p.enabled);
      }

      if (!targetPrinter) {
        addLogEntry("ERROR", "CLOUD_PRINT", "Cloud print failed: No enabled printer found", {
          pairCode: SERVER_ID,
          requestedPrinter: printerId,
        });
        return;
      }

      addLogEntry(
        "INFO",
        "CLOUD_PRINT",
        `Dispatching cloud print to "${targetPrinter.name}" (${targetPrinter.connection?.ip})`,
        {
          pairCode: SERVER_ID,
          printer: targetPrinter.name,
          mode: data.isInvoiceData?.isInvoice ? "INVOICE" : "DATA",
        }
      );

      processPrintJob(targetPrinter, data);
    } catch (err) {
      addLogEntry("ERROR", "CLOUD_PRINT", `Cloud print dispatch error: ${err.message}`, {
        error: err.message,
      });
    }
  },
});

try {
  cloudAgent.start();
} catch (e) {
  console.error("Failed to start CloudPrintAgent:", e.message);
}


/* ===============================
   AUTH
================================ */

function authRequired(req, res, next) {
  if (!ENABLE_AUTH) return next();

  const id = req.headers["x-client-id"];
  const key = req.headers["x-print-key"];

  if (!id || !key) {
    addLogEntry(
      "WARN",
      "AUTH",
      `Authentication rejected: Missing headers (x-client-id or x-print-key) from ${req.ip || "client"}`,
      { ip: req.ip, headers: req.headers }
    );
    return res.status(401).json({ error: "Client auth required" });
  }

  const clients = loadClients(); // ✅ now ALWAYS array

  const ok = clients.find(
    (c) => c.id === id && c.pin === key && c.enabled === true,
  );

  if (!ok) {
    addLogEntry(
      "WARN",
      "AUTH",
      `Authentication rejected: Invalid credentials for client "${id}" from ${req.ip || "client"}`,
      { ip: req.ip, clientId: id }
    );
    return res.status(403).json({ error: "Invalid client" });
  }

  next();
}

/* ===============================
   CLIENT MANAGEMENT API
================================ */

app.get("/api/clients", (req, res) => {
  const clients = loadClients();
  res.json({ success: true, clients });
});

app.post("/api/client/create", (req, res) => {
  try {
    const clients = loadClients();
    const newId = `clt-${Math.random().toString(36).substring(2, 8)}`;
    const newPin = Math.floor(100000 + Math.random() * 900000).toString();
    const newClient = {
      id: newId,
      pin: newPin,
      role: req.body?.role || "CLIENT",
      enabled: true,
      createdAt: new Date().toISOString(),
    };
    clients.push(newClient);
    fs.writeFileSync(CLIENT_FILE, JSON.stringify({ clients }, null, 2));
    addLogEntry(
      "INFO",
      "CLIENT_MGMT",
      `New client registered: ID "${newClient.id}" (${newClient.role})`,
      { client: newClient }
    );
    res.json(newClient);
  } catch (err) {
    addLogEntry(
      "ERROR",
      "CLIENT_MGMT",
      `Failed to create client: ${err.message}`,
      { error: err.message }
    );
    res.status(500).json({ error: err.message });
  }
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
      addLogEntry(
        "ERROR",
        "PRINT",
        "Print job rejected: 'x-printer-id' header is missing",
        { ip: req.ip, headers: req.headers }
      );
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
      addLogEntry(
        "ERROR",
        "PRINT",
        `Print job rejected: Printer "${printerId}" not found or disabled`,
        {
          printerId: printerId,
          availablePrinters: loadPrinters().map((p) => ({ id: p.id, name: p.name, enabled: p.enabled })),
        }
      );
      return res.status(404).json({ error: "Printer not found or disabled" });
    }

    const body = req.body || {};
    const mode = body.isInvoiceData?.isInvoice
      ? "INVOICE"
      : body.isInvoiceData?.isKot
      ? "KOT"
      : body.isInvoiceData?.isALLKot
      ? "ALL_KOT"
      : body.text
      ? "TEXT"
      : "UNKNOWN";

    const billNo = body.master?.BillNo || (body.table && body.table[0]?.BillNo) || null;
    const partyName = body.master?.BillPartyName || null;

    addLogEntry(
      "INFO",
      "PRINT",
      `Print request accepted [${mode}] for printer "${printerCfg.name}" (${printerCfg.connection?.ip}:${printerCfg.connection?.port})${billNo ? ` - Bill #${billNo}` : ""}`,
      {
        printerId: printerCfg.id,
        printerName: printerCfg.name,
        targetIp: printerCfg.connection?.ip,
        targetPort: printerCfg.connection?.port,
        mode: mode,
        billNo: billNo,
        party: partyName,
      }
    );

    // ✅ RESPOND IMMEDIATELY
    res.json({
      success: true,
      message: "Print accepted",
      printer: printerCfg.id,
    });

    console.log("✅ HTTP response sent in", Date.now() - start, "ms");

    // 🔥 PRINT IN BACKGROUND
    processPrintJob(printerCfg, body);
  } catch (err) {
    console.error("❌ API ERROR:", err);
    addLogEntry("ERROR", "PRINT", `Print API Exception: ${err.message}`, { error: err.message });
  }
});

async function processPrintJob(printerCfg, body) {
  console.log("\n--- PRINT JOB START ---");

  try {
    /* ========= AUTO DETECT ========= */

    if (body.isInvoiceData?.isInvoice) {
      console.log("Mode: INVOICE");
      const billNo = body.master?.BillNo || (body.table && body.table[0]?.BillNo) || "N/A";
      const party = body.master?.BillPartyName || "Cash";
      const netTotal = body.master?.BillNetTotalField || body.master?.NetTotal || "";

      const printer = await createPrinter(printerCfg);
      if (!printer) {
        const diag = analyzePrintFailure(
          printerCfg.connection?.ip,
          printerCfg.connection?.port || 9100,
          "Printer offline or connection timeout"
        );
        addLogEntry(
          "ERROR",
          "PRINT",
          `Invoice Print Failed: Printer "${printerCfg.name}" (${printerCfg.connection?.ip}:${printerCfg.connection?.port || 9100}) is OFFLINE`,
          diag
        );
        return;
      }

      await printInvoice(printer, body);
      addLogEntry(
        "SUCCESS",
        "PRINT",
        `Invoice #${billNo} (${party}) printed successfully to "${printerCfg.name}" (${printerCfg.connection?.ip})`,
        {
          billNo,
          party,
          netTotal,
          printer: printerCfg.name,
          ip: printerCfg.connection?.ip,
        }
      );
    } else if (body.isInvoiceData?.isKot) {
      // Handle ALL KOT cases with smart routing
      console.log("Mode: KOT ROUTING (KOT or ALL KOT or BOTH)");
      await routeKotToPrinters(body);
      return; // Return here since routeKotToPrinters handles its own printing
    } else if (body.isInvoiceData?.isALLKot) {
      // Handle ALL KOT cases with smart routing
      console.log("Mode: ALL KOT ROUTING ( ALL KOT)");
      await routeKotToPrinters(body);
      return; // Return here since routeKotToPrinters handles its own printing
    } else if (body.text) {
      console.log("Mode: TEXT");
      const printer = await createPrinter(printerCfg);
      if (!printer) {
        const diag = analyzePrintFailure(
          printerCfg.connection?.ip,
          printerCfg.connection?.port || 9100,
          "Printer offline or connection timeout"
        );
        addLogEntry(
          "ERROR",
          "PRINT",
          `Text Print Failed: Printer "${printerCfg.name}" (${printerCfg.connection?.ip}:${printerCfg.connection?.port || 9100}) is OFFLINE`,
          diag
        );
        return;
      }

      printer.println(body.text);
      printer.cut();
      await printer.execute();
      addLogEntry(
        "SUCCESS",
        "PRINT",
        `Text print completed successfully on "${printerCfg.name}" (${printerCfg.connection?.ip})`,
        {
          printer: printerCfg.name,
          ip: printerCfg.connection?.ip,
          textLength: body.text?.length,
        }
      );
    } else {
      console.log("❌ Unsupported payload", JSON.stringify(body, null, 2));
      addLogEntry(
        "WARN",
        "PRINT",
        `Unsupported print payload received for printer "${printerCfg.name}"`,
        { keys: Object.keys(body || {}) }
      );
      return;
    }

    console.log("✅ PRINT SUCCESS");
  } catch (err) {
    console.error("❌ PRINT FAILED:", err.message);
    const diag = analyzePrintFailure(
      printerCfg.connection?.ip,
      printerCfg.connection?.port || 9100,
      err.message
    );
    addLogEntry(
      "ERROR",
      "PRINT",
      `Print execution failed on "${printerCfg.name}": ${err.message}`,
      diag
    );
  }

  console.log("--- PRINT JOB END ---\n");
}

// Helper function to create printer and check connection
async function createPrinter(printerCfg) {
  const printer = new ThermalPrinter({
    type: PrinterTypes.EPSON,
    interface: `tcp://${printerCfg.connection?.ip}:${printerCfg.connection?.port || 9100}`,
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
  console.log("✅ printInvoice");
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

  // If BillPartyName is "3", 3, empty, or "Cash", treat as "Cash"
  if (
    !master.BillPartyName ||
    String(master.BillPartyName).trim() === "3" ||
    String(master.BillPartyName).trim().toLowerCase() === "cash"
  ) {
    master.BillPartyName = "Cash";
  }

  printer.println("Party   : " + master.BillPartyName);

  if (master.BillPartyName !== "Cash") {
    if (master.Address1 && master.Address1 !== "null") {
      printer.println("Address: " + master.Address1);
    }
    if (master.Ph && master.Ph !== "null") {
      printer.println("Contact: " + master.Ph);
    }
    if (master.TinNo && master.TinNo !== "null") {
      printer.println("Tax No : " + master.TinNo);
    }
  }

  if (master.table && master.table !== "null") {
    printer.println("Table No: " + master.table);
  }
  if (master.OrderNo !== undefined && master.OrderNo !== null && master.OrderNo !== "null") {
    printer.println("Token No: " + master.OrderNo);
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

  // table.forEach((it, i) => {
  //   printer.tableCustom([
  //     { text: i + 1, cols: 3, align: "LEFT" },
  //     {
  //       text: String(it.ItemNameTextField || "").substring(0, 30),
  //       cols: 45,
  //       align: "LEFT",
  //     },
  //   ]);

  //   printer.tableCustom([
  //     { text: "", cols: 3 },
  //     { text: "", cols: 15 },
  //     { text: it.qty ?? 0, cols: 3, align: "CENTER" },
  //     { text: fmt(it.Rate1, 2), cols: 9, align: "RIGHT" },
  //     { text: fmt(it.taxAmt, 2), cols: 9, align: "RIGHT" },
  //     { text: fmt(it.total, 2), cols: 9, align: "RIGHT" },
  //   ]);
  // });

  let slNo = 1;

  table.forEach((it, i) => {
    if (parseFloat(it.qty || 0) <= 0) {
      return; // skip this item
    }

    printer.tableCustom([
      { text: slNo++, cols: 3, align: "LEFT" },
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
  printer.leftRight("Sub Total:", fmt(master.BillTotalField, 2));
  printer.leftRight("Disc Amt:", fmt(master.BillDiscAmtField, 2));
  printer.leftRight("Tax  Amt:", fmt(master.TItTaxAmt, 2));
  // printer.leftRight("Net Total:", fmt(master.BillNetTotalField, 2));

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

async function printInvoice_custom2(printer, data) {
  console.log("✅ printInvoice_custom");

  console.log("✅", data);
  //const { company = [], master = {}, table = [] } = data;

  //const comp = company[0] || {};

  const comp = data.company?.[0] || {};
  const master = data.master || {};
  const table = data.table || [];

  const fmt = (n, d = 2) => Number(n || 0).toFixed(d);

  console.log("__dirname:", __dirname);
  console.log("Public path:", path.join(__dirname, "public"));

  /* =========================
     1) LOGO (optional)
  ========================= */

  printer.alignCenter();

  const logo = await prepareLogo();

  if (logo) {
    printer.alignCenter();

    await printer.printImage(logo);

    printer.newLine(); // space AFTER logo only
  }

  // printer.newLine();

  /* =========================
     2) COMPANY HEADER
  ========================= */
  printer.bold(true);
  printer.println(comp.Name || "COMPANY NAME");
  printer.bold(false);

  if (comp.Place) printer.println(comp.Place);
  if (comp.Ph) printer.println("PH : " + comp.Ph);
  if (comp.gst) printer.println("GST IN : " + comp.gst);

  printer.newLine();
  printer.drawLine();
  printer.bold(true);
  printer.println(" INVOICE ");
  printer.bold(false);

  printer.drawLine();

  /* =========================
     3) BILL INFO (two sides)
  ========================= */
  printer.alignLeft();

  printer.leftRight(
    "Bill No : " + (master.BillNo ?? ""),
    "Date : " + (master.BillDate || ""),
  );

  const billParty =
    !master.BillPartyName ||
    String(master.BillPartyName).trim() === "3" ||
    String(master.BillPartyName).trim().toLowerCase() === "cash"
      ? "Cash"
      : master.BillPartyName;

  printer.leftRight(
    "Party : " + billParty,
    "Time : " + (master.BillTime || ""),
  );

  printer.leftRight("Table No : " + (master.table ?? ""));

  printer.drawLine();

  /* =========================
     4) TABLE HEADER (48 COLS)
  ========================= */
  // printer.tableCustom([
  //   { text: "#", cols: 3, align: "LEFT", bold: true },
  //   { text: "Item Name", cols: 21, align: "LEFT", bold: true },
  //   { text: "Qty", cols: 4, align: "CENTER", bold: true },
  //   { text: "Rate", cols: 10, align: "RIGHT", bold: true },
  //   { text: "Net", cols: 10, align: "RIGHT", bold: true },
  // ]);

  printer.tableCustom([
    { text: "#", align: "LEFT", cols: 3, bold: true },
    {
      text: "Item Name",
      align: "LEFT",
      cols: 21,
      bold: true,
    },
    {
      text: "Qty",
      align: "CENTER",
      cols: 4,
      bold: true,
    },
    { text: "Rate", align: "RIGHT", cols: 10, bold: true },
    { text: "Net", align: "RIGHT", cols: 10, bold: true },
  ]);

  printer.drawLine();

  /* =========================
     5) ITEMS (single row)
  ========================= */
  // table.forEach((it, i) => {
  //   const name = String(it.ItemNameTextField || "")
  //     .substring(0, 21);

  //   printer.tableCustom([
  //     { text: i + 1, cols: 3, align: "LEFT" },
  //     { text: name, cols: 21, align: "LEFT" },
  //     { text: it.qty ?? 0, cols: 4, align: "CENTER" },
  //     { text: fmt(it.Rate1), cols: 10, align: "RIGHT" },
  //     { text: fmt(it.total), cols: 10, align: "RIGHT" },
  //   ]);
  // });

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
      { text: "", cols: 21 },
      { text: it.qty ?? 0, cols: 4, align: "CENTER" },
      { text: fmt(it.Rate1, 2), cols: 10, align: "RIGHT" },
      { text: fmt(it.total, 2), cols: 10, align: "RIGHT" },
    ]);
  });

  printer.drawLine();

  /* =========================
     6) TOTALS
  ========================= */
  printer.leftRight("Sub Total :", fmt(master.BillTotalField));
  printer.leftRight("Disc Amt  :", fmt(master.BillDiscAmtField));

  printer.drawLine();

  printer.bold(true);
  printer.leftRight("NET TOTAL :", fmt(master.BillNetTotalField));
  printer.bold(false);

  printer.drawLine();

  /* =========================
     7) FOOTER
  ========================= */
  printer.alignCenter();
  printer.println("Thanks for your shopping");
  printer.println("We are under composition tax payer !");
  // printer.println("We are adding consumed tax");

  printer.newLine();
  printer.cut();
  printer.beep();
  printer.beep();
  printer.beep();

  await printer.execute();
}

async function printInvoice_custom(printer, data) {
  console.log("🧾 printInvoice_custom START");

  try {
    /* ========= SAFE DATA ========= */
    const comp = data?.company?.[0] || {};
    const master = data?.master || {};
    const table = data?.table || [];

    // console.log("🏢 Company:", comp);
    // console.log("📄 Master:", master);
    // console.log("📦 Items:", table.length);

    const fmt = (n, d = 2) => Number(n || 0).toFixed(d);

    /* =========================
       LOGO
    ========================= */
    printer.alignCenter();

    try {
      const logo = await prepareLogo(data.logo);

      if (logo) {
        console.log("🖼️ Printing logo...");
        await printer.printImage(logo);
        printer.newLine();
      } else {
        console.log("⚠️ Logo not found / skipped");
      }
    } catch (e) {
      console.log("⚠️ Logo error:", e.message);
    }

    /* =========================
       HEADER
    ========================= */
    printer.bold(true);
    printer.println(comp.Name || "COMPANY NAME");
    printer.bold(false);

    if (comp.Place) printer.println(comp.Place);
    if (comp.Ph) printer.println("Ph : " + comp.Ph);

    printer.newLine();
    printer.drawLine();

    printer.bold(true);
    printer.println("INVOICE");
    printer.bold(false);

    printer.drawLine();

    /* =========================
       BILL INFO
    ========================= */
    printer.alignLeft();

    printer.leftRight(
      "Bill No : " + (master.BillNo ?? ""),
      "Date : " + (master.BillDate || ""),
    );

    const billParty =
      !master.BillPartyName ||
      String(master.BillPartyName).trim() === "3" ||
      String(master.BillPartyName).trim().toLowerCase() === "cash"
        ? "Cash"
        : master.BillPartyName;

    printer.leftRight(
      "Party : " + billParty,
      "Time : " + (master.BillTime || ""),
    );

    printer.leftRight("Table : " + (master.table || ""), "");

    printer.drawLine();

    /* =========================
       TABLE HEADER
    ========================= */
    printer.tableCustom([
      { text: "#", cols: 3, align: "LEFT", bold: true },
      { text: "Item Name", cols: 21, align: "LEFT", bold: true },
      { text: "Qty", cols: 4, align: "CENTER", bold: true },
      { text: "Rate", cols: 10, align: "RIGHT", bold: true },
      { text: "Net", cols: 10, align: "RIGHT", bold: true },
    ]);

    printer.drawLine();

    /* =========================
       ITEMS
    ========================= */
    // table.forEach((it, i) => {
    //   try {
    //     printer.tableCustom([
    //       { text: i + 1, cols: 3 },
    //       {
    //         text: String(it?.ItemNameTextField || "").substring(0, 21),
    //         cols: 21,
    //       },
    //       { text: String(it?.qty || 0), cols: 4, align: "CENTER" },
    //       { text: fmt(it?.Rate1), cols: 10, align: "RIGHT" },
    //       { text: fmt(it?.total), cols: 10, align: "RIGHT" },
    //     ]);
    //   } catch (e) {
    //     console.log("❌ Item print error:", e.message, it);
    //   }
    // });

    let slNo = 1;

    table.forEach((it) => {
      try {
        if (parseFloat(it?.qty || 0) <= 0) {
          return;
        }

        printer.tableCustom([
          { text: slNo++, cols: 3 },
          {
            text: String(it?.ItemNameTextField || "").substring(0, 21),
            cols: 21,
          },
          { text: String(it?.qty || 0), cols: 4, align: "CENTER" },
          { text: fmt(it?.Rate1), cols: 10, align: "RIGHT" },
          { text: fmt(it?.total), cols: 10, align: "RIGHT" },
        ]);
      } catch (e) {
        console.log("❌ Item print error:", e.message, it);
      }
    });

    printer.drawLine();

    /* =========================
       TOTALS
    ========================= */
    printer.leftRight("Sub Total :", fmt(master?.BillTotalField));
    printer.leftRight("Discount  :", fmt(master?.BillDiscAmtField));

    printer.drawLine();

    printer.bold(true);
    printer.leftRight("NET TOTAL :", fmt(master?.BillNetTotalField));
    printer.bold(false);

    printer.drawLine();

    /* =========================
       FOOTER
    ========================= */
    printer.alignCenter();
    printer.println("Thanks for your Visit");
    printer.println("We are adding consumed tax");

    printer.newLine();
    printer.cut();

    await printer.execute();

    console.log("✅ Invoice printed successfully");
  } catch (err) {
    console.error("❌ printInvoice_custom ERROR:", err.message);
    console.error(err.stack);
  }
}

// ALL KOT PRINT

async function all_kot_print2(printer, data) {
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

  // Increase font size
  printer.setTextSize(2, 2);

  printer.tableCustom([
    {
      text: "KOT NO: " + (master.OrderNo ?? "0"),
      align: "LEFT",
      cols: 22,
    },
  ]);

  // Reset font size back to normal
  printer.setTextSize(1, 1);

  printer.tableCustom([
    {
      text: "Date: " + (master.BillDate || "") + " " + (master.BillTime || ""),
      align: "RIGHT",
      cols: 22,
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

    const unitStr = String(
      it.units || it.unit || it.Units || it.Unit || "",
    ).trim();
    if (unitStr) {
      printer.tableCustom([
        { text: "", align: "LEFT", cols: 3 },
        { text: `[${unitStr}]`, align: "LEFT", cols: 37 },
        { text: "", align: "CENTER", cols: 8 },
      ]);
    }

    /* =========================
       NOTES (Null/empty allenkil mathram)
    ========================= */
    if (
      it.notes !== null &&
      it.notes !== undefined &&
      String(it.notes).trim() !== "" &&
      String(it.notes).toLowerCase() !== "null"
    ) {
      const notes = String(it.notes)
        .replace(/\\n/g, "\n")
        .split(/[\r\n,;|]+|\s{2,}/)
        .map((s) => s.trim())
        .filter(Boolean)
        .join(" | ");

      if (notes) {
        printer.tableCustom([
          {
            text: "",
            align: "LEFT",
            cols: 3,
          },
          {
            text: "* " + notes,
            align: "LEFT",
            cols: 45,
          },
        ]);
      }
    }
  });

  printer.drawLine();
  printer.newLine();

  /* =========================
     CUT + BEEP
  ========================= */
  printer.cut();
  printer.beep();
  printer.beep();

}

async function all_kot_print(printer, data) {

  const {
    company = [],
    master = {},
    table = [],
    kotTableData = [],
    logo = ""
  } = data;

  /* =========================
     LOGO (optional)
  ========================= */
  printer.alignCenter();

  // if (logo) {
  //   try {
  //     const logoPath = await downloadImage(logo);
  //     await printer.printImage(logoPath);
  //     printer.newLine();
  //   } catch (e) {
  //     console.log("Logo print error:", e.message);
  //   }
  // }

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
     KOT NO
  ========================= */
  printer.bold(true);
  printer.setTextDoubleHeight();
  printer.setTextDoubleWidth();

  printer.alignLeft();
  printer.println("KOT NO: " + (master.OrderNo ?? "0"));

  printer.setTextNormal();
  printer.bold(false);

  /* =========================
     DATE
  ========================= */
  printer.alignRight();

  const shortDate =
    (master.BillDate || "") + " " + (master.BillTime || "");

  printer.println("Date: " + shortDate);

  printer.alignLeft();
  printer.drawLine();

  /* =========================
     STAFF & TABLE
  ========================= */
  printer.println("BILL  NO: " + (master.BillNo || "0"));
  printer.println("STAFF: " + (master.Lorry || "NIL"));
  printer.println("TABLE NO: " + (master.table || "0"));

  printer.drawLine();

  /* =========================
     HEADER
  ========================= */
  printer.bold(true);
  printer.setTextDoubleHeight();

  printer.tableCustom([
    { text: "#", align: "LEFT", cols: 3 },
    { text: "Item Name", align: "LEFT", cols: 37 },
    { text: "Qty", align: "CENTER", cols: 8 }
  ]);

  printer.setTextNormal();
  printer.bold(false);

  printer.drawLine();

  /* =========================
     ITEMS
  ========================= */

  table.forEach((item, i) => {

    const itemName = item.ItemNameTextField || "";
    const qty = item.qty || 0;
    const unit = item.Typ || "";

    // console.log("ALL KOT", "===============");
    // console.log("itemName", itemName);
    // console.log("qty", qty);

    // Match notes from kotTableData
    const kot = kotTableData.find(k =>
      String(k.itemname || "").trim().toUpperCase() ===
      String(itemName).trim().toUpperCase()
    );

    printer.bold(true);

    printer.tableCustom([
      {
        text: String(i + 1),
        align: "LEFT",
        cols: 3,
      },
      {
        text: itemName.substring(0, 37),
        align: "LEFT",
        cols: 37,
      },
      {
        text: String(qty),
        align: "CENTER",
        cols: 8,
      },
    ]);

    printer.bold(false);

    /* =========================
       UNIT
    ========================= */
    if (unit && String(unit).trim() !== "") {

      printer.tableCustom([
        {
          text: "",
          align: "LEFT",
          cols: 3,
        },
        {
          text: "[" + unit + "]",
          align: "LEFT",
          cols: 37,
        },
        {
          text: "",
          align: "CENTER",
          cols: 8,
        },
      ]);

    }

    /* =========================
       NOTES (Null/empty allenkil mathram)
    ========================= */
    const notes = kot?.notes;

    if (
      notes !== null &&
      notes !== undefined &&
      String(notes).trim() !== "" &&
      String(notes).toLowerCase() !== "null"
    ) {
      const formattedNotes = String(notes)
        .replace(/\\n/g, "\n")
        .split(/[\r\n,;|]+|\s{2,}/)
        .map((s) => s.trim())
        .filter(Boolean)
        .join(" | ");

      if (formattedNotes) {
        printer.tableCustom([
          {
            text: "",
            align: "LEFT",
            cols: 3,
          },
          {
            text: "* " + formattedNotes,
            align: "LEFT",
            cols: 45,
          },
        ]);
      }
    }

  });

  printer.drawLine();

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

  // if (logo) {
  //   try {
  //     const logoPath = await downloadImage(logo);
  //     await printer.printImage(logoPath);
  //     printer.newLine();
  //   } catch (e) {
  //     console.log("Logo print error:", e.message);
  //   }
  // }

  /* =========================
     TITLE
  ========================= */
  printer.setTextDoubleHeight();
  printer.setTextDoubleWidth();
  printer.bold(true);
  printer.println("KOT");
  printer.bold(false);
  printer.setTextNormal();

  printer.drawLine();

  /* =========================
     KOT NO (BIG FONT)
  ========================= */
  printer.bold(true);
  printer.setTextDoubleHeight();
  printer.setTextDoubleWidth();

  printer.alignLeft();
  printer.println("KOT NO: " + (master.OrderNo ?? "0"));

  printer.setTextNormal();
  printer.bold(false);

  /* =========================
     DATE (RIGHT SIDE)
  ========================= */
  printer.alignRight();

  const shortDate = (master.BillDate || "") + " " + (master.BillTime || "");

  printer.println("Date: " + shortDate);

  printer.alignLeft();
  printer.drawLine();

  /* =========================
     STAFF & TABLE
  ========================= */
  printer.println("BILL  NO: " + (master.BillNo || "0"));
  printer.println("STAFF: " + (master.Lorry || "NIL"));
  printer.println("TABLE NO: " + (master.table || "0"));

  printer.drawLine();

  /* =========================
     HEADER (BIGGER FONT)
  ========================= */
  printer.bold(true);
  printer.setTextDoubleHeight();

  printer.tableCustom([
    { text: "#", align: "LEFT", cols: 3 },
    { text: "Item Name", align: "LEFT", cols: 37 },
    { text: "Qty", align: "CENTER", cols: 8 },
  ]);

  printer.setTextNormal();
  printer.bold(false);

  printer.drawLine();

  /* =========================
     ITEMS (CLEAR & BOLD)
  ========================= */
  kotTableData.forEach((it, i) => {
    printer.bold(true);

    // Main item row
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

    printer.bold(false);

    /* =========================
       UNIT (Item name-nte thazhe)
    ========================= */
    if (it.units && String(it.units).trim() !== "") {
      printer.tableCustom([
        {
          text: "",
          align: "LEFT",
          cols: 3,
        },
        {
          text: "[" + it.units + "]",
          align: "LEFT",
          cols: 37,
        },
        {
          text: "",
          align: "CENTER",
          cols: 8,
        },
      ]);
    }

    /* =========================
       NOTES (Null/empty allenkil mathram)
    ========================= */
    if (
      it.notes !== null &&
      it.notes !== undefined &&
      String(it.notes).trim() !== "" &&
      String(it.notes).toLowerCase() !== "null"
    ) {
      const notes = String(it.notes)
        .replace(/\\n/g, "\n")
        .split(/[\r\n,;|]+|\s{2,}/)
        .map((s) => s.trim())
        .filter(Boolean)
        .join(" | ");

      if (notes) {
        printer.tableCustom([
          {
            text: "",
            align: "LEFT",
            cols: 3,
          },
          {
            text: "* " + notes,
            align: "LEFT",
            cols: 45,
          },
        ]);
      }
    }

  });

  printer.drawLine();
  //printer.newLine();

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
    responseType: "arraybuffer",
  });

  // Convert image to printer-friendly format
  await sharp(response.data)
    .resize(300) // optional resize
    .flatten({ background: "#FFFFFF" }) // remove transparency
    .png()
    .toFile(filePath);

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
      addLogEntry("ERROR", "PRINT", "Test print rejected: Missing 'x-printer-id' header");
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
      addLogEntry("ERROR", "PRINT", `Test print rejected: No matching printers found for "${printerHeader}"`);
      return res.status(404).json({ error: "No matching printers found" });
    }

    addLogEntry(
      "INFO",
      "PRINT",
      `Multi-printer test print accepted for: ${printers.map((p) => p.name).join(", ")}`,
      { printerNames: printers.map((p) => p.name) }
    );

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
    addLogEntry("ERROR", "PRINT", `Test print API error: ${err.message}`);
  }
});

async function test_processPrintJob(printerCfg, body) {
  console.log(`\n--- PRINT JOB START (${printerCfg.name}) ---`);
  console.log(`--- ROLE: ${printerCfg.role} ---`);

  try {
    const printer = new ThermalPrinter({
      type: PrinterTypes.EPSON,
      interface: `tcp://${printerCfg.connection?.ip}:${printerCfg.connection?.port || 9100}`,
      options: { timeout: 15000 },
    });

    const connected = await printer.isPrinterConnected();
    console.log(`[${printerCfg.name}] Connected:`, connected);

    if (!connected) {
      console.log(`[${printerCfg.name}] ❌ Printer offline`);
      const diag = analyzePrintFailure(printerCfg.connection?.ip, printerCfg.connection?.port || 9100, "Printer offline");
      addLogEntry(
        "ERROR",
        "PRINT",
        `Test Print Failed: "${printerCfg.name}" (${printerCfg.connection?.ip}) is OFFLINE`,
        diag
      );
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
      addLogEntry(
        "WARN",
        "PRINT",
        `Test print on "${printerCfg.name}": No text provided for role ${printerCfg.role}`
      );
      return;
    }

    printer.println(textToPrint);

    if (printerCfg.printSettings?.cut) {
      printer.cut();
    }

    await printer.execute();

    console.log(`[${printerCfg.name}] ✅ PRINT SUCCESS`);
    addLogEntry(
      "SUCCESS",
      "PRINT",
      `Test print completed successfully on "${printerCfg.name}" (${printerCfg.role})`,
      { printer: printerCfg.name, role: printerCfg.role }
    );
  } catch (err) {
    console.error(`[${printerCfg.name}] ❌ PRINT FAILED:`, err.message);
    const diag = analyzePrintFailure(printerCfg.connection?.ip, printerCfg.connection?.port || 9100, err.message);
    addLogEntry(
      "ERROR",
      "PRINT",
      `Test print error on "${printerCfg.name}": ${err.message}`,
      diag
    );
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

//===========================================//
async function routeKotToPrinters(body) {
  console.log("🔀 Routing KOT by product printer...");

  body = attachPrinterToKotItems(body);

  const isKot = body.isInvoiceData?.isKot;
  const isALLKot = body.isInvoiceData?.isALLKot;
  const tableNo = body.master?.BillTableNo || body.master?.TableNo || body.tableNo || "";

  // 1️⃣ HANDLE KOT (Send individual items to respective Kitchen printers based on item IP)
  if (isKot || (!isKot && !isALLKot)) {
    console.log("📋 Processing KOT for Kitchen printers...");
    const printerWiseItems = {};

    // Group by printer IP
    (body.kotTableData || []).forEach((item) => {
      const ip = item.printer || item.printer_ip; // Try both fields

      if (!ip) {
        console.log("❌ No printer IP found for item:", item.itemname);
        addLogEntry(
          "WARN",
          "PRINT",
          `KOT Item "${item.itemname || item.ItemNameTextField || 'Unknown'}" has no kitchen printer IP assigned`,
          { item }
        );
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

    // Print per Kitchen printer
    for (const ip in printerWiseItems) {
      const { items, printerCfg } = printerWiseItems[ip];

      if (!printerCfg) {
        console.log("❌ No kitchen printer configuration found for IP:", ip);
        const diag = analyzePrintFailure(ip, 9100, "Printer not configured in system");
        addLogEntry(
          "WARN",
          "PRINT",
          `No Kitchen printer configured in settings for IP ${ip} (${items.length} items skipped)`,
          diag
        );
        continue;
      }

      console.log(
        `🖨️ Printing ${items.length} KOT items to ${printerCfg.name} (${ip})`,
      );

      try {
        const printer = await createPrinter(printerCfg);
        if (!printer) {
          const diag = analyzePrintFailure(ip, printerCfg.connection?.port || 9100, "Printer offline");
          addLogEntry(
            "ERROR",
            "PRINT",
            `KOT Print Failed: Kitchen printer "${printerCfg.name}" (${ip}) is OFFLINE`,
            diag
          );
          continue;
        }

        const newBody = {
          ...body,
          kotTableData: items,
        };

        await kot_print(printer, newBody);
        await printer.execute();
        console.log(`✅ KOT Printed successfully to ${printerCfg.name}`);
        addLogEntry(
          "SUCCESS",
          "PRINT",
          `KOT (${items.length} items${tableNo ? `, Table ${tableNo}` : ""}) printed successfully to "${printerCfg.name}" (${ip})`,
          {
            printer: printerCfg.name,
            ip: ip,
            itemCount: items.length,
            table: tableNo,
            items: items.map(i => i.itemname || i.ItemNameTextField || ""),
          }
        );
      } catch (err) {
        console.error(
          `❌ Failed to print KOT to ${printerCfg.name}:`,
          err.message,
        );
        const diag = analyzePrintFailure(ip, printerCfg.connection?.port || 9100, err.message);
        addLogEntry(
          "ERROR",
          "PRINT",
          `KOT print error on "${printerCfg.name}" (${ip}): ${err.message}`,
          diag
        );
      }
    }
  }

  // 2️⃣ HANDLE ALL KOT (Send ALL KOT to CASHIER printer)
  if (isALLKot) {
    console.log("📋 Processing ALL KOT for CASHIER printer...");
    const cashierPrinters = findCashierPrinters();

    if (!cashierPrinters || cashierPrinters.length === 0) {
      console.log("⚠️ No CASHIER printer found for ALL KOT printing!");
      addLogEntry(
        "WARN",
        "PRINT",
        "ALL KOT Warning: No active CASHIER printer configured for ALL KOT printing",
        { table: tableNo }
      );
    } else {
      for (const cashierCfg of cashierPrinters) {
        console.log(
          `🖨️ Printing ALL KOT to CASHIER printer: ${cashierCfg.name} (${cashierCfg.connection.ip})`,
        );

        try {
          const printer = await createPrinter(cashierCfg);
          if (!printer) {
            const diag = analyzePrintFailure(
              cashierCfg.connection?.ip,
              cashierCfg.connection?.port || 9100,
              "Cashier printer offline"
            );
            addLogEntry(
              "ERROR",
              "PRINT",
              `ALL KOT Print Failed: Cashier printer "${cashierCfg.name}" (${cashierCfg.connection.ip}) is OFFLINE`,
              diag
            );
            continue;
          }

          await all_kot_print(printer, body);
          await printer.execute();
          console.log(
            `✅ ALL KOT Printed successfully to CASHIER printer: ${cashierCfg.name}`,
          );
          addLogEntry(
            "SUCCESS",
            "PRINT",
            `ALL KOT${tableNo ? ` (Table ${tableNo})` : ""} printed successfully to Cashier printer "${cashierCfg.name}" (${cashierCfg.connection.ip})`,
            {
              printer: cashierCfg.name,
              ip: cashierCfg.connection.ip,
              table: tableNo,
            }
          );
        } catch (err) {
          console.error(
            `❌ Failed to print ALL KOT to CASHIER printer ${cashierCfg.name}:`,
            err.message,
          );
          const diag = analyzePrintFailure(
            cashierCfg.connection?.ip,
            cashierCfg.connection?.port || 9100,
            err.message
          );
          addLogEntry(
            "ERROR",
            "PRINT",
            `ALL KOT print error on "${cashierCfg.name}" (${cashierCfg.connection.ip}): ${err.message}`,
            diag
          );
        }
      }
    }
  }
}

function findPrinterByIp(ip) {
  const printers = loadPrinters();

  return printers.find(
    (p) => p.enabled && p.role === "KITCHEN" && p.connection.ip === ip,
  );
}

function findCashierPrinters() {
  const printers = loadPrinters();

  return printers.filter((p) => p.enabled && p.role === "CASHIER");
}

function attachPrinterToKotItems(body) {
  const tableMap = {};

  // Map item name -> printer_ip & units from the table array
  if (body.table && Array.isArray(body.table)) {
    body.table.forEach((t) => {
      const itemName = (t.ItemNameTextField || t.itemname || "").trim();
      const unitVal =
        t.units ||
        t.unit ||
        t.Unit ||
        t.Units ||
        t.unitName ||
        t.UnitName ||
        t.item_unit ||
        "";
      if (itemName) {
        tableMap[itemName] = {
          printer_ip: t.printer_ip,
          units: unitVal,
        };
      }
    });
  }

  // Inject printer & units into kot items
  if (body.kotTableData && Array.isArray(body.kotTableData)) {
    body.kotTableData.forEach((k) => {
      const name = (k.itemname || "").trim();
      if (name && tableMap[name]) {
        if (tableMap[name].printer_ip) {
          k.printer = tableMap[name].printer_ip;
        }
        if (!k.units && !k.unit && tableMap[name].units) {
          k.units = tableMap[name].units;
        }
      } else {
        console.log(`⚠️ No printer found for item: ${name}`);
      }
    });
  }

  return body;
}

/* ===============================
   API : SERVER INFO & CONNECTION
================================ */

function getSystemConnectionUrls(req) {
  const netIps = getNetworkIps();
  const hostHeader = req ? req.get("host") : null;
  const protocol = req ? req.protocol : "http";

  const localhostUrl = `http://localhost:${PORT}`;
  const networkUrls = netIps.map((ip) => `http://${ip}:${PORT}`);
  let domainUrl = DOMAIN ? (DOMAIN.startsWith("http") ? DOMAIN : `http://${DOMAIN}`) : "";

  const activeUrl = hostHeader ? `${protocol}://${hostHeader}` : localhostUrl;

  return {
    localhost: localhostUrl,
    networkIps: netIps,
    networkUrls: networkUrls,
    domain: domainUrl,
    activeUrl: activeUrl,
  };
}

app.get("/api/server", (req, res) => {
  const connections = getSystemConnectionUrls(req);
  res.json({
    status: "success",
    data: {
      serverId: SERVER_ID,
      pairCode: SERVER_ID,
      cloudAgent: cloudAgent ? cloudAgent.getInfo() : null,
      port: PORT,
      host: HOST,
      authEnabled: ENABLE_AUTH,
      cloudflare: process.env.CLOUDFLARE === "true" ? "Enabled" : "Disabled",
      connections: connections,
      createdAt: new Date().toISOString(),
    },
  });
});

app.get("/api/connection-info", (req, res) => {
  const connections = getSystemConnectionUrls(req);
  res.json({
    status: "success",
    serverId: SERVER_ID,
    pairCode: SERVER_ID,
    cloudAgent: cloudAgent ? cloudAgent.getInfo() : null,
    port: PORT,
    host: HOST,
    authEnabled: ENABLE_AUTH,
    connections: connections,
  });
});

/* ===============================
   PRINTER HELPERS & API
================================ */

function isPrinterOnline(ip, port = 9100, timeout = 1500) {
  return new Promise((resolve) => {
    if (!ip) return resolve(false);
    const socket = new net.Socket();
    socket.setTimeout(timeout);
    socket.on("connect", () => {
      socket.destroy();
      resolve(true);
    });
    socket.on("error", () => {
      socket.destroy();
      resolve(false);
    });
    socket.on("timeout", () => {
      socket.destroy();
      resolve(false);
    });
    socket.connect(port, ip);
  });
}

function savePrinters(printers) {
  safeWrite(PRINTER_FILE, { printers });
}

function safeWrite(file, data) {
  fs.writeFileSync(file, JSON.stringify(data, null, 2));
}

app.get(["/api/printers_app", "/api/printers"], async (req, res) => {
  const printers = loadPrinters();

  const result = await Promise.all(
    printers.map(async (p) => ({
      ...p,
      online: await isPrinterOnline(p.connection?.ip, p.connection?.port || 9100),
    })),
  );

  res.json({ printers: result });
});

// Save or update printer
let lastSaveSignature = "";
let lastSaveTime = 0;
let lastSaveResponse = null;

const handleSavePrinter = (req, res) => {
  const incomingData = req.body;

  if (!incomingData) {
    return res.status(400).json({ success: false, error: "No payload provided" });
  }

  // Prevent duplicate rapid calls (e.g. double submit or frontend sending twice within 600ms)
  const currentSignature = JSON.stringify(incomingData);
  const now = Date.now();
  if (now - lastSaveTime < 600 && currentSignature === lastSaveSignature && lastSaveResponse) {
    return res.json(lastSaveResponse);
  }

  const printers = loadPrinters();

  const generateIdFromName = (printerName, existingId = null) => {
    if (existingId) return existingId;
    const cleanName = String(printerName)
      .toLowerCase()
      .replace(/\s+/g, "-")
      .replace(/[^a-z0-9-]/g, "");
    const timestamp = Date.now().toString().slice(-6);
    return `${cleanName}-${timestamp}`;
  };

  let rawList = [];
  if (Array.isArray(incomingData)) {
    rawList = incomingData;
  } else if (incomingData.printers && Array.isArray(incomingData.printers)) {
    rawList = incomingData.printers;
  } else if (incomingData.data && Array.isArray(incomingData.data)) {
    rawList = incomingData.data;
  } else {
    rawList = [incomingData];
  }

  // Deduplicate incoming list in this single batch (keep latest)
  const seenKeys = new Set();
  const printersToSave = [];
  for (let i = rawList.length - 1; i >= 0; i--) {
    const item = rawList[i];
    if (!item || typeof item !== "object") continue;
    const itemRole = String(item.role || (item.printerRole || "KITCHEN")).trim().toUpperCase();
    const itemName = String(item.printerName || item.name || "").trim().toLowerCase();
    const itemIp = String(item.printerIp || item.connection?.ip || "").trim();
    const key = item.id ? `id_${item.id}` : `${itemRole}_${itemName}_${itemIp}`;
    if (!seenKeys.has(key)) {
      seenKeys.add(key);
      printersToSave.unshift(item);
    }
  }

  const results = [];

  printersToSave.forEach((data) => {
    let fullPrinter;

    if (data.printerName && data.printerIp) {
      fullPrinter = {
        id: data.id || generateIdFromName(data.printerName),
        name: data.printerName,
        role: data.role ? String(data.role).trim().toUpperCase() : "KITCHEN",
        enabled: data.enabled !== undefined ? data.enabled : true,
        connection: {
          ip: data.printerIp,
          port: parseInt(data.port || 9100),
        },
        paper: {
          name: data.paperName || "RECEIPT(72mm)",
          width: parseInt(data.paperWidth || 576),
        },
        printSettings: {
          cut: data.cut !== undefined ? data.cut : true,
        },
      };
    } else if (data.name && data.connection && data.connection.ip) {
      fullPrinter = { ...data };
      fullPrinter.role = fullPrinter.role ? String(fullPrinter.role).trim().toUpperCase() : "KITCHEN";
      if (!fullPrinter.id) {
        fullPrinter.id = generateIdFromName(data.name);
      }
      fullPrinter.connection.port = parseInt(fullPrinter.connection.port || 9100);
      if (fullPrinter.paper) {
        fullPrinter.paper.width = parseInt(fullPrinter.paper.width || 576);
      }
    } else {
      results.push({
        status: "error",
        error: "Invalid printer format",
        data: data,
      });
      return;
    }

    let existingIndex = -1;
    let action = "created";

    const explicitId = data.id || (data.printerId ? data.printerId : null);
    const incomingName = String(fullPrinter.name || "").trim().toLowerCase();
    const incomingRole = String(fullPrinter.role || "KITCHEN").trim().toUpperCase();
    const incomingIp = String(fullPrinter.connection?.ip || "").trim();

    // Check 1: Find by explicit ID if provided
    if (explicitId) {
      existingIndex = printers.findIndex((p) => p.id === explicitId);
    }

    // Check 2: Find by Name AND Role
    if (existingIndex < 0 && incomingName) {
      existingIndex = printers.findIndex(
        (p) =>
          p.name &&
          p.name.trim().toLowerCase() === incomingName &&
          String(p.role || "KITCHEN").trim().toUpperCase() === incomingRole
      );
    }

    // Check 3: Find by Name alone
    if (existingIndex < 0 && incomingName) {
      existingIndex = printers.findIndex(
        (p) => p.name && p.name.trim().toLowerCase() === incomingName
      );
    }

    // Check 4: Role-specific IP matching
    // Same IP can exist between CASHIER and KITCHEN sections without issue.
    // If same IP comes for KITCHEN role -> update existing KITCHEN printer with that IP.
    if (existingIndex < 0 && incomingIp) {
      if (incomingRole === "KITCHEN") {
        existingIndex = printers.findIndex(
          (p) =>
            String(p.role || "KITCHEN").trim().toUpperCase() === "KITCHEN" &&
            p.connection &&
            p.connection.ip === incomingIp
        );
      } else if (incomingRole === "CASHIER") {
        existingIndex = printers.findIndex(
          (p) =>
            String(p.role || "").trim().toUpperCase() === "CASHIER" &&
            p.connection &&
            p.connection.ip === incomingIp
        );
      }
    }

    if (existingIndex >= 0) {
      // Preserve existing ID if explicit ID was not provided
      if (!explicitId && printers[existingIndex].id) {
        fullPrinter.id = printers[existingIndex].id;
      }
      printers[existingIndex] = fullPrinter;
      action = "updated";
    } else {
      // Add new printer (Insert)
      fullPrinter.id = fullPrinter.id || generateIdFromName(fullPrinter.name);
      while (printers.some((p) => p.id === fullPrinter.id)) {
        fullPrinter.id = `${generateIdFromName(fullPrinter.name)}-${Math.floor(Math.random() * 1000)}`;
      }
      printers.push(fullPrinter);
      action = "created";
    }

    results.push({
      status: "success",
      action: action,
      printer: fullPrinter,
    });
  });

  savePrinters(printers);

  // Log printer save action
  results.forEach((r) => {
    if (r.status === "success") {
      addLogEntry(
        "INFO",
        "PRINTER_MGMT",
        `Printer "${r.printer.name}" (${r.printer.role}) ${r.action} for IP ${r.printer.connection?.ip}:${r.printer.connection?.port}`,
        { printer: r.printer, action: r.action }
      );
    }
  });

  const hasErrors = results.some((r) => r.status === "error");
  if (hasErrors) {
    addLogEntry(
      "ERROR",
      "PRINTER_MGMT",
      `Printer configuration save failed due to invalid format`,
      { results: results.filter((r) => r.status === "error") }
    );
    return res.status(400).json({
      success: false,
      error: "Failed to save printer due to invalid format",
      results: results,
    });
  }

  const responsePayload = {
    success: true,
    message: `Successfully saved ${results.length} printer(s)`,
    results: results,
    printer: results[0]?.printer,
  };

  lastSaveSignature = currentSignature;
  lastSaveTime = now;
  lastSaveResponse = responsePayload;

  res.json(responsePayload);
};

app.post(
  ["/api/printer/save", "/api/printer/save_printers", "/api/save_printers", "/save_printers"],
  handleSavePrinter
);

// Delete printer endpoint
app.post("/api/printer/delete", (req, res) => {
  const { id } = req.body || {};
  if (!id) {
    addLogEntry("ERROR", "PRINTER_MGMT", "Printer delete failed: Printer ID missing in request");
    return res.status(400).json({ success: false, error: "Printer ID is required" });
  }

  let printers = loadPrinters();
  const initialLength = printers.length;
  const deletedPrinter = printers.find((p) => p.id === id);
  printers = printers.filter((p) => p.id !== id);

  if (printers.length === initialLength) {
    addLogEntry("ERROR", "PRINTER_MGMT", `Printer delete failed: Printer ID "${id}" not found`);
    return res.status(404).json({ success: false, error: "Printer not found" });
  }

  savePrinters(printers);

  addLogEntry(
    "WARN",
    "PRINTER_MGMT",
    `Printer "${deletedPrinter?.name || id}" removed from system`,
    { deletedId: id, deletedPrinter }
  );

  res.json({ success: true, message: "Printer deleted successfully" });
});

// Remove all printers endpoint
app.post(
  ["/api/printer/delete_all", "/api/printer/remove_all", "/api/printer/clear_all"],
  (req, res) => {
    const printers = loadPrinters();
    const count = printers.length;

    savePrinters([]);

    addLogEntry(
      "WARN",
      "PRINTER_MGMT",
      `All printers removed from system (${count} printer(s) cleared)`,
      { count }
    );

    res.json({
      success: true,
      message: `All ${count} printer(s) removed successfully`,
      count,
    });
  }
);

// Test printer endpoint
app.post("/api/printer/test", async (req, res) => {
  const { printerId, printerIp, printerPort } = req.body || {};
  const printers = loadPrinters();
  const printer = printers.find((p) => p.id === printerId) || {
    connection: { ip: printerIp, port: printerPort || 9100 },
    name: "Test Printer",
  };

  const targetIp = printer.connection?.ip || printerIp;
  const targetPort = printer.connection?.port || printerPort || 9100;

  if (!targetIp) {
    addLogEntry("ERROR", "PRINTER_TEST", "Test print failed: Missing Printer IP", { reqBody: req.body });
    return res.status(400).json({ success: false, error: "Printer IP is required" });
  }

  const online = await isPrinterOnline(targetIp, targetPort);
  if (!online) {
    const diag = analyzePrintFailure(targetIp, targetPort, "Printer offline or TCP port unreachable");
    addLogEntry(
      "ERROR",
      "PRINTER_TEST",
      `Test Print Failed: ${printer.name || "Printer"} (${targetIp}:${targetPort}) is UNREACHABLE`,
      diag
    );
    return res.json({
      success: false,
      printed: false,
      error: `Printer offline or unreachable at ${targetIp}:${targetPort}`,
      diagnostics: diag,
    });
  }

  try {
    const socket = new net.Socket();
    socket.connect(targetPort, targetIp, () => {
      const initCmd = Buffer.from([0x1b, 0x40]);
      const centerCmd = Buffer.from([0x1b, 0x61, 0x01]);
      const title = Buffer.from("--- ANDROPRINT TEST PRINT ---\n\n", "utf8");
      const text = Buffer.from(`Printer: ${printer.name || "ESC/POS"}\nIP: ${targetIp}:${targetPort}\nStatus: OK\nDate: ${new Date().toLocaleString()}\n\n\n`, "utf8");
      const cutCmd = Buffer.from([0x1d, 0x56, 0x42, 0x00]);

      socket.write(Buffer.concat([initCmd, centerCmd, title, text, cutCmd]));
      socket.end();

      addLogEntry(
        "SUCCESS",
        "PRINTER_TEST",
        `Test Print Job SENT to "${printer.name || "Printer"}" (${targetIp}:${targetPort})`,
        { printerName: printer.name, ip: targetIp, port: targetPort }
      );

      res.json({
        success: true,
        printed: true,
        message: "Test print sent successfully",
      });
    });

    socket.on("error", (err) => {
      socket.destroy();
      const diag = analyzePrintFailure(targetIp, targetPort, err.message);
      addLogEntry(
        "ERROR",
        "PRINTER_TEST",
        `Test Print Socket Error for "${printer.name || "Printer"}" (${targetIp}:${targetPort}): ${err.message}`,
        diag
      );
      res.json({
        success: false,
        printed: false,
        error: `Print connection error: ${err.message}`,
        diagnostics: diag,
      });
    });
  } catch (err) {
    const diag = analyzePrintFailure(targetIp, targetPort, err.message);
    addLogEntry(
      "ERROR",
      "PRINTER_TEST",
      `Test Print Exception: ${err.message}`,
      diag
    );
    res.json({
      success: false,
      printed: false,
      error: `Test print error: ${err.message}`,
      diagnostics: diag,
    });
  }
});

/* ===============================
   SYSTEM LOGS API
================================ */

app.get("/api/logs", (req, res) => {
  let filtered = [...systemLogs];
  const { limit, level, type, search } = req.query;

  if (level) {
    filtered = filtered.filter((l) => l.level === String(level).toUpperCase());
  }
  if (type) {
    filtered = filtered.filter((l) => l.type.includes(String(type).toUpperCase()));
  }
  if (search) {
    const s = String(search).toLowerCase();
    filtered = filtered.filter(
      (l) =>
        l.message.toLowerCase().includes(s) ||
        JSON.stringify(l.details || {}).toLowerCase().includes(s)
    );
  }

  const maxLimit = parseInt(limit) || 200;
  res.json({
    success: true,
    total: filtered.length,
    logs: filtered.slice(0, maxLimit),
  });
});

app.post("/api/logs/clear", (req, res) => {
  systemLogs = [];
  try {
    fs.writeFileSync(LOG_FILE, "");
  } catch (err) { }
  addLogEntry("INFO", "SERVER", "System logs cleared by user");
  res.json({ success: true, message: "Logs cleared successfully" });
});

app.post("/api/cloud-test", (req, res) => {
  const mqtt = require("mqtt");
  const brokerUrl = process.env.MQTT_BROKER || "wss://broker.emqx.io:8084/mqtt";
  const topic = `androprint/${SERVER_ID}/print`;

  const testClient = mqtt.connect(brokerUrl, {
    clientId: "tester_" + Math.random().toString(16).slice(2, 8),
    clean: true,
  });

  testClient.on("connect", () => {
    const payload = {
      printerId: req.body?.printerId || "",
      data: {
        isInvoiceData: { isInvoice: true },
        master: {
          BillNo: "TEST-" + Math.floor(1000 + Math.random() * 9000),
          BillPartyName: "MQTT Cloud Test User",
          BillNetTotalField: "100.00",
          BillDate: new Date().toLocaleDateString(),
          BillTime: new Date().toLocaleTimeString(),
        },
        company: [{ CompanyName: "CLOUD PRINT TEST", Address1: "Pair Code: " + SERVER_ID }],
        table: [{ ItemName: "Cloud Print Verification", Qty: 1, Rate: 100, Amount: 100 }],
      },
    };

    testClient.publish(topic, JSON.stringify(payload), { qos: 1 }, (err) => {
      testClient.end();
      if (err) {
        return res.status(500).json({ success: false, error: err.message });
      }
      res.json({
        success: true,
        message: "Cloud MQTT print dispatched successfully!",
        pairCode: SERVER_ID,
        topic: topic,
      });
    });
  });

  testClient.on("error", (err) => {
    testClient.end();
    res.status(500).json({ success: false, error: err.message });
  });
});

app.get(["/logs", "/logs.html"], (req, res) => {
  res.sendFile(path.join(PUBLIC_FOLDER, "logs.html"));
});

// async function prepareLogo() {
//   try {

//     // if already resized, use it
//     if (fs.existsSync(logoResized)) {
//       return logoResized;
//     }

//     // resize logo
//     await sharp(logoOriginal)
//       .resize({
//         width: 300,        // best centered width
//         fit: "contain",
//         background: "white"
//       })
//       .toFile(logoResized);

//     return logoResized;

//   } catch (error) {
//     console.log("Logo resize error:", error.message);
//     return logoOriginal;
//   }
// }

// find logo from public folder

// resize logo for thermal printer

function getLogoPath() {
  const files = fs.readdirSync(PUBLIC_FOLDER);

  for (let file of files) {
    if (allowedExt.includes(path.extname(file).toLowerCase())) {
      return path.join(PUBLIC_FOLDER, file);
    }
  }

  return null;
}

async function prepareLogo() {
  try {
    // find logo automatically
    const files = fs.readdirSync(PUBLIC_FOLDER);

    const allowedExt = [".png", ".jpg", ".jpeg", ".webp", ".bmp"];

    let inputPath = null;

    for (let file of files) {
      if (allowedExt.includes(path.extname(file).toLowerCase())) {
        inputPath = path.join(PUBLIC_FOLDER, file);
        break;
      }
    }

    if (!inputPath) {
      console.log("No logo found in public folder");
      return null;
    }

    // resize and fix spacing
    await sharp(inputPath)
      .flatten({ background: "#FFFFFF" })
      .trim()
      .resize({
        width: 320,
        fit: "contain",
        background: "#FFFFFF",
      })
      .extend({
        top: 0,
        bottom: 8,
        left: 0,
        right: 0,
        background: "#FFFFFF",
      })
      .png()
      .toFile(RESIZED_LOGO);

    return RESIZED_LOGO;
  } catch (err) {
    console.log("Logo fix error:", err.message);
    return null;
  }
}

/* ===============================
   START SERVER
================================ */

app.listen(PORT, HOST, () => {
  const netIps = getNetworkIps();
  console.log("==================================================");
  console.log("             ANDROPRINT SERVER RUNNING            ");
  console.log("==================================================");
  console.log("  Localhost URL :", `http://localhost:${PORT}`);
  if (netIps.length > 0) {
    netIps.forEach((ip) => {
      console.log("  Network IP URL:", `http://${ip}:${PORT}`);
    });
  } else {
    console.log("  Network IP URL: Not connected to network");
  }
  if (DOMAIN) {
    const formattedDomain = DOMAIN.startsWith("http") ? DOMAIN : `http://${DOMAIN}`;
    console.log("  Domain URL    :", formattedDomain);
  }
  console.log("--------------------------------------------------");
  console.log("  Bound Host    :", HOST);
  console.log("  Server ID     :", SERVER_ID);
  console.log("  Auth          :", ENABLE_AUTH ? "ENABLED" : "DISABLED");
  console.log("==================================================");

  addLogEntry(
    "INFO",
    "SERVER",
    `AndroPrint Server Started on port ${PORT} (${HOST})`,
    {
      port: PORT,
      host: HOST,
      networkIps: netIps,
      domain: DOMAIN || null,
      authEnabled: ENABLE_AUTH,
    }
  );
});
