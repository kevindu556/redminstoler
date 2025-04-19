#!/bin/bash

echo '🔧 RedM Linux Installer'

# System aktualisieren
apt update && apt upgrade -y

# Notwendige Pakete installieren
apt install -y xz-utils tar wget screen

# Server-Verzeichnis erstellen
mkdir -p /home/RedM/server
cd /home/RedM/server

# RedM Artifacts herunterladen
echo '🔗 Geben Sie den Link zu den RedM-Artifakten ein (z. B. von https://runtime.fivem.net/artifacts/fivem/build_proot-redm/master/):'
read link
wget -O fx.tar.xz "$link"

# Artifacts entpacken
echo '📦 Entpacken der RedM-Dateien...'
tar xf fx.tar.xz
echo '✅ Artifacts installiert'

# Ursprüngliche Datei löschen
rm fx.tar.xz

# Screen installieren
echo '🖥️ Installiere Screen...'
apt install -y screen

# Crontab hinzufügen
echo '📅 Crontab wird installiert und eingerichtet...'

(crontab -l 2>/dev/null; echo "@reboot /bin/bash /home/RedM/server/run.sh > /home/RedM/server/cron.log 2>&1") | crontab -

# Server starten
cd /home/RedM/server && screen ./run.sh

echo '✅ Erfolgreich installiert!'
echo '👉 Wechsle in den Ordner: cd /home/RedM/server'
echo '👉 Starte den Server mit: ./run.sh'
echo '🌀 Beim Serverneustart wird dein RedM-Server automatisch gestartet (über Crontab).'
