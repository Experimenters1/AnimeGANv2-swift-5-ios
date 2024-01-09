# AnimeGANv2-swift-5-ios
## AnimeGANv2 swift 5 ios
#  [UIImagePickerController Rotate horizontally](https://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload) <br><br>

#  [How do you trigger a block after a delay, like -performSelector:withObject:afterDelay:?](https://stackoverflow.com/questions/4139219/how-do-you-trigger-a-block-after-a-delay-like-performselectorwithobjectafter) <br><br>
![image](https://github.com/Experimenters1/AnimeGANv2-swift-5-ios/assets/64000769/b5d15c21-2fdd-4c64-9f68-dc31ed0909a6)


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

