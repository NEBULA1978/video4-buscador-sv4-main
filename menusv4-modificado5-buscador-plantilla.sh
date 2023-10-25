#!/bin/bash

function controlC() {
  # Parametro -e para que me aplique los saltos de linea
  echo -e "\n\n[!] Saliendo...\n"
  # Código de estado no exitoso
  exit 1
}

# Para capturar el atajo de teclado que acabo de escribir y redirigirlo a la función controlC
trap controlC INT

# Si no comento se ejecuta después de 10 segundos
# sleep 10

#///////////////////////////////////////////
#///////////////////////////////////////////

function helpPanel() {
  echo -e "\n[!] Por favor, seleccione una opción válida del menú.\n"
}

function updatefiles() {
  echo "Verificando si hay actualizaciones..."
  sleep 3
  echo "No se encontraron actualizaciones."
}

function installfiles() {
  echo "Instalando actualizaciones..."
  sleep 3
  echo "No se encontraron actualizaciones para instalar."
}

function searchMachine() {
  echo "Buscando máquina $1..."
  echo "No se encontró la máquina $1."
}

while true; do
  echo "Menú:"
  echo "1. Ver si hay actualizaciones"
  echo "2. Instalar actualizaciones"
  echo "3. Buscar máquina"
  echo "4. Salir"
  read -p "Seleccione una opción (1-4): " opcion_elegida

  if [ $opcion_elegida -eq 4 ]; then
    echo -e "\n\n[!] Saliendo...\n"
    exit 0
  elif [ $opcion_elegida -ge 1 ] && [ $opcion_elegida -le 3 ]; then
    if [ $opcion_elegida -eq 1 ]; then
      updatefiles
    elif [ $opcion_elegida -eq 2 ]; then
      installfiles
    elif [ $opcion_elegida -eq 3 ]; then
      read -p "Introduzca el nombre de la máquina: " nombre_maquina
      searchMachine $nombre_maquina
    fi
  else
    helpPanel
  fi
done
