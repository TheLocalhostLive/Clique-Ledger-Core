# Contributor's Guide

---

### **1. To build and Start the Server (in watch mode)**  
Run the following command to start the server in watch mode:

```bash
docker compose build
docker compose up --watch
```

---

### **2. Handling Prisma Schema Changes**

If you make changes to the `prisma.schema`, follow these steps:

1. **Start the server** in one terminal:
   ```bash
   docker compose up
   ```
2. **Run Prisma commands** in another terminal:
   - If there are changes to existing tables, reset the migrations:
     ```bash
     npx prisma migrate reset --force
     ```
   - Then apply the migrations:
     ```bash
     npx prisma migrate dev --name init
     ```
3. **Stop the server** once the migrations are applied:
   - Press `CTRL + C` or run:
     ```bash
     docker compose down
     ```
4. **Rebuild the containers** after schema changes:
   ```bash
   docker compose build
   ```
5. **Restart the server** in watch mode to continue development:
   ```bash
   docker compose up --watch
   ```

---

### **3. Troubleshooting: Module Not Found Error**  

If you encounter a `./dist/app.js module not found` error, stop the server by pressing `CTRL + C` and restart it. This should resolve the issue.

--- 


