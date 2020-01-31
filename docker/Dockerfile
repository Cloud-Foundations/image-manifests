# Build all the bins
FROM golang:buster AS builder

ENV APP     /go/src/Dominator
ENV COMMIT  ee0024f8ccc1ce647137e1c75dc68f40e19c0ed2

RUN git clone https://github.com/Cloud-Foundations/Dominator.git $APP \
    && cd $APP \
    && git checkout $COMMIT

WORKDIR $APP

RUN go get -d -v ./...
RUN CGO_ENABLED=0 make

# Imaginator Server
FROM debianlive/base:latest AS imaginator

EXPOSE 6975

VOLUME /var/log/imaginator

RUN apt-get update \
    && apt-get -y install debootstrap git

COPY --from=builder /go/bin/imaginator /bin/imaginator

ENTRYPOINT ["/bin/imaginator"]

# Dominator Server
FROM debianlive/base:latest AS dominator

EXPOSE 6970

RUN useradd -rm -d /home/dominator -s /bin/bash -u 1000 dominator \
    && mkdir -p /var/lib/Dominator \
       /var/lib/mdbd \
       /var/log/dominator \
    && chown -R dominator:dominator /var/lib/Dominator \
       /var/lib/mdbd \
       /var/log/dominator

VOLUME /var/lib/Dominator
VOLUME /var/lib/mdbd
VOLUME /var/log/dominator

COPY --from=builder /go/bin/dominator /bin/dominator
COPY --from=builder /go/bin/domtool /bin/domtool

USER dominator

ENTRYPOINT ["/bin/dominator"]

# Image Server
FROM debianlive/base:latest AS imageserver

EXPOSE 6971

RUN useradd -rm -d /home/imageserver -s /bin/bash -u 1000 imageserver \
    && mkdir -p /var/lib/objectserver \
       /var/lib/imageserver \
       /var/log/imageserver \
    && chown -R imageserver:imageserver /var/lib/objectserver \
       /var/lib/imageserver \
       /var/log/imageserver

VOLUME /var/log/imageserver
VOLUME /var/lib/imageserver
VOLUME /var/lib/objectserver

COPY --from=builder /go/bin/imageserver /bin/imageserver

USER imageserver

ENTRYPOINT ["/bin/imageserver"]

# MDBD Server
FROM debianlive/base:latest AS mdbd

EXPOSE 6973

# /var/lib/mdbd/mdb.sources.list must be volumed into the container
RUN useradd -rm -d /home/mdbd -s /bin/bash -u 1000 mdbd \
    && mkdir -p /var/lib/mdbd \
       /var/log/mdbd \
    && chown -R mdbd:mdbd /var/lib/mdbd \
       /var/log/mdbd

VOLUME /var/log/mdbd
VOLUME /var/lib/mdbd

COPY mdbd/mdbd /bin/mdbd

USER mdbd

ENTRYPOINT ["/bin/mdbd"]

# Filegen Server
FROM debianlive/base:latest AS filegenserver

EXPOSE 6972

# /var/lib/mdbd/mdb.sources.list must be volumed into the container
RUN useradd -rm -d /home/fg -s /bin/bash -u 1000 fg \
    && mkdir -p /var/lib/filegenserver \
       /var/log/filegenserver \
    && chown -R fg:fg /var/lib/filegenserver \
       /var/log/filegenserver

VOLUME /var/log/filegenserver
VOLUME /var/lib/filegenserver

COPY filegenserver/filegenserver /bin/filegenserver

USER fg

ENTRYPOINT ["/bin/filegenserver"]
