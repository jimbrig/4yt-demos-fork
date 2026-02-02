
# https://caddyserver.com/docs/caddyfile-tutorial
# https://github.com/zhangjiayin/caddy-geoip2

mkdir config data

docker build -t sinawic/caddy:2.8.4-geoip2 .

curl -i -H 'X-Forwarded-For: 184.69.48.26' http://pc.com/api/
curl -i -H 'X-Forwarded-For: 150.136.112.62' http://pc.com/api/
