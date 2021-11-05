import XCTest
@testable import FilesUI
import UniformTypeIdentifiers

final class FileImporterButtonTests: XCTestCase {
    
    var url: URL?
    let types = [UTType.fileURL]
    
    func test_buttonIsInitialized() throws {
        let button = FileImporterButton(types, inputFile: { url in self.url = url })
        XCTAssertEqual(button.types, types)
        XCTAssertEqual(url, nil)
    }
}
