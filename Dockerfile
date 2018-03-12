FROM node:8

ENV SCRIPT_DIR='/usr/local/bin'
ENV TURNOUT='/usr/local/turnout/mirakurun'
ENV CONF_DIR='/usr/local/etc/mirakurun'

COPY service $SCRIPT_DIR

RUN set -eux && \
    apt-get update && \
    apt-get install -y \
      build-essential autoconf automake cmake pkg-config \
      pcscd libpcsclite-dev pcsc-tools vim-tiny && \
    # pm2
    npm install pm2 -g && \
    # mirakurun
    npm install mirakurun -g --unsafe --production && \
    mkdir -p $TURNOUT && \
    mv $CONF_DIR/* $TURNOUT && \
    \
    # libarib25
    cd /tmp && \
    git clone https://github.com/stz2012/libarib25.git && \
    cd libarib25 && \
    cmake .  && make && make install && cd .. && \
    # recdvb
    git clone https://github.com/k-pi/recdvb.git && \
    cd recdvb && \
    sh ./autogen.sh && ./configure --enable-b25 && make && make install && \
    cd .. \
    # clean
    apt-get autoremove -y && apt-get clean && \
    rm -rf /tmp/* ~/.npm

EXPOSE 40772

CMD ["service"]
