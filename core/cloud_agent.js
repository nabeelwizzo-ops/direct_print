/**
 * Cloud Print Agent (MQTT Zero-Tunnel Architecture)
 * Inspired by AndroPrint v2.0
 * Connects securely to MQTT Broker and listens for cloud print jobs using Pair Code (Server ID).
 */

const mqtt = require("mqtt");

class CloudPrintAgent {
  constructor(options = {}) {
    this.serverId = options.serverId || "dp-" + Math.random().toString(36).slice(2, 8);
    this.brokerUrl = options.brokerUrl || process.env.MQTT_BROKER || "wss://broker.emqx.io:8084/mqtt";
    this.fallbackBroker = "wss://broker.hivemq.com:8884/mqtt";
    this.printHandler = options.onPrintJob || null;
    this.addLog = options.addLogEntry || console.log;
    this.client = null;
    this.status = "DISCONNECTED"; // DISCONNECTED | CONNECTING | CONNECTED | ERROR
    this.lastSeen = null;
    this.reconnectAttempts = 0;
  }

  get topic() {
    return `androprint/${this.serverId}/print`;
  }

  get statusTopic() {
    return `androprint/${this.serverId}/status`;
  }

  start() {
    if (this.client) return;

    this.status = "CONNECTING";
    const clientId = `androprint_srv_${this.serverId}_${Math.random().toString(16).slice(2, 6)}`;

    console.log(`[CLOUD_AGENT] Connecting to Cloud MQTT Broker: ${this.brokerUrl}`);
    console.log(`[CLOUD_AGENT] Pair Code (Topic): ${this.topic}`);

    try {
      this.client = mqtt.connect(this.brokerUrl, {
        clientId: clientId,
        clean: true,
        connectTimeout: 10000,
        reconnectPeriod: 5000,
        keepalive: 60,
      });

      this.client.on("connect", () => {
        this.status = "CONNECTED";
        this.lastSeen = new Date().toISOString();
        this.reconnectAttempts = 0;
        console.log(`[CLOUD_AGENT] ✅ Connected to Cloud MQTT Broker. Listening on ${this.topic}`);

        // Subscribe to print commands for this Pair Code
        this.client.subscribe(this.topic, { qos: 1 }, (err) => {
          if (err) {
            console.error(`[CLOUD_AGENT] ❌ Subscribe error:`, err.message);
          } else {
            // Publish status online
            this.client.publish(
              this.statusTopic,
              JSON.stringify({
                status: "ONLINE",
                serverId: this.serverId,
                timestamp: new Date().toISOString(),
              }),
              { retain: true, qos: 1 }
            );

            if (typeof this.addLog === "function") {
              this.addLog(
                "SUCCESS",
                "CLOUD_AGENT",
                `Cloud Print Agent Connected! Pair Code: ${this.serverId}`,
                {
                  pairCode: this.serverId,
                  topic: this.topic,
                  broker: this.brokerUrl,
                }
              );
            }
          }
        });
      });

      this.client.on("message", async (receivedTopic, messageBuffer) => {
        if (receivedTopic !== this.topic) return;

        try {
          const raw = messageBuffer.toString("utf8");
          const payload = JSON.parse(raw);
          const printerId = payload.printerId || payload.printer || null;
          const printData = payload.data || payload;

          if (typeof this.addLog === "function") {
            this.addLog(
              "INFO",
              "CLOUD_PRINT",
              `Cloud print job received via Pair Code [${this.serverId}] for Printer: "${printerId || "AUTO"}"`,
              {
                pairCode: this.serverId,
                printerId: printerId,
                payloadSize: raw.length,
                timestamp: new Date().toISOString(),
              }
            );
          }

          if (typeof this.printHandler === "function") {
            await this.printHandler({
              printerId: printerId,
              data: printData,
              source: "CLOUD_MQTT",
            });
          }
        } catch (err) {
          console.error(`[CLOUD_AGENT] ❌ Failed to parse incoming print payload:`, err.message);
          if (typeof this.addLog === "function") {
            this.addLog(
              "ERROR",
              "CLOUD_PRINT",
              `Failed to process cloud print message: ${err.message}`,
              { error: err.message }
            );
          }
        }
      });

      this.client.on("error", (err) => {
        this.status = "ERROR";
        console.error(`[CLOUD_AGENT] ⚠️ MQTT Error:`, err.message);
      });

      this.client.on("offline", () => {
        this.status = "DISCONNECTED";
      });

      this.client.on("reconnect", () => {
        this.reconnectAttempts++;
        this.status = "CONNECTING";
      });
    } catch (e) {
      this.status = "ERROR";
      console.error(`[CLOUD_AGENT] ❌ Exception in CloudPrintAgent:`, e.message);
    }
  }

  getInfo() {
    return {
      pairCode: this.serverId,
      status: this.status,
      topic: this.topic,
      broker: this.brokerUrl,
      lastSeen: this.lastSeen,
    };
  }

  stop() {
    if (this.client) {
      try {
        this.client.end(true);
      } catch {}
      this.client = null;
      this.status = "DISCONNECTED";
    }
  }
}

module.exports = CloudPrintAgent;
