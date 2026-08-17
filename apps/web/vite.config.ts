import { defineConfig } from 'vite';
import { sveltekit } from '@sveltejs/kit/vite';

export default defineConfig({
  envDir: '../../',
  plugins: [sveltekit()]
});