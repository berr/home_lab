FROM debian:bookworm as Builder

RUN apt update && \
    apt install --no-install-recommends -y wget ca-certificates build-essential git make && \
    apt clean

WORKDIR /root
RUN wget https://go.dev/dl/go1.21.7.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.21.7.linux-amd64.tar.gz && rm -Rf ./*

ENV PATH="${PATH}:/usr/local/go/bin:/root/go/bin"

WORKDIR /root/go/src/lxc
RUN git clone https://github.com/lxc/distrobuilder && \
    cd distrobuilder && \
    git checkout distrobuilder-3.0 && \
    make && \
    cd /root && \
    rm -Rf /root/go/src/lxc


FROM debian:bookworm as Runner

RUN apt update && \
    apt install --no-install-recommends -y debootstrap rsync gpg squashfs-tools xz-utils  && \
    apt clean

COPY --from=Builder /root/go/bin/distrobuilder /usr/bin/distrobuilder

WORKDIR /root