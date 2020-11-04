# Dockerfile for moodle container

FROM ubuntu:18.04
LABEL maintainer="Yuma Saito <y_saito@timedia.co.jp>" version="1.0"

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /tmp
RUN apt-get -y update && \
    apt-get -y install software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get -y install \
      apache2 mysql-client supervisor cron curl wget git unzip sudo \
      pwgen python-setuptools postfix libcurl4 locales \
      php7.4 php7.4-mbstring php7.4-curl php7.4-xmlrpc php7.4-soap \
      php7.4-zip php7.4-gd php7.4-xml php7.4-intl php7.4-json php7.4-mysql
# moodle 3.9のダウンロード
RUN git clone -b MOODLE_39_STABLE https://github.com/moodle/moodle.git --depth 1&& \
    mv ./moodle/* /var/www/html/ && \
    rm /var/www/html/index.html && \
    chown -R www-data:www-data /var/www/html/ && \
    mkdir /var/moodledata/ && \
    chown -R www-data:www-data /var/moodledata/
# miscellaneous (cron, ssl, locale, lightweight)
COPY moodlecron /etc/cron.d/moodlecron
RUN chmod 0644 /etc/cron.d/moodlecron && \
    a2enmod ssl && a2ensite default-ssl && \
    locale-gen en_AU.UTF-8 && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /tmp/* /var/tmp/* /var/lib/cache/* /var/lib/log/*
COPY ./foreground.sh /etc/apache2/
ENTRYPOINT ["/etc/apache2/foreground.sh"]
