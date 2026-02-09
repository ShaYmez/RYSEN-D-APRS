FROM python:alpine3.18

ENTRYPOINT [ "/entrypoint" ]

COPY entrypoint /entrypoint
COPY config /opt/

VOLUME /usersettings

RUN adduser -D -u 54000 radio && \
        apk update && \
        apk add git gcc g++ musl-dev libffi-dev && \
	pip install --upgrade pip && \
        pip cache purge && \
        cd /opt && \
        git clone https://github.com/shaymez/hbnet.git hbnet && \
        cd /opt/hbnet && \
	git checkout hbnet && \ 
        pip install --no-cache-dir -r requirements.txt && \
        apk del git gcc musl-dev && \
        chown -R radio: /opt/ && \
	mkdir /usersettings && \
	cp /opt/usersettings.txt /usersettings/  && \
	chown -R radio: /usersettings

USER radio
