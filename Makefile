MKL_RED?=	\033[031m
MKL_GREEN?=	\033[032m
MKL_YELLOW?=	\033[033m
MKL_BLUE?=	\033[034m
MKL_CLR_RESET?=	\033[0m

BIN=      rb_forwarder
prefix?=  /usr/local
bindir?=	$(prefix)/bin

build:
	@printf "$(MKL_YELLOW)Building $(BIN)$(MKL_CLR_RESET)\n"
	go build -o $(BIN) ./cmd/app/

shared_lib:
	@printf "$(MKL_YELLOW)Building shared library$(MKL_CLR_RESET)\n"
	go build -buildmode=c-archive -o rbforwarder.a librbforwarder.go

install:
	@printf "$(MKL_YELLOW)Install $(BIN) to $(bindir)$(MKL_CLR_RESET)\n"
	install $(BIN) $(bindir)

uninstall:
	@printf "$(MKL_RED)Uninstall $(BIN) from $(bindir)$(MKL_CLR_RESET)\n"
	rm -f $(prefix)/$(BIN)

check: fmt errcheck vet
	@printf "$(MKL_GREEN)No errors found$(MKL_CLR_RESET)\n"

fmt:
	@if [ -n "$$(go fmt ./...)" ]; then echo 'Please run go fmt on your code.' && exit 1; fi

errcheck:
	@printf "$(MKL_YELLOW)Checking errors$(MKL_CLR_RESET)\n"
	errcheck -ignoretests -verbose ./...

vet:
	@printf "$(MKL_YELLOW)Runing go vet$(MKL_CLR_RESET)\n"
	go vet ./...

test:
	@printf "$(MKL_YELLOW)Runing tests$(MKL_CLR_RESET)\n"
	go test -cover ./...
	@printf "$(MKL_GREEN)Test passed$(MKL_CLR_RESET)\n"

coverage:
	@printf "$(MKL_YELLOW)Computing coverage$(MKL_CLR_RESET)\n"
	@overalls -covermode=set -project=github.com/redBorder/rbforwarder
	@go tool cover -func overalls.coverprofile
	@goveralls -coverprofile=overalls.coverprofile -service=travis-ci
	@rm -f overalls.coverprofile

get_dev:
	@printf "$(MKL_YELLOW)Installing deps$(MKL_CLR_RESET)\n"
	go get golang.org/x/tools/cmd/cover
	go get github.com/kisielk/errcheck
	go get github.com/stretchr/testify/assert
	go get github.com/mattn/goveralls
	go get github.com/axw/gocov/gocov
	go get github.com/go-playground/overalls

get:
	@printf "$(MKL_YELLOW)Installing deps$(MKL_CLR_RESET)\n"
	go get -t ./...
