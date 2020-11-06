GOBIN = ./build/bin
GO ?= latest
GORUN = env GO111MODULE=on go run

gpt:
	$(GORUN) build/ci.go install ./cmd/gpt
	@echo "Done building."
	@echo "Run \"$(GOBIN)/gpt\" to launch gpt."

all:
	$(GORUN) build/ci.go install
