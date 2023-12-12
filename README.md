# AnimeGANv2-swift-5-ios
## AnimeGANv2 swift 5 ios


```swift
                // Lưu ảnh vào thư mục Documents của ứng dụng
                if let imageData = resultImage?.pngData(),
                   let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

                    let fileURL = documentsDirectory.appendingPathComponent("processed_image.png")
                    try? imageData.write(to: fileURL)
    }

```
