const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");

const ROOT = path.join(__dirname, "..");
const STAGING = path.join(ROOT, "_staging_androprint");
const ZIP_FILE = path.join(ROOT, "androprint_client_setup.zip");

console.log("Preparing client package staging directory...");

if (fs.existsSync(STAGING)) {
  fs.rmSync(STAGING, { recursive: true, force: true });
}
fs.mkdirSync(STAGING, { recursive: true });

function copyDir(src, dest, filterFn) {
  if (!fs.existsSync(src)) return;
  fs.mkdirSync(dest, { recursive: true });
  const entries = fs.readdirSync(src, { withFileTypes: true });

  for (const entry of entries) {
    const srcPath = path.join(src, entry.name);
    const destPath = path.join(dest, entry.name);

    if (filterFn && !filterFn(srcPath, entry)) continue;

    if (entry.isDirectory()) {
      copyDir(srcPath, destPath, filterFn);
    } else {
      fs.copyFileSync(srcPath, destPath);
    }
  }
}

// 1. Copy core
copyDir(path.join(ROOT, "core"), path.join(STAGING, "core"), (filePath, entry) => {
  // Exclude old nested zip backups
  if (entry.name.endsWith(".zip")) return false;
  return true;
});

// 2. Copy public
copyDir(path.join(ROOT, "public"), path.join(STAGING, "public"));

// 3. Copy config
copyDir(path.join(ROOT, "config"), path.join(STAGING, "config"), (filePath, entry) => {
  if (entry.name.endsWith(".zip")) return false;
  return true;
});

// 4. Copy scripts
copyDir(path.join(ROOT, "scripts"), path.join(STAGING, "scripts"), (filePath, entry) => {
  if (entry.name === "pack_client_zip.js") return false;
  return true;
});

// 5. Copy print_formats
if (fs.existsSync(path.join(ROOT, "print_formats"))) {
  copyDir(path.join(ROOT, "print_formats"), path.join(STAGING, "print_formats"));
}

// 6. Copy root files
const rootFiles = [
  "server.js",
  "package.json",
  "package-lock.json",
  ".env",
  ".env.example",
  "printerexamplefull.env",
  "ecosystem.config.js",
  "setup.bat",
  "setup.sh",
  "install_service.bat",
  "uninstall_service.bat",
  "set_static_ip.bat",
  "readme.txt",
  "README.md"
];

for (const file of rootFiles) {
  const src = path.join(ROOT, file);
  if (fs.existsSync(src)) {
    fs.copyFileSync(src, path.join(STAGING, file));
  }
}

// 7. Ensure clean initial system.log for client
const stagingLog = path.join(STAGING, "config", "system.log");
const initialLogEntry = JSON.stringify({
  id: `log_${Date.now()}_001`,
  timestamp: new Date().toISOString(),
  level: "INFO",
  type: "SERVER",
  message: "AndroPrint Client Package Initialized",
  details: { status: "Ready for Client Setup" }
}) + "\n";
fs.writeFileSync(stagingLog, initialLogEntry, "utf8");

console.log("Staging prepared. Creating zip archive...");

// Backup existing zip before replacing
const BACKUP_ZIP = path.join(ROOT, "androprint_client_setup_backup.zip");
if (fs.existsSync(ZIP_FILE)) {
  try {
    fs.copyFileSync(ZIP_FILE, BACKUP_ZIP);
    console.log(`Created backup of previous zip at: ${BACKUP_ZIP}`);
  } catch (e) {
    console.warn("Could not create backup zip:", e.message);
  }
  fs.unlinkSync(ZIP_FILE);
}

// Create zip using PowerShell Compress-Archive
const psCmd = `powershell -NoProfile -Command "Compress-Archive -Path '${STAGING}\\*' -DestinationPath '${ZIP_FILE}' -CompressionLevel Optimal"`;

try {
  execSync(psCmd, { stdio: "inherit" });
  console.log(`Successfully created: ${ZIP_FILE}`);
  const stats = fs.statSync(ZIP_FILE);
  console.log(`Archive size: ${(stats.size / 1024).toFixed(1)} KB`);
} catch (err) {
  console.error("PowerShell zip failed, trying tar:", err.message);
  execSync(`tar -a -c -f "${ZIP_FILE}" -C "${STAGING}" .`, { stdio: "inherit" });
} finally {
  if (fs.existsSync(STAGING)) {
    fs.rmSync(STAGING, { recursive: true, force: true });
  }
}
