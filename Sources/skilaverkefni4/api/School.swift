import MySQL

struct School: Codable, QueryParameter {
    
    let id: Int
    var name: String{
        didSet {
            update(column: .name, value: name)
        }
    }

    enum CodingKeys: String, CodingKey {
        case id = "schoolID"
        case name = "schoolName"
    }

    static var all: Future<[School]> {
        return MySQLFuncs.getAll(functionName: "getAllSchools")
    }

    static func create(id: Int, name: String) -> Future<Bool>
    {
        let student: Future<Bool> = MySQLFuncs.createRow(functionName: "createSchool", parameters: [id, name])
        return student
    }

    static func find(id: Int) -> Future<Student>
    {
        return MySQLFuncs.findRow(functionName: "selectSchool", id: id)
    }

    func delete() -> Future<Bool>
    {
        return MySQLFuncs.deleteRow(functionName: "deleteSchool", id: id)
    }
    
    func update(column: CodingKeys, value: QueryParameter) -> Future<Bool>
    {
        return MySQLFuncs.changeValue(functionName: "changeSchoolValue", valueToChange: String(describing: column), changeTo: value, id: id)
    }
}

