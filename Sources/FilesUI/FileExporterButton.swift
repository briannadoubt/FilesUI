//
//  FileExporterButton.swift
//  
//
//  Created by Bri on 11/4/21.
//

import SwiftUI
import UniformTypeIdentifiers

public struct FileExporterButton: View {
    
    @Binding public var outputDirectory: URL
    
    @State var stale = false
    
    public init(outputDirectory: Binding<URL>) {
        self._outputDirectory = outputDirectory
    }
    
    @State private var showingFileExporter = false
    @AppStorage("outputDirectory") private var output: Data = Data()
    
    public var body: some View {
        Button(
            action: { showingFileExporter.toggle() },
            label: {
                Label(outputDirectory.lastPathComponent, systemImage: "folder")
                    .foregroundColor(Color.accentColor)
                    .lineLimit(nil)
                    .padding()
                    .background(.ultraThinMaterial)
                    .background(Color("BackgroundColor").opacity(0.5))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("AccentColor"), lineWidth: 3))
                    .padding()
            }
        )
        .buttonStyle(LinkButtonStyle())
        .padding()
        .fileImporter(isPresented: $showingFileExporter, allowedContentTypes: [.directory]) { result in
            do {
                let newUrl = try result.get()
                try withAnimation {
                    output = try newUrl.bookmarkData(options: .withSecurityScope)
                    self.outputDirectory = try URL(resolvingBookmarkData: output, options: .withSecurityScope, bookmarkDataIsStale: &stale)
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}

struct FileExporterButton_Previews: PreviewProvider {
    static var previews: some View {
        FileExporterButton(outputDirectory: .constant(URL(fileURLWithPath: "~/dev/")))
    }
}
