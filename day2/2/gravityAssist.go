package main

import (
	"fmt"
	"io/ioutil"
	"strings"
)

func main() {
	file := "../1/instructions.txt"
	givenResult := 19690720
	var verb, noun, result int

	// Make the program test each answer until it finds one that fits
	for result != givenResult && verb <= 99 && noun <= 99 {
		result = compute(data(file), noun, verb)
		if result == givenResult {
			fmt.Printf("Houston, the result are :\nnoun = %d,\nverb = %d,\nanswer = %d", noun, verb, 100*noun+verb)
		}
		noun++
		if result > givenResult {
			noun -= 2
			verb++
		}
	}
	if result > givenResult {
		fmt.Print("We got an error Houston\n")
	}
}

func compute(data []int, noun int, verb int) int {
	data[1] = noun
	data[2] = verb

	// Check the opcode and make the operation
	for i := 0; i <= len(data); i += 4 {
		switch {
		case data[i] == 1:
			data[data[i+3]] = data[data[i+1]] + data[data[i+2]]
		case data[i] == 2:
			data[data[i+3]] = data[data[i+1]] * data[data[i+2]]
		case data[i] == 99:
			i = len(data)
		}
	}
	return data[0]
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
