#!/bin/bash

TRASH_DIR="$HOME/trash"

mkdir -p "$TRASH_DIR"

if [ -z "$1" ]; then
    echo "Error: Uso: $0 <nombre_del_archivo>"
    exit 1
fi

FILE=$1

if [ ! -f "$FILE" ]; then
    echo "Error: El archivo '$FILE' no existe o no es un archivo regular."
    exit 1
fi

FILENAME=$(basename "$FILE")
DEST="$TRASH_DIR/$FILENAME"

if [ -e "$DEST" ]; then
    counter=1
    while [ -e "$TRASH_DIR/$FILENAME($counter)" ]; do
        ((counter++))
    done
    DEST="$TRASH_DIR/$FILENAME($counter)"
fi

if mv "$FILE" "$DEST"; then
    echo "Movido con éxito: '$FILE' -> '$DEST'"
else
    echo "Error: No se pudo mover el archivo."
    exit 1
fi
