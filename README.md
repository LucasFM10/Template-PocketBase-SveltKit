# 🚀 Monorepo Template — SvelteKit + PocketBase

Este é um **Template Monorepo** pronto para uso ("plug-and-play") combinando **SvelteKit 5** no frontend e **PocketBase** no backend.

---

## ⚡ Como Iniciar um Novo Projeto a partir deste Template

### 1. Clonar o Repositório
```bash
git clone https://github.com/LucasFM10/Template-PocketBase-SveltKit.git meu-novo-projeto
cd meu-novo-projeto
```

### 2. Rodar a Aplicação (O setup é 100% automático no 1º boot!)

#### Opção A — Método Padrão (Tenta Docker com fallback automático):
```powershell
.\scripts\rodar.ps1
```

#### Opção B — Forçar Docker 🐳:
```powershell
.\scripts\rodar-com-docker.ps1
```

#### Opção C — Forçar Sem Docker 🚀:
```powershell
.\scripts\rodar-sem-docker.ps1
```

*(No Prompt de Comando do Windows, você também pode usar `.\scripts\rodar.bat`, `.\scripts\rodar-com-docker.bat` ou `.\scripts\rodar-sem-docker.bat`)*

---

## 🌐 URLs do Projeto

- **Frontend SvelteKit:** [http://localhost:5173](http://localhost:5173)
- **API do PocketBase:** [http://localhost:8090](http://localhost:8090)
- **Dashboard Admin do PocketBase:** [http://localhost:8090/_/](http://localhost:8090/_/)

### 🔐 Credenciais Padrão do Admin
O PocketBase já cria um superusuário automático no primeiro boot (configurável em `apps/pocketbase/.env`):
- **E-mail:** `admin@admin.com`
- **Senha:** `admin123456`

---

## 📁 Estrutura do Repositório

```text
.
├── apps/
│   ├── pocketbase/         # Backend PocketBase
│   │   ├── Dockerfile
│   │   ├── .env.example
│   │   └── pb_migrations/  # Migrações automáticas em JS
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
│   ├── rodar.ps1 / .bat / .sh             # Script principal (Auto-setup + Docker / Fallback)
│   ├── rodar-com-docker.ps1 / .bat / .sh  # Execução via Docker
│   └── rodar-sem-docker.ps1 / .bat / .sh  # Execução local direta (sem Docker)
├── docker-compose.yml      # Configuração Docker para desenvolvimento local
└── README.md
```
