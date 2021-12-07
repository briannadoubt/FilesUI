//
//  FileExporterButton.swift
//  
//
//  Created by Bri on 11/4/21.
//

public struct DirectoryPicker: View {
    
    public init(
        directory: Binding<URL?>,
        borderWidth: CGFloat = 3,
        borderCornerRadius: CGFloat = 10,
        borderColor: Color = Color("AccentColor"),
        buttonBackgroundColor: Color = Color("DirectoryPickerBackgroundColor")
    ) {
        self._directory = directory
        self.borderWidth = borderWidth
        self.borderCornerRadius = borderCornerRadius
        self.borderColor = borderColor
        self.buttonBackgroundColor = buttonBackgroundColor
    }
    
    fileprivate let borderWidth: CGFloat
    fileprivate let borderCornerRadius: CGFloat
    fileprivate let borderColor: Color
    fileprivate let buttonBackgroundColor: Color
    
    @Binding fileprivate var directory: URL?
    @State fileprivate var stale = false
    @State fileprivate var showingFileExporter = false
    @AppStorage("outputDirectory") fileprivate var output: Data = Data()
    
    public var body: some View {
        Button(
            action: { showingFileExporter.toggle() },
            label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10).stroke(borderColor, lineWidth: borderWidth)
                        .background(.ultraThinMaterial)
                        .background(Color("BackgroundColor").opacity(0.5))
                    
                    HStack {
                        Group {
                            Text(directory?.lastPathComponent ?? "Choose Destination...").bold()
                            + Text(" \(Image(systemName: "folder"))").bold()
                        }
                        .padding()
                    }
                    .foregroundColor(Color.accentColor)
                    .font(.largeTitle)
                    .lineLimit(nil)
                }
            }
        )
        #if os(macOS)
        .buttonStyle(PlainButtonStyle())
        #elseif os(iOS)
        .buttonStyle(PlainButtonStyle())
        #endif
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
                assertionFailure()
            }
        }
        .tag("documentPicker")
        .accessibility(label: Text("Document Picker"))
    }
}

struct DirectoryPicker_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryPicker(directory: .constant(URL(fileURLWithPath: "~/dev/")))
    }
}
