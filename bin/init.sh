# 1. 确保本地代码是最新的
git fetch origin
git checkout main
git pull origin main

# 2. 创建一个没有历史的新分支
git checkout --orphan temp_branch

# 3. 添加所有文件
git add -A

# 4. 提交
git commit -m "Initial"

# 5. 删除原来的main分支并重命名当前分支
git branch -D main
git branch -m main

# 6. 强制推送到远程仓库
git push -f origin main

# 7. 重置其他协作者的引用（每个协作者都需执行）
# 其他协作者执行: git fetch origin
# 其他协作者执行: git reset --hard origin/main
