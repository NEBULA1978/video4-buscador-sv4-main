#!/bin/bash

greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
# endColour="\033[0m\e[0m"

function controlC() {
  echo -e "\n\n${redColour}[!] Exiting... ${endColour}\n"
  tput cnorm && exit 1
}
# Para capturar el atajo de teclado que acabo de escribir y redirigirlo a la función controlC
trap controlC INT

# Si no comento se ejecuta después de 10 segundos
# sleep 10

#///////////////////////////////////////////
# VARIABLES GLOBALES
main_url="https://htbmachines.github.io/bundle.js"
#///////////////////////////////////////////

function helpPanel() {
  echo -e "\n[!] Por favor, seleccione una opción válida del menú.\n"
}

function updatefiles() {
  # echo -e "\n\t${purpleColour}u)${endColour}${yellowColour} Comprobando si Hay actualizaciones${endColour}"

  # sleep 2

  # Si el archivo no existe me lo descargas
  if [ ! -f bundle.js ]; then
    clear
    tput civis
    echo -e "\n\t${purpleColour}u)${endColour}${yellowColour} Comprobando si Hay actualizaciones${endColour}"

    echo -e "\n\t${purpleColour}u)${endColour} Descargando archivos necesarios"
    curl -s $main_url >bundle.js
    js-beautify bundle.js | sponge bundle.js
    echo -e "\n\t${purpleColour}u)${endColour} Todos los archivos Descargados\n"
    # echo "El archivo existe"
    tput cnorm
  else
    tput civis
    echo -e "\n\t${purpleColour}u)${endColour}${yellowColour}Comprobando si hay actualizaciones pendientes${endColour}"
    curl -s $main_url >bundle_temp.js
    js-beautify bundle_temp.js | sponge bundle_temp.js
    md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
    md5_original_value=$(md5sum bundle.js | awk '{print $1}')

    # echo $md5_temp_value
    # echo $md5_original_value
    if [ "$md5_temp_value" == "$md5_original_value" ]; then
      echo -e "\n\t${purpleColour}u)${endColour}${yellowColour} [*] No hay actualizaciones detectadas esta todo al dia${endColour}"

      rm bundle_temp.js
    else
      echo -e "\n\t${purpleColour}u)${endColour}${yellowColour} [*] Se han encontrado actualizaciones disponibles${endColour}"

      sleep 1

      # Borra bundle.js y bundle_temp.js lo conviertas en bundle.js
      rm bundle.js && mv bundle_temp.js bundle.js

      echo -e "\n\t${purpleColour}u)${endColour}${yellowColour} [*] Los archivos han sido actualizados${endColour}"
    fi

    tput cnorm

  fi
}

function readfiles() {
  echo "Vamos a navegar por las carpetas de home"
  sleep 3
  cd
  ls * .sh
  echo "Añdiendo opciones"
}

function searchMachine() {
  machineName="$1"
  echo -e "\n\t${purpleColour}u)${endColour}${yellowColour} [*] Listando las propiedades de la maquina ${endColour}${yellowColour}$machineName${endColour}${purpleColour}:${endColour}\n"

  cat bundle.js | awk '/name: "'"${machineName}"'"/,/resuelta/' | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'

  # ERROR
  # cat bundle.js | awk "/name: "${ machineName }"/,/resuelta/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'
}

function searchhIP() {

  ipAddress="$1"
  echo -e "\n\t${purpleColour}i)${endColour}${yellowColour} [*] La IP es $ipAddress${endColour}\n"

  machineName="$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"
  echo -e "\n\t${purpleColour}[*])${endColour}${yellowColour} [*] La maquina correspondiente para la IP $ipAddress es $machineName${endColour}\n"

  searchMachine $machineName

}
# cat bundle.js: muestra el contenido del archivo bundle.js
# grep "ip:\"10.10.11.139\"" -B 3: busca la línea que contiene ip:\"10.10.11.139\" y muestra tres líneas antes
# grep "name:": busca las líneas que contienen name:
# awk 'NF{print $NF}': muestra el último campo de cada línea
# tr -d '"': elimina todas las comillas dobles (") de la salida
# tr -d ',': elimina todas las comas (,) de la salida

#

# ==============================================

while true; do
  echo -e "${greenColour}Menú:${endColour}"
  echo -e "${yellowColour}1. Ver si hay actualizaciones e Instalar actualizaciones${endColour}"
  echo -e "${yellowColour}2. Vamos a navegar por las carpetas de home${endColour}"
  echo -e "${yellowColour}3. Buscar máquina por nombre${endColour}"
  echo -e "${yellowColour}5. Buscar máquina por IP${endColour}"
  echo -e "${redColour}4. Salir${endColour}"
  # echo -e "\e[0;32m\033[1mSeleccione una opción (1-5): \033[0m\e[0m"
  read -p "Seleccione una opción (1-5):" opcion_elegida
  if [ $opcion_elegida -eq 1 ]; then
    updatefiles
  elif [ $opcion_elegida -eq 2 ]; then
    readfiles
  elif [ $opcion_elegida -eq 3 ]; then
    read -p "${yellowColour}Introduzca el nombre de la máquina: ${endColour}" machineName
    searchMachine $machineName
  elif [ $opcion_elegida -eq 5 ]; then
    read -p "Introduzca el nombre de la IP: " ipAddress
    searchhIP $ipAddress
  elif [ $opcion_elegida -eq 4 ]; then
    echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
    exit 0
  else
    helpPanel
  fi

done
