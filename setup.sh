#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "======================================"
echo "   ANDROPRINT v2 – ONE CLICK INSTALL"
echo "======================================"
echo ""

# -----------------------------
# BASIC CHECKS
# -----------------------------
if [ ! -d "$HOME" ]; then
  echo "❌ Termux environment not detected"
  exit 1
fi

# -----------------------------
# SYSTEM UPDATE
# -----------------------------
echo "🔄 Updating system..."
pkg update -y && pkg upgrade -y

# -----------------------------
# CORE PACKAGES
# -----------------------------
echo "📦 Installing core packages..."
pkg install -y \
  nodejs \
  git \
  curl \
  jq \
  netcat-openbsd \
  poppler \
  imagemagick \
  cloudflared \
  openjdk-21 \
  maven

# -----------------------------
# PROJECT ROOT
# -----------------------------
ROOT_DIR="$HOME/downloads/AndroPrint"
cd "$ROOT_DIR"

echo "📂 Project directory:"
echo "➡ $ROOT_DIR"
echo ""

# -----------------------------
# REQUIRED DIRECTORIES
# -----------------------------
echo "📁 Creating required folders..."
mkdir -p uploads
mkdir -p logs
mkdir -p config
mkdir -p print_formats
mkdir -p java_print/jasper/compiled

# -----------------------------
# NODE DEPENDENCIES
# -----------------------------
echo "📦 Installing Node.js dependencies..."
npm install --production

# -----------------------------
# PM2 INSTALL
# -----------------------------
if ! command -v pm2 >/dev/null 2>&1; then
  echo "⚙️ Installing PM2..."
  npm install -g pm2
else
  echo "✔ PM2 already installed"
fi

# -----------------------------
# ENV CHECK
# -----------------------------
if [ ! -f ".env" ]; then
  echo "⚠️ .env not found, creating from example..."
  cp printerexamplefull.env .env
  echo "➡ Edit .env before production use"
fi

# -----------------------------
# JAVA PRINT ENGINE BUILD
# -----------------------------
JAVA_ENGINE="$ROOT_DIR/java_print/jasper/java_print/springboot/print-engine"

if [ -d "$JAVA_ENGINE" ]; then
  echo "☕ Building Java Print Engine..."
  cd "$JAVA_ENGINE"
  mvn clean package
else
  echo "❌ Java Print Engine not found!"
  exit 1
fi

# -----------------------------
# LOAD ENV FOR JAVA
# -----------------------------
echo "🔑 Loading .env variables..."
cd "$ROOT_DIR"
set -a
source .env
set +a

# -----------------------------
# START JAVA PRINT ENGINE
# -----------------------------
echo "🚀 Starting Java Print Engine (Jasper)..."
pm2 delete androprint-java >/dev/null 2>&1 || true
pm2 start java \
  --name androprint-java \
  -- -jar "$JAVA_ENGINE/target/print-engine-1.0.0.jar"

# -----------------------------
# START ANDROPRINT CORE
# -----------------------------
echo "🚀 Starting AndroPrint Core (Node)..."
pm2 delete androprint-core >/dev/null 2>&1 || true
pm2 start core/server.js --name androprint-core

# -----------------------------
# PM2 AUTOSTART
# -----------------------------
echo "🔁 Enabling PM2 startup..."
pm2 save

# -----------------------------
# START CLOUDFLARE TUNNEL
# -----------------------------
if [ "$CLOUDFLARE" = "true" ]; then
  echo "☁ Starting Cloudflare Tunnel..."
  pm2 delete androprint-cloudflare >/dev/null 2>&1 || true
  pm2 start scripts/cloudflare.sh \
    --name androprint-cloudflare
else
  echo "☁ Cloudflare disabled"
fi


# -----------------------------
# FINAL STATUS
# -----------------------------
echo ""
echo "======================================"
echo " ✅ ANDROPRINT v2 SETUP COMPLETE"
echo "======================================"
echo ""
echo "🖥 AndroPrint Core : http://localhost:3000"
echo "☕ Java Print API  : http://localhost:8090"
echo ""
echo "📄 Admin UI:"
echo "➡ http://localhost:3000/index.html"
echo ""
echo "🖨 Jasper Test API:"
echo "➡ POST http://localhost:8090/print/test"
echo ""
echo "⚙ PM2 Status:"
pm2 status
echo ""
echo "🎉 AndroPrint v2 is LIVE!"
