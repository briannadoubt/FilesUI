import XCTest
import SwiftUI
@testable import FilesUI
import UniformTypeIdentifiers
import ViewInspector

extension DirectoryPicker: Inspectable { }

final class DirectoryPickerTests: XCTestCase {
    
    @State var directory: URL?
    
    func test_buttonIsInitialized() throws {
//        let button = DirectoryPicker(directory: $directory)
//        let inspection = try button.inspect().find(DirectoryPicker.self).actualView()
    }
}
