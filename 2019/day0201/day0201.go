package main

import (
	"fmt"
	"io/ioutil"
	"strings"
)

func main() {
	file := "../inputs/day2.txt"
	data := data(file)
	data[1] = 12
	data[2] = 2

	for i := 0; i <= len(data); i += 4 {
		// Create pointers to places of the array to simplify operations
		p := &data[0]
		opcode := &data[i]
		param1 := &data[data[i+1]]
		param2 := &data[data[i+2]]
		storage := &data[data[i+3]]

		// Check the opcode and make the operation
		switch {
		case *opcode == 1:
			*storage = *param1 + *param2
		case *opcode == 2:
			*storage = *param1 * *param2
		case *opcode == 99:
			fmt.Printf("Value on index 0 is %d\n", *p)
			i = len(data)
		}
	}
}

func data(file string) []int {
	var value []int
	var val int
	data, _ := ioutil.ReadFile(file)
	array := strings.SplitAfter(string(data), ",")

	// Parse array to []int
	for _, v := range array {
		fmt.Sscanf(v, "%d,", &val)
		value = append(value, val)
	}
	return value
}
