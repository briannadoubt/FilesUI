//
//  FileImporterButton.swift
//  Oatmeal
//
//  Created by Bri on 11/1/21.
//

import SwiftUI
import UniformTypeIdentifiers

public struct FileImporterButton: View {
    
    public var types: [UTType]
    public var url: (_ url: URL) -> ()
    
    public init(_ allowedTypes: [UTType], url: @escaping (_ url: URL) -> ()) {
        self.types = allowedTypes
        self.url = url
    }
    
    @State private var showingFileImporter = false
    @State private var hovored: Bool = false
    
    public var body: some View {
        Button(
            action: { showingFileImporter.toggle() },
            label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(hovored ? Color.orange : Color.clear)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(hovored ? Color.white : Color.orange, lineWidth: 3))
                        .transition(.opacity)

                    VStack {
                        Text("Drop \(Image(systemName: "arrow.uturn.down")) / Tap \(Image(systemName: "hand.tap"))")
                            .bold()
                            .foregroundColor(hovored ? .white : .orange)
                            .lineLimit(nil)
                    }
                    .font(.largeTitle)
                    .padding()
                }
            }
        )
        .padding()
        .fileImporter(isPresented: $showingFileImporter, allowedContentTypes: types) { result in
            do {
                let newUrl = try result.get()
                withAnimation {
                    url(newUrl)
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        .onDrop(of: types, isTargeted: $hovored) { providers in
            for item in providers {
                _ = item.loadObject(ofClass: URL.self) { newUrl, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    if let newUrl = newUrl {
                        withAnimation {
                            url(newUrl)
                        }
                    }
                }
            }
            return true
        }
    }
}

struct FileImporterButton_Previews: PreviewProvider {
    static var previews: some View {
        FileImporterButton([.fileURL], url: { url in print(url) })
    }
}