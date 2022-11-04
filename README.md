[![Docker Pulls](https://img.shields.io/docker/pulls/j3lte/debian-torproxy.svg)](https://hub.docker.com/r/j3lte/debian-torproxy/) [![Twitter Follow](https://img.shields.io/twitter/follow/j3lte.svg?style=social)](https://twitter.com/j3lte)

# j3lte/debian-torproxy

```
               Docker Container
               -------------------------------------
               (Optional)           <-> Tor Proxy 1
Client <---->   Privoxy <-> HAproxy <-> Tor Proxy 2
                                    <-> Tor Proxy n
```

## Based on

* [zet4/alpine-tor](https://github.com/zet4/alpine-tor)

## Why?

- Tor is a great tool to anonymize your traffic, but it's not a proxy.
- Lots of IP addresses. One single endpoint for your client.
- Load-balancing by HAproxy.
- Optionaly adds support for [Privoxy](https://www.privoxy.org/) using
`-e privoxy=1`, useful for http (default `8118`, changable via
`-e privoxy_port=<port>`) proxy forward and ad removal.

## Environment Variables

Variable | Type | Description | Default
--- | --- | --- | ---
`tors` | Integer | Number of tor instances to run | 20
`new_circuit_period` | Integer | NewCircuitPeriod parameter value in seconds | 120
`max_circuit_dirtiness` | Integer | MaxCircuitDirtiness parameter value in seconds | 600
`circuit_build_timeout` | Integer | CircuitBuildTimeout parameter value in seconds | 60
`privoxy` | Boolean | Set to run insance of privoxy in front of haproxy. | 0
`privoxy_port` | Integer | Port for privoxy | 8118
`privoxy_permit` | String | Space-separated list of source addresses for permit-access option. | *Unset*
`privoxy_deny` | String | Space-separated list of source addresses for deny-access option. | *Unset*
`haproxy_port` | Integer | Port for haproxy | 5566
`haproxy_stats` | Integer | Port for haproxy monitor. | 2090
`haproxy_login` and `haproxy_pass` | String | BasicAuth config for haproxy monitor | admin *(both)*
`test_url` | String | URL for health check throught Tor proxy. | http://google.com
`test_status` | Integer | HTTP status code for `test_url` in working case. | 302

## Usage

```bash
# build docker container
docker build -t j3lte/debian-torproxy:latest .

# ... or pull docker container
docker pull j3lte/debian-torproxy:latest

# start docker container
docker run -d -p 5566:5566 -p 2090:2090 -e tors=25 j3lte/debian-torproxy

# start docker with privoxy enabled and exposed
docker run -d -p 8118:8118 -p 2090:2090 -e tors=25 -e privoxy=1 j3lte/debian-torproxy

# test with ...
curl --socks5 localhost:5566 http://httpbin.org/ip

# or if privoxy enabled ...
curl --proxy localhost:8118 http://httpbin.org/ip

# or to run chromium with your new found proxy
chromium --proxy-server="http://localhost:8118" \
    --host-resolver-rules="MAP * 0.0.0.0 , EXCLUDE localhost"

# monitor
# auth login:admin
# auth pass:admin
http://localhost:2090 or http://admin:admin@localhost:2090

# start docket container with new auth
docker run -d -p 5566:5566 -p 2090:2090 -e haproxy_login=MySecureLogin \
    -e haproxy_pass=MySecurePassword j3lte/debian-torproxy
```

## Docker Compose

```yaml
version: "3.9"
services:
  torproxy:
    image: j3lte/debian-torproxy
    restart: unless-stopped
    ports:
      - "8118:8118"
      - "5566:5566"
      - "2090:2090"
    environment:
      tors: 25
      privoxy: 1
```

## Further Readings

 * [Tor Manual](https://www.torproject.org/docs/tor-manual.html.en)
 * [Tor Control](https://www.thesprawl.org/research/tor-control-protocol/)
 * [HAProxy Manual](http://cbonte.github.io/haproxy-dconv/index.html)
 * [Privoxy Manual](https://www.privoxy.org/user-manual/)

## License

MIT
