#!/bin/bash
 
# 1. 获取所有暂存文件的修改时间，并找出最大值
latest_mtime=$(
    git diff --cached --name-only | \
    xargs stat -c %Y 2>/dev/null | \
    awk 'BEGIN { max=0 } { if ($1 > max) max=$1 } END { print max }'
)
 
# 2. 计算时间偏移
author_timestamp=$((latest_mtime + 25))
committer_timestamp=$((author_timestamp + 82))
 
# 3. 提交
export GIT_AUTHOR_DATE=$(date -d "@$author_timestamp" +"%Y-%m-%d %H:%M:%S")
export GIT_COMMITTER_DATE=$(date -d "@$committer_timestamp" +"%Y-%m-%d %H:%M:%S")
git commit -m "提交信息 x2"
# git commit  --dry-run -m "提交信息 $GIT_COMMITTER_DATE"

## 当直接运行./script.sh时，系统会创建子Shell进程，环境变量只在该子进程中有效，父进程（终端）无法获取这些变量。
# source your_script.sh : 这会在当前Shell环境中执行脚本，而不是创建子进程。
# git push


# 4. 输出
echo "-----------------------"
echo "最新修改时间: $(date -d "@$latest_mtime" +"%Y-%m-%d %H:%M:%S")"
echo "作者时间（加5分钟）: $GIT_AUTHOR_DATE"
echo "提交时间（再加8分钟）: $GIT_COMMITTER_DATE"
echo "-----------------------"
echo "RUN : git log -1 --pretty=fuller"
git log -1 --pretty=fuller

