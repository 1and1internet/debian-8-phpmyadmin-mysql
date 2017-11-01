FROM golang as configurability_mysql
MAINTAINER brian.wilkinson@1and1.co.uk
WORKDIR /go/src/github.com/1and1internet/configurability
RUN export GOOS=linux GOARCH=amd64 CGO_ENABLED=0 \
	&& git clone https://github.com/1and1internet/configurability.git . \
	&& make mysql\
	&& echo "configurability mysql plugin successfully built"

FROM 1and1internet/debian-8-phpmyadmin
MAINTAINER brian.wojtczak@1and1.co.uk
COPY files/ /
COPY --from=configurability_mysql /go/src/github.com/1and1internet/configurability/bin/plugins/mysql.so /opt/configurability/goplugins
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
	&& apt-get update \
	&& apt-get install --no-install-recommends mysql-server pwgen \
	&& rm -rf /tmp/* \
	&& mkdir -p /var/lib/mysql \
	&& chmod -R 777 /var/run /run /var/log /etc/mysql/ /var/lib/mysql \
	&& chmod -R 755 /init /hooks \
	&& mv /etc/mysql/my.cnf /etc/mysql/my.cnf.default \
	&& find /etc/mysql/ -type f -exec chmod 644 {} \; \
	&& rm -rf /var/lib/mysql/* \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
ENV PMA_ARBITRARY=0 \
	PMA_HOST=localhost \
	MYSQL_GENERAL_LOG=0 \
	MYSQL_QUERY_CACHE_TYPE=1 \
	MYSQL_QUERY_CACHE_SIZE=16M \
	MYSQL_QUERY_CACHE_LIMIT=1M
VOLUME /var/lib/mysql
EXPOSE 3306
