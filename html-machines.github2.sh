#!/bin/bash

# Asignación de colores a variables
readonly GREEN_COLOR="\e[0;32m\033[1m"
readonly END_COLOR="\033[0m\e[0m"
readonly RED_COLOR="\e[0;31m\033[1m"
readonly YELLOW_COLOR="\e[0;33m\033[1m"
readonly PURPLE_COLOR="\e[0;35m\033[1m"

# Función para manejar la señal de control + C
function handle_ctrl_c() {
  echo -e "\n\n${RED_COLOR}[!] Exiting... ${END_COLOR}\n"
  tput cnorm && exit 1
}

trap handle_ctrl_c INT

# Variables globales
readonly MAIN_URL="https://htbmachines.github.io/bundle.js"

# Función para mostrar el panel de ayuda
function show_help_panel() {
  echo -e "\n${YELLOW_COLOR}[*]${END_COLOR} Usage: ./html-machines.github2.sh"
  echo -e "\n\t${PURPLE_COLOR}u)${END_COLOR} Download or update necessary files"
  echo -e "\n\t${PURPLE_COLOR}a)${END_COLOR} Search mode"
  echo -e "\t\tMachine name or technique of machines"
  echo -e "\t\tWrite -m after ./html-machines.github2.sh and the name of the machine or technique"
  echo -e "\t${PURPLE_COLOR}n)${END_COLOR} Start search ./html-machines.github.sh -m machine name"
  echo -e "\t${PURPLE_COLOR}h)${END_COLOR} Show this help panel (./html-machines.github2.sh -h)\n"
  exit 0
}

# Función para buscar una máquina
function search_machine() {
  local machine_name="$1"
  echo "$machine_name"
}

# Función para descargar o actualizar archivos
function update_files() {
  tput civis
  echo -e "\n\t${PURPLE_COLOR}u)${END_COLOR}${YELLOW_COLOR} Checking for updates${END_COLOR}"

  # Si el archivo no existe, descargarlo
  if [ ! -f bundle.js ]; then
    clear
    echo -e "\n\t${PURPLE_COLOR}u)${END_COLOR} Downloading necessary files"
    curl -s "$MAIN_URL" >bundle.js
    js-beautify bundle.js | sponge bundle.js
    echo -e "\n\t${PURPLE_COLOR}u)${END_COLOR} All files have been downloaded\n"
    tput cnorm
  else
    echo -e "\n\t${PURPLE_COLOR}u)${END_COLOR}${YELLOW_COLOR} Checking for pending updates${END_COLOR}"
    curl -s "$MAIN_URL" >bundle_temp.js
    js-beautify bundle_temp.js | sponge bundle_temp.js
    local md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
    local md5_original_value=$(md5sum bundle.js | awk '{print $1}')

    # Si el hash MD5 de los archivos es diferente, actualizar el archivo
    if [ "$md5_temp_value" == "$md5_original_value" ]; then
      echo -e "\n\t${PURPLE_COLOR}u)${END_COLOR}${YELLOW_COLOR} [*] No updates detected, everything is up-to-date${END_COLOR}"
      rm bundle_temp.js
    else
      echo -e "\n\t${PURPLE_COLOR}u)${END_COLOR}${YELLOW_COLOR} [*] Available updates have been found${END_COLOR}"
      sleep 1
      rm bundle.js && mv bundle_temp.js bundle.js
      echo -e "\n\t${PURPLE_COLOR}u)${END_COLOR}${YELLOW_COLOR} [*] Files have been updated${END_COLOR}"
    fi
  fi
  tput cnorm
}

# Contador de parámetros
declare -i parameter_counter=0

# Bucle para procesar los parámetros
while getopts "m:uh" arg; do
  case $arg in
  m)
    machine_name=$OPTARG
    let parameter_counter+=1
    ;;
  u)
    let parameter_counter+=2
    ;;
  h)
    let parameter_counter+=3
    ;;
  esac
done

# Ejecutar la acción correspondiente según el parámetro
if [ $parameter_counter -eq 1 ]; then
  search_machine "$machine_name"
elif [ $parameter_counter -eq 2 ]; then
  update_files
else
  show_help_panel
fi
