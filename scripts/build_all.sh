#!/bin/bash

# Colores para la salida
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Iniciando proceso de compilación para todas las plataformas...${NC}"

# Cargar las variables del archivo .env
echo -e "${GREEN}Cargando variables del .env...${NC}"
export $(grep -v '^#' .env | xargs)

# Dar permisos de ejecución a los scripts si es necesario
chmod +x scripts/build_android.sh
chmod +x scripts/build_ios.sh

# Compilar para Android
echo -e "${GREEN}Compilando para Android...${NC}"
./scripts/build_android.sh

# Verificar si la compilación de Android fue exitosa
if [ $? -ne 0 ]; then
  echo -e "${RED}Error en la compilación de Android. Continuando con iOS...${NC}"
fi

# Verificar si estamos en macOS para compilar iOS
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo -e "${GREEN}Compilando para iOS...${NC}"
  ./scripts/build_ios.sh

  # Verificar si la compilación de iOS fue exitosa
  if [ $? -ne 0 ]; then
    echo -e "${RED}Error en la compilación de iOS.${NC}"
  fi
else
  echo -e "${YELLOW}No se puede compilar para iOS porque no estás en macOS.${NC}"
fi

echo -e "${YELLOW}Proceso de compilación completado.${NC}"
