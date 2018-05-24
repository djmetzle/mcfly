FROM alpine

MAINTAINER daryl@ifixit.com

ADD . /opt/mcfly

RUN apk add --no-cache ruby ruby-dev \
      build-base \
      ruby-bundler \
      zlib zlib-dev \
      libmemcached-libs libmemcached-dev \
      cyrus-sasl cyrus-sasl-dev \
   \
   && mkdir -p /var/spool/mcrouter \
   && cd /opt/mcfly \
   && bundle install --without test \
   \
   && apk del build-base \
      ruby-dev \
   && rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

ENTRYPOINT ["/opt/mcfly/mcfly"]
CMD ["/var/spool/mcrouter"]
