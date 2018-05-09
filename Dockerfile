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

ENV XMR_STAK_VERSION 2.4.3

RUN    git clone https://github.com/fireice-uk/xmr-stak.git \
    && cd xmr-stak \
    && git checkout -b build ${XMR_STAK_VERSION} \
    && sed -i 's/constexpr double fDevDonationLevel.*/constexpr double fDevDonationLevel = 0.0;/' xmrstak/donate-level.hpp \
    && cmake -DCMAKE_LINK_STATIC=ON -DCUDA_ENABLE=OFF -DOpenCL_ENABLE=OFF . \
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

COPY --from=build /usr/local/src/xmr-stak/bin/* /usr/local/bin/*
COPY configs/* ./
COPY start.sh ./

CMD ["bash", "start.sh"]
