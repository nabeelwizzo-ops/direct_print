==================================================
 ANDROPRINT – API & USAGE DOCUMENTATION
 Developed by MSAMODS
==================================================

AndroPrint is an Android-based ESC/POS thermal print server
running on Termux + Node.js.

It supports LAN & Cloud printing with optional security,
multi-printer management, and admin UI.

--------------------------------------------------
 SERVER INFO
--------------------------------------------------

Local URL:
http://localhost:3000

If Cloudflare enabled:
https://xxxx.trycloudflare.com

Admin UI:
http://localhost:3000/index.html
(Login: admin / 1231)

--------------------------------------------------
 ENDPOINT SUMMARY (FINAL)
--------------------------------------------------

🔐 ADMIN / INFO
----------------------------------
GET  /api/config
GET  /api/cloudflare

👥 CLIENT MANAGEMENT
----------------------------------
POST /api/client/create
GET  /api/clients

🖨 PRINTER MANAGEMENT
----------------------------------
GET  /api/printers
POST /api/printer/save
POST /api/printer/delete
POST /api/printer/test

🧾 PRINTING
----------------------------------
POST /print

📄 DOCUMENT PRINTING (ADVANCED)
----------------------------------
POST /pdftoimg
POST /pdfdirect
POST /img
POST /html

--------------------------------------------------
 BASIC TEXT PRINT (NO AUTH)
--------------------------------------------------

This prints text to a specific printer.

Example: Print "Hi from shefin" to Cashier1

curl -X POST http://localhost:3000/print \
  -H "Content-Type: application/json" \
  -H "x-printer-id: Cashier1" \
  -d '{"text":"Hi from shefin"}'

--------------------------------------------------
 AUTHENTICATED PRINT (IF ENABLED)
--------------------------------------------------

If ENABLE_CLIENT_AUTH=true in .env,
you MUST include client headers.

Example headers:
x-client-id   → clt-SLWPXp
x-print-key   → 143368

Example curl:

curl -X POST http://localhost:3000/print \
  -H "Content-Type: application/json" \
  -H "x-client-id: clt-SLWPXp" \
  -H "x-print-key: 143368" \
  -H "x-printer-id: Cashier1" \
  -d '{"text":"Secure Print Test"}'

--------------------------------------------------
 CLOUDFARE (TEMPORARY URL)
--------------------------------------------------

If .env contains:
CLOUDFLARE=true

Server will automatically generate a temporary
Cloudflare URL on startup.

Terminal output example:

☁ CLOUDFLARE TEMP URL
https://abc123.trycloudflare.com

Admin UI:
https://abc123.trycloudflare.com/dashboard.html

API Base:
https://abc123.trycloudflare.com/print

Cloudflare info API:
GET /api/cloudflare

--------------------------------------------------
 PDF → IMAGE PRINT
--------------------------------------------------

This converts a PDF to image and prints it.

Endpoint:
POST /pdftoimg

Example curl:

curl -X POST http://localhost:3000/pdftoimg \
  -H "x-printer-id: Cashier1" \
  -F "file=@invoice.pdf"

--------------------------------------------------
 DIRECT PDF PRINT
--------------------------------------------------

Print PDF directly (printer must support it).

Endpoint:
POST /pdfdirect

curl -X POST http://localhost:3000/pdfdirect \
  -H "x-printer-id: Cashier1" \
  -F "file=@bill.pdf"

--------------------------------------------------
 IMAGE PRINT
--------------------------------------------------

Endpoint:
POST /img

curl -X POST http://localhost:3000/img \
  -H "x-printer-id: Cashier1" \
  -F "file=@logo.png"

--------------------------------------------------
 HTML PRINT
--------------------------------------------------

Endpoint:
POST /html

curl -X POST http://localhost:3000/html \
  -H "Content-Type: application/json" \
  -H "x-printer-id: Cashier1" \
  -d '{"html":"<h1>Hello AndroPrint</h1>"}'

--------------------------------------------------
 NOTES
--------------------------------------------------

• Max printers:
  - 3 CASHIER
  - 3 KITCHEN

• Printer config stored in:
  printer.env

• Client auth can be disabled:
  ENABLE_CLIENT_AUTH=false

• Cloudflare temp URL changes on restart
  (use named tunnel for permanent URL)

--------------------------------------------------
 DEVELOPED BY
--------------------------------------------------

MSAMODS
In partnership with WhatYouWantKerala (WYWK)

==================================================
 END OF DOCUMENT
==================================================
