# FilesUI
A few drop-in SwiftUI components for easily importing and thumb-nailing files

## Usage

### 1. Import Files
To import files you can use the `FileImporterButton`:
```
FileImporterButton(types: [.fileURL], url: { url in print(url) })
```
This button also supports drag and drop for the specified `UTType`s

### 2. Display thumbnail
To display a thumbnail of the imported file you can use `FileThumbnailView` with `FileImporterButton`:
```
struct MyView: View {
    @State var importedFileUrl: URL?
    
    var body: some View {
        if let url = importedFileUrl {
            FileThumbnail(url: importedFileUrl)
        } else {
            FileImporterButton(types: [.fileURL]) { url in
                self.importedFileUrl = url
            }
        }
    }
}
```
