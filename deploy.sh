#!/bin/bash

# React 19 完全指南 - 部署脚本

echo "====================================="
echo "React 19 完全指南 - 部署脚本"
echo "====================================="

# 颜色定义
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m" # No Color

# 检查Docker是否安装
if ! command -v docker &> /dev/null; then
    echo -e "${RED}错误: Docker未安装！${NC}"
    echo "请先安装Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# 检查Docker Compose功能是否可用
if ! docker compose version &> /dev/null; then
    echo -e "${RED}错误: Docker Compose功能不可用！${NC}"
    echo "请确保安装了支持Compose的Docker版本: https://docs.docker.com/get-docker/"
    exit 1
fi

# 显示帮助信息
show_help() {
    echo -e "${GREEN}用法: ./deploy.sh [命令]${NC}"
    echo ""
    echo "命令:"
    echo "  build      构建生产镜像"
    echo "  dev        启动开发服务器"
    echo "  up         启动生产服务器"
    echo "  down       停止所有服务"
    echo "  preview    启动预览服务器"
    echo "  clean      清理所有资源"
    echo "  status     显示服务状态"
    echo "  help       显示帮助信息"
    echo ""
    exit 0
}

# 构建生产镜像
build_image() {
    echo -e "${YELLOW}正在构建生产镜像...${NC}"
    docker compose run builder
    echo -e "${GREEN}构建完成！${NC}"
}

# 启动开发服务器
start_dev() {
    echo -e "${YELLOW}正在启动开发服务器...${NC}"
    echo -e "${GREEN}开发服务器将在 http://localhost:5173 启动${NC}"
    docker compose up dev
}

# 启动生产服务器
start_prod() {
    echo -e "${YELLOW}正在启动生产服务器...${NC}"
    echo -e "${GREEN}生产服务器将在 http://localhost:80 启动${NC}"
    docker compose up -d web
}

# 停止所有服务
stop_all() {
    echo -e "${YELLOW}正在停止所有服务...${NC}"
    docker compose down
    echo -e "${GREEN}所有服务已停止！${NC}"
}

# 启动预览服务器
start_preview() {
    echo -e "${YELLOW}正在启动预览服务器...${NC}"
    echo -e "${GREEN}预览服务器将在 http://localhost:4173 启动${NC}"
    docker compose up preview
}

# 清理所有资源
clean_resources() {
    echo -e "${YELLOW}正在清理所有资源...${NC}"
    docker compose down -v --rmi all --remove-orphans
    docker system prune -f
    echo -e "${GREEN}资源清理完成！${NC}"
}

# 显示服务状态
show_status() {
    echo -e "${YELLOW}正在检查服务状态...${NC}"
    docker compose ps
    echo ""
    echo -e "${GREEN}镜像列表:${NC}"
    docker images | grep react-19-guide
}

# 处理命令参数
case "$1" in
    build)
        build_image
        ;;
    dev)
        start_dev
        ;;
    up)
        start_prod
        ;;
    down)
        stop_all
        ;;
    preview)
        start_preview
        ;;
    clean)
        clean_resources
        ;;
    status)
        show_status
        ;;
    help)
        show_help
        ;;
    *)
        echo -e "${RED}错误: 未知命令 '$1'${NC}"
        show_help
        ;;
esac

echo ""
echo -e "${GREEN}操作完成！${NC}"