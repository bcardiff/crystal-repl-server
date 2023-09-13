CRYSTAL ?= crystal

CRYSTAL_CONFIG_PATH=$(shell $(CRYSTAL) env CRYSTAL_PATH 2> /dev/null)
CRYSTAL_CONFIG_LIBRARY_PATH=$(shell $(CRYSTAL) env CRYSTAL_LIBRARY_PATH 2> /dev/null)

EXPORTS := \
  CRYSTAL_CONFIG_PATH="$(CRYSTAL_CONFIG_PATH)" \
  CRYSTAL_CONFIG_LIBRARY_PATH="$(CRYSTAL_CONFIG_LIBRARY_PATH)"

SHELL = sh

BINDIR = ./bin

$(BINDIR)/crystal-repl-server: src/server/*.cr src/common/*.cr
	mkdir -p $(BINDIR)
	$(EXPORTS) $(CRYSTAL) build $(FLAGS) src/server/cli.cr -o $(BINDIR)/crystal-repl-server

$(BINDIR)/system_spec: src/**/*.cr spec/system/*.cr
	mkdir -p $(BINDIR)
	$(CRYSTAL) build $(FLAGS) spec/system/*_spec.cr -o $(BINDIR)/system_spec

.PHONY: system_spec
system_spec: $(BINDIR)/system_spec
	$(BINDIR)/system_spec

.PHONY: all
all: $(BINDIR)/crystal-repl-server system_spec

clean:
	rm -f bin/*
