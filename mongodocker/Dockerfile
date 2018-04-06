FROM mongo:latest
COPY cards.json /docker-entrypoint-initdb.d/
COPY init.sh /docker-entrypoint-initdb.d/
EXPOSE 27017