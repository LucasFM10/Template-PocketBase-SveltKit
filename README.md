# 🚀 Monorepo Template — SvelteKit + PocketBase + Mercado Pago

Este é um **Template Monorepo** completo e pronto para uso ("plug-and-play") combinando **SvelteKit 5** no frontend, **PocketBase** no backend e checkout transparente com **Mercado Pago** (Pix e Cartão de Crédito).

---

## ⚡ Como Iniciar um Novo Projeto a partir deste Template

### 1. Clonar o Repositório
```bash
git clone https://github.com/LucasFM10/Template-PocketBase-SveltKit.git meu-novo-projeto
cd meu-novo-projeto
```

### 2. Rodar a Aplicação (O setup é 100% automático no 1º boot!)

#### Opção A — Método Padrão (Orquestrador Inteligente):
```powershell
.\scripts\rodar.ps1
```
*(No Prompt de Comando do Windows, use `.\scripts\rodar.bat` ou no Linux/macOS `./scripts/rodar.sh`)*

#### Opção B — Forçar Docker 🐳:
```powershell
.\scripts\rodar-com-docker.ps1
```

#### Opção C — Forçar Sem Docker 🚀:
```powershell
.\scripts\rodar-sem-docker.ps1
```

---

## 🌐 URLs do Projeto

- **Frontend SvelteKit:** [http://localhost:5173](http://localhost:5173)
- **Checkout Mercado Pago:** [http://localhost:5173/pagamento](http://localhost:5173/pagamento)
- **API do PocketBase:** [http://localhost:8090](http://localhost:8090)
- **Dashboard Admin do PocketBase:** [http://localhost:8090/_/](http://localhost:8090/_/)

### 🔐 Credenciais Padrão do Admin
O PocketBase já cria um superusuário automático no primeiro boot (configurável no `.env` da raiz):
- **E-mail:** `admin@admin.com`
- **Senha:** `admin123456`

---

## 💳 Integração Mercado Pago (PIX e Cartão de Crédito)

A integração utiliza a **Orders API** oficial do Mercado Pago para garantir segurança total (tokenização no frontend e cobrança no backend):

```text
[ Cliente / Navegador ]
       │ (1. Tokeniza o Cartão via MercadoPago.js SDK v2 com Public Key)
       ▼
[ Frontend - SvelteKit (/pagamento) ]
       │ (2. Envia token do cartão ou pedido de PIX)
       ▼
[ Backend - PocketBase JS Hooks (/api/pix e /api/card-payment) ]
       │ (3. Processa cobrança com Mercado Pago via Access Token Secreto)
       ▼
[ API Oficial Mercado Pago (v1/orders) ]
```

### 🔑 Variáveis de Ambiente (`.env` na Raiz)

Todas as variáveis do projeto ficam centralizadas no arquivo **`.env`** (e **`.env.example`**) localizado na **raiz do projeto**:

* **`PUBLIC_POCKETBASE_URL`**: URL do backend PocketBase (ex: `http://127.0.0.1:8090`).
* **`PUBLIC_MERCADO_PAGO_PUBLIC_KEY`**: Chave pública do Mercado Pago usada no frontend para tokenizar o cartão.
* **`MERCADO_PAGO_ACCESS_TOKEN`**: Access Token secreto do Mercado Pago usado no backend PocketBase.

### 🧪 Cartões de Teste Oficiais (Sandbox Mercado Pago)
Para testar a tela de pagamento em ambiente de testes (`/pagamento`):
* **Nome do titular:** `APRO VADO`
* **CPF:** `111.111.111-11`
* **CVV:** `123`
* **Mastercard:** `5480 8328 0103 3311`
* **Visa:** `4235 6477 2802 5682`
* **Amex:** `3753 651535 56885`
* **Elo:** `5067 7667 8388 8311`

### 🚀 Deploy em Produção (Coolify)

O projeto suporta **duas abordagens de deploy** no Coolify:

#### 🟢 Abordagem 1: 1 Único Recurso (Docker Compose — Recomendado ⭐)
Cria **1 único recurso do tipo "Docker Compose"** apontando para a raiz do repositório.

1. No Coolify, selecione **+ New Resource** → **Docker Compose** → Conecte ao seu repositório Git.
2. O Coolify detectará o arquivo `docker-compose.yml` automaticamente.
3. Na aba **Environment Variables**, adicione as variáveis do arquivo `.env` (ex: `PUBLIC_POCKETBASE_URL`, `PUBLIC_MERCADO_PAGO_PUBLIC_KEY`, `MERCADO_PAGO_ACCESS_TOKEN`, `PB_SUPERUSER_EMAIL`, `PB_SUPERUSER_PASSWORD`).
   * *Atenção:* Marque as variáveis do frontend (`PUBLIC_`) como **Build Variable** no painel do Coolify.
4. Defina os domínios FQDN para os dois serviços no Coolify:
   * Serviço `web`: `https://seu-dominio.com`
   * Serviço `pocketbase`: `https://pb.seu-dominio.com`
5. Clique em **Deploy**. Ambas as aplicações sobem juntas em uma única Stack!

#### 🔵 Abordagem 2: Serviços Separados (Public Dockerfile)
Cria **2 recursos individuais** no Coolify:

1. **Recurso `pocketbase` (Backend):**
   * Tipo: **Public Dockerfile** → Base Directory: `/apps/pocketbase`.
   * Environment Variable: `MERCADO_PAGO_ACCESS_TOKEN`.
2. **Recurso `web` (SvelteKit Frontend):**
   * Tipo: **Public Dockerfile** → Base Directory: `/apps/web`.
   * Environment Variables (marcar como **Build Variable**): `PUBLIC_POCKETBASE_URL` (com a URL de produção do PocketBase) e `PUBLIC_MERCADO_PAGO_PUBLIC_KEY`.

---

## 📁 Estrutura do Repositório

```text
.
├── .env.example            # Exemplo centralizado de variáveis de ambiente
├── docker-compose.yml      # Configuração Docker para desenvolvimento local
├── apps/
│   ├── pocketbase/         # Backend PocketBase
│   │   ├── Dockerfile
│   │   ├── pb_hooks/       # JS Hooks customizados (/api/pix e /api/card-payment)
│   │   └── pb_migrations/  # Migrações automáticas em JS
│   └── web/                # Frontend SvelteKit
│       ├── Dockerfile
│       ├── default.conf    # Configuração Nginx para rotas SPA
│       ├── package.json
│       └── src/
│           ├── lib/
│           │   └── pocketbase.ts # Cliente do PocketBase pré-configurado
│           └── routes/
│               ├── +page.svelte  # Gerenciador de Batatas 🥔
│               └── pagamento/    # Checkout Transparente Mercado Pago 💳
├── scripts/
│   ├── rodar.ps1 / .bat / .sh             # Script orquestrador principal
│   ├── rodar-com-docker.ps1 / .bat / .sh  # Execução via Docker
│   └── rodar-sem-docker.ps1 / .bat / .sh  # Execução local direta (sem Docker)
└── README.md
```
