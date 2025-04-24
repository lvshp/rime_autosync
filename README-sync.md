
本地修改但不提交的自定义配置文件，使用 --skip-worktree 标记：

```bash
git update-index --skip-worktree my_custom_dict.txt
```

使用macOS的launchd 定时更新（每天晚上10点30）

```bash
# 创建plist文件
cat > ~/Library/LaunchAgents/io.astralwave.rime.updater.plist << EOL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>io.astralwave.rime.updater</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/你的用户名/Library/Rime/bin/update.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>22</integer>
        <key>Minute</key>
        <integer>30</integer>
    </dict>
    <key>StandardErrorPath</key>
    <string>/Users/你的用户名/Library/Logs/rime_update_error.log</string>
    <key>StandardOutPath</key>
    <string>/Users/你的用户名/Library/Logs/rime_update.log</string>
</dict>
</plist>
EOL

# 加载plist文件
launchctl load ~/Library/LaunchAgents/io.astralwave.rime.updater.plist

```