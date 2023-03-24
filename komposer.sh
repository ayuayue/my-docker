#!/usr/bin/env sh

# 将 PowerShell 命令 REM 和 Set-Item 替换成 Bash 的注释和环境变量赋值
# REM 设置要转换的 Docker Compose 文件路径
composeFile="docker-compose-resolved.yaml"
directory="k8s"
# 读取 .env 变量
# while read line; do
#   line=`echo $line | sed -e 's/\r//g'`
#   if [ -n "$line" ]; then
#     name=`echo $line | cut -d '=' -f 1`
#     value=`echo $line | cut -d '=' -f 2-`
#     export $name="$value"
#   fi
# done < .env

# 将 PowerShell 命令 sudo 和 docker compose 替换成对应的 Linux 命令
# 先转为普通 docker-compose 配置文件
docker-compose config > "$composeFile"
# 转换 Docker Compose 文件为 Kubernetes YAML 文件
kompose convert -f "$composeFile" -o "$directory"

# 将 PowerShell 命令 Write-Host 替换成 echo
echo "Docker Compose 文件已成功转换为 Kubernetes YAML 文件。"

# 将 PowerShell 命令 Get-ChildItem 替换成 ls
# ls "$directory"/*.yaml | while read file; do
#   if [ "$(basename $file)" != "docker-compose-resolved.yaml" ]; then
#     # 在这里添加处理 YAML 文件的代码
#     kubectl apply -f "$file"
#   fi
# done
kubectl apply -f "$directory/"