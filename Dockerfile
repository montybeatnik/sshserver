FROM golang:1.18

LABEL maintainer="Chris Hern<gopher-network-engineer@gmail.com>"

WORKDIR /go/src/github.com/gopher-network-engineer/ssh/server

ARG GITHUB_LOGIN
ARG GITHUB_TOKEN
ARG GOPRIVATE

RUN apk add --no-cache git \
    ca-certificates &&  \
    git config --global url."https://${GITHUB_TOKEN}:x-oauth-basic@github.com/".insteadOf "https://github.com/"

# copy dependency mgmt files from host to container
COPY go.mod go.sum ./

# grab depdendencies
RUN go mod download

# copy everything in the CWD of host to CWD of container
COPY . .

# ###########################################################
#                                                           #
#               UN/COMMENT BELOW FOR BINARY                 #
#                                                           #
# ###########################################################
# Build the executable to `/net_infra`. Mark the build as statically linked.
# WORKDIR /go/src/github.com/atni/sage/cmd/web
# COPY tls/self/ /tls/self/

# RUN CGO_ENABLED=0 go build \
#     -installsuffix 'static' \
#     -o /sage .

# WORKDIR /
# RUN rm -rf /go

EXPOSE 2022
ENTRYPOINT [ "go", "run", "main.go" ]
