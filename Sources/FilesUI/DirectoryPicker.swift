//
//  FileExporterButton.swift
//  
//
//  Created by Bri on 11/4/21.
//

import SwiftUI
import UniformTypeIdentifiers

public struct DirectoryPicker: View {
    
    @Binding public var directory: URL
    
    @State var stale = false
    
    public init(directory: Binding<URL>) {
        self._directory = directory
    }
    
    @State private var showingFileExporter = false
    @AppStorage("outputDirectory") private var output: Data = Data()
    
    public var body: some View {
        Button(
            action: { showingFileExporter.toggle() },
            label: {
                HStack {
                    Spacer()
                    Label(directory.lastPathComponent, systemImage: "folder")
                        .foregroundColor(Color.accentColor)
                        .lineLimit(nil)
                    Spacer()
                }
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
                    self.directory = try URL(resolvingBookmarkData: output, options: .withSecurityScope, bookmarkDataIsStale: &stale)
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}

struct DirectoryPicker_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryPicker(directory: .constant(URL(fileURLWithPath: "~/dev/")))
    }
}
