# DovaCore

### Criar apps híbridos para Android com Ionic Capacitor e sem Android Studio

Este guia foca na eficiência radical: o seu sistema hospeda o código (pnpm) e o Docker (Debian-based) resolve a compilação. Sem Android Studio, sem lixo, apenas o essencial.

**OBS.:** A primeira vez que você rodar o container e compilar vai demorar. É o preço do setup. Mas depois disso, é só alegria. Nada de instalar e configurar Android Studio e um monte de Bloatware que vem com ele.

[LEIA: "Como Otimizei Builds Android com Docker - 25 Segundos"](./Como-Otimizei-Builds-Android-com-Docker-25-Segundos.md)

[Repo que eu usava antes para compilar usando Github Actions, em cerca de 4 a 6 minutos](https://github.com/shuantsu/ionic-github-actions-apk)

## 1. Setup do Host (PowerShell)

Verifique e instale as ferramentas apenas se necessário. **Pragmatismo acima de tudo.**

1. **Node.js (via NVM):**
```powershell
# Verifique se tem NVM
nvm version 
# Se não tiver, instale (https://github.com/coreybutler/nvm-windows)

nvm install 20 && nvm use 20

```


2. **PNPM & Ionic:**
```powershell
npm install -g pnpm @ionic/cli

```


3. **Docker Desktop:** Certifique-se de que o motor está rodando.

## 2. Criando o Projeto (Sem distrações)

Substitua `MeuApp` pelo nome do seu projeto. Ao final do comando, o Ionic pedirá login: **digite "N"**.

```powershell
ionic start MeuApp tabs --type=react --capacitor --pnpm
cd MeuApp

```

## 3. Desenvolvimento & Sincronia

Use o navegador para agilidade e o Docker apenas para o binário.

1. **Web (90% do tempo):** `pnpm ionic serve`
2. **Preparar Android:**
```powershell
pnpm ionic build
npx cap add android  # (Só na 1ª vez)
npx cap sync         # (Sempre que mudar código/plugins)

```



## 4. O Build "Quente" (Docker)

Execute o comando de build pesado dentro do container isolado. A velocidade (25s) vem do cache do Gradle que deve estar configurado no seu `docker-compose.yml`.

```powershell
docker compose run --rm android-build bash -c "cd MeuApp/android && chmod +x gradlew && ./gradlew assembleDebug"

```

**Resultado:** `.\MeuApp\android\app\build\outputs\apk\debug\app-debug.apk`

---

## 📋 Critérios de Sucesso (Paz Mental)

* **Base do Docker:** Deve ser `debian-slim` ou `ubuntu` (evite Alpine/glibc issues).
* **Cache:** O volume `~/.gradle` deve ser persistente no `docker-compose`.
* **Foco:** O Windows fica limpo; o Docker faz o trabalho sujo.

---

Observação: O build do container e a primeira compilação vão ser demorados, mas depois é só alegria. Não é como ter que baixar/instalar/configurar Android Studio e todo aquele monte de bloatware pra fazer apps híbridos.
