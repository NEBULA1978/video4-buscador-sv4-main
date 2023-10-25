#!/bin/bash

greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"

function controlC() {
  echo -e "\n\n${redColour}[!] Exiting... ${endColour}\n"
  tput cnorm && exit 1
}

trap controlC INT

# VARIABLES GLOBALES
main_url="https://htbmachines.github.io/bundle.js"

function helpPanel() {
  echo -e "\n${yellowColour}[*]${endColour} Usage: ./html-machines.github2.sh"
  echo -e "\n\t${purpleColour}u)${endColour} Download or update necessary files"
  echo -e "\n\t${purpleColour}a)${endColour} Search mode"
  echo -e "\t\tMachine name or technique of machines"
  echo -e "\t\tWrite -m after ./html-machines.github2.sh and the name of the machine or technique"
  echo -e "\t${purpleColour}n)${endColour} Start search ./html-machines.github.sh -m machine name"
  echo -e "\t${purpleColour}h)${endColour} Show this help panel (./html-machines.github2.sh -h)\n"
  exit 0
}

function searchMachine() {
  machineName="$1"

  echo "$machineName"
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

declare -i parameter_counter=0

while getopts "m:uh" arg; do
  case $arg in
  m)
    machineName=$OPTARG
    let parameter_counter+=1
    ;;
  u)
    let parameter_counter+=2
    ;;
  h) ;;
  esac
done

if [ $parameter_counter -eq 1 ]; then
  searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
  updatefiles
else
  helpPanel
fi
