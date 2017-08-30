//
//  ClosureTests.swift
//  Deferred
//
//  Created by damouse on 5/18/16.
//  Copyright © 2016 I. All rights reserved.
//

import XCTest
@testable import AnyFunction


class ClosureSuccessTests: XCTestCase {
    func testVoidVoid() {
        let c = Closure.wrapOne { }
        let ret = try! c.call([])
        
        XCTAssert(ret.count == 0)
    }
    
    func testStringVoid() {
        let t: (String) -> () = { (a: String) -> () in  }
        let c = Closure.wrapOne(t)
        let ret = try! c.call(["A"])
        
        XCTAssert(ret.count == 0)
    }
    
    func testReturn() {
        let c = Closure.wrapOne { (a: String) in a }
        let ret = try! c.call(["Test"])
        
        XCTAssert(ret.count == 1)
        XCTAssert(ret[0] as! String == "Test")
    }
    
    // More than one param
    func testMultipleParams() {
        let c = Closure.wrapTwo { (a: String, b: Int) in b }
        let ret = try! c.call(["Test", 1])
        
        XCTAssert(ret.count == 1)
        XCTAssert(ret[0] as! Int == 1)
    }
}


class ClosureFailureTests: XCTestCase {
    // Too many arguments
    func testBadNumParamsVoid() {
        let c = Closure.wrapOne({ })
        
        do {
            try c.call([1])
            XCTFail()
        } catch {}
    }
    
    // too few arguments
    func testBadNumParamsOne() {
        let c = Closure.wrapOne{ (a: Int) in a }
        
        do {
            try c.call([])
            XCTFail()
        } catch {}
    }
    
    // This is already tested in Conversion tests, so more of a sanity check that the throws work correctly
    func testBadType() {
        let c = Closure.wrapOne({ (a: Int) in })
        
        do {
            try c.call(["Not an Int"])
            XCTFail()
        } catch {}
    }
}
