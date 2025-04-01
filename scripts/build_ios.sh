#!/bin/bash

# Colores para la salida
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Iniciando proceso de compilación para iOS...${NC}"

# Verificar si estamos en macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
  echo -e "${RED}Este script solo puede ejecutarse en macOS. Abortando.${NC}"
  exit 1
fi

# Limpiar el proyecto
echo -e "${GREEN}Limpiando el proyecto...${NC}"
flutter clean

# Obtener dependencias
echo -e "${GREEN}Obteniendo dependencias...${NC}"
flutter pub get

# Ejecutar pruebas (opcional)
echo -e "${GREEN}Ejecutando pruebas...${NC}"
flutter test

# Verificar si hay errores en las pruebas
if [ $? -ne 0 ]; then
  echo -e "${RED}Las pruebas han fallado. Abortando la compilación.${NC}"
  exit 1
fi

# Generar archivo IPA
echo -e "${GREEN}Generando archivo IPA...${NC}"

# Primero, construir el archivo .app
flutter build ios --release --no-codesign

# Verificar si la compilación fue exitosa
if [ $? -ne 0 ]; then
  echo -e "${RED}Error al generar el archivo .app. Abortando.${NC}"
  exit 1
fi

echo -e "${GREEN}Archivo .app generado con éxito.${NC}"
echo -e "${YELLOW}Para generar el archivo IPA, debes usar Xcode para archivar y exportar la aplicación.${NC}"
echo -e "${YELLOW}Instrucciones:${NC}"
echo -e "${YELLOW}1. Abre el proyecto en Xcode: open ios/Runner.xcworkspace${NC}"
echo -e "${YELLOW}2. Selecciona 'Product' > 'Archive' en el menú${NC}"
echo -e "${YELLOW}3. Una vez completado el archivo, haz clic en 'Distribute App'${NC}"
echo -e "${YELLOW}4. Selecciona el método de distribución y sigue los pasos${NC}"

# Abrir Xcode automáticamente
echo -e "${GREEN}Abriendo Xcode...${NC}"
open ios/Runner.xcworkspace

echo -e "${YELLOW}Proceso de preparación para iOS completado.${NC}"

