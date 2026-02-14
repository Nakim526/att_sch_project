FROM node:25.6.1

# Folder kerja di container
WORKDIR /app

# Copy file dependency dulu (biar cache efisien)
COPY package*.json ./

RUN npm install

# Copy semua source code
COPY . .

# Generate Prisma Client
RUN npx prisma generate

# BUILD TYPESCRIPT
RUN npm run build

# Port yang digunakan aplikasi
EXPOSE 3000

# Jalankan app
CMD ["npm", "run", "start"]
