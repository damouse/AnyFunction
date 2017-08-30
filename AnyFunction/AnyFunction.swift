//
//  AnyFunction.swift
//  Pods
//
//  Created by damouse on 4/26/16.
//
//  Generic wrappers that allow "AnyFunction" to be accepted and constrained by type and number of parameters
//  AnyFunction functionality seems to have been lost when this code was linked up with Convertible code. If we
//  still want to support that we have to change a few things up

import Foundation
//import DSON

public enum ClosureError : Error, CustomStringConvertible {
    case executorNotSet()
    case badNumberOfArguments(expected: Int, actual: Int)
    case badType()
    
    public var description: String {
        switch self {
        case .executorNotSet(): return "Cannot invoke function without the curried executor that actually fires it. If using BaseClosure directly, did you call setExecutor after initializing?"
        case .badNumberOfArguments(expected: let expected, actual: let actual): return "Expected  \(expected) arguments, got \(actual)"
        case .badType(): return "Bad type passed"
        }
    }
}

// Any possible closure. This allows you to create lists like [AnyClosure] where each of the internal closures have their own signatures
public protocol AnyClosureType {
    func call(_ args: [Any]) throws -> [Any]
}

public protocol ClosureType {
    associatedtype ParameterTypes
    associatedtype ReturnTypes
    var handler: (ParameterTypes) -> ReturnTypes { get }
}


// Concrete and invokable closure wrapper. Doesnt care about types and doesnt constrain its internal generics
// Note that this class is marked "Abstract" because its not ready out of the box-- a curried executor *must* be
// set by subclasses
open class BaseClosure<A, B>: AnyClosureType, ClosureType {
    open let handler: (A) -> B
    
    // This is the method that forwards an invocation to the true closure above
    // We don't have a way of capturing and enforcing the "true" type information from generic paramters, so the
    // invocation must be manually forwarded, likely in a subclass or factory
    fileprivate var executor: (([Any]) throws -> [Any])?
    
    
    // For some reason the generic constraints aren't forwarded correctly when
    // the curried function is passed along, so it gets its own method below
    // You MUST call setExecutor immediately after init! Pretend its attached to the init method
    public init(fn: @escaping (A) -> B) {
        handler = fn
    }
    
    // You MUST call this method after initializing
    open func setExecutor(_ fn: @escaping ([Any]) throws -> [Any]) -> Self {
        executor = fn
        return self
    }
    
    open func call(_ args: [Any]) throws -> [Any] {
        guard let curry = executor else { throw ClosureError.executorNotSet() }
        return try curry(args)
    }
}



// A closure wrapper factory that automatically wraps the handler in an executor.
// Does not enforce constraints on allowed types. Strangely this method errs on BaseClosure
open class Closure {
    
    open static func wrapOne<A, R>(_ fn: @escaping (A) -> R) -> BaseClosure<A, R> {
        return BaseClosure(fn: fn).setExecutor { a in
            
            // This is a special case, since it covers cases where either or both A and B can be Void.
            if A.self == Void.self  {
                if a.count != 0 { throw ClosureError.badNumberOfArguments(expected: 0, actual: a.count) }
            } else {
                if a.count != 1 { throw ClosureError.badNumberOfArguments(expected: 1, actual: a.count) }
            }
            
            // Trying to sidestep DSON updates
            // let result = A.self == Void.self ? fn(() as! A) : fn(try convert(a[0], to: A.self))
            
            // Catch void closure wraps before trying the type coercion
            if A.self == Void.self {
                let ret = fn(() as! A)
                
                return R.self == Void.self ? [] : [ret as! AnyObject]
            }
            
            guard let a1 = a[0] as? A else { throw ClosureError.badType() }
            
            let result = A.self == Void.self ? fn(() as! A) : fn(a1)
            
            return R.self == Void.self ? [] : [result as AnyObject]
        }
    }
    
    open static func wrapTwo<A, B, R>(_ fn: @escaping (A, B) -> R) -> BaseClosure<(A, B), R> {
        return BaseClosure(fn: fn).setExecutor { a in
            if a.count != 2 { throw ClosureError.badNumberOfArguments(expected: 2, actual: a.count) }
            // let ret = fn(try convert(a[0], to: A.self), try convert(a[1], to: B.self))
            
            guard let a1 = a[0] as? A else { throw ClosureError.badType() }
            guard let a2 = a[1] as? B else { throw ClosureError.badType() }
            
            let ret = fn(a1, a2)
            
            return R.self == Void.self ? [] : [ret as AnyObject]
        }
    }
    
    open static func wrapThree<A, B, C, R>(_ fn: @escaping (A, B, C) -> R) -> BaseClosure<(A, B, C), R> {
        return BaseClosure(fn: fn).setExecutor { a in
            if a.count != 3 { throw ClosureError.badNumberOfArguments(expected: 3, actual: a.count) }
            // let ret = fn(try convert(a[0], to: A.self), try convert(a[1], to: B.self), try convert(a[2], to: C.self))
            
            guard let a1 = a[0] as? A else { throw ClosureError.badType() }
            guard let a2 = a[1] as? B else { throw ClosureError.badType() }
            guard let a3 = a[2] as? C else { throw ClosureError.badType() }
        
            
            let ret = fn(a1, a2, a3)
            return R.self == Void.self ? [] : [ret as AnyObject]
        }
    }
}

