prefix ?= /usr/local
bindir = $(prefix)/bin

build:
	swift build -c release --disable-sandbox

install: build
	install -d "$(bindir)"
	install ".build/release/dark-mode-notify" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/dark-mode-notify"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
