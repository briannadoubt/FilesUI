//
//  FileThumbnailView.swift
//  Free Video Converter
//
//  Created by Bri on 10/30/21.
//

import QuickLookThumbnailing

public class ThumbnailGenerator: ObservableObject {
    
    #if os(iOS)
    @Published public var image: UIImage?
    #elseif os(macOS)
    @Published public var image: NSImage?
    #endif
    
    public func generate(fileAt url: URL) {
        let thumbnailRequest = QLThumbnailGenerator.Request(fileAt: url, size: CGSize(width: 150, height: 150), scale: 3, representationTypes: .all)
        QLThumbnailGenerator.shared.generateBestRepresentation(for: thumbnailRequest) { thumbnail, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            if let thumbnail = thumbnail {
                DispatchQueue.main.async {
                    withAnimation {
                        #if os(iOS)
                        self.image = thumbnail.uiImage
                        #elseif os(macOS)
                        self.image = thumbnail.nsImage
                        #endif
                    }
                }
            }
        }
    }
}

public struct Thumbnail: View {
    
    public var url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    @StateObject private var generator = ThumbnailGenerator()
    
    public var body: some View {
        Group {
            if let image = generator.image {
                #if os(iOS)
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                #elseif os(macOS)
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                #endif
            } else {
                Image(systemName: "film")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .onAppear {
            generator.generate(fileAt: url)
        }
        .onChange(of: url) { newUrl in
            generator.generate(fileAt: newUrl)
        }
    }
}

struct Thumbnail_Previews: PreviewProvider {
    static var previews: some View {
        Thumbnail(url: URL(fileURLWithPath: "~/Downloads/egg.png"))
    }
}
