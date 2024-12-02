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
        // Do any additional setup after loading the view.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}