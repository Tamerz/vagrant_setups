#!/usr/bin/env bash

PROXY_USER="username"
PROXY_PASS="password"

apt-get update
apt-get install -y squid3
service squid3 stop

echo "auth_param digest program /usr/lib/squid3/digest_pw_auth -c /etc/squid3/passwords" > /etc/squid3/squid.conf
echo "auth_param digest realm proxy" >> /etc/squid3/squid.conf
echo "acl authenticated proxy_auth REQUIRED" >> /etc/squid3/squid.conf
echo "http_access allow authenticated" >> /etc/squid3/squid.conf
echo "http_port 3128" >> /etc/squid3/squid.conf

(echo -n "$PROXY_USER:proxy:" && echo -n "$PROXY_USER:proxy:$PROXY_PASS" | md5sum | awk '{print $1}') >> /etc/squid3/passwords

service squid3 start
