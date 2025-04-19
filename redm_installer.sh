#!/bin/bash

echo '🔧 RedM Linux Installer'

# System aktualisieren
apt update && apt upgrade -y

# Notwendige Pakete installieren
apt install -y xz-utils tar wget screen

# Server-Verzeichnis erstellen
mkdir -p /home/RedM/server
cd /home/RedM/server

# run.sh erstellen
echo '📄 Erstelle run.sh...'
cat > /home/RedM/server/run.sh <<EOF
#!/bin/bash
cd \$(dirname "\$0")
./run.sh +exec server.cfg
EOF
chmod +x /home/RedM/server/run.sh
echo '✅ run.sh wurde erfolgreich erstellt!'

# server.cfg erstellen
echo '📝 Erstelle server.cfg...'
cat > /home/RedM/server/server.cfg <<EOF
# ---------------------------
#   RedM Beispiel server.cfg
# ---------------------------

endpoint_add_tcp "0.0.0.0:30120"
endpoint_add_udp "0.0.0.0:30120"

sv_hostname "Mein RedM Server"
sv_maxclients 32

# 🚨 WICHTIG: Trage deinen LicenseKey hier ein!
sv_licenseKey "DEIN_LICENSE_KEY_HIER"

# Beispiel für MySQL-Verbindung (VORP-ready)
set mysql_connection_string "server=localhost;uid=root;password=deinpasswort;database=redm_db"

# Standard-Ressourcen
ensure sessionmanager
ensure mapmanager
ensure spawnmanager
ensure fivem
ensure hardcap
ensure rconlog

# VORP-Beispiel (auskommentiert)
# ensure vorp_core
# ensure vorp_inventory
EOF
echo '✅ server.cfg wurde erstellt!'

# RedM Artifacts herunterladen
echo '🔗 Gib den Link zu den RedM-Artifakten ein (z. B. von https://runtime.fivem.net/artifacts/fivem/build_proot-redm/master/):'
read link
wget -O fx.tar.xz "$link"

# Artifacts entpacken
echo '📦 Entpacken der RedM-Dateien...'
tar xf fx.tar.xz
echo '✅ Artifacts installiert'

# Ursprüngliche Datei löschen
rm fx.tar.xz

# Crontab hinzufügen
echo '📅 Crontab wird eingerichtet...'
(crontab -l 2>/dev/null; echo "@reboot /bin/bash /home/RedM/server/run.sh > /home/RedM/server/cron.log 2>&1") | crontab -

# Server starten
cd /home/RedM/server && screen -S redm ./run.sh

# Abschlussmeldung
echo ''
echo '✅ RedM-Server wurde erfolgreich installiert!'
echo '📁 Verzeichnis: /home/RedM/server'
echo '🛠️  Trage jetzt deinen LicenseKey in die server.cfg ein (Zeile mit sv_licenseKey)'
echo '🚀 Starte den Server jederzeit mit: ./run.sh'
echo '🔁 Crontab ist aktiv – dein Server startet beim Systemstart automatisch.'
