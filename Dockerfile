FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

COPY /survex_1.2.40-1.999disco+1_amd64.deb \
     /survex-aven_1.2.40-1.999disco+1_amd64.deb /

RUN apt-get update && \
    apt-get install -y zip survex survex-aven && \
    apt-get install -y binutils xz-utils && \
    true

RUN mkdir /surv && \
    cd /surv && \
    ar x /survex_1.2.40-1.999disco+1_amd64.deb && \
    tar xJf data.tar.xz && \
    ar x /survex-aven_1.2.40-1.999disco+1_amd64.deb && \
    tar xJf data.tar.xz && \
    ln -s /usr/lib/x86_64-linux-gnu/libproj.so.12 /usr/lib/x86_64-linux-gnu/libproj.so.13 && \
    true

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
