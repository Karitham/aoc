package main

import (
	"fmt"
	"io/ioutil"
	"strings"
)

func main() {
	file := "../inputs/day1.txt"
	var fuelsize, sum int
	sum = fuelsize
	data := data(file)

	// Recursively call the math function to calculate the fuel needed
	for _, v := range data {
		fuelsize = v
		for fuelsize > 0 {
			fuelsize = math(fuelsize)
			sum = sum + fuelsize
		}
	}

	// Print the answer
	fmt.Printf("The sum is %d", sum)
}

// Quick math
func math(x int) int {
	x = x/3 - 2
	if x > 0 {
		return x
	}
	return 0
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
