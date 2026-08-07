# 🚀 Monorepo Template — SvelteKit + PocketBase

Este é um **Template Monorepo** pronto para uso ("plug-and-play") combinando **SvelteKit 5** no frontend e **PocketBase** no backend.

---

## ⚡ Como Iniciar um Novo Projeto a partir deste Template

### 1. Clonar o Repositório
```bash
git clone https://github.com/SEU_USUARIO/SEU_REPOSISOTORIO.git meu-novo-projeto
cd meu-novo-projeto
```

### 2. Rodar o Setup (Apenas 1 vez após clonar)
```powershell
# No Windows PowerShell:
.\scripts\setup.ps1

# Ou no Linux/macOS:
./scripts/setup.sh
```

### 3. Rodar a Aplicação

#### Option A — Com Docker (Recomendado) 🐳
```powershell
.\scripts\dev.ps1
```

#### Option B — Sem Docker (Local com pocketbase.exe) 🚀
```powershell
.\scripts\dev.ps1 -Local
```

---

## 🌐 URLs do Projeto

- **Frontend SvelteKit:** [http://localhost:5173](http://localhost:5173)
- **API do PocketBase:** [http://localhost:8090](http://localhost:8090)
- **Dashboard Admin do PocketBase:** [http://localhost:8090/_/](http://localhost:8090/_/)

### 🔐 Credenciais Padrão do Admin
O PocketBase já cria um superusuário automático no primeiro boot:
- **E-mail:** `admin@admin.com`
- **Senha:** `admin123456`

---

## 📁 Estrutura do Repositório

```text
.
├── apps/
│   ├── pocketbase/         # Backend PocketBase
│   │   ├── Dockerfile
│   │   ├── pb_migrations/  # Migrações automáticas em JS
│   │   └── pocketbase.exe
│   └── web/                # Frontend SvelteKit
│       ├── Dockerfile
│       ├── .env.example
│       ├── package.json
│       └── src/
│           ├── lib/
│           │   └── pocketbase.ts # Cliente do PocketBase pré-configurado
│           └── routes/
│               └── +page.svelte  # Exemplo do Gerenciador de Batatas 🥔
├── scripts/
│   ├── setup.ps1 / .sh     # Script de inicialização pós-clone
│   ├── dev.ps1 / .sh       # Script unificado para rodar a aplicação
│   ├── dev-docker.ps1      # Força modo Docker
│   └── dev-local.ps1       # Força modo Local (sem Docker)
├── docker-compose.yml      # Configuração Docker para desenvolvimento local
└── README.md
```
