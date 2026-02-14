# 第一阶段：构建阶段
FROM node:18-alpine AS builder

# 设置工作目录
WORKDIR /app

# 复制package.json和pnpm-lock.yaml
COPY package.json pnpm-lock.yaml ./

# 安装pnpm
RUN npm install -g pnpm

# 配置pnpm镜像源（解决网络问题）
RUN pnpm config set registry https://registry.npmmirror.com && \
    pnpm config set @types:registry https://registry.npmmirror.com && \
    pnpm config set electron_mirror https://npmmirror.com/mirrors/electron/ && \
    pnpm config set electron_builder_binaries_mirror https://npmmirror.com/mirrors/electron-builder-binaries/

# 安装依赖
RUN pnpm install

# 复制项目文件
COPY . .

# 构建文档
RUN pnpm run docs:build

# 第二阶段：生产阶段
FROM nginx:alpine AS production

# 复制构建产物到Nginx
COPY --from=builder /app/.vitepress/dist /usr/share/nginx/html

# 复制自定义Nginx配置
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# 暴露端口
EXPOSE 80

# 启动Nginx
CMD ["nginx", "-g", "daemon off;"]