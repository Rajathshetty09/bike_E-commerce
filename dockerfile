# --- Build Stage ---
FROM public.ecr.aws/docker/library/node:18-alpine AS builder
WORKDIR /srv/app
COPY package.json pnpm-lock.yaml* ./
RUN npm install -g pnpm && pnpm install
COPY . .
# Run your frontend build command (e.g., pnpm build)
RUN pnpm build

# --- Production Stage ---
FROM public.ecr.aws/docker/library/nginx:alpine
# Copy the built static files from the builder stage over to nginx HTML directory
# Note: Check if your build output folder is 'dist' or 'build' and change accordingly
COPY --from=builder /srv/app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
