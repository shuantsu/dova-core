#!/bin/bash

# ======================================================================
# SCRIPT DE BUILD - ANDROID DOCKER (VERSAO BASH / WSL2 / INTELIGENTE)
# ======================================================================

# 1. Definir onde esta o docker-compose.yml (Caminho no formato Linux/WSL)
COMPOSE_PATH="/mnt/d/__PROGRAMMING/PROJETOS_PESSOAIS/capacitor_ionic_docker/docker-compose.yml"

# 2. Determinar a pasta de trabalho
# Se nao houver argumento, usa a pasta atual (pwd)
TARGET_DIR="${1:-$(pwd)}"

# 3. Verificar se a pasta 'android' existe
if [ ! -d "$TARGET_DIR/android" ]; then
    echo ""
    echo "---------------------------------------------------"
    echo "[ERRO] A pasta 'android' nao foi encontrada em:"
    echo "$TARGET_DIR"
    echo "---------------------------------------------------"
    echo "Certifica-te de que correstes 'ionic cap add android' primeiro."
    exit 1
fi

echo ""
echo "---------------------------------------------------"
echo "Iniciando Build Android Inteligente via Docker"
echo "Pasta: $TARGET_DIR"
echo "---------------------------------------------------"
echo ""

# 4. Executar o Docker Compose
# O Gradle vai gerir os SDKs (32, 34, 40, etc.) automaticamente.
# Os ficheiros serao salvos nos volumes definidos no docker-compose.yml.
docker compose -f "$COMPOSE_PATH" run --rm -v "$TARGET_DIR:/project" android-build bash -c "cd android && chmod +x gradlew && ./gradlew assembleDebug"

# 5. Verificacao de Sucesso
if [ $? -eq 0 ]; then
    echo ""
    echo "---------------------------------------------------"
    echo "[SUCESSO] Build concluido!"
    echo "APK: $TARGET_DIR/android/app/build/outputs/apk/debug/app-debug.apk"
    echo "---------------------------------------------------"
else
    echo ""
    echo "---------------------------------------------------"
    echo "[ERRO] Falha na compilacao. Verifica os logs acima."
    echo "---------------------------------------------------"
    exit 1
fi