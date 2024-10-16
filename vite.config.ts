import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

// https://vitejs.dev/config/
export default defineConfig({
  root: "client/",
  plugins: [react()],
  clearScreen: false,
  server: {
    host: true,
    port: 30002,
  },
});
