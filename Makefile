

.PHONY: lint has-coffeelint

has-coffeelint:
	which coffeelint || npm install -g coffeelint

lint: has-coffeelint
	coffeelint -f dist/coffeelint.json src/lib/*

.git/hooks: .git/hooks/pre-commit

.git/hooks/%: dist/%.sh
	ln -sf ../../$< $@
