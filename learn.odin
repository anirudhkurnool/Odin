#+feature dynamic-literals
package main

import "core:fmt"
import o "core:os" //o is a alias for os

PI :: 3.14 //constant

@(private) //cannot be accessed outside the package 
TEST_CONSTANT :: 1234

@(private = "file") // cannot be accessed outside the file 
TEST_CONSTANT_1 :: 2345

main :: proc() {
	fmt.println("Hello, World")
	fmt.println(add(1, 2))
	fmt.println(sub(3, 4))
	fmt.println(mul(2, 5))
	fmt.println(div(3, 5))
	//fmt.println(div(1, 0))

	//basic for loop in odin
	//odin doesn't have while, do-while loops 
	for i := 0; i < 10; i += 1 {
		fmt.println(i)
	}

	fmt.println("-------------------------------------")

	//the initial and post statements are optional 
	t := 3
	for t < 10 {
		fmt.println(t)
		t += 1
	}

	//all of the statements beside the for loop are optional 
	//to get a infinite for loop 
	for {
		fmt.println("infinity...")
		break
	}

	fmt.println("-----------------------------------------------------")

	//range based for loops 
	for i in 0 ..= 10 { 	//from 0 to 10 both inclusive 
		fmt.println(i)
	}

	fmt.println("-----------------------------------------------------")

	for i in 0 ..< 10 { 	//from 0 to 10 (10 not inclusive)
		fmt.println(i)
	}

	fmt.println("------------------------------------------------------")

	//using the for loop one can iterate over strings, arrays, maps, slices, dynamic arrays
	//The iterated values are copies and cannot be written to.
	//strings cannot be iterated using a reference as strings are immutable in odin 
	str: string = "Hello World"

	for i in str {
		fmt.println(i)
	}

	fmt.println("---------------------------------------------------------")

	//to iterate with the index 
	for char, index in str {
		fmt.println(index, char)
	}

	fmt.println("---------------------------------------------------------")

	//to iterate over a array 

	arr := [3]int{1, 2, 3}
	for i in arr {
		fmt.println(i)
	}

	fmt.println("---------------------------------------------------------")
	//to iterate with the index 

	for num, index in arr {
		fmt.println(index, num)
	}

	fmt.println("---------------------------------------------------------")

	//to iterate over slices 

	slc := []int{2, 4, 6}
	for i in slc {
		fmt.println(i)
	}

	fmt.println("---------------------------------------------------------")


	for num, index in slc {
		fmt.println(index, num)
	}

	fmt.println("---------------------------------------------------------")
	// to iterate over dynamic arrays 

	d_arr := [dynamic]int{3, 6, 9}
	defer delete(d_arr) // defers the execution of delete until the end of the scope
	for i in d_arr {
		fmt.println(i)
	}

	fmt.println("---------------------------------------------------------")


	for num, index in d_arr {
		fmt.println(index, num)
	}

	fmt.printfln("length of d_arr = %d", len(d_arr))
	fmt.printfln("capacity of d_arr = %d", cap(d_arr))

	fmt.println("---------------------------------------------------------")

	mp := map[string]int {
		"A" = 1,
		"B" = 2,
		"C" = 3,
	} //all maps are put on heap by default 
	//sp they have to be deleted manually
	defer delete(mp)

	fmt.println(mp)

	//to iterate over the keys of a map 

	for key in mp {
		fmt.println(key)
	}

	fmt.println("-----------------------------------------------------------")

	//to iterate over the key - value pairs of a map 

	for key, value in mp {
		fmt.println(key, value)
	}

	//key are immutable in a map while values are mutable and can be iterated over using a reference 

	for _, &value in mp {
		value += 1
	}

	fmt.println(mp)

	fmt.println(
		"------------------------------------------------------------------------------------",
	)

	//to iterate in the reverse direction use the #reverse directive 
	#reverse for i in arr {
		fmt.println(i)
	}

	//to unroll a for loop at compile time the number of iteration should be known at compile time for this to work
	//this might lead to some performance improvements 
	#unroll for i in 0 ..< len(arr) {
		fmt.println(arr[i])
	}

	num := 2
	if num % 2 == 0 {
		fmt.println("even")
	} else {
		fmt.println("odd")
	}

	//you can execute a statement before the if condition 
	//the scope of num is only in the if - else if - else blocks 
	if num := 3; num % 2 == 0 {
		fmt.println("even")
	} else {
		fmt.println("odd")
	}


	//switch statements 
	//the default case is case without a expression 
	//switch expression has to be exhaustive otherwise it will lead to a compile time error
	//it only runs the selected and does not fallthrough automatically
	//so a break statement is not necessary
	//case values need not be integers or constants 
	switch arch := ODIN_ARCH; arch {
	case .amd64, .riscv64, .arm64, .wasm64p32:
		fmt.println("64 bit architecture")

	case .i386, .arm32, .wasm32:
		fmt.println("32 bit architechture")

	case .Unknown:
		fmt.println("unknown architechture")

	case:
		fmt.println("the default case")
	}


	//#partial directive removes the necessity for switch to be exhaustive
	#partial switch arch := ODIN_ARCH; arch {
	case .amd64:
		fmt.println("64 bit")

	case .arm32:
		fmt.println("32 bit")
	}


	age := 18
	switch age {
	case 0 ..= 3:
		fmt.println("baby")
	case 4 ..= 10:
		fmt.println("child")
	case 11 ..= 17:
		fmt.println("teenager but not adult")

	case 18 ..= 19:
		fmt.println("teenager but a adult")

	case 20 ..= 100:
		fmt.println("adult")

	case:
		fmt.println("invalid age")
	}

	//defer statements are executed in reverse of the order in which they were declared 
	defer fmt.println(1)
	defer fmt.println(2)
	defer fmt.println(3)

	Foo :: enum {
		A, //0
		B, //1
		C, //2 
		D, //3 
	}


	varOfTypeEnum := Foo.A
	switch varOfTypeEnum {
	case .A:
		fmt.println("A")
	case .B:
		fmt.println("B")
	case .C:
		fmt.println("C")
	case .D:
		fmt.println("D")
	}

	#partial switch varOfTypeEnum {
	case .A:
		fmt.println("A")
	case .C:
		fmt.println("C")
	}


	//when does not support initial statements ??? 
	when ODIN_ARCH == .amd64 {
		fmt.println("64 bit architecture")
	} else when ODIN_ARCH == .arm32 {
		fmt.println("32 bit architecture")
	} else {
		fmt.println("unknown architecture")
	}


	//for loops can have labels 
	outer: for i in 1 ..= 3 {
		inner: for j in 1 ..= 10 {

			if i == 2 && j == 2 {
				fmt.println("skipping 2 x 2")
				continue inner
			}


			if i == 3 && j == 3 {
				break outer
			}

			fmt.printfln("%d X %d = %d", i, j, i * j)
		}
	}
}


add :: proc(a, b: int) -> int {
	return a + b
}

sub :: proc(a, b: int) -> int {
	return a - b
}

mul :: proc(a, b: int) -> int {
	return a * b
}

div :: proc(a, b: int) -> int {
	assert(b != 0)
	return a / b
}

is_even :: proc(num: int) -> bool {
	return num % 2 == 0
}

even_or_odd :: proc(num: int) {
	if num % 2 == 0 {
		fmt.println("even")
	} else {
		fmt.println("odd")
	}
}

sqrt :: proc(num: int) -> f64 {
	num := f64(num)
	x := num
	iter := 0
	for x * x - num > 0 && iter < 100 {
		x = (x + (num / x)) / 2
		iter += 1
	}

	return x
}

is_prime :: proc(num: int) -> bool {
	maxNumCheck := int(sqrt(num))
	for i in 0 ..= maxNumCheck {
		if num % i == 0 {
			return false
		}
	}

	return true
}
