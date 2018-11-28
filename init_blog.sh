#!/bin/bash

function main {
    get_token
    set_vars
    set_db_perms
    start_apache
}

function get_token {
    cd ~/smsblog
    TOKEN="$(smsblog token)"
}

function set_vars {
    cd ~
    sed -i "s@placeholder_num@$NUMBER@g" smsblog_wsgi.txt
    sed -i "s@placeholder_url@$DOMAIN@g" smsblog_wsgi.txt
    sed -i "s@placeholder_auth_token@$AUTH_TOKEN@g" smsblog_wsgi.txt

    sed -i "s@placeholder_url@$DOMAIN@g" smsface_wsgi.txt
    sed -i "s@placeholder_token@$TOKEN@g" smsface_wsgi.txt
    sed -i "s@placeholder_pass@$PASSWORD@g" smsface_wsgi.txt


    sed -i "s@placeholder_url@$DOMAIN@g" smsblog_conf.txt

    echo "$IP $DOMAIN" >> /etc/hosts
    echo "$IP sms.$DOMAIN" >> /etc/hosts

    cp smsblog_wsgi.txt /var/www/smsblog/smsblog.wsgi
    cp smsface_wsgi.txt /var/www/smsface/smsface.wsgi
    cp smsblog_conf.txt /etc/apache2/sites-available/smsblog.conf
    cp smsblog_conf.txt /etc/apache2/sites-enabled/smsblog.conf
}

function set_db_perms {
  chmod 777 /opt/smsblog/smsblog.db
  chmod 777 /opt/smsblog/
}

function start_apache {
    service apache2 restart
}

main "$@"
