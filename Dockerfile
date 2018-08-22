ARG arch
FROM multiarch/debian-debootstrap:${arch}-stretch

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install git wget tar build-essential

ARG arch
ARG go_arch
ARG checkout
ARG go_version=1.10

#Install golang
RUN wget -O -  "https://golang.org/dl/go${go_version}.linux-${go_arch}.tar.gz" | tar xzC /usr/local
ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

# Install registry
RUN git clone https://github.com/docker/distribution.git -b ${checkout} /go/src/github.com/docker/distribution &&\
    cd /go/src/github.com/docker/distribution/ &&\
    go get &&\
    make PREFIX=/go clean binaries &&\
    mkdir -p /etc/docker/registry &&\
    cp bin/* /usr/local/bin/ &&\
    cp cmd/registry/config-dev.yml /etc/docker/registry/config.yml &&\
    cd / && rm -fr /go/src

EXPOSE 5000
ENTRYPOINT ["registry"]
CMD ["serve", "/etc/docker/registry/config.yml"]