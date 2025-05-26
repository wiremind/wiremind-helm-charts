# syntax=docker/dockerfile:1

ARG NGINX_VERSION=1.25.3
ARG VTS_VERSION=0.1.0
FROM nginx:${NGINX_VERSION}-alpine AS builder

# Install build dependencies
RUN apk add --no-cache --virtual .build-deps \
        git build-base openssl-dev pcre2-dev zlib-dev linux-headers curl \
    && curl -fSL https://github.com/vozlt/nginx-module-vts/archive/refs/tags/v${VTS_VERSION}.tar.gz | tar -xz -C /tmp \
    && mv /tmp/nginx-module-vts-* /tmp/nginx-module-vts \
    && curl -fSL https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz | tar -xz -C /tmp \
    && cd /tmp/nginx-${NGINX_VERSION} \
    && ./configure --with-compat --add-dynamic-module=/tmp/nginx-module-vts \
    && make modules

FROM nginx:${NGINX_VERSION}-alpine
COPY --from=builder /tmp/nginx-${NGINX_VERSION}/objs/ngx_http_vhost_traffic_status_module.so /etc/nginx/modules/
RUN mkdir -p /etc/nginx/modules-enabled \
    && echo 'load_module modules/ngx_http_vhost_traffic_status_module.so;' > /etc/nginx/modules-enabled/50-mod-http-vts.conf

CMD ["nginx", "-g", "daemon off;"]
