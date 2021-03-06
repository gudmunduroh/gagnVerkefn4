
/*let pool = ConnectionPool(option: Options())
let students: [Student] = try pool.execute { conn in
	try conn.query("SELECT * FROM students") 
}
print(students[50].name)*/

struct ManangeStudents {
    let menu: Menu

    init()
    {
        menu = Menu(header: "Manange students")
        menu.options = [
            "Delete student": self.delete,
            "Rename student": self.rename,
            "Add Student": self.add,
            "Print all student names": self.printAll
        ]
    }

    private func askForID() -> Int?
    {
        return input("ID of student")
    }

    func delete()
    {
        guard let id = askForID() else {
            print("Error: Invalid id")
            return
        }
        Student.find(id: id).whenReady{ studentn in
            guard let student = studentn else {
                print("Error: Student with id \(id) not found")
                return
            }
            student.delete().whenReady { success in
                if success! {
                    print("Student with id \(id) has been deleted")
                } else {
                    print("Failed to delete student with id \(id)")
                }
            }
        }
    }

    func rename()
    {
        guard let id = askForID() else {
            print("Error: Invalid id")
            return
        }
        guard let name: String = input("New name") else {
            print("Invalid name")
            return
        }

        Student.find(id: id).whenReady{ studentn in
            guard let student = studentn else {
                print("Error: Student with id \(id) not found")
                return
            }
            student.update(column: .name, value: name).whenReady { success in
                if success! {
                    print("Student with id \(id) has been renamed")
                } else {
                    print("Failed to rename student with id \(id)")
                }
            }
        }
    }

    func add()
    {
        guard let name: String = input("Name"), name != "" else {
            print("Invalid name")
            return
        }
        guard let credits: Int = input("Credits") else {
            print("Invalid credits")
            return
        }
        guard let trackID: Int = input("Track") else {
            print("Invalid track")
            return
        }
        Student.create(name: name, credits: credits, trackID: trackID).whenReady { success in
            if let s = success, s {
                print("Student created")
            } else {
                print("Failed to create student")
            }
        }
    }

    func printAll()
    {
        print("Names of all students: ")
        Student.all.whenReady {
            print("inside!")
            guard let students = $0 else {
                print("Failed to load students")
                return
            }
            students.forEach { student in
                print(student.name)
            }
        }
        print("----------END----------")
    }
}

var running = true

let menu = Menu(header: "Select action", options: [
    "Manange students": {
        let manangeStudents = ManangeStudents()
        manangeStudents.menu.display()
    },
    "Manange schools": {
        print("Option not implemented")
    },
    "Manange courses": {
        print("Option not implemented")
    },
    "Exit": {
        running = false
    }
])
while running
{
    menu.display()
}