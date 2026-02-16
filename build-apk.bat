@echo off
setlocal enabledelayedexpansion

:: ======================================================================
:: SCRIPT DE BUILD - ANDROID DOCKER (VERSAO INTELIGENTE E ADAPTAVEL)
:: ======================================================================

:: 1. Definir onde esta o docker-compose.yml
set "COMPOSE_PATH=D:\__PROGRAMMING\PROJETOS_PESSOAIS\capacitor_ionic_docker\docker-compose.yml"

:: 2. Determinar a pasta de trabalho (Projeto Ionic/Capacitor)
if "%~1"=="" (
    set "TARGET_DIR=%cd%"
) else (
    set "TARGET_DIR=%~f1"
)

:: 3. Verificar se a pasta 'android' existe
if not exist "%TARGET_DIR%\android" (
    echo [ERRO] A pasta 'android' nao foi encontrada em: %TARGET_DIR%
    echo Certifique-se de que rodou 'ionic cap add android' antes.
    pause
    exit /b 1
)

echo.
echo ---------------------------------------------------
echo Iniciando Build Android Inteligente via Docker
echo Pasta: %TARGET_DIR%
echo ---------------------------------------------------
echo.

:: 4. Executar o Docker Compose
:: Nota: O Gradle detectara automaticamente se precisa baixar SDKs (32, 34, 40, etc)
:: e os salvara nos volumes persistentes configurados no docker-compose.yml
docker compose -f "%COMPOSE_PATH%" run --rm -v "%TARGET_DIR%:/project" android-build bash -c "cd android && chmod +x gradlew && ./gradlew assembleDebug"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo [SUCESSO] Build concluido!
    echo APK: %TARGET_DIR%\android\app\build\outputs\apk\debug\app-debug.apk
) else (
    echo.
    echo [ERRO] Falha na compilacao. Verifique as mensagens acima.
)

pause