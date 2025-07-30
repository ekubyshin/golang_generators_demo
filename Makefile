LOCAL_BIN := $(CURDIR)/bin

GOENV:=GOPRIVATE="gitlab.ae-rus.net/*"

GOLANGCI_BIN=$(LOCAL_BIN)/golangci-lint
GOLANGCI_TAG=v2.3.0
$(GOLANGCI_BIN):
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(LOCAL_BIN) $(GOLANGCI_TAG)

GOOSE_BIN=$(LOCAL_BIN)/goose
$(GOOSE_BIN):
	GOBIN=$(LOCAL_BIN) go install github.com/pressly/goose/v3/cmd/goose@latest

EASY_JSON=$(LOCAL_BIN)/easyjson
$(EASY_JSON):
	GOBIN=$(LOCAL_BIN) go install github.com/mailru/easyjson/...@latest

MOCKGEN_BIN=$(LOCAL_BIN)/mockgen
$(MOCKGEN_BIN):
	GOBIN=$(LOCAL_BIN) go install go.uber.org/mock/mockgen@latest

.PHONY: db-create
db-create: $(GOOSE_BIN)
	goose -dir db/migrations create $(NAME) sql

.PHONY: easyjson
easyjson: $(EASY_JSON)
	$(EASY_JSON) models/models.go

.PHONY: mockgen
mockgen: $(MOCKGEN_BIN)
	$(MOCKGEN_BIN) -source=domain/repository.go -destination=../mocks/repository_mock.go -package=domain

.PHONY: db-up
db-up: $(GOOSE_BIN)
	goose -dir db/migrations up

.PHONY: lint
lint: $(GOLANGCI_BIN)
	$(GOLANGCI_BIN) run --fix ./...

.PHONY: test
test:
	go test -v -cover ./...

.PHONY: test-update
test-update:
	go test ./... -update

SQLC_BIN=$(LOCAL_BIN)/sqlc
$(SQLC_BIN):
	GOBIN=$(LOCAL_BIN) go install github.com/sqlc-dev/sqlc/cmd/sqlc

.PHONY: sql-format
sql-format:
	pg_format -i sqlc/*.sql

.PHONY: sqlc
sqlc: $(SQLC_BIN) sql-format
	rm -f sqlc/*.go
	$(SQLC_BIN) generate