FROM python:alpine
LABEL name='scrapyd' tag='python-alpine' maintainer='RockYuan <RockYuan@gmail>'

ENV BUILD_DEPS \
    autoconf \
    # build-essential \
    # libffi-dev \
    # libssl-dev \
    libtool \
    libxml2-dev \
    # libxslt1-dev \
    libxslt-dev \
    # libtiff5-dev \
    tiff-dev \
    # libfreetype6-dev \
    freetype-dev \
    # libjpeg62-turbo-dev \
    libjpeg-turbo-dev \
    # liblcms2-dev \
    lcms2-dev \
    libwebp-dev \
    # zlib1g-dev \
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
    py3-libxml2 \
    libxslt \
    py2-libxslt \
    # libxslt1.1 \
    # libtiff5 \
    tiff \
    # libjpeg62-turbo \
    libjpeg-turbo \
    # liblcms2-2 \
    lcms2 \
    libwebp \
    # zlib1g \
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
WORKDIR /data
EXPOSE 6800

CMD ["scrapyd"]