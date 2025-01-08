#!/bin/bash

# Verificar si se ha pasado el nombre del host como parámetro
if [ -z "$1" ]; then
    echo "Por favor, proporciona el nombre del host remoto como parámetro."
    echo "Uso: $0 <nombre_del_host_remoto>"
    exit 1
fi

# Dirección del servidor remoto (reemplaza con la IP o dominio de tu servidor remoto)
REMOTE_SERVER="operador@${1}"
REMOTE_PATH="/home/operador/.ssh/id_rsa"

# Ruta local donde deseas guardar la clave pública
LOCAL_PATH="keys/${1}"

# Usar SCP para copiar el archivo de la máquina remota a la máquina local
echo "Copiando clave pública desde el servidor remoto..."
scp -P 22000 "${REMOTE_SERVER}:${REMOTE_PATH}" "${LOCAL_PATH}"

# Verificar si el archivo se copió correctamente
if [ $? -eq 0 ]; then
    echo "Archivo copiado exitosamente a ${LOCAL_PATH}"
else
    echo "Error al copiar el archivo."
    exit 1
fi

# Opcional: Hacer que el archivo copiado sea accesible para Ansible
echo "Asegurando permisos del archivo copiado..."
chmod 400 "${LOCAL_PATH}"

# Confirmar que el archivo es accesible
if [ -f "${LOCAL_PATH}" ]; then
    echo "El archivo ahora está listo para ser utilizado por Ansible."
else
    echo "Error: El archivo no se pudo encontrar o acceder en la ruta local."
    exit 1
fi