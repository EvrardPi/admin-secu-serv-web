FROM nginx:latest

RUN apt-get update && apt-get install -y \
    sed \
    && rm -rf /var/lib/apt/lists/*

COPY default.conf /etc/nginx/conf.d/
COPY nginx.conf /etc/nginx/

# Remove server version in default configuration
RUN sed -i 's/Server: nginx/Server: hidden/g' /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
