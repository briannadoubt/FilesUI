//
//  FileThumbnailView.swift
//  Free Video Converter
//
//  Created by Bri on 10/30/21.
//

import SwiftUI
import QuickLookThumbnailing

public class ThumbnailGenerator: ObservableObject {
    
    @Published public var image: UIImage?
    
    public func generate(fileAt url: URL) {
        let thumbnailRequest = QLThumbnailGenerator.Request(fileAt: url, size: CGSize(width: 150, height: 150), scale: 3, representationTypes: .all)
        QLThumbnailGenerator.shared.generateBestRepresentation(for: thumbnailRequest) { thumbnail, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            if let thumbnail = thumbnail {
                DispatchQueue.main.async {
                    withAnimation {
                        self.image = thumbnail.uiImage
                    }
                }
            }
        }
    }
}

public struct FileThumbnail: View {
    
    @Binding public var url: URL?
    
    @StateObject private var generator = ThumbnailGenerator()
    
    public var body: some View {
        Group {
            if let image = generator.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
            } else {
                Image(systemName: "film")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .onAppear {
            guard let url = url else {
                return
            }
            generator.generate(fileAt: url)
        }
        .onChange(of: url) { newUrl in
            guard let newUrl = newUrl else {
                return
            }
            generator.generate(fileAt: newUrl)
        }
    }
}

struct FileThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        FileThumbnail(url: .constant(nil))
    }
}
