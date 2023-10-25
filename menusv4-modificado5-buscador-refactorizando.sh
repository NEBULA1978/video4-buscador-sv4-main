#!/bin/bash

readonly main_url="https://htbmachines.github.io/bundle.js"

function update_files() {
  if [ ! -f bundle.js ]; then
    curl -s "$main_url" >bundle.js
    js-beautify bundle.js | sponge bundle.js
  else
    curl -s "$main_url" >bundle_temp.js
    js-beautify bundle_temp.js | sponge bundle_temp.js
    md5_temp=$(md5sum bundle_temp.js | awk '{print $1}')
    md5_original=$(md5sum bundle.js | awk '{print $1}')
    if [ "$md5_temp" != "$md5_original" ]; then
      rm bundle.js
      mv bundle_temp.js bundle.js
    else
      rm bundle_temp.js
    fi
  fi
}

function search_machine_by_name() {
  machine_name="$1"
  echo -e "\n[*] Listando las propiedades de la maquina $machine_name:\n"
  cat bundle.js | awk '/name: "'"$machine_name"'"/,/resuelta/' | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'
}

function search_machine_by_ip() {
  ip_address="$1"
  machine_name=$(cat bundle.js | grep "ip: \"$ip_address\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')
  echo -e "\n[*] La maquina correspondiente para la IP $ip_address es $machine_name\n"
  search_machine_by_name "$machine_name"
}

while true; do
  echo "Menú:"
  echo "1. Ver si hay actualizaciones e instalar actualizaciones"
  echo "2. Buscar máquina por nombre"
  echo "3. Buscar máquina por IP"
  echo "4. Salir"
  read -p "Seleccione una opción (1-4): " option
  case "$option" in
  1) update_files ;;
  2)
    read -p "Introduzca el nombre de la máquina: " machine_name
    search_machine_by_name "$machine_name"
    ;;
  3)
    read -p "Introduzca el nombre de la IP: " ip_address
    search_machine_by_ip "$ip_address"
    ;;
  4) exit 0 ;;
  *) echo "[!] Por favor, seleccione una opción válida del menú." ;;
  esac
done
s
