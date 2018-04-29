package main

import (
	"fmt"
	"testing"
)

func TestCSum(T *testing.T) {
	a := Sum(2, 5)
	if a != 7 {
		fmt.Printf("test failed")
	} else {
		fmt.Printf("test success")
	}
}
