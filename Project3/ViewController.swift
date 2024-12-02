//
//  ViewController.swift
//  Project1
//
//  Created by Serhii Prysiazhnyi on 17.10.2024.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        // Вызов метода для настройки кнопки "Рекомендовать"
        setupRecommendButton()
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
                pictures.sort()
                print(pictures)
            }
        }
    }
    
    func setupRecommendButton() {
        // Создание кнопки "Рекомендовать приложение"
        let recommendButton = UIBarButtonItem(title: "Рекомендувати", style: .plain, target: self, action: #selector(recommendTapped))
        navigationItem.rightBarButtonItem = recommendButton
    }
    
    @objc func recommendTapped() {
        let appURL = URL(string: "https://github.com/Prysiazhnyi?tab=repositories")!
        let shareText = "https://github.com/Prysiazhnyi?tab=repositories"
        
        let itemsToShare = [shareText, appURL] as [Any]
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem // Настройка для iPad
        present(activityVC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedPictureNumber = indexPath.row + 1
            vc.totalPictures = pictures.count
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

