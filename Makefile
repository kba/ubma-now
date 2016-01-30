VERSION = $(shell grep version package.json | grep -oE '[0-9\.]+')
PKGNAME = $(shell grep name package.json |/bin/grep -o '[^"]*",'|/bin/grep -o '[^",]*')

COFFEE = coffee -c -b

CP = cp -r
RM = rm -rf
MKDIR = mkdir -p

COFFEE_TARGETS = $(shell find src -type f -name "*.coffee"|sed 's,src/,,'|sed 's,\.coffee,\.js,')

.PHONY: lint has-coffeelint coffee start

coffee: ${COFFEE_TARGETS}

lib/%.js : src/lib/%.coffee
	@$(MKDIR) $(@D)
	$(COFFEE) -o "$(@D)" "$<"

test/%.js : src/test/%.coffee
	@$(MKDIR) $(@D)
	$(COFFEE) -o "$(@D)" "$<"

public/js/%.js : src/public/js/%.coffee
	@$(MKDIR) $(@D)
	$(COFFEE) -o "$(@D)" "$<"

clean : 
	$(RM) lib test public/js

start: coffee
	coffee src/lib/server.coffee

has-coffeelint:
	which coffeelint || npm install -g coffeelint

lint: has-coffeelint
	coffeelint -f dist/coffeelint.json src/*

.git/hooks: .git/hooks/pre-commit

.git/hooks/%: dist/%.sh
	ln -sf ../../$< $@
