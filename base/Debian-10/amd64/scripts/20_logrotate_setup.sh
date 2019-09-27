#! /bin/bash --posix

set -x

mv /etc/cron.daily/logrotate /etc/cron.hourly
