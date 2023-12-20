# AnimeGANv2-swift-5-ios
## AnimeGANv2 swift 5 ios
#  [UIImagePickerController Rotate horizontally](https://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload) <br><br>


![Screenshot 2023-12-20 at 8 59 22 PM](https://github.com/Experimenters1/AnimeGANv2-swift-5-ios/assets/64000769/5f81ce14-76f3-4a76-9a30-6c1216c2f3a0)

# Rotate horizontally : Xoay ngang
```swift
                // Lưu ảnh vào thư mục Documents của ứng dụng
                if let imageData = resultImage?.pngData(),
                   let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

                    let fileURL = documentsDirectory.appendingPathComponent("processed_image.png")
                    try? imageData.write(to: fileURL)
    }

```


[download AnimeGANv2_512.mlmodel](https://drive.google.com/file/d/1FQDyTBbXWdy8JV0LLUxgTwtqnwk0JhHy/view?usp=sharing) <br><br>

[download AnimeGANv2_1024.mlmodel](https://drive.google.com/file/d/1UsCCwNuaGWZwAFZzllvrNTtIHvRU86z9/view?usp=sharing) <br><br>

![image](https://github.com/Experimenters1/AnimeGANv2-swift-5-ios/assets/64000769/0927fd1b-209d-4e70-925c-0883fad3ed5f)<br><br>

![Screenshot 2023-12-12 at 11 28 56 AM](https://github.com/Experimenters1/AnimeGANv2-swift-5-ios/assets/64000769/b5fe7321-c560-4434-98ae-a1dbd59e3698)<br><br>

