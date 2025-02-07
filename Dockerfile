FROM node:20.9.0 as builder
WORKDIR /app
RUN npm config set registry https://registry.npmmirror.com
RUN npm install pnpm -g

COPY . .

RUN pnpm install && pnpm build


FROM nginx:latest
# 安装 dos2unix
RUN apt-get update && \
    apt-get install -y dos2unix && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/docker-entrypoint.sh /docker-entrypoint2.sh 
RUN chmod +x /docker-entrypoint2.sh && \
    dos2unix /docker-entrypoint2.sh
COPY --from=builder /app/nginx.conf.template /
COPY --from=builder /app/dist /usr/share/nginx/html
ENTRYPOINT ["sh", "/docker-entrypoint2.sh"]
CMD ["nginx","-g","daemon off;"]
