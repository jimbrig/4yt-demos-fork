FROM caddy:builder-alpine AS builder

RUN xcaddy build \
		--with github.com/mholt/caddy-l4

FROM caddy:2.8.4

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
