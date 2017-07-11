# AnyFunction 

Type tools for manipulating any function in Swift 1.3. Think generic closures. 

This project is suspended indefinitely. It was written before Swift 2 came out, and so likely doesn't work anymore. 

## Functionality
Swift doesn't allow for generic closures. Specifically, it doesn't allow for variadic generic closures. 

In other words, you can take a closure that has a generic signature: 
```swift
func takesAClosure<A, B, C>((A, B) -> C) 
```

But you cant take closures that may have more or less parameters: 
```swift
func takesAClosure<A, B, C>(passedClosure: (A, B) -> C) 

# This has to be a different function
func takesAClosure<A, C>(passedClosure: (A) -> C) 
```

The point of this library is create a type that can standin for any closure with any number of parameters. This is a useful function if you want to make a library that can accept arbitrary closures and both resolve and invoke them dynamically. 

```swift
func TakesAnyFunction<A: AnyFunction>(A)

TakesAnyFunction((a: Int, b: String) in 1 })
TakesAnyFunction((c: Bool) in "1" })
```

It works by reflecting the type of the passed closure, wrapping it in an abstract `Closure` class, then exposing a method `call` that takes an array of arguments. If the number and type of arguments match the signature of the passed closure then the original closure is invoked and the results returned. 

## Example

```swift
import AnyFunction

let c = Closure.wrap { (a: String) in a }
let ret = try! c.call(["Test"])

print(ret) // #=> "Test"
```

