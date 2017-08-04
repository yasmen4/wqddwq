###
# Build image
###
FROM resin/intel-nuc-alpine:edge AS build

WORKDIR /usr/local/src

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> //etc/apk/repositories
RUN apk add --no-cache \
      libmicrohttpd-dev \
      openssl-dev \
      hwloc-dev@testing \
      build-base\
      cmake \
      coreutils \
      git

ENV XMR_STAK_CPU_VERSION v1.3.0-1.5.0

RUN    git clone https://github.com/fireice-uk/xmr-stak-cpu.git \
    && cd xmr-stak-cpu \
    && git checkout -b build ${XMR_STAK_CPU_VERSION} \
    && sed -i 's/constexpr double fDevDonationLevel.*/constexpr double fDevDonationLevel = 0.0;/' donate-level.h \
    && cmake -DCMAKE_LINK_STATIC=ON . \
    && make -j$(nproc)

###
# Deployed image
###
FROM resin/intel-nuc-alpine:edge

WORKDIR /usr/src/app

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> //etc/apk/repositories
RUN apk add --no-cache \
      libmicrohttpd \
      openssl \
      hwloc@testing \
      coreutils

COPY --from=build /usr/local/src/xmr-stak-cpu/bin/xmr-stak-cpu /usr/local/bin/xmr-stak-cpu
COPY config.txt ./
COPY start.sh ./

CMD ["bash", "start.sh"]
