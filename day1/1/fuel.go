package main

import (
	"fmt"
	"io/ioutil"
	"strings"
)

func main() {
	file := "FuelRequirement.txt"
	data := data(file)
	var sum int

	// Make the math
	for _, v := range data {
		v = v/3 - 2
		sum += v
	}

	// Print the answer
	fmt.Printf("The answer is %d", sum)
}

// Get the data turn it into an []int
func data(file string) []int {
	var val int
	var value []int
	data, _ := ioutil.ReadFile(file)
	array := strings.SplitAfter(string(data), "\n")

	// Parse the []string as an []int
	for _, v := range array {
		fmt.Sscanf(v, "%d", &val)
		value = append(value, val)
	}
	return value
}
