import UIKit


// 表示老师所教授的课程
enum Course {
    case language // 语文
    case english // 英语
    case calculus // 微积分
    case quantumMechanics // 量子力学
    case geology // 地质学
}

class Teacher: NSObject {
    let lastName: String
    let course: Course
    weak var student: Student?
    
    var isRight: Bool?
    
    
    init(lastName: String, course: Course) {
        self.lastName = lastName
        self.course = course
        print("init------------------Teacher")
    }
    
    func judgmentIsRight() {
        let stundent = Student(name: "Tom")
        stundent.configSelect()
        stundent.selectClosures = { (answer) in
            self.isRight = answer == .B ? true : false
        }
    }
    
    deinit {
        print("deinit------------------Teacher")
    }
}

enum OptionsEnum {
    case A
    case B
    case C
    case D
}

class Student: NSObject {
    var name: String
    var teacher: Teacher?
    // 家庭作业
    var homeWork: HomeWork?
    
    
    var selectClosures: ((OptionsEnum) -> Void)? = nil
    
    init(name: String) {
        self.name = name
        print("init------------------Student")
    }
    
    func configSelect() {
        guard let selectClosures = selectClosures else {
            return
        }
        selectClosures(.B)
    }
    
    deinit {
        print("deinit------------------Student")
    }
}

class HomeWork: NSObject {
    unowned let student: Student
    let course: Course
    init(student: Student, course: Course) {
        self.student = student
        self.course = course
        print("init------------------HomeWork")
    }
    
    deinit {
        print("deinit------------------HomeWork")
    }
}


var studentTom: Student? = Student(name: "Tom")
var teacherMars: Teacher? = Teacher(lastName: "Mars", course: .calculus)

teacherMars?.student = studentTom
studentTom?.teacher = teacherMars
studentTom = nil
teacherMars?.student
print("------------------\(String(describing: teacherMars?.student))")
teacherMars = nil


var david: Student? = Student(name: "David Taylor")
var homeWork: HomeWork? = HomeWork(student: david!, course: .quantumMechanics)
david?.homeWork = homeWork

david = nil
homeWork = nil
//homeWork!.student
