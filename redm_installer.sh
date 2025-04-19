#!/bin/bash

echo '🔧 RedM Linux Installer (TXADMIN Ready)'

# System aktualisieren
apt update && apt upgrade -y

# Notwendige Pakete installieren
apt install -y xz-utils tar wget screen

# Server-Verzeichnis erstellen
mkdir -p /home/RedM/server
cd /home/RedM/server

# start.sh erstellen
echo '📄 Erstelle start.sh für txAdmin Setup...'

cat > /home/RedM/server/start.sh <<EOF
#!/bin/bash
cd "$(dirname "$0")"
./run.sh


chmod +x /home/RedM/server/start.sh
echo '✅ start.sh wurde erstellt!'

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

# Crontab einrichten (startet FXServer bei Reboot)
echo '📅 Crontab wird eingerichtet...'
(crontab -l 2>/dev/null; echo "@reboot /bin/bash /home/RedM/server/start.sh > /home/RedM/server/cron.log 2>&1") | crontab -

# FXServer sofort starten – im Screen!
echo '🖥️ Starte FXServer jetzt in screen...'
cd /home/RedM/server && screen -dmS redm ./start.sh

# Abschlussmeldung
echo ''
echo '✅ RedM-Server erfolgreich installiert und gestartet!'
echo '🌐 Öffne jetzt deinen Browser und gehe zu: http://<deine-server-ip>:40120'
echo '🛠️  Dort kannst du deinen Server mit txAdmin einrichten'
echo '🚀 Manuell starten: screen -S redm -r'
echo '🔁 Crontab aktiv – FXServer startet bei jedem Systemstart automatisch.'
