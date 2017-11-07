FROM golang as configurability_mysql
MAINTAINER brian.wilkinson@1and1.co.uk
WORKDIR /go/src/github.com/1and1internet/configurability
RUN git clone https://github.com/1and1internet/configurability.git . \
	&& make mysql\
	&& echo "configurability mysql plugin successfully built"

FROM 1and1internet/debian-8-phpmyadmin
MAINTAINER brian.wojtczak@1and1.co.uk
COPY files/ /
COPY --from=configurability_mysql /go/src/github.com/1and1internet/configurability/bin/plugins/mysql.so /opt/configurability/goplugins
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
	&& apt-get update \
	&& apt-get install curl libaio-dev libnuma-dev pwgen binutils \
	&& echo "Find and retrieve latest mysql 5.7 tar.gz file" \
	&& TARGZ=$(curl -s http://www.mirrorservice.org/sites/ftp.mysql.com/Downloads/MySQL-5.7/ | sed 's/.*a href.*>\(.*\)<\/a>.*/\1/' | egrep "mysql-5.7.[0-9]*-linux-glibc2.12-x86_64.tar.gz$" | sort | tail -1) \
	&& curl -g http://www.mirrorservice.org/sites/ftp.mysql.com/Downloads/MySQL-5.7/${TARGZ} -o ${TARGZ} \
	&& tar zxvf ${TARGZ} \
	&& mkdir -p /usr/local/mysql/bin \
	&& MYSQL_PKG=$(echo $TARGZ | sed 's/\(.*\).tar.gz/\1/') \
	&& cd /${MYSQL_PKG}/bin \
	&& cp my_print_defaults mysql mysqld mysqld_safe mysql_tzinfo_to_sql /usr/local/mysql/bin \
	&& cd /${MYSQL_PKG} \
	&& cp -R share /usr/share/mysql/ \
	&& cd / \
	&& rm -rf /${MYSQL_PKG} /${TARGZ} \
	&& mkdir -p /var/run/mysqld \
	&& cd /usr/local/mysql \
	&& rm -rf /tmp/* \
	&& mkdir -p /var/lib/mysql /var/log/mysql \
	&& chmod -R 777 /var/run /run /var/log /etc/mysql/ /var/lib/mysql /usr/share/mysql \
	&& chmod -R 755 /init /hooks \
	&& find /etc/mysql/ -type f -exec chmod 644 {} \; \
	&& rm -rf /var/lib/mysql/* \
	&& cd /usr/local/mysql/bin \
	&& strip my_print_defaults mysql mysqld mysql_tzinfo_to_sql \
	&& apt-get remove curl binutils \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& update-alternatives --install /usr/sbin/mysqld mysqld /usr/local/mysql/bin/mysqld 1 \
	&& update-alternatives --install /usr/bin/my_print_defaults my_print_defaults /usr/local/mysql/bin/my_print_defaults 1 \
	&& update-alternatives --install /usr/bin/mysql mysql /usr/local/mysql/bin/mysql 1 \
	&& update-alternatives --install /usr/sbin/mysqld_safe mysqld_safe /usr/local/mysql/bin/mysqld_safe 1 \
	&& update-alternatives --install /usr/bin/mysql_tzinfo_to_sql mysql_tzinfo_to_sql /usr/local/mysql/bin/mysql_tzinfo_to_sql 1 \
	&& dpkg -i /mysql-server_5.7.20_all.deb
ENV PMA_ARBITRARY=0 \
	PMA_HOST=localhost \
	MYSQL_GENERAL_LOG=0 \
	MYSQL_QUERY_CACHE_TYPE=1 \
	MYSQL_QUERY_CACHE_SIZE=16M \
	MYSQL_QUERY_CACHE_LIMIT=1M
VOLUME /var/lib/mysql
EXPOSE 3306
