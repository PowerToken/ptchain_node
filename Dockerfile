# Build Geth in a stock Go builder container
FROM golang:1.15-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

ADD . /thundercore
RUN cd /thundercore && make gpt

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /thundercore/build/bin/gpt /usr/local/bin/

EXPOSE 10444 10445 8547 10443 10443/udp
ENTRYPOINT ["gpt"]
