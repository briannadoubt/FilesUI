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
            }
        )
        #if os(macOS)
        .buttonStyle(LinkButtonStyle())
        #elseif os(iOS)
        .buttonStyle(PlainButtonStyle())
        #endif
        .frame(minWidth: 150)
        .padding()
        .fileImporter(isPresented: $showingFileExporter, allowedContentTypes: [.folder]) { result in
            do {
                let newUrl = try result.get()
                try withAnimation {
                    #if os(macOS)
                    output = try newUrl.bookmarkData(options: .withSecurityScope)
                    self.directory = try URL(resolvingBookmarkData: output, options: .withSecurityScope, bookmarkDataIsStale: &stale)
                    #elseif os(iOS)
                    output = try newUrl.bookmarkData()
                    self.directory = try URL(resolvingBookmarkData: output, bookmarkDataIsStale: &stale)
                    #endif
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
