//
//  ViewController.swift
//  test2
//
//  Created by Huy Vu on 12/12/23.
//

import UIKit
import Vision
import CoreML
import Lottie
import JGProgressHUD

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
            
            let hub = JGProgressHUD()
            
            // Gọi hàm showExample() trước khi xử lý extractAudio
            showExample(hub: hub)
            
            processImage(pickedImage.fixedOrientation) {
                // Closure sẽ được gọi khi processImage hoàn thành
                hub.dismiss(animated: true)
            }
        }
        dismiss(animated: true, completion: nil)
    }

    // Hàm này được gọi khi người dùng huỷ chọn ảnh
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showExample(hub: JGProgressHUD) {
           hub.indicatorView = JGProgressHUDPieIndicatorView()
           hub.textLabel.text = "Downloading"
           hub.detailTextLabel.text = "0%"
           hub.show(in: view)
           
           var progress: Float =  0.0
           Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
               progress += 0.1
               hub.setProgress(progress, animated: true)
               let value: Float =  progress / 1.0
               hub.detailTextLabel.text = "\(Int(value * 100.0))%"
               if progress > 1.0 {
                   timer.invalidate()
                   
                   hub.indicatorView = JGProgressHUDSuccessIndicatorView()
                   hub.textLabel.text = "Done!"
                   hub.detailTextLabel.text = nil
                   hub.dismiss(afterDelay: 3)
               }
           }
       }

    // Hàm xử lý ảnh và lưu kết quả
    func processImage(_ image: UIImage, completion: @escaping () -> Void) {
        
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
                    
                    // Gọi completion khi processImage hoàn thành
                    completion()
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
    
    
    var fixedOrientation: UIImage {
        guard imageOrientation != .up else { return self }
        
        var transform: CGAffineTransform = .identity
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform
                .translatedBy(x: size.width, y: size.height).rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform
                .translatedBy(x: size.width, y: 0).rotated(by: .pi)
        case .right, .rightMirrored:
            transform = transform
                .translatedBy(x: 0, y: size.height).rotated(by: -.pi/2)
        case .upMirrored:
            transform = transform
                .translatedBy(x: size.width, y: 0).scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        guard
            let cgImage = cgImage,
            let colorSpace = cgImage.colorSpace,
            let context = CGContext(
                data: nil, width: Int(size.width), height: Int(size.height),
                bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0,
                space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue
            )
        else { return self }
        context.concatenate(transform)
        
        var rect: CGRect
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            rect = CGRect(x: 0, y: 0, width: size.height, height: size.width)
        default:
            rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }
        
        context.draw(cgImage, in: rect)
        return context.makeImage().map { UIImage(cgImage: $0) } ?? self
    }
    
    
}



