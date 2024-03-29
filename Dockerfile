# Copyright 2019 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# STEP 1: Build webserver binary
ARG GOARCH="amd64"
FROM golang:1.12.5 AS builder
# golang envs
ARG GOARCH
ARG GOOS=linux
ENV CGO_ENABLED=0
ENV GO111MODULE="on"
ENV GOPROXY=https://proxy.golang.org
# copy in sources
WORKDIR /src
COPY . .
# build
RUN go build -o /go/bin/go-webserver .

# STEP 2: Build small image
FROM alpine:3.7
COPY --from=builder /go/bin/go-webserver /bin/go-webserver
CMD ["/bin/go-webserver"]
