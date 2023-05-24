import { defineConfig } from 'vite';
import autoprefixer from 'autoprefixer';
import react from '@vitejs/plugin-react';

export default defineConfig({
  server: {
    proxy: {
      '/graphql': {
        target: 'http://localhost:3000',
        changeOrigin: true,
        secure: false,
      },
    },
  },
  plugins: [react()],
  css: {
    postcss: {
      plugins: [autoprefixer({})],
    },
  },
});
