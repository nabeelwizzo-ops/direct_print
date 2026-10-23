// ==============================================================================
// AndroPrint Server Watchdog
// Keeps core/server.js running continuously and auto-restarts on exit or crash.
// ==============================================================================

const { spawn } = require("child_process");
const path = require("path");

const SERVER_SCRIPT = path.join(__dirname, "..", "core", "server.js");
const RESTART_DELAY = 2000; // 2 seconds delay before auto-restarting

let serverProcess = null;
let isStopping = false;

function startServer() {
    if (isStopping) return;

    console.log(`[WATCHDOG] Starting AndroPrint Server: ${SERVER_SCRIPT}`);

    serverProcess = spawn(process.execPath, [SERVER_SCRIPT], {
        cwd: path.join(__dirname, ".."),
        stdio: "inherit",
    });

    serverProcess.on("exit", (code, signal) => {
        console.log(`[WATCHDOG] Server process exited with code ${code}, signal: ${signal}`);
        serverProcess = null;

        if (!isStopping) {
            console.log(`[WATCHDOG] Restarting server in ${RESTART_DELAY / 1000} seconds...`);
            setTimeout(startServer, RESTART_DELAY);
        }
    });

    serverProcess.on("error", (err) => {
        console.error(`[WATCHDOG] Failed to start server process: ${err.message}`);
        serverProcess = null;

        if (!isStopping) {
            setTimeout(startServer, RESTART_DELAY);
        }
    });
}

// Handle termination signals
process.on("SIGINT", () => {
    isStopping = true;
    if (serverProcess) serverProcess.kill("SIGINT");
    process.exit(0);
});

process.on("SIGTERM", () => {
    isStopping = true;
    if (serverProcess) serverProcess.kill("SIGTERM");
    process.exit(0);
});

// Start the watchdog
startServer();
