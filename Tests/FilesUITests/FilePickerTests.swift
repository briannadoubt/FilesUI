import XCTest
@testable import FilesUI
import UniformTypeIdentifiers

final class FilePickerTests: XCTestCase {
    
    @State var file: URL?
    let types = [UTType.fileURL]
    
    func test_buttonIsInitialized() throws {
        let button = FilePicker(types, file: $file)
        XCTAssertEqual(button.types, types)
        XCTAssertEqual(file, nil)
    }
}
