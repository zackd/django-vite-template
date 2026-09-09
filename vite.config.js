import { defineConfig } from 'vite';
import tailwindcss from '@tailwindcss/vite'
import path from 'path';

export default defineConfig({
  plugins: [tailwindcss()],
  base: '/static/', // Matches Django's STATIC_URL
  publicDir: './frontend/public',
  build: {
    outDir: path.resolve(__dirname, './static'),
    emptyOutDir: false, // Preserve Django's other static files
    manifest: "manifest.json",
    rollupOptions: {
      input: {
        'index': path.resolve(__dirname, './frontend/index.ts'),
        'ga': path.resolve(__dirname, './frontend/ga.js'),
        'style': path.resolve(__dirname, './frontend/style.css'),
      },
      output: {
        entryFileNames: `js/[name]-bundle.js`,
        assetFileNames: `css/[name].css`,
      },
    },
  },
});
