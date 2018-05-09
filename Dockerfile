FROM resin/intel-nuc-alpine:edge-20180501

WORKDIR /usr/src/app

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
    && cmake -DCUDA_ENABLE=OFF -DOpenCL_ENABLE=OFF -DCMAKE_CXX_FLAGS="-mno-avx" . \
    && make -j$(nproc) \
    && cp bin/xmr-stak /usr/local/bin/

COPY configs/* ./
COPY start.sh ./

RUN apk add --no-cache strace gdb
#RUN cat /proc/cpuinfo

CMD ["bash", "start.sh"]
