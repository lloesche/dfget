FROM golang:1.9 as builder
COPY musl.patch /root/
WORKDIR /root
RUN apt-get update \
    && apt-get -y install musl musl-dev musl-tools patch \
    && git clone https://github.com/alibaba/Dragonfly.git \
    && cd Dragonfly \
    && patch -p1 < ../musl.patch \
    && cd build \
    && ./build.sh client

FROM alpine
COPY --from=builder /root/.dragonfly/df-client/dfget-go /usr/local/bin/dfget
ENTRYPOINT ["/usr/local/bin/dfget"]
