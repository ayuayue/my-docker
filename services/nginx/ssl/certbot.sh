#!/usr/bin/env sh

# 泛域名，需要添加dns解析 txt记录。
# 过期只需要 certbot renew 重新生成证书即可。
# 在宿主机加入定时任务 0 0 * * 0 root docker exec -it nginx certbot renew > /tmp/certbot.log 2>&1
# 管理证书 certbot certificates

echo '请输入域名,如果需要泛域名请使用 *.example.com'
read domain
echo "输入域名的$domain"
certbot certonly --preferred-challenges dns --manual -d "$domain" --server https://acme-v02.api.letsencrypt.org/directory --dry-run