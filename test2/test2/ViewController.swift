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
            processImage(pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }

    // Hàm này được gọi khi người dùng huỷ chọn ảnh
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // Hàm xử lý ảnh và lưu kết quả
    func processImage(_ image: UIImage) {
        guard let model = try? AnimeGANv2_512(configuration: .init()),
              let ciImage = CIImage(image: image) else {
            return
        }

        // Tạo request cho Core ML và Vision
        let request = VNCoreMLRequest(model: try! VNCoreMLModel(for: model.model)) { (request, error) in
            DispatchQueue.main.async { // Đảm bảo gọi trên main thread
                if let results = request.results as? [VNPixelBufferObservation],
                   let pixelBuffer = results.first?.pixelBuffer {

                    // Chuyển kết quả về UIImage
                    let resultImage = UIImage(pixelBuffer: pixelBuffer)

                    self.img.image = resultImage
                }
            }
        }

        // Xử lý ảnh với Vision
        let handler = VNImageRequestHandler(ciImage: ciImage)
        DispatchQueue.global(qos: .userInitiated).async { // Thực hiện xử lý trên background queue
            do {
                try handler.perform([request])
            } catch {
                print("Error processing image: \(error)")
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



