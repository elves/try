# Build Elvish and gotty in a separate builder image
FROM golang:1.19.0-alpine3.16 as builder
RUN apk update && \
    apk add --virtual build-deps make git
RUN export CGO_ENABLED=0 && \
    go install src.elv.sh/cmd/elvish@v0.18.0 && \
    go install github.com/sorenisanerd/gotty@v1.4.0

# Runtime image
FROM alpine:3.16

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
