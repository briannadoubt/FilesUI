//
//  FileExporterButton.swift
//  
//
//  Created by Bri on 11/4/21.
//

import SwiftUI
import UniformTypeIdentifiers

public struct FileExporterButton: View {
    
    @Binding public var outputDirectory: URL?
    
    public init(outputDirectory: Binding<URL?>) {
        self._outputDirectory = outputDirectory
    }
    
    @State private var showingFileExporter = false
    @AppStorage("outputDirectory") private var output: Data = Data()
    
    public var body: some View {
        Button(
            action: { showingFileExporter.toggle() },
            label: {
                let rightArrow = Image(systemName: "arrow.right")
                HStack {
                    Text(outputDirectory?.absoluteString.replacingOccurrences(of: "/", with: " \(rightArrow) ") ?? "iCloud Drive \(rightArrow) \(Bundle.main.bundleIdentifier ?? "Converted Videos")")
                        .bold()
                        .foregroundColor(Color("AccentColor"))
                        .lineLimit(nil)
                    Spacer()
                }
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("AccentColor"), lineWidth: 3))
                .padding()
            }
        )
        .padding()
        .fileImporter(isPresented: $showingFileExporter, allowedContentTypes: [.directory]) { result in
            do {
                let newUrl = try result.get()
                try withAnimation {
                    output = try newUrl.bookmarkData(options: .withSecurityScope)
                    self.outputDirectory = newUrl
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}

struct FileExporterButton_Previews: PreviewProvider {
    static var previews: some View {
        FileExporterButton(outputDirectory: .constant(URL(fileURLWithPath: "files:///Users/bri/dev/")))
    }
}
