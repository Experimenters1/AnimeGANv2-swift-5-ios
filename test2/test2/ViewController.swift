//
//  ViewController.swift
//  test2
//
//  Created by Huy Vu on 12/12/23.
//

import UIKit
import Vision
import CoreML

class ViewController: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let fileManager = FileManager.default
               guard let documentsFolderURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                   return
               }
               
               print(documentsFolderURL)
    }

    @IBAction func Photos(_ sender: Any) {
        let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.sourceType = .photoLibrary
           imagePicker.allowsEditing = false
           present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func camera(_ sender: Any) {
        let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            present(picker, animated: true)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Hàm này được gọi khi người dùng chọn ảnh từ thư viện hoặc máy ảnh
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            // Gọi hàm xử lý ảnh và lưu kết quả
//            processImage(pickedImage)
            
            // Sử dụng hàm
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
               // code to execute
            
                self.processImage(pickedImage) { resultImage in
                    if let resultImage = resultImage {
                        // Hiển thị kết quả trên giao diện
                        self.img.image = resultImage
                    } else {
                        // Xử lý khi có lỗi hoặc không có kết quả
                        print("Failed to process image.")
                    }
                }
            })
        }
        dismiss(animated: true, completion: nil)
    }

    // Hàm này được gọi khi người dùng huỷ chọn ảnh
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // Hàm xử lý ảnh và lưu kết quả
    func processImage(_ image: UIImage, completion: @escaping (UIImage?) -> Void) {
        // Kiểm tra xem model có khả dụng không
        guard let model = try? AnimeGANv2_512(configuration: .init()) else {
            completion(nil)
            return
        }

        // Tạo CIImage từ UIImage
        guard let ciImage = CIImage(image: image) else {
            completion(nil)
            return
        }

        // Tạo request cho Core ML và Vision
        let request = VNCoreMLRequest(model: try! VNCoreMLModel(for: model.model)) { (request, error) in
            // Xử lý kết quả trên main thread để cập nhật giao diện
            DispatchQueue.main.async {
                if let results = request.results as? [VNPixelBufferObservation],
                   let pixelBuffer = results.first?.pixelBuffer {
                    // Chuyển kết quả về UIImage
                    let resultImage = UIImage(pixelBuffer: pixelBuffer)
                    // Gọi closure với kết quả
                    completion(resultImage)
                } else {
                    // Gọi closure với nil nếu có lỗi hoặc không có kết quả
                    completion(nil)
                }
            }
        }

        // Xử lý ảnh với Vision
        let handler = VNImageRequestHandler(ciImage: ciImage)
        DispatchQueue.global(qos: .userInitiated).async { // Thực hiện xử lý trên background queue
            do {
                try handler.perform([request])
            } catch {
                // In ra console nếu có lỗi xử lý ảnh
                print("Error processing image: \(error)")
                // Gọi closure với nil nếu có lỗi
                completion(nil)
            }
        }
    }


}


extension UIImage {
    // Hàm khởi tạo mới nhận đối số là CVPixelBuffer
    convenience init?(pixelBuffer: CVPixelBuffer) {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        self.init(cgImage: cgImage)
    }
}



