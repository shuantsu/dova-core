FROM ubuntu:24.04

# 1. Instalação do Java 21 e dependências essenciais [cite: 5]
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    openjdk-21-jdk-headless \
    && rm -rf /var/lib/apt/lists/*

# 2. Configuração de Variáveis de Ambiente [cite: 7]
ENV ANDROID_SDK_ROOT=/opt/android-sdk-cache
ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools

# 3. Preparação do diretório do SDK [cite: 6]
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools

# 4. Instalação das Command Line Tools (O motor do Android SDK)
# Baixamos a versão estável mais recente para garantir que o sdkmanager exista
RUN curl -o sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip sdk.zip -d $ANDROID_SDK_ROOT/cmdline-tools && \
    mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest && \
    rm sdk.zip

# 5. O Pulo do Gato: Aceitar licenças sem instalar plataformas específicas
# O comando 'sdkmanager --licenses' é genérico e aceita os termos para qualquer versão futura
RUN yes | $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager --licenses

WORKDIR /project