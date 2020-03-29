FROM node:alpine

ENV TZ Europe/Paris
RUN apk update
RUN apk upgrade
RUN apk add ca-certificates && update-ca-certificates
# Change TimeZone
RUN apk add --no-cache --update tzdata
#ENV TZ=America/Bahia

RUN apk add --no-cache --update \
    git \
    ca-certificates

# Clean APK cache
RUN rm -rf /var/cache/apk/*


# --- Hue to MQTT from https://github.com/AntorFr/hue-mqtt-bridge.git ---

# Home directory for Hue-mqtt application source code.
RUN mkdir -p /usr/src/hue


WORKDIR /usr/src/hue

# Add hue user so we aren't running as root.
RUN adduser -h /usr/src/hue -D -H hue \
    && chown -R hue:hue /usr/src/hue

USER hue

RUN git clone git://github.com/AntorFr/hue-mqtt-bridge.git
COPY config.json /usr/src/hue/hue-mqtt-bridge/

WORKDIR /usr/src/hue/hue-mqtt-bridge

# Expose log volume
VOLUME /usr/src/hue/hue-mqtt-bridge/logs

RUN npm install --production

CMD ["npm", "start"]

#---------





