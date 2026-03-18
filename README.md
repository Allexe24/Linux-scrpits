# Network Interactive Manager (Bash)

Script interactivo diseñado para la gestión de interfaces de red en sistemas Linux (probado en Manjaro/Arch). Permite configurar conexiones cableadas e inalámbricas de forma permanente.

## Características
* Listado de interfaces y estado en tiempo real.
* Control de estado de hardware (Up/Down).
* Escaneo de redes Wi-Fi circundantes.
* Configuración de red Estática o Dinámica (DHCP).
* Persistencia de configuración a través de NetworkManager.

## Requisitos
* `NetworkManager` (instalado por defecto en la mayoría de las distros).
* Privilegios de superusuario (`sudo`).

## Uso
1. Clonar el repositorio.
2. Dar permisos de ejecución: `chmod +x net-manager.sh`
3. Ejecutar: `sudo ./net-manager.sh`
