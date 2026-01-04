# ----------------------------------
# STAGE 1: Build the Static Site
# ----------------------------------
FROM node:lts AS builder

WORKDIR /app

# Copy package files first (for better caching)
COPY package*.json ./
RUN npm install

# Copy the rest of the code
COPY . .

# Build the Astro site
RUN npm run build

# ----------------------------------
# STAGE 2: Serve with Nginx
# ----------------------------------
FROM nginx:alpine

# Copy the built files from Stage 1 into the Nginx container
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose Port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]