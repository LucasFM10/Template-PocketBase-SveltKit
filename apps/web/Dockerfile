FROM node:22-alpine

WORKDIR /app

# Copia os manifestos de dependências
COPY package.json package-lock.json ./

# Instala todas as dependências
RUN npm install

# Copia o código-fonte da aplicação
COPY . .

# Expõe a porta padrão do Vite / SvelteKit
EXPOSE 5173

# Executa o servidor de desenvolvimento permitindo acesso externo (--host)
CMD ["npm", "run", "dev", "--", "--host"]
