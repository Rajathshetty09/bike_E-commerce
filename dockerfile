# --- Stage 1: Build the React Application ---
FROM public.ecr.aws/docker/library/node:18-alpine AS builder

WORKDIR /srv/app

# Copy dependency configuration files
COPY package.json pnpm-lock.yaml* ./

# Install pnpm globally and install all packages
RUN npm install -g pnpm && pnpm install

# Copy the rest of the application source code
COPY . .

# Run the TypeScript check and Vite production build
RUN pnpm build

# --- Stage 2: Serve with Nginx ---
FROM public.ecr.aws/docker/library/nginx:alpine

# Copy the compiled static assets from the builder stage into Nginx's default public folder
# Note: Vite defaults its build output directory to 'dist'
COPY --from=builder /srv/app/dist /usr/share/nginx/html

# Expose port 80 (Nginx's default web traffic port)
EXPOSE 80

# Run Nginx in the foreground so the ECS container remains active
CMD ["nginx", "-g", "daemon off;"]
