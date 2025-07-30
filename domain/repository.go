package domain

//go:generate mockgen -source=repository.go -destination=../mocks/repository_mock.go -package=mocks
type UserRepository interface {
	GetUser(string) (string, error)
	ListUsers() ([]string, error)
}
