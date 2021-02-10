FROM golang:alpine as builder
RUN apk update && \
    apk add --virtual build-deps make git
# Build Elvish
RUN mkdir -p /data/elvish && \
    cd /data/elvish && \
    git clone --depth 1 --branch v0.15.0 https://github.com/elves/elvish . && \
    CGO_ENABLED=0 ELVISH_REPRODUCIBLE=release make get
# Build gotty
RUN go get github.com/yudai/gotty

FROM alpine

RUN addgroup elves
# Useful packages for users of try.elv.sh
RUN apk update && apk add tmux mandoc man-pages vim curl git bash

COPY --from=builder /go/bin/elvish /bin/elvish
COPY --from=builder /go/bin/gotty /bin/gotty

RUN mkdir /app
COPY run.bash /root/run.bash
COPY gotty.conf /root/.gotty
COPY notice /etc/notice

WORKDIR /root
EXPOSE 80

CMD ["/bin/gotty", "./run.bash"]
