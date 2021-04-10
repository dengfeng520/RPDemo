import UIKit

var str = "Hello, playground"
// MARK: - struct
struct Color {
    var red: Double = 0
    var green: Double = 0
    var blue: Double = 0
    
    var alpha: Double? = 1
    
    
    init(red: Double = 0, green: Double = 0, blue: Double = 0, alpha: Double? = 1) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    mutating func modifyWith(alpha: Double) {
        self.alpha = alpha
    }
}


extension Color: Codable {
    init?(data: Data) {
        guard let model = try? JSONDecoder().decode(Color.self, from: data) else { return nil }
        self = model
    }
}

extension Color {
    static let themeColor = Color(red: 200, green: 200, blue: 200, alpha: 1)
}

//let color = Color.themeColor

var colorA = Color(red: 200, green: 200, blue: 200) {
    didSet {
        print("color============\(colorA)")
    }
}
let colorB = Color(red: 100, green: 100, blue: 100)
colorA = colorB
if colorA.alpha == colorB.alpha {
    
}
let colorC = colorA
let colorD = colorA
let colorE = colorA

var colorArray = [colorA, colorB, colorC, colorD, colorE]
let queue = DispatchQueue.global()
let count = colorArray.count
//queue.async { [colorArray] in
//    for index in 0..<colorArray.count {
//        print("index=========\(colorArray[index])")
//        Thread.sleep(forTimeInterval: 1)
//    }
//}

queue.async {
    for index in 0..<count {
        print("index=========\(colorArray[index])")
        Thread.sleep(forTimeInterval: 1)
    }
}
queue.async {
    Thread.sleep(forTimeInterval: 0.5)
    colorArray.removeLast()
    print("-------\(colorArray.count)")
}



// MARK: - class
@objcMembers class MyColor {
    var red: Double = 0.0
    var green: Double = 0.0
    var blue: Double = 0.0

    var alpha: Double? = 1
    
    init(_ red: Double = 0, _ green: Double = 0, _ blue: Double = 0, _ alpha: Double? = 1) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    convenience init(at: (Double, Double, Double, Double?)) {
        self.init(at.0, at.1, at.2, at.3)
    }
    
    convenience init?(at: (String, String, String, String?)) {
        guard let red = Double(at.0), let green = Double(at.1), let blue = Double(at.2) else {
            return nil
        }
        self.init(red, green, blue)
    }
}


let mycolorA = MyColor()
let mycolor = MyColor(100, 100, 100)
let mycolorB = mycolorA
if mycolorA === mycolor {
    
}

struct Stack<Element> {
    lazy var stackList = Array<Element>()
    // 进栈
//    @available(*, unavailable, renamed: "")
    mutating func push(_ data: Element?) {
        guard let data = data else { return }
        stackList.append(data)
        print("push----------\(stackList.count)")
    }
    // 出栈
    mutating func pop() {
        guard stackList.count != 0 else { return }
        stackList.removeLast()
        print("pop----------\(stackList.count)")
    }
}

var stack = Stack<Any>()
stack.push("1")
stack.push("2")
stack.push(3)
stack.push("test")
stack.pop()


