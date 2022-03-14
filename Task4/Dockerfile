FROM alpine:latest

ARG PASSWORD

ENV DEVOPS=opedanov
ENV PASSWORD=$PASSWORD

ADD nginx-install.sh /tmp
RUN apk update && apk add nginx --no-cache

ADD www.conf /etc/nginx/http.d/

ADD index.html /home/www/
RUN chmod +r /home/www/index.html

ADD entrypoint.sh ./
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
