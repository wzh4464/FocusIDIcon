import XCTest
@testable import FocusIDIcon

final class FocusIDIconTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        do {
            let path = "/Volumes/External/SteamLibrary/steamapps/common/Hearts of Iron IV/common/national_focus"
                let focusSet = try focusSet(from: path)
                for focus in focusSet {
                    print("id:", focus.id, "icon:", focus.icon)
                }
        } catch {
            print(error.localizedDescription)
        }
    }
}
