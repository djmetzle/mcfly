FROM alpine

MAINTAINER daryl@ifixit.com

ADD . /opt/mcfly

RUN apk add --no-cache ruby ruby-dev \
      build-base \
      ruby-bundler \
      zlib zlib-dev \
      libmemcached-libs libmemcached-dev \
      cyrus-sasl cyrus-sasl-dev \
      ngrep \
      tcpdump \
      wget \
      perl \
      bash \
      socat \
      rsync \
   \
   && mkdir -p /var/spool/mcrouter \
   && cd /opt/mcfly \
   && bundle install --without test \
   \
   && apk del build-base \
      ruby-dev \
   && wget https://raw.githubusercontent.com/memcached/memcached/master/scripts/memcached-tool -O /usr/bin/memcached-tool \
   && chmod a+x /usr/bin/memcached-tool \
   && rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

ENTRYPOINT ["/opt/mcfly/mcfly"]
CMD ["/var/spool/mcrouter"]
