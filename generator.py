'''
Generator for base wrapper functions. 
'''

import os

# public static func wrap<A, B, R>(fn: (A, B) -> R) -> BaseClosure<(A, B), R> {
#     return BaseClosure(fn: fn).setExecutor { a in
#         if a.count != 2 { throw ClosureError.BadNumberOfArguments(expected: 2, actual: a.count) }
#         let ret = fn(try convert(a[0], to: A.self), try convert(a[1], to: B.self))
#         return R.self == Void.self ? [] : [ret as! AnyObject]
#     }
# }

template = '''
public static func wrap<$genericList>(fn: ($args) -> ($ret)) -> BaseClosure<($args), ($ret)> {
    return BaseClosure(fn: fn).setExecutor { a in
        if a.count != $argsLen { throw ClosureError.BadNumberOfArguments(expected: argsLen, actual: a.count) }
        let ret = fn($apply)
        return R.self == Void.self ? [] : [$returnCast]
    }
}
'''

PATH = 'Deferred/AnyFunction.swift'

generics = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J']
returns = ['R', 'S', 'T', 'U', 'V', 'X', 'Y', 'Z']


def render(template, args, ret):
    name = stringIntegers[len(args)]
    cumin = ', '.join(["%s.self <- a[%s]" % (x, i) for i, x in enumerate(args)])
    both = ', '.join([x + ": PR" for x in args] + [x + ": PR" for x in ret])
    args = ', '.join(args)
    invokcation = "fn(%s)" % cumin

    return (template % (name, both, args, invokcation,)).replace("<>", "")


# Replaces the exising lines with these new lines
def foldLines(f, addition):
    start_marker = '// Start Generic Shotgun'
    end_marker = '// End Generic Shotgun'
    ret = []

    with open(f) as inf:
        ignoreLines = False
        written = False

        for line in inf:
            if end_marker in line:
                ignoreLines = False

            if ignoreLines:
                if not written:
                    written = True
                    [ret.append(x) for x in addition]
            else:
                ret.append(line)

            if start_marker in line:
                ignoreLines = True

    return ret


def foldAndWrite(fileName, lines):
    lines = foldLines(fileName, lines)

    with open(fileName, 'w') as f:
        [f.write(x) for x in lines]


if __name__ == '__main__':
    lines = []

    for j in range(6):  # The number of return types
        for i in range(7):  # Number of parameters
            lines.append(render(template, generics[:i], returns[:j]))

    foldAndWrite(PATH, lines)
