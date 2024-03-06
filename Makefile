SHELL := /bin/bash -euo pipefail

#
# Installation for selecting and sending device…
#

install: /etc/cron.d/photoframe

uninstall:
	rm -v /etc/cron.d/photoframe

/etc/cron.d/photoframe: crontab
	install -vm u=rw,go=r $< $@


#
# …and for displaying device…
#

display-install: /etc/cron.d/photoframe-display

display-uninstall:
	rm -v /etc/cron.d/photoframe-display

/etc/cron.d/photoframe-display: crontab.display
	install -vm u=rw,go=r $< $@


#
# …and for the Apple device.
#

apple-photos-install: crontab.apple-photos
	# XXX FIXME: check for existing crontab first
	crontab $<

apple-photos-uninstall:
	# XXX FIXME: check that we're removing just our crontab first
	crontab -r
