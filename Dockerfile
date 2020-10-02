FROM golang:1.13.8-alpine as builder

RUN apk add --update --no-cache make git gcc libc-dev && \
    go get github.com/golang/dep                      && \
    go install github.com/golang/dep/cmd/dep

WORKDIR /go/src/github.com/openshift/snapshot-operator

COPY Gopkg.toml Gopkg.lock /go/src/github.com/openshift/snapshot-operator/

RUN dep ensure -v -vendor-only

COPY . /go/src/github.com/openshift/snapshot-operator

RUN make

FROM scratch

COPY --from=builder \
     /go/src/github.com/openshift/snapshot-operator/_output/bin/snapshot-operator \
     /snapshot-operator

ENTRYPOINT ["/snapshot-operator"]
