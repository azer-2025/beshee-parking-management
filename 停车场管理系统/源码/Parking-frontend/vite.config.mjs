import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue2'
import path from 'path'

export default defineConfig({
  base: './',
  plugins: [vue()],
  resolve: {
    alias: {
      '@': path.resolve(path.dirname(new URL(import.meta.url).pathname), './src')
    }
  },
  css: {
    preprocessorOptions: {
      less: {
        javascriptEnabled: true
      }
    }
  },
  server: {
    open: false,
    host: 'localhost',
    port: 9272,
    strictPort: true,
    proxy: {
      '/api': {
        target: 'http://127.0.0.1:9271',
        changeOrigin: true,
        rewrite: (urlPath) => urlPath.replace(/^\/api/, '')
      }
    }
  },
  build: {
    outDir: 'dist'
  }
})
