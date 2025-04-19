#!/bin/bash

echo '🔧 RedM Linux Installer (TXADMIN Ready)'

# System aktualisieren
apt update && apt upgrade -y

# Notwendige Pakete installieren
apt install -y xz-utils tar wget screen

# Server-Verzeichnis erstellen
mkdir -p /home/RedM/server
cd /home/RedM/server

# Startskript erstellen
echo '📄 Erstelle start.sh für txAdmin Setup...'

cat > /home/RedM/server/start.sh <<EOF
#!/bin/bash
cd \$(dirname "\$0")
./FXServer
EOF

chmod +x /home/RedM/server/start.sh
echo '✅ start.sh wurde erstellt! Er startet FXServer, damit du txAdmin im Browser einrichten kannst.'

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
echo '📅 Crontab wird eingerichtet (startet FXServer bei Reboot)...'
(crontab -l 2>/dev/null; echo "@reboot /bin/bash /home/RedM/server/start.sh > /home/RedM/server/cron.log 2>&1") | crontab -

# Server starten im Screen
cd /home/RedM/server && screen -S redm ./start.sh

# Abschlussmeldung
echo ''
echo '✅ RedM-Server wurde erfolgreich installiert!'
echo '📁 Verzeichnis: /home/RedM/server'
echo '🧠 Öffne deinen Browser und gehe zu: http://<deine-ip>:40120'
echo '🌐 Dort kannst du nun deinen Server mit txAdmin einrichten!'
echo '🚀 Manuell starten: ./start.sh'
echo '🔁 Crontab ist aktiv – dein Server startet beim Systemstart automatisch.'
