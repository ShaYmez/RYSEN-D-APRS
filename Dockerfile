FROM python:alpine3.16

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
