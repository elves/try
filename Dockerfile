FROM golang:alpine as builder
RUN apk update && \
    apk add --virtual build-deps make git
# Build Elvish
RUN go get -d github.com/elves/elvish && \
    make -C /go/src/github.com/elves/elvish get
# Build gotty
RUN go get github.com/yudai/gotty

FROM alpine

RUN addgroup elves
RUN apk update && apk add tmux man man-pages vim curl git bash

COPY --from=builder /go/bin/elvish /bin/elvish
COPY --from=builder /go/bin/gotty /bin/gotty

RUN mkdir /app
COPY run.bash /root/run.bash
COPY gotty.conf /root/.gotty
COPY notice /etc/notice

WORKDIR /root
EXPOSE 80

CMD ["/bin/gotty", "./run.bash"]
