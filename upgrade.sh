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

# Mettre à jour la liste des paquets
echo "Mise à jour de la liste des paquets avec les nouveaux dépôts Debian Bookworm..."
apt update

# Simuler la mise à jour pour vérifier s'il y a des problèmes
echo "Simulation de la mise à niveau pour détecter les problèmes potentiels..."
apt -s dist-upgrade

# Demander une confirmation pour continuer
read -p "Voulez-vous continuer avec la mise à niveau de Debian 11 à Debian 12? [y/N]" -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # Réellement mettre à jour tous les paquets vers leur dernière version
    echo "Démarrage de la mise à niveau vers Debian 12 (Bookworm)..."
    apt -y full-upgrade

    # Nettoyer les paquets obsolètes
    echo "Nettoyage des paquets obsolètes..."
    apt -y autoremove

    # Redémarrer le système
    echo "La mise à niveau est terminée, un redémarrage est nécessaire."
    read -p "Voulez-vous redémarrer maintenant ? [y/N]" -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Redémarrage du système..."
        shutdown -r now
    else
        echo "Redémarrage annulé. Veuillez redémarrer manuellement votre système plus tard."
    fi
else
    echo "Mise à niveau annulée par l'utilisateur."
fi
