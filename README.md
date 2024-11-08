# Contributor's Guide

---

### 1. How to setup   

1. **Start the server**
   ```bash
   docker compose up -d
   ```
2. **Run Migrations**: 
     ```bash
     npx prisma migrate dev --name init
     ```
3. **Stop the server** once the migrations are applied:
   - Press `CTRL + C` or run:
     ```bash
     docker compose down
     ```
4. **Rebuild the containers**: 
   ```bash
   docker compose build
   ```


---

### **2. How to start the server after setup**  

After you have successfully set up the server you need to run the following command to run the server and start development.

```bash
docker compose up --watch
```

### 2. Troubleshooting  

We have noticed when we run the nodejs server for the first time after setup we sometimes get a module not found error.
In such case you may restart the server and the error will resolve

```bash
docker compose down
docker compose up --watch
```

--- 

### Database Model:
Link: https://dbdiagram.io/d/66952aa99939893daef73792

![Clique_Ledger_Relational_Model 1](https://github.com/user-attachments/assets/224c1564-5a94-4cb1-8f97-fde8ee8ad154)

---

