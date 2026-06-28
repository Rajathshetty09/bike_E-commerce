# 1. Use the Node base image
FROM public.ecr.aws/docker/library/node:18-alpine

# 2. Set the working directory inside the container
WORKDIR /srv/app

# 3. Copy package files first to leverage Docker cache
COPY package.json pnpm-lock.yaml* ./

# 4. Install dependencies (Assuming you are using pnpm based on your file list)
RUN npm install -g pnpm && pnpm install

# 5. Copy the rest of your application files
COPY . .

# 6. Open the port your application listens on
EXPOSE 8000

# 7. Start your actual node application server (keeps container running)
CMD ["pnpm", "start"]
