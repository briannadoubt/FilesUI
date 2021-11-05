import XCTest
import SwiftUI
@testable import FilesUI
import UniformTypeIdentifiers

final class FileExporterButtonTests: XCTestCase {
    
    @State var url: URL?
    
    func test_buttonIsInitialized() throws {
        let button = FileExporterButton(outputDirectory: $url)
        XCTAssertEqual(url, button.outputDirectory)
    }
}
