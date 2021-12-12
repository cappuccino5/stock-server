GIT_BRANCH := $(shell git branch --show-current)
GIT_COMMIT = $(shell git rev-parse --short HEAD)
GIT_TAG=$(strip $(shell git describe --tags --abbrev=0))
BINARY_VERSION=$(GIT_BRANCH)-$(GIT_COMMIT)
BUILD_TIME=$(shell date "+%Y/%m/%d-%H:%M:%S")

ifeq ($(findstring $(GIT_BRANCH),$(GIT_TAG)),)
	IMAGE_VERSION=$(GIT_BRANCH)
	BINARY_VERSION=$(GIT_BRANCH)
else
	IMAGE_VERSION=$(GIT_TAG)
	BINARY_VERSION=$(GIT_TAG)
endif
SERVICE_NAME="stock-server"

build:
	GONOSUMDB="github.com" GOPROXY=goproxy.io,direct GOPRIVATE='github.com*' go mod tidy -compat=1.17
	GONOSUMDB="github.com" GOPROXY=goproxy.io,direct GOPRIVATE='github.com*' CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-s -w -X main.Version=$(BINARY_VERSION) -X main.GitVersion=$(GIT_COMMIT) -X main.BuildTime=$(BUILD_TIME) -X main.ServiceName=$(SERVICE_NAME)" -o stock-server cmd/stock-server/main.go

image_amd64: build
	#docker buildx build --platform linux/amd64 -t registry.cn-sz.aliyuncs.com/xxx/stock-server:$(IMAGE_VERSION) --push .
	rm -f stock-server

