//
//  DetailViewController.swift
//  Project1
//
//  Created by Serhii Prysiazhnyi on 18.10.2024.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var selectedPictureNumber = 0
    var totalPictures = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "This image is \(selectedPictureNumber) from \(totalPictures)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.largeTitleDisplayMode = .never
        if let imageToLoad = selectedImage {
            imageView.image  = UIImage(named: imageToLoad)
        }
        
        textCoreGraphics()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        let imageName = selectedImage ?? "unknown_image.jpg"
        // Создайте временный файл
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let fileURL = temporaryDirectory.appendingPathComponent(imageName)
        
        do {
            // Запишите данные изображения в файл
            try image.write(to: fileURL)
            
            // Передаем файл вместо данных изображения
            let itemsToShare: [Any] = [fileURL]
            
            let vc = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        } catch {
            print("Error saving image: \(error)")
        }
    }
    
    func textCoreGraphics() {
        guard let originalImage = imageView.image else {
            print("No image found")
            return
        }

        let renderer = UIGraphicsImageRenderer(size: originalImage.size)

        let img = renderer.image { ctx in
            // Рисуем оригинальное изображение
            originalImage.draw(at: .zero)

            // Текст и атрибуты
            let text = "From Storm Viewer\n(задание из project-27\n Core Graphics)"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Chalkduster", size: 60) ?? UIFont.boldSystemFont(ofSize: 60),
                .foregroundColor: UIColor.red,
                .paragraphStyle: {
                    let style = NSMutableParagraphStyle()
                    style.alignment = .center
                    return style
                }()
            ]

            // Рассчитываем прямоугольник для текста
            let textRect = CGRect(
                x: 0,
                y: (originalImage.size.height / 2) - 50, // Центрируем по вертикали с небольшим отступом
                width: originalImage.size.width,
                height: 300 // Высота под текст
            )

            // Рисуем текст в прямоугольнике
            text.draw(with: textRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        }

        imageView.image = img
    }

}
