#!/bin/bash

function controlC() {
  # Parametro -epara que me aplique los saltos de linea
  echo -e "\n\n[!] Saliendo...\n"
  # Codigo de estado no exitoso
  exit 1
}

# controlC
# Para capturr el atajo de teclado que acabo de escribir y redirijirlo a la funcion controlC
trap controlC INT

# Si no ccomento se ejecuta despues de 10 segundos
# sleep 10

#///////////////////////////////////////////
#///////////////////////////////////////////

function helpPanel() {
  echo -e "\n[!] Por favor, introduzca una cantidad de dinero y una técnica de apuestas válida. Las técnicas disponibles son martingala, d'Alembert y Paroli.\n"
}

while true; do
  echo "Menú:"
  echo "1. Ver si hay actualizaciones"
  echo "2. Instalar actualizaciones"
  echo "3. Buscar maquina"
  echo "4. Salir"
  read -p "Seleccione una técnica de apuestas (1-4): " technique_choice

  if [ $technique_choice -eq 4 ]; then
    echo -e "\n\n[!] Saliendo...\n"
    exit 0
  elif [ $technique_choice -ge 1 ] && [ $technique_choice -le 3 ]; then
    # read -p "Introduzca la cantidad de dinero: " money

    if [ $technique_choice ]; then
      case $technique_choice in
      1) technique=" Ver si hay actualizaciones" ;;
      2) technique="Instalar actualizaciones" ;;
      3) technique="Buscar maquina" ;;
      esac
      echo -e "\n${yellowColour}[*]${endColour} Usage: ./menusv4-modificado5.sh"

      echo "Vamos a proceder usando la tecnica $technique"
      # Ejecutar técnica aquí
      sleep 6
    else
      helpPanel
    fi
  else
    helpPanel
  fi
done

# Ahora, después de que el usuario elige una técnica y introduce una cantidad de dinero, el script esperará 10 segundos (simulando la ejecución de la técnica) antes de mostrar el menú de nuevo. Si el usuario selecciona la opción 4, el script se cerrará. Si el usuario no introduce una cantidad de dinero válida, se mostrará el panel de ayuda.
