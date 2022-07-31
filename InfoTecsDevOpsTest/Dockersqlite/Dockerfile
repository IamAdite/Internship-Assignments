FROM debian:bullseye

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
               build-essential \
    && apt-get clean

RUN mkdir ./usr/src/sqlite

COPY ./src/shell.c ./usr/src/sqlite 
COPY ./src/sqlite3.c ./usr/src/sqlite
COPY ./src/sqlite3.h ./usr/src/sqlite

WORKDIR ./usr/src/sqlite

RUN gcc -shared -o sqlite.so shell.c sqlite3.c -fPIC 
