FROM python:alpine
LABEL name='scrapyd' tag='python-alpine' maintainer='RockYuan <RockYuan@gmail>'

ENV BUILD_DEPS \
    autoconf \
    libtool \
    libxml2-dev \
    libxslt-dev \
    tiff-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    lcms2-dev \
    libwebp-dev \
    bzip2-dev \
    coreutils \
    dpkg-dev dpkg \
    expat-dev \
    findutils \
    gcc \
    musl-dev \
    libgcc \
    gdbm-dev \
    libc-dev \
    libffi-dev \
    libnsl-dev \
    # openssl-dev \
    libressl-dev \
    libtirpc-dev \
    linux-headers \
    make \
    ncurses-dev \
    pax-utils \
    readline-dev \
    sqlite-dev \
    tcl-dev \
    tk \
    tk-dev \
    util-linux-dev \
    xz-dev \
    zlib-dev \
    tzdata

ENV RUN_DEPS \
    curl \
    git \
    libxml2 \
    libxslt \
    tiff \
    libjpeg-turbo \
    lcms2 \
    libwebp \
    zlib \
    bash \
    vim

RUN set -xe \
    && apk update \
    && apk add --no-cache --virtual .build-deps \
        ${BUILD_DEPS} \
    && apk add --no-cache --virtual .run-deps \
        ${RUN_DEPS} \
    && pip install git+https://github.com/scrapy/scrapy.git \
        git+https://github.com/scrapy/scrapyd.git \
        git+https://github.com/scrapy/scrapyd-client.git \
        git+https://github.com/scrapinghub/scrapy-splash.git \
        git+https://github.com/scrapinghub/scrapyrt.git \
        git+https://github.com/python-pillow/Pillow.git \
    # && curl -sSL https://github.com/scrapy/scrapy/raw/master/extras/scrapy_bash_completion -o /etc/profile.d/scrapy_bash_completion.sh \
    && cp /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime \
    && echo "Asia/Hong_Kong" >  /etc/timezone \
    && apk del .build-deps \
    && rm -rf /tmp/* \
    && mkdir -p /data

COPY config/scrapyd.conf /etc/scrapyd/
# 根据系统环境变量修改命令行提示
COPY config/env_prompt.sh /etc/profile.d/env_prompt.sh
ENV ENV="/etc/profile"
VOLUME /etc/scrapyd/ /var/lib/scrapyd/

ONBUILD ADD ./*.txt /etc/scrapyd/
ONBUILD RUN cd /etc/scrapyd; \
    [ -f packages.txt -o -f dependencies.txt ] && apk update; \
    [ -f packages.txt ] && xargs -r apk add --no-cache < packages.txt; \
    [ -f dependencies.txt ] && xargs -r apk add --no-cache < dependencies.txt; \
    [ -f requirements.txt ] && pip install -r requirements.txt; \
    [ -f dependencies.txt ] && xargs -r apk del < dependencies.txt; \
    [ -f packages.txt -o -f dependencies.txt ] && rm -rf /tmp/*

WORKDIR /data
EXPOSE 6800

CMD ["scrapyd"]