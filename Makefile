ligo_compiler?=ligo
# ^ Override this variable when you run make command by make <COMMAND> ligo_compiler=<LIGO_EXECUTABLE>
# ^ Otherwise use default one (you'll need docker)
image=oxheadalpha/flextesa:20230901
script=nairobibox
PROJECTROOT_OPT=--project-root .
protocol_opt?=
JSON_OPT?=--michelson-format json
tsc=npx tsc
help:
	@echo  'Usage:'
	@echo  '  all             - Remove generated Michelson files, recompile smart contracts and lauch all tests'
	@echo  '  clean           - Remove generated Michelson files'
	@echo  '  compile         - Compiles smart contract Factory'
	@echo  '  test            - Run integration tests (written in Ligo)'
	@echo  '  deploy          - Deploy smart contracts advisor & indice (typescript using Taquito)'
	@echo  ''

all: clean compile test

compile: fa2_nft.tz factory 

factory: factory.tz factory.json

factory.tz: src/main.jsligo
	@echo "Compiling smart contract to Michelson"
	@mkdir -p compiled
	@$(ligo_compiler) compile contract $^ -e main $(protocol_opt) $(PROJECTROOT_OPT) > compiled/$@

factory.json: src/main.jsligo
	@echo "Compiling smart contract to Michelson in JSON format"
	@mkdir -p compiled
	@$(ligo_compiler) compile contract $^ $(JSON_OPT) -e main $(protocol_opt) $(PROJECTROOT_OPT) > compiled/$@

fa2_nft.tz: src/generic_fa2/core/NFT.mligo
	@echo "Compiling smart contract FA2 to Michelson"
	@mkdir -p src/generic_fa2/compiled
	@$(ligo_compiler) compile contract $^ -e main $(protocol_opt) $(PROJECTROOT_OPT) > src/generic_fa2/compiled/$@

clean: clean_contracts clean_fa2 clean_marketplace

clean_contracts:
	@echo "Removing Michelson files"
	@rm -f compiled/*.tz compiled/*.json

clean_fa2:
	@echo "Removing FA2 Michelson file"
	@rm -f src/generic_fa2/compiled/*.tz

test: test_ligo 

test_ligo: test/test.jsligo
	@echo "Running integration tests"
	@$(ligo_compiler) run test $^ $(protocol_opt) $(PROJECTROOT_OPT)


deploy: node_modules deploy.js

deploy.js:
	@if [ ! -f ./deploy/metadata.json ]; then cp deploy/metadata.json.dist deploy/metadata.json ; fi
	@echo "Running deploy script\n"
	@cd deploy && npm start

node_modules:
	@echo "Installing deploy script dependencies"
	@cd deploy && npm install
	@echo ""

sandbox-start:
	@docker run --rm --name flextesa-sandbox \
		--detach -p 20000:20000 \
		-e block_time=3 \
		-e flextesa_node_cors_origin='*' \
		$(image) $(script) start

sandbox-stop:
	@docker stop flextesa-sandbox

sandbox-exec:
	@docker exec flextesa-sandbox octez-client get balance for alice

sandbox-deploy: node_modules sandbox-deploy.js

sandbox-deploy.js:
	@if [ ! -f ./deploy/metadata.json ]; then cp deploy/metadata.json.dist deploy/metadata.json ; fi
	@echo "Running deploy script\n"
	@cd deploy && npm run sandbox
