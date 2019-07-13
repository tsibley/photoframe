SHELL := /bin/bash -euo pipefail

#
# Installation
#

install: /etc/cron.d/photoframe

uninstall:
	rm -v /etc/cron.d/photoframe

/etc/cron.d/photoframe: crontab
	install -vm u=rw,go=r $< $@
