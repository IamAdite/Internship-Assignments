FROM alpine:latest AS build

ADD https://nginx.org/download/nginx-1.23.1.tar.gz /tmp/nginx.tar.gz
ADD https://www.openssl.org/source/openssl-1.1.1o.tar.gz /tmp/openssl.tar.gz
ADD https://zlib.net/zlib-1.2.12.tar.gz /tmp/zlib.tar.gz

RUN apk add build-base ca-certificates gcc linux-headers pcre-dev perl && \
    tar -C /tmp -xf /tmp/nginx.tar.gz && \
    tar -C /tmp -xf /tmp/openssl.tar.gz && \
    tar -C /tmp -xf /tmp/zlib.tar.gz && \
    cd /tmp/nginx-1.23.1 && \
      ./configure \
        --with-cc-opt="-static" \
        --with-ld-opt="-static" \
        --with-cpu-opt="generic" \
        --sbin-path="/bin/nginx" \
        --conf-path="/etc/nginx/nginx.conf" \
        --pid-path="/tmp/nginx.pid" \
        --http-log-path="/dev/stdout" \
        --error-log-path="/dev/stderr" \
        --http-client-body-temp-path="/tmp/client_temp" \
        --http-fastcgi-temp-path="/tmp/fastcgi_temp" \
        --http-proxy-temp-path="/tmp/proxy_temp" \
        --http-scgi-temp-path="/tmp/scgi_temp" \
        --http-uwsgi-temp-path="/tmp/uwsgi_temp" \
        --with-select_module \
        --with-poll_module \
        --with-threads \
        --with-file-aio \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_auth_request_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_degradation_module \
        --with-http_slice_module \
        --with-http_stub_status_module \ 
        --with-mail \
        --with-mail_ssl_module \
        --with-stream \
        --with-stream_ssl_module \
        --with-stream_realip_module \
        --with-stream_ssl_preread_module \
        --with-compat \
        --with-openssl="/tmp/openssl-1.1.1o" \
        --with-zlib="/tmp/zlib-1.2.12" && \
      make

RUN mkdir -p /rootfs/bin && \
      cp /tmp/nginx-1.23.1/objs/nginx /rootfs/bin/ && \
    mkdir -p /rootfs/etc && \
      echo "nogroup:*:10000:nobody" > /rootfs/etc/group && \
      echo "nobody:*:10000:10000:::" > /rootfs/etc/passwd && \
    mkdir -p /rootfs/etc/nginx && \
    mkdir -p /rootfs/etc/ssl/certs && \
      cp /etc/ssl/certs/ca-certificates.crt /rootfs/etc/ssl/certs/ && \
    mkdir -p /rootfs/tmp && mkdir -p /rootfs/usr/local/nginx/html && \
      cp -r /tmp/nginx-1.23.1/html/* /rootfs/usr/local/nginx/html/

FROM scratch

COPY --from=build --chown=10000:10000 /rootfs /


USER 10000:10000
EXPOSE 80
ENTRYPOINT ["/bin/nginx"]
CMD ["-g", "daemon off;"]
