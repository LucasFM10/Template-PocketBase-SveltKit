import { defineConfig } from 'vite';
import { sveltekit } from '@sveltejs/kit/vite';

export default defineConfig({
  define: {
    'import.meta.env.PUBLIC_POCKETBASE_URL': JSON.stringify(process.env.PUBLIC_POCKETBASE_URL || ''),
    'import.meta.env.PUBLIC_MERCADO_PAGO_PUBLIC_KEY': JSON.stringify(process.env.PUBLIC_MERCADO_PAGO_PUBLIC_KEY || '')
  },
  plugins: [sveltekit()]
});