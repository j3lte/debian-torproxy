FROM debian:bookworm

LABEL maintainer="Jelte Lagendijk <jwlagendijk@gmail.com>"

RUN apt-get update && apt-get install -y \
  tor \
  haproxy \
  privoxy \
  obfs4proxy \
  ruby \
  ruby-dev \
  ruby-bundler \
  ruby-nokogiri \
  ruby-socksify \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD templates/torrc.erb       /usr/local/etc/torrc.erb
ADD templates/haproxy.cfg.erb /usr/local/etc/haproxy.cfg.erb
ADD templates/privoxy.cfg.erb /usr/local/etc/privoxy.cfg.erb

ADD scripts/start.rb /usr/local/bin/start.rb
RUN chmod +x /usr/local/bin/start.rb

EXPOSE 2090 8118 5566

CMD ruby /usr/local/bin/start.rb
