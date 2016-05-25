/*:
# Silvery
Try out Silvery here!
*/
import Foundation
@testable import AnyFunction


let c = Closure.wrap { (a: String) in a }
let ret = try! c.call(["Test"])

print(ret)
print(1)