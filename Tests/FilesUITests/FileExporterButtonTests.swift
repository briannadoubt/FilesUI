import XCTest
import SwiftUI
@testable import FilesUI
import UniformTypeIdentifiers

final class FileExporterButtonTests: XCTestCase {
    
    @State var url: URL = URL(fileURLWithPath: "~/Downloads", isDirectory: true)
    
    func test_buttonIsInitialized() throws {
        let button = DirectoryPicker(directory: $url)
        XCTAssertEqual(url, button.directory)
    }
}
