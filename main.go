package main

import "fmt"

func Sum(i, j int) int {
	return i + j
}

func main() {
	a := Sum(10, 20)
	fmt.Printf("this is sum [%d]\n", a)
}
