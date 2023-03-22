import Foundation

public struct Focus {
    public let id: String
    public let icon: String
}

public func focusSet (from path: String) throws -> [Focus] {
    var focusSet: [Focus] = []
    do {
        let fileManager = FileManager.default
        let folderURL = URL(fileURLWithPath: path)
        let fileURLs = try fileManager.contentsOfDirectory(atPath: folderURL.path)
        for fileURL in fileURLs where fileURL.hasSuffix(".txt") {
            let content = try String(contentsOfFile: folderURL.appendingPathComponent(fileURL).path)
            let focuses = parseFocuses(from: content)
            for focus in focuses {
                focusSet.append(focus)
            }
        }
    } catch {
        print(error.localizedDescription)
        throw error
    }
    return focusSet
}

// define a function to parse focuses from string
private func parseFocuses(from string: String) -> [Focus] {
    var focuses: [Focus] = []
    // define stack to save "{" and "}"
    var stack: [String] = []
    // define item to save second layer of "{" and "}
    var item = ""
    var linenum = 0

    let lines = string.components(separatedBy: "\r\n") // ! "\n" is not working
    for line in lines {
        linenum = linenum + 1
        let validLine = line.split(separator: "#").first ?? "" // remove comments
        for (_, char) in validLine.enumerated() {
            if char == "{" {
                stack.append("{")
                if stack.count == 2 {
                    item = ""
                }
            } else if char == "}" {
                if let last = stack.last, last == "{" {
                    stack.removeLast()
                    if stack.count == 1 {
                        let focusString = item
                        if let idRange = focusString.range(of: #"id\s*=\s*(\S+)"#, options: .regularExpression),
                        let iconRange = focusString.range(of: #"icon\s*=\s*(\S+)"#, options: .regularExpression) {
                            let id = String(focusString[idRange].split(separator: "=")[1]).trimmingCharacters(in: .whitespaces)
                            let icon = String(focusString[iconRange].split(separator: "=")[1]).trimmingCharacters(in: .whitespaces)
                            focuses.append(Focus(id: id, icon: icon)) // add focus to array
                        }
                    }
                } else {
                    // throw error and tell the user which focus is the error from
                    fatalError("Invalid string at " + string)
                }
            } else if stack.count == 2 {
                item.append(char)
            }
        }
    }

    return focuses
}
