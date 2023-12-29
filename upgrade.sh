#!/bin/bash

# Mise à jour de Debian 11 (Bullseye) à Debian 12 (Bookworm)

# Vérifiez si le script est exécuté en tant que superutilisateur
if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être exécuté en tant que root" 
   exit 1
fi

# Mettre à jour tous les paquets existants
echo "Mise à jour des paquets existants..."
apt update && apt -y full-upgrade

# S'assurer que le système est configuré pour accepter les annonces `buster-backports`
echo "Configuration des dépôts Debian Bookworm..."
sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list
sed -i 's/bullseye-updates/bookworm-updates/g' /etc/apt/sources.list
sed -i 's/bullseye-backports/bookworm-backports/g' /etc/apt/sources.list
sed -i 's/bullseye-security/bookworm-security/g' /etc/apt/sources.list
sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list.d/*.list

# Mettre à jour la liste des paquets
echo "Mise à jour de la liste des paquets avec les nouveaux dépôts Debian Bookworm..."
apt update

# Simuler la mise à jour pour vérifier s'il y a des problèmes
echo "Simulation de la mise à niveau pour détecter les problèmes potentiels..."
apt -s dist-upgrade

DEBIAN_FRONTEND=noninteractive apt -y full-upgrade

echo "Nettoyage des paquets obsolètes..."
DEBIAN_FRONTEND=noninteractive apt -y autoremove

echo "La mise à niveau est terminée, un redémarrage est nécessaire."


echo "Redémarrage du système..."

shutdown -r now

