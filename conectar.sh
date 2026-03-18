#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "Este script debe ejecutarse como root (sudo)."
   exit 1
fi

show_menu() {
    echo "--- GESTOR DE RED INTERACTIVO ---"
    echo "1. Mostrar interfaces y estado"
    echo "2. Levantar/Apagar interfaz (Up/Down)"
    echo "3. Escanear redes Wi-Fi"
    echo "4. Conectar a red (Wired/Wireless)"
    echo "5. Salir"
    echo -n "Seleccione una opción: "
}

list_interfaces() {
    echo -e "\nInterfaces disponibles:"
    nmcli device status
    echo ""
}

toggle_interface() {
    list_interfaces
    read -p "Nombre de la interfaz: " IFACE
    read -p "Acción (up/down): " ACTION
    nmcli device "$ACTION" "$IFACE"
}

scan_wifi() {
    echo "Escaneando redes inalámbricas..."
    nmcli device wifi rescan
    nmcli device wifi list
}

connect_network() {
    list_interfaces
    read -p "Interfaz a usar (ej. eth0, wlan0): " IFACE
    
    TYPE=$(nmcli -t -f TYPE device show "$IFACE" | head -n 1 | cut -d: -f2)
    
    if [ "$TYPE" == "wifi" ]; then
        scan_wifi
        read -p "SSID (Nombre de la red): " SSID
        read -s -p "Password (dejar vacío si es abierta): " PASS
        echo ""
    fi

    echo "Configuración de IP:"
    echo "1. Dinámica (DHCP)"
    echo "2. Estática (Manual)"
    read -p "Opción: " IP_OPT

    if [ "$IP_OPT" == "2" ]; then
        read -p "IP/CIDR (ej. 192.168.1.50/24): " ADDR
        read -p "Gateway (Puerta de enlace): " GW
        read -p "DNS (ej. 8.8.8.8): " DNS
        
        if [ "$TYPE" == "wifi" ]; then
            nmcli con add type wifi ifname "$IFACE" con-name "$SSID" ssid "$SSID" \
            ip4 "$ADDR" gw4 "$GW" ipv4.dns "$DNS"
            nmcli con up "$SSID" --ask
        else
            nmcli con add type ethernet ifname "$IFACE" con-name "Static-Ethernet" \
            ip4 "$ADDR" gw4 "$GW" ipv4.dns "$DNS"
            nmcli con up "Static-Ethernet"
        fi
    else
        if [ "$TYPE" == "wifi" ]; then
            nmcli device wifi connect "$SSID" password "$PASS" ifname "$IFACE"
        else
            nmcli device connect "$IFACE"
        fi
    fi
}

while true; do
    show_menu
    read opt
    case $opt in
        1) list_interfaces ;;
        2) toggle_interface ;;
        3) scan_wifi ;;
        4) connect_network ;;
        5) exit 0 ;;
        *) echo "Opción no válida." ;;
    esac
    echo ""
done
