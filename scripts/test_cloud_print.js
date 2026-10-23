/**
 * Quick Test Script for Cloud Printing via MQTT Pair Code
 * Run: node test_cloud_print.js
 */

const mqtt = require("mqtt");
const fs = require("fs");
const path = require("path");

// 1. Get Pair Code from config
const serverIdFile = path.join(__dirname, "config", "server.id");
let pairCode = "srv-0f6fecb2-a23d-4103-a52f-f6aff267fcdb";
if (fs.existsSync(serverIdFile)) {
  pairCode = fs.readFileSync(serverIdFile, "utf8").trim();
}

const brokerUrl = "wss://broker.emqx.io:8084/mqtt";
const topic = `androprint/${pairCode}/print`;

console.log("==========================================");
console.log("    CLOUD PRINT MQTT TEST SCRIPT          ");
console.log("==========================================");
console.log("  Target Pair Code :", pairCode);
console.log("  Broker URL       :", brokerUrl);
console.log("  Topic            :", topic);
console.log("==========================================");

const client = mqtt.connect(brokerUrl, {
  clientId: "cloud_tester_" + Math.random().toString(16).slice(2, 8),
  clean: true,
  connectTimeout: 8000,
});

client.on("connect", () => {
  console.log("✅ Connected to Cloud MQTT Broker!");

  // Mock Invoice / Print Payload
  const testPayload = {
    printerId: "", // Empty will auto-select first enabled printer, or specify e.g. "kitchen-166559"
    data: {
      isInvoiceData: {
        isInvoice: true,
      },
      master: {
        BillNo: "CLOUD-TEST-" + Math.floor(1000 + Math.random() * 9000),
        BillPartyName: "Cloud MQTT Test Customer",
        BillNetTotalField: "150.00",
        BillDate: new Date().toLocaleDateString(),
        BillTime: new Date().toLocaleTimeString(),
      },
      company: [
        {
          CompanyName: "ANDROPRINT CLOUD TEST",
          Address1: "Zero-Tunnel MQTT Mode",
          Phone1: "+91 9876543210",
        },
      ],
      table: [
        {
          ItemName: "Cloud Print Test Item 1",
          Qty: 1,
          Rate: 100.0,
          Amount: 100.0,
        },
        {
          ItemName: "Cloud Service Fee",
          Qty: 1,
          Rate: 50.0,
          Amount: 50.0,
        },
      ],
    },
  };

  const message = JSON.stringify(testPayload);
  console.log("🚀 Sending Cloud Print Job...");

  client.publish(topic, message, { qos: 1 }, (err) => {
    if (err) {
      console.error("❌ Failed to publish cloud print:", err.message);
    } else {
      console.log("🎉 SUCCESS! Cloud Print Job Published successfully to topic:", topic);
      console.log("👉 Check your DirectPrint Terminal & System Logs page (/logs.html)!");
    }
    client.end();
  });
});

client.on("error", (err) => {
  console.error("❌ MQTT Connection Error:", err.message);
  client.end();
});
