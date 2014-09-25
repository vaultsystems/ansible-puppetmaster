#!/bin/bash
/etc/init.d/apache2 stop
puppet cert clean --all
rm /var/lib/puppet/ssl/ca/requests/*
timeout 5 puppet master --no-daemonize --verbose
/etc/init.d/apache2 start
