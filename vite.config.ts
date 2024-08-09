import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import Rails from "vite-plugin-rails";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react(), Rails()],
  clearScreen: false,
  server: {
    port: 30002,
  },
});
