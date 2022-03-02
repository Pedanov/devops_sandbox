FROM alpine:latest

ENV DEVOPS=opedanov

ADD nginx-install.sh /tmp
RUN apk update && apk add nginx --no-cache

ADD www.conf /etc/nginx/http.d/

ADD index.html /home/www/
RUN chmod +r /home/www/index.html

ADD entrypoint.sh ./
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
# CMD ["nginx", "-g", "daemon off;"]