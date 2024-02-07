//
//  FullScareenViewController.swift
//  HD Wallpaper
//
//  Created by mac-high-13 on 06/02/24.
//

import UIKit
import SDWebImage
import Photos

class FullScareenViewController: UIViewController {
    @IBOutlet var menuView: UIView!
    @IBOutlet var downloadBtn: UIButton!
    @IBOutlet var setwallpaperBtn: UIButton!
    @IBOutlet var homeBtn: UIButton!
    var wallpaperData: [String: Any]?
    @IBOutlet var downloadIndicator: UIActivityIndicatorView!
    @IBOutlet var MainImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadIndicator.isHidden=true
        self.setCustomView()
        
        if let srcDictionary = wallpaperData?["src"] as? [String: Any] {
            // Now you have the "src" dictionary
          //  print("Source Dictionary: \(srcDictionary)")
            
            // You can access its elements as needed, for example:
            
            let activityIndicator = SDWebImageActivityIndicator.gray
            MainImageView.sd_imageIndicator = activityIndicator
            if let originalUrl = srcDictionary["original"] as? String,
               let url = URL(string: originalUrl) {
                
                MainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            }
        } else {
            MainImageView.image = UIImage(named: "placeholder")
        }
        
        
        
        

    }
    func setCustomView(){
        if let font = UIFont(name: "FontAwesome", size: 20) {
                    // Set the font for the button
            downloadBtn.titleLabel?.font = font
            downloadBtn.setTitle("\u{f019}", for: .normal)
            
            setwallpaperBtn.titleLabel?.font = font
            setwallpaperBtn.setTitle("\u{f03e}", for: .normal)
            
            homeBtn.titleLabel?.font = font
            homeBtn.setTitle("\u{f015}", for: .normal)
                    
                    
      }
        
        menuView.layer.cornerRadius = 15  // You can adjust the value based on your preference
        menuView.clipsToBounds = true
        menuView.layer.shadowColor = UIColor.black.cgColor
        menuView.layer.shadowOpacity = 0.5
        menuView.layer.shadowOffset = CGSize(width: 0, height: 2)
        menuView.layer.shadowRadius = 4
    }

    @IBAction func downloadBtnPress(_ sender: Any) {
        if let srcDictionary = wallpaperData?["src"] as? [String: Any] {
            if let originalUrl = srcDictionary["original"] as? String,
               let url = URL(string: originalUrl) {
                
        downloadImageAndSave(from: url)
               
               
            }else{
                
            }
        } else {
           
        }
        
    }
    
    @IBAction func setwallpaperBtnPress(_ sender: Any) {
        if let url = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
    }
    
    
    @IBAction func homeBtnPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func downloadImageAndSave(from url: URL) {
        self.downloadIndicator.isHidden=false
        self.downloadIndicator.startAnimating()
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                           self.downloadIndicator.stopAnimating()
                self.downloadIndicator.isHidden=true
                       }
            if let imageData = data {
                // Save the image data to the documents directory
                let timestamp = Int(Date().timeIntervalSince1970)
                let fileName = "wallpaper_\(timestamp).jpg"
                self.saveFileToDocumentsDirectory(data: imageData, fileName: fileName)
            } else {
                // Handle the case where there's an error downloading the image
                print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        task.resume()
    }

    func saveFileToDocumentsDirectory(data: Data, fileName: String) {
        // Get the document directory URL
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        // Append the file name to the directory
        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        do {
            // Write the data to the file
            try data.write(to: fileURL)

            // Add the image to the photo library
            PHPhotoLibrary.shared().performChanges({
                let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: UIImage(data: data)!)
                creationRequest.creationDate = Date()
            }) { success, error in
                if success {
                    print("File saved successfully at \(fileURL.absoluteString) and added to the photo library.")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(
                            title: "Success",
                            message: "Image downloaded and saved successfully.",
                            preferredStyle: .alert
                        )

                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okAction)

                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    print("Error saving file: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        } catch {
            print("Error saving file: \(error.localizedDescription)")
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
