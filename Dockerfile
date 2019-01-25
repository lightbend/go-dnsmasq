FROM golang:1.11 as build

ADD . /src
WORKDIR /src
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix static

FROM scratch
MAINTAINER Lightbend Monitoring Team <es-monitoring@lightbend.com>

COPY --from=build /src/go-dnsmasq /go-dnsmasq

ENV DNSMASQ_LISTEN=0.0.0.0
EXPOSE 53 53/udp
ENTRYPOINT ["/go-dnsmasq"]
