#!/bin/bash

# 定义颜色输出函数，使输出更友好
print_green() {
    echo -e "\033[0;32m$1\033[0m"
}

print_red() {
    echo -e "\033[0;31m$1\033[0m"
}

print_blue() {
    echo -e "\033[0;34m$1\033[0m"
}

# 定义路径变量
RIME_DIR="$HOME/Library/Rime"
TEMP_DIR="/tmp/rime_update_temp"
REPO_URL="https://github.com/amzxyz/RIME-LMDG"

# 创建临时目录
mkdir -p "$TEMP_DIR"

print_blue "======== Rime 配置更新脚本 ========"

# 1. 更新 Rime 目录下的仓库到 main 分支
print_green "1. 更新 Rime 仓库..."
cd "$RIME_DIR" || {
    print_red "无法进入 $RIME_DIR 目录"
    exit 1
}

if [ -d ".git" ]; then
    git fetch origin || {
        print_red "获取远程更新失败"
        exit 1
    }
    git checkout main || {
        print_red "切换到 main 分支失败"
        exit 1
    }
    git pull origin main || {
        print_red "拉取更新失败"
        exit 1
    }
    print_green "仓库更新成功"
else
    print_red "$RIME_DIR 不是一个 git 仓库"
    exit 1
fi

# 2. 强制更新配置文件
print_green "2. 强制更新配置文件..."

# 检查custom目录是否存在
if [ -d "$RIME_DIR/custom" ]; then
    # 复制所有custom目录下的文件到RIME主目录
    cp -f "$RIME_DIR/custom/"* "$RIME_DIR/" 2>/dev/null
    print_green "已将custom目录下的所有文件复制到Rime主目录"
else
    print_blue "custom目录不存在，跳过配置文件更新"
fi

# 3. 从GitHub仓库获取最新的cn_dicts目录
print_green "3. 获取最新字典文件..."

# 创建临时目录存放克隆的仓库
mkdir -p "$TEMP_DIR/repo"
cd "$TEMP_DIR/repo" || {
    print_red "无法创建或进入临时目录"
    exit 1
}

# 克隆仓库（仅获取最新版本，不下载历史）
print_blue "正在从 $REPO_URL 克隆仓库..."
git clone --depth 1 "$REPO_URL" . || {
    print_red "克隆仓库失败"
    exit 1
}

# 检查cn_dicts目录是否存在
if [ ! -d "cn_dicts" ]; then
    print_red "仓库中不存在cn_dicts目录"
    exit 1
fi

# 4. 复制字典文件并强制覆盖
print_green "4. 强制更新字典文件..."

# 先删除目标目录，确保完全同步
rm -rf "$RIME_DIR/cn_dicts"
mkdir -p "$RIME_DIR/cn_dicts"

# 强制复制所有字典文件
cp -rf "cn_dicts/"* "$RIME_DIR/cn_dicts/" || {
    print_red "复制字典文件失败"
    exit 1
}

print_green "字典文件已成功更新"

# 返回到原来的目录
cd "$RIME_DIR" || {
    print_red "无法返回到 $RIME_DIR 目录"
    exit 1
}

# 清理临时文件
print_green "5. 清理临时文件..."
rm -rf "$TEMP_DIR"

bash bin/repo_update.sh

print_blue "======== 更新完成！========="
print_green "RIME配置和字典已更新。"
