#!/bin/bash

# Colores para la salida
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Iniciando proceso de compilación para Android...${NC}"

# Cargar las variables del archivo .env
echo -e "${GREEN}Cargando variables del .env...${NC}"
export $(grep -v '^#' .env | xargs)

# Limpiar el proyecto
echo -e "${GREEN}Limpiando el proyecto...${NC}"
flutter clean

# Obtener dependencias
echo -e "${GREEN}Obteniendo dependencias...${NC}"
flutter pub get

# Ejecutar pruebas (opcional)
echo -e "${GREEN}Ejecutando pruebas...${NC}"
flutter test

if [ $? -ne 0 ]; then
  echo -e "${RED}Las pruebas han fallado. Abortando la compilación.${NC}"
  exit 1
fi

# Generar APK
echo -e "${GREEN}Generando APK...${NC}"
flutter build apk --release

if [ $? -ne 0 ]; then
  echo -e "${RED}Error al generar el APK. Abortando.${NC}"
  exit 1
fi

echo -e "${GREEN}APK generado con éxito en build/app/outputs/flutter-apk/app-release.apk${NC}"

# Generar AAB
echo -e "${GREEN}Generando AAB...${NC}"
flutter build appbundle --release

if [ $? -ne 0 ]; then
  echo -e "${RED}Error al generar el AAB. Abortando.${NC}"
  exit 1
fi

echo -e "${GREEN}AAB generado con éxito en build/app/outputs/bundle/release/app-release.aab${NC}"
echo -e "${YELLOW}Proceso de compilación para Android completado.${NC}"
