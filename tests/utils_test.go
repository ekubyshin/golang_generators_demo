package tests

import (
	"testing"
)

func Test_testSome(t *testing.T) {
	type args struct {
		s string
	}
	tests := []struct {
		name string
		args args
		want bool
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := testSome(tt.args.s); got != tt.want {
				t.Errorf("testSome() = %v, want %v", got, tt.want)
			}
		})
	}
}
