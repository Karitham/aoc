package main

import (
	"fmt"
	"io/ioutil"
	"strings"
)

func main() {
	// get the data from the function
	data := data()

	// Change the first 2 values according to the text
	data[1] = 12
	data[2] = 2

	// Loop through the operations
	for i := 0; i <= len(data); i += 4 {
		// Create pointers to places of the array to simplify operations
		p := &data[0]
		operand := &data[i]
		input1 := &data[data[i+1]]
		input2 := &data[data[i+2]]
		storage := &data[data[i+3]]

		// Check the operand and make the operation
		switch {
		case *operand == 1:
			*storage = *input1 + *input2
		case *operand == 2:
			*storage = *input1 * *input2
		case *operand == 99:
			fmt.Printf("Value on index 0 is %d\n", *p)
			i = len(data)
		}
	}
}

func data() []int {
	// Init variables
	var value []int
	var val int

	// Read File
	data, _ := ioutil.ReadFile("instructions.txt")
	array := strings.SplitAfter(string(data), ",")

	// Parse array to []int
	for _, v := range array {
		fmt.Sscanf(v, "%d,", &val)
		value = append(value, val)
	}
	return value
}
