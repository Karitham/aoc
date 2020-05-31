package main

import (
	"fmt"
	"io/ioutil"
	"strings"
)

func main() {
	var fuelsize, sum int
	sum = fuelsize
	data := data()
	for _, v := range data {
		fuelsize = v
		fmt.Println(v)
		for fuelsize > 0 {
			fuelsize = math(fuelsize)
			fmt.Println(fuelsize)
			sum = sum + fuelsize
		}
	}
	fmt.Println(sum)
}

func math(x int) int {
	x = x/3 - 2
	if x > 0 {
		return x
	}
	return 0
}

func data() []int {
	data, _ := ioutil.ReadFile("../1/FuelRequirement.txt")
	array := strings.SplitAfter(string(data), "\n")
	var val int
	var value []int
	for _, v := range array {
		fmt.Sscanf(v, "%d", &val)
		value = append(value, val)
	}
	return value
}
