# 🖨️ AndroPrint – Android Thermal Print Server (ESC/POS)

AndroPrint converts an Android phone into a fully operational
multi-printer thermal print server using Termux + Node.js.

No PC. No root. POS-grade architecture.

## Features
- Multi-printer (Cashier / Kitchen)
- Secure PIN + Client ID
- Admin Web UI
- printer.env based configuration
- PM2 background service
- Cloudflare tunnel support
- ASCII / Text / Image printing

## Start
```bash
cp .env.example .env
bash setup.sh
node server.js
=======
ANDROPRINT
==========
Android Thermal Print Server (ESC/POS)

AndroPrint is a production-ready Android-based thermal printer server that turns
any Android phone into a secure LAN or Cloud print gateway for ESC/POS printers.

Built using Termux + Node.js, AndroPrint removes the need for a PC, Raspberry Pi,
or proprietary printer drivers.

--------------------------------------------------
FEATURES
--------------------------------------------------
- No PC required
- No root required
- Works fully offline (LAN)
- Optional Cloudflare Tunnel support
- Secure PIN-based printing
- One-click setup
- Low memory usage
- Admin dashboard
- SQLite-based credentials
- PM2 background service

--------------------------------------------------
ARCHITECTURE
--------------------------------------------------
Client / Web / Cloud
        |
        v
HTTP Print API
        |
        v
Android Phone (Termux + Node.js)
        |
        v
ESC/POS Thermal Printer (LAN TCP 9100)

--------------------------------------------------
SUPPORTED PRINT TYPES
--------------------------------------------------
/txtprint     -> Text & ASCII receipts
/img          -> Image printing (PNG/JPG)
/pdftoimg     -> Fast PDF printing (PDF -> Image)
/pdfdirect    -> Alias for pdftoimg

--------------------------------------------------
SECURITY MODEL
--------------------------------------------------
- 16-digit Print PIN
- Unique Client ID per device
- SQLite credential store
- Admin login (admin / 1231)
- Device access can be disabled

No IMEI, no Ads ID, no MAC tracking.

--------------------------------------------------
ASCII / THERMAL LOGO SUPPORT
--------------------------------------------------

                                  .........                 ....
                                  ........                 ......
                                   ..+*+...             ....-**:.
                                  ...:+*+... ..............=*+:..
                                    ...-:..:-=+++**+++=-:..:-....
                                    ....=+****************+=:....
                                   ..:+**********************+-.....
                               ....:+***************************-...
                               ...-******************************=..
                               ..=********************************+....
                              ..-********++**************++********=...
                            ....********+:.=************+..+********-...
                            ...=************************************+...
                            ...+************************************+..
                            ...=+++++++++++++++++++++++++++++++++++++...
                            ............................................
                            ...........:-----=-=---+==:-=:=.............
                                      .-.::::-::.-::...::.::.
                        ..:=+++..:++++++++++++++++++++++++++++++++-..=++=:....
                        .:+***+..:+*******************************-..+***+:...
                        .:+***+..:+********%%##########%%*********-..+***+:..
                        .:+***+..:+********%#**********#%*********-..+***+:..
                        .:+***+..:+*******#%%**********%%#********-..+***+:..
                        .:+***+..:+***%%####################%%****-..+***+:..
                        .:+***+..:+***%**********************%#***-..+***+:..
                        .:+***+..:+***%******************##**%#***-..+***+:..
                        .:+***+..:+***%**********************%#***-..+***+:..
                        .:+***+..:+***%**********************%#***-..+***+:..
                        .:+***+..:+***%**##################**%#***-..+***+:..
                        ..=+*+-..:+***%***#%%##########%%#***%#***-..:+**=...
                        .........:+***%%#**%#**######**#%**#%%****-..........
                                .:+********%#**********#%*********-.
                               ..:+********%#*########*#%*********-.
                               ...--------=%#-========-#%=--------:.
                                ....     .:##**********##:      ..
                                         .................

--------------------------------------------------
INSTALLATION (TERMUX)
--------------------------------------------------
git clone https://github.com/msamods/androprint.git
cd androprint
bash setup.sh

--------------------------------------------------
RUN SERVER
--------------------------------------------------
node server.js

Admin Panel:
http://localhost:3000
Login: admin / **** 

--------------------------------------------------
PROJECT STRUCTURE
--------------------------------------------------
setup.sh           -> One-click installer
server.js          -> Main server
db.js              -> SQLite DB
config.json        -> Printer config
menu.sh            -> Printer configuration UI
public/index.html  -> Admin UI
public/list.html   -> Registered devices list

--------------------------------------------------
LICENSE
--------------------------------------------------
MIT License

Author: msamods
GitHub: https://github.com/msamods
>>>>>>> 335cbeb361fa7f7310db1bcba68f79e569c9f676
