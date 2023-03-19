# 设置要转换的 Docker Compose 文件路径
$composeFile = "k8s/docker-compose-resolved.yaml"
$directory = "k8s"
#读取 .env 变量
Get-Content ".env" |  Where-Object { $_.Trim() -and $_.Trim()[0] -ne '#' } |   ForEach-Object {
    $name, $value = $_ -split '=', 2
    Set-Item -Path "env:${name}" -Value $value
}
sudo kompose convert -f "docker-compose.yml" -o k8s
# 安装 Kompose（如果未安装）
# if (-not (Get-Command kompose -ErrorAction SilentlyContinue)) {
#     Invoke-WebRequest -Uri https://github.com/kubernetes/kompose/releases/download/v1.22.0/kompose-windows-amd64.exe -OutFile kompose.exe
#     New-Item -Path "$HOME\bin" -ItemType Directory -Force | Out-Null
#     Move-Item -Path kompose.exe -Destination "$HOME\bin\kompose.exe"
#     $env:PATH += ";$HOME\bin"
# }
# 先转为普通 docker-compose 配置文件
# sudo docker compose config > $composeFile
# 转换 Docker Compose 文件为 Kubernetes YAML 文件
# sudo kompose convert -f $composeFile -o k8s

# Write-Host "Docker Compose 文件已成功转换为 Kubernetes YAML 文件。"


# cd k8s
# Get-ChildItem -Path $directory -Filter *.yaml -Recurse | ForEach-Object {
#         if ($_.Name -ne "docker-compose-resolved.yaml") {
#         # 在这里添加处理 YAML 文件的代码
#         kubectl apply -f $_.FullName
#     }
# }
# Get-ChildItem -Path . -Filter *-deployment.yaml | %{kubectl apply -f $_.FullName}
# Get-ChildItem -Path . -Filter *-deployment.yaml | %{kubectl apply -f $_.FullName}
