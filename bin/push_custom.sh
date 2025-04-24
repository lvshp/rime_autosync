#!/bin/bash

# 定义颜色输出函数
print_green() {
    echo -e "\033[0;32m$1\033[0m"
}

print_red() {
    echo -e "\033[0;31m$1\033[0m"
}

print_blue() {
    echo -e "\033[0;34m$1\033[0m"
}

print_yellow() {
    echo -e "\033[0;33m$1\033[0m"
}

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# 获取仓库根目录
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# 处理自定义提交信息
COMMIT_MSG="更新自定义配置 $(date '+%Y-%m-%d %H:%M')"
if [ $# -gt 0 ]; then
    COMMIT_MSG="$*"
fi

# 进入仓库目录
cd "$REPO_DIR" || {
    print_red "无法进入仓库目录: $REPO_DIR"
    exit 1
}

# 检查是否为git仓库
if [ ! -d ".git" ]; then
    print_red "当前目录不是git仓库"
    exit 1
fi

# 检查custom目录是否存在
if [ ! -d "custom" ]; then
    print_red "custom目录不存在"
    exit 1
fi

print_blue "开始处理自定义配置更新..."

# 1. 将custom目录的文件复制到上层目录
print_blue "将custom目录中的文件复制到根目录..."
cp -f custom/* . 2>/dev/null || true

# 2. 检查目录是否有变更
print_blue "检查custom目录变更..."
git status --porcelain custom/ bin/ | grep -q . || {
    print_blue "检查整个仓库是否有变更..."
    git status --porcelain | grep -q . || {
        print_yellow "没有检测到任何变更，无需提交"
        exit 0
    }
}

# 3. 添加变更到暂存区
print_blue "添加变更到Git..."
git add custom/ || {
    print_red "无法添加custom目录的变更"
    exit 1
}

# 添加bin目录的变更
git add bin/ || {
    print_yellow "警告: 无法添加bin目录的变更"
}

# 同时添加根目录中非忽略的文件
for file in $(find custom -type f -not -path "*/\.*" | sed 's|^custom/||'); do
    if [ -f "$file" ] && ! [[ "$file" == *custom*.yaml ]]; then
        git add "$file" 2>/dev/null || true
    fi
done

# 4. 提交变更
print_blue "提交变更: $COMMIT_MSG"
git commit -m "$COMMIT_MSG" || {
    print_red "提交变更失败"
    exit 1
}

# 5. 推送到远程仓库
print_blue "推送到远程仓库..."
git push || {
    print_red "推送到远程仓库失败"
    exit 1
}

print_green "自定义配置已成功更新并推送到远程仓库！"
