FROM alpine:3.17.0 as builder
RUN apk add --update build-base git bash gcc make g++ zlib-dev linux-headers pcre-dev openssl-dev
RUN git clone https://github.com/arut/nginx-rtmp-module.git --depth 1
RUN git clone https://github.com/nginx/nginx.git -b release-1.22.1 --depth 1
RUN cd nginx && ./auto/configure --add-module=../nginx-rtmp-module && make && make install

FROM alpine:3.17.0 as nginx
RUN apk add --update pcre ffmpeg
COPY --from=builder /usr/local/nginx /usr/local/nginx
COPY nginx.conf /usr/local/nginx/conf
ENTRYPOINT ["/usr/local/nginx/sbin/nginx"]
CMD ["-g", "daemon off;"]