#!/bin/sh
service ssh start

#sed -i "s/Listen 80/Listen ${PORT:-80}/g" /etc/apache2/ports.conf
#sed -i "s/:80/:${PORT:-80}/g" /etc/apache2/sites-enabled/*
apache2-foreground