#!/bin/bash

TRASH_DIR="$HOME/trash"

if [ -z "$1" ]; then
    echo "Error: Uso: $0 <nombre_del_archivo_en_trash>"
    exit 1
fi

FILE_TO_RECOVER="$1"
SOURCE="$TRASH_DIR/$FILE_TO_RECOVER"

if [ ! -f "$SOURCE" ]; then
    echo "Error: El archivo '$FILE_TO_RECOVER' no existe en ~/trash."
    exit 1
fi

DEST="./$FILE_TO_RECOVER"

if [ -e "$DEST" ]; then
    counter=1
    while [ -e "${DEST}(${counter})" ]; do
        ((counter++))
    done
    DEST="${DEST}(${counter})"
fi

if mv "$SOURCE" "$DEST"; then
    echo "Archivo recuperado con éxito: '$SOURCE' -> '$DEST'"
else
    echo "Error: No se pudo recuperar el archivo."
    exit 1
fi
