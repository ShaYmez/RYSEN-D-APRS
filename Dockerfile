###############################################################################
#   Copyright (C) 2020 Simon Adlem, G7RZU <g7rzu@gb7fr.org.uk> 
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software Foundation,
#   Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
###############################################################################
FROM python:3.9-alpine

ENTRYPOINT [ "/entrypoint" ]

COPY entrypoint /entrypoint
COPY config /opt/

VOLUME /usersettings

RUN adduser -D -u 54000 radio && \
        apk update && \
        apk add git gcc g++ musl-dev && \
        cd /opt && \
        git clone https://github.com/kf7eel/hbnet.git hbnet && \
        cd /opt/hbnet && \
	git checkout gps && \
        pip install --no-cache-dir -r requirements.txt && \
        apk del git gcc musl-dev && \
        chown -R radio: /opt/ && \
	mkdir /usersettings && \
	cp /opt/usersettings.txt /usersettings/  && \
	chown -R radio: /usersettings

USER radio
