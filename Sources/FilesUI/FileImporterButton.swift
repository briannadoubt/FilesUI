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
    public var inputFile: (_ url: URL) -> ()
    
    public init(_ allowedTypes: [UTType], inputFile: @escaping (_ url: URL) -> ()) {
        self.types = allowedTypes
        self.inputFile = inputFile
    }
    
    @State private var showingFileImporter = false
    @State private var hovored: Bool = false
    
    var actionText: String {
        #if os(iOS)
        "Tap"
        #elseif os(macOS)
        "Click"
        #endif
    }
    
    var actionImage: String {
        #if os(iOS)
        "hand.tap"
        #elseif os(macOS)
        "cursorarrow.click"
        #endif
    }
    
    public var body: some View {
        Button(
            action: { showingFileImporter.toggle() },
            label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(hovored ? Color("AccentColor") : Color.clear)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(hovored ? Color.primary : Color("AccentColor"), lineWidth: 3))
                        .transition(.opacity)

                    VStack {
                        Text("\(Image(systemName: "arrow.uturn.down")) / \(Image(systemName: actionImage))")
                            .bold()
                            .foregroundColor(hovored ? Color("AccentColor") : Color("SecondaryColor"))
                            .lineLimit(nil)
                    }
                    .font(.largeTitle)
                    .padding()
                }
                .background(.ultraThinMaterial)
                .background(Color.accentColor.opacity(0.5))
                .cornerRadius(10)
            }
        )
        .buttonStyle(PlainButtonStyle())
        .padding()
        .fileImporter(isPresented: $showingFileImporter, allowedContentTypes: types) { result in
            do {
                let newUrl = try result.get()
                withAnimation {
                    inputFile(newUrl)
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
                            inputFile(newUrl)
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
        FileImporterButton([.fileURL], inputFile: { url in print(url) })
    }
}
