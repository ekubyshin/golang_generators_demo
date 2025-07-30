package tests

import (
	"testing"

	"github.com/ekubyshin/db_demo/mocks"
	"go.uber.org/mock/gomock"
)

func TestFoo(t *testing.T) {
	ctrl := gomock.NewController(t)

	m := mocks.NewMockUserRepository(ctrl)

	// Asserts that the first and only call to Bar() is passed 99.
	// Anything else will fail.
	m.
		EXPECT().
		GetUser(gomock.Any()).
		Return("test", nil)

	m.GetUser("test")
}
