# 第一阶段：构建
FROM node:18.19.0 AS builder

WORKDIR /build

# 复制所有源代码
COPY . .

# 安装依赖（包括开发依赖）
RUN npm ci --ignore-scripts && \
    mkdir -p /app/saved && \
    mkdir -p /app/levels/load && \
    mkdir -p /app/levels/new

# 第二阶段：运行
FROM node:18.19.0-slim

WORKDIR /app

# 复制所有文件
COPY --from=builder /build/ ./

# 复制创建的目录
COPY --from=builder /app/saved ./saved
COPY --from=builder /app/levels ./levels

# 只安装生产依赖
RUN npm ci --only=production --ignore-scripts

# 设置环境变量
ENV APP_DIR=/app \
    APP_NAME=vim-adventures \
    NODE_ENV=production \
    PORT=3000

EXPOSE 3000
CMD ["npm", "start"]
