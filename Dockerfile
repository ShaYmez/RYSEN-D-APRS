FROM python:3.11-alpine

COPY entrypoint /entrypoint
COPY config /opt/

VOLUME /usersettings

RUN adduser -D -u 54000 radio && \
        apk update && \
        apk add --no-cache --virtual .build-deps \
            git \
            gcc \
            g++ \
            musl-dev \
            libffi-dev \
            openssl-dev \
            cargo \
            rust && \
        apk add --no-cache \
            libffi \
            openssl && \
        pip install --upgrade pip setuptools wheel && \
        cd /opt && \
        git clone https://github.com/shaymez/hbnet.git hbnet && \
        cd /opt/hbnet && \
        git checkout gps && \
        pip install --no-cache-dir -r requirements.txt && \
        apk del .build-deps && \
        rm -rf /root/.cargo /root/.cache /tmp/* && \
        chown -R radio: /opt/ && \
        mkdir /usersettings && \
        cp /opt/usersettings.txt /usersettings/ && \
        chown -R radio: /usersettings

USER radio

ENTRYPOINT [ "/entrypoint" ]
