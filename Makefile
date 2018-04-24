all: setup build test lint

.PHONY: setup
setup: src/Client.hs
	stack setup
	stack build \
	  --dependencies-only --test --no-run-tests
	stack install hlint weeder

.PHONY: build
build:
	stack build \
	  --coverage \
	  --fast --pedantic --test --no-run-tests

.PHONY: test
test:
	stack build \
	  --coverage \
	  --fast --pedantic --test

.PHONY: lint
lint:
	hlint .
	weeder .

.PHONY: clean
clean:
	stack clean

.PHONY: install
install: src/Client.hs
	stack install

src/Client.hs:
	[ -n "$(CLIENT_ID)" ]
	[ -n "$(CLIENT_SECRET)" ]
	echo "module Client where" > src/Client.hs
	echo "clientId, clientSecret :: String" >> src/Client.hs
	printf 'clientId = "%s"\n' "$(CLIENT_ID)" >> src/Client.hs
	printf 'clientSecret = "%s"\n' "$(CLIENT_SECRET)" >> src/Client.hs
