import UIKit


// MARK: - 尾随闭包
func comparison(closure: () -> Void) {
    
}

let nameList = ["1","2","3","4","5"]
nameList.map { (name) in
    
}

// MARK: - 逃逸闭包
func requestServer(with URL: String,parameter: @escaping(AnyObject?, Error?) -> Void) {
    
}
// 尾随闭包
func requestServerTrailing(losure: () -> Void) {
    
}

class EscapingTest {
    var x = 10
    func request() {
        // 尾随闭包
        requestServerTrailing {
            x = x + 1
        }
        // 逃逸闭包
        requestServer(with: "") { [weak self] (obj, error) in
            guard let self = `self` else {
                return
            }
            self.x = self.x + 1
        }
    }
}

// MARK: - 图片下载管理类
struct DownLoadImageManager {
    // 单例方法
    static let sharedInstance = DownLoadImageManager()
    
    let queue = DispatchQueue(label: "com.tsn.demo.escapingClosure", attributes: .concurrent)
    // 逃逸闭包
    // path: 图片的URL
    func downLoadImageWithEscapingClosure(path: String, completionHandler: @escaping(UIImage?, Error?) -> Void) {
        queue.async {
            URLSession.shared.dataTask(with: URL(string: path)!) { (data, response, error) in
                if let error = error {
                    print("error===============\(error)")
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                } else {
                    guard let responseData = data, let image = UIImage(data: responseData) else {
                        return
                    }
                    DispatchQueue.main.async {
                        completionHandler(image, nil)
                    }
                }
            }.resume()
        }
    }
    // 保证init方法在外部不会被调用
    private init() {
        
    }
}

let path = "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Finews.gtimg.com%2Fnewsapp_match%2F0%2F12056372662%2F0.jpg&refer=http%3A%2F%2Finews.gtimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1618456758&t=3df7a5cf69ad424954badda9bc7fc55f"
DownLoadImageManager.sharedInstance.downLoadImageWithEscapingClosure(path: path) { (image: UIImage?, error: Error?) in
    if let error = error {
        print("error===============\(error)")
    } else {
        guard let image = image else { return }
        print("图片下载完成，显示图片: \(image)")
    }
}
   
enum Course {
    case spacePhysics // 空间物理
    case nuclearPhysics // 原子核物理
    case calculus // 微积分
    case quantumMechanics // 量子力学
    case geology // 地质学
}

struct StudentModel {
    var name: String = String()
    var course: Course!
    
    init(name: String, course: Course) {
        self.name = name
        self.course = course
    }
}

// MARK: - 自动闭包
class StudentManager {
    var studentInfoArray: [StudentModel] = [StudentModel]()
    
    func autoAddWith(_ student: @autoclosure @escaping() -> StudentModel) {
        studentInfoArray.append(student())
    }
    
    func autoDeleteWith(_ index: @autoclosure() -> Int) {
        studentInfoArray.remove(at: index())
    }
}

class HomeWork: NSObject {
    let studentManager: StudentManager = StudentManager()
    
    override init() {
        super.init()
        
        // John Appleseed 交了作业
        studentManager.autoAddWith(StudentModel(name: "John Appleseed", course: .spacePhysics))
        print("====================\(studentManager.studentInfoArray.count)")
        // Kate Bell 交了作业
        studentManager.autoAddWith(StudentModel(name: "Kate Bell", course: .nuclearPhysics))
        print("====================\(studentManager.studentInfoArray.count)")
        // Anna Haro 交了作业
        studentManager.autoAddWith(StudentModel(name: "Anna Haro", course: .calculus))
        print("====================\(studentManager.studentInfoArray.count)")
        // Daniel Higgins Jr. 交了作业
        studentManager.autoAddWith(StudentModel(name: "Daniel Higgins Jr.", course: .quantumMechanics))
        print("====================\(studentManager.studentInfoArray.count)")
        // David taylor 交了作业
        studentManager.autoAddWith(StudentModel(name: "David taylor", course: .geology))
        print("====================\(studentManager.studentInfoArray.count)")
        // Hand M. Zakroff 交了作业
        studentManager.autoAddWith(StudentModel(name: "Hand M. Zakroff", course: .spacePhysics))
        print("====================\(studentManager.studentInfoArray.count)")
        
        studentManager.autoDeleteWith(0)
        print("====================\(studentManager.studentInfoArray.count)")
    }
}


StudentManager()

// MARK: - 自动闭包 + 逃逸闭包
func autoAndEscaping(_ name: @autoclosure @escaping() -> String) {
    
}


autoAndEscaping("")

// MARK: - inout
func configStudent(_ fraction: inout Int) -> Int {
    return fraction + 30
}
var num = 53
configStudent(&num)

var testArray = [1,2,3,4,5,6]
testArray[1] = configStudent(&testArray[1])
print("\(testArray)")

struct Location {
    var lat: Double
    var lon: Double
    
    var fraction: Int {
        return 30
    }
}


func configLocation(_ num: inout Double) -> String {
    return "\(num + 1)"
}

func configFraction(_ fraction: inout Int) -> Int {
    return fraction + 30
}

var location = Location(lat: 37.33020, lon: -122.024348)
configLocation(&location.lat)
configFraction(&location.fraction)