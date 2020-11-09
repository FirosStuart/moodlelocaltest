#!/bin/bash
set -e

# プロセス情報の取得とシグナルトラップ
read pid cmd state ppid pgrp session tty_nr tpgid rest < /proc/self/stat
trap "kill -TERM -$pgrp; exit" EXIT TERM KILL SIGKILL SIGTERM SIGQUIT

# cron起動
/usr/sbin/cron && touch /etc/cron.d/moodlecron

# apache settings...
source /etc/apache2/envvars
tail -F /var/log/apache2/* &
export HOME=/root


#if [ ! -e "/var/www/html/config.php" ]; then
  # install moodle
  #sudo -u www-data /usr/bin/php /var/www/html/admin/cli/install.php \
  --non-interactive \
  --lang=ja \
  --wwwroot="${MOCA_URL}" \
  --dataroot="/var/moodledata" \
  --chmod=2770 \
  --dbtype="mysqli" \
  --dbhost="moca-mt-testdb.mysql.database.azure.com" \
  --dbname="${MYSQL_DATABASE}" \
  --dbuser="${MYSQL_USER}" \
  --dbpass="${MYSQL_PASSWORD}" \
  --dbport=3306 \
  --fullname="${MOCA_FULLNAME}" \
  --shortname="${MOCA_SHORTNAME}" \
  --summary="${MOCA_SUMMARY}" \
  --adminuser="${MOCA_ADMIN_USER}" \
  --adminpass="${MOCA_ADMIN_PASSWORD}" \
  --adminemail="${MOCA_ADMIN_EMAIL}" \
  --agree-license

  # add phpunit settings into config.php
  # sed -ie "/^require/i \$CFG->phpunit_prefix = 'phpu_';" /var/www/html/config.php
  # sed -ie "/^require/i \$CFG->phpunit_dataroot = '/var/moodledata_test';" /var/www/html/config.php
  # initialize test environment
  # /usr/bin/php /var/www/html/admin/tool/phpunit/cli/init.php
#fi

# for running container permanently...
#exec apache2 -D FOREGROUND
