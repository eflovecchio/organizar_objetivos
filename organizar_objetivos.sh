#!/bin/bash

# Verificación de los parámetros de entrada
if [ $# -lt 1 ]; then
    echo "Uso: $0 archivo_objetivos"
    exit 1
fi

# Archivo que contiene la lista de objetivos
archivo_objetivos="$1"

# Verificar si el archivo de objetivos existe
if [ ! -f "$archivo_objetivos" ]; then
    echo "El archivo $archivo_objetivos no existe."
    exit 1
fi

# Mostrar el contenido del archivo de objetivos para propósitos de depuración
echo "Contenido del archivo de objetivos:"
cat "$archivo_objetivos"

# Iterar sobre cada objetivo en el archivo
while IFS= read -r objetivo; do
    # Eliminar "http://" o "https://" del inicio del objetivo
    carpeta_nombre=$(echo "$objetivo" | sed -e 's,^\(http://\|https://\),,')
    
    # Verificar si la carpeta ya existe
    if [ ! -d "$carpeta_nombre" ]; then
        echo "Creando carpeta: $carpeta_nombre"
        mkdir "$carpeta_nombre"
    fi
    
    # Buscar archivos similares al nombre de la línea dentro del directorio actual
    echo "Buscando archivos similares a '$carpeta_nombre' en el directorio actual..."
    archivos_similares=$(ls | grep "$carpeta_nombre")
    
    # Si se encontraron archivos, moverlos a la carpeta correspondiente
    if [ -n "$archivos_similares" ]; then
        echo "Se encontraron archivos similares:"
        echo "$archivos_similares"
        echo "Moviendo archivos a la carpeta: $carpeta_nombre"
        mv $archivos_similares "$carpeta_nombre/"
    else
        echo "No se encontraron archivos similares a '$carpeta_nombre'."
    fi
done < "$archivo_objetivos"

# Salir del script
exit 0
