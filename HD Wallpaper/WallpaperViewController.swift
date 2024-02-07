//
//  WallpaperViewController.swift
//  HD Wallpaper
//
//  Created by mac-high-13 on 06/02/24.
//
import SDWebImage

import UIKit

class WallpaperViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate {

    private var overlayView: UIView?
    @IBOutlet var searchtextfiled: UITextField!
    @IBOutlet var ImageCollectionView: UICollectionView!
    @IBOutlet var infoBtn: UIButton!
    @IBOutlet var SearchBtn: UIButton!
 
    
    var pageNumber = 1  // Replace with the desired page number
    var urlString = ""
    var arrImg: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoBtn.isHidden=true
        
        searchtextfiled.delegate = self
       
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
       
        if let font = UIFont(name: "FontAwesome", size: 20) {
                    // Set the font for the button
            SearchBtn.titleLabel?.font = font

                    // Set the Unicode for the FontAwesome icon you want (e.g., the "fa-coffee" icon)
            SearchBtn.setTitle("\u{f002}", for: .normal)
                    
                    
                }
        SearchBtn.layer.cornerRadius = 10  // You can adjust the value based on your preference
       SearchBtn.clipsToBounds = true
        
        urlString = "https://api.pexels.com/v1/curated/?page=\(pageNumber)&per_page=80"
        fetchWallpapers(apiURL: urlString)
        
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        print("array size: \(arrImg.count)")
        return arrImg.count
    }

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagecell", for: indexPath) as! ImageCollectionViewCell
        
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            print("This is an iPhone")
            cell.heightConstraint.constant = 150
            cell.widthConstraint.constant = 180
            
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            print("This is an iPad")
            cell.heightConstraint.constant = 200
            cell.widthConstraint.constant = 250
        }
        
        
        let wallpaperDictionary = arrImg[indexPath.row]

        if let srcDictionary = wallpaperDictionary["src"] as? [String: Any] {
            // Now you have the "src" dictionary
          //  print("Source Dictionary: \(srcDictionary)")
            
            // You can access its elements as needed, for example:
            if let originalUrl = srcDictionary["medium"] as? String,
               let url = URL(string: originalUrl) {
                // Use the 'url' variable for further processing
               
           
                
                cell.image.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            }
        } else {
            cell.image.image = UIImage(named: "placeholder")
        }
        
        if indexPath.row == arrImg.count - 1 {
                   // Fetch the next page
                   pageNumber += 1
                   fetchWallpapers(apiURL: urlString)
               }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let wallpaperDictionary = arrImg[indexPath.row]
//        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
//        if let FullScareenViewController = storyboard.instantiateViewController(withIdentifier: "FullScareenViewController") as? FullScareenViewController {
//            self.navigationController?.pushViewController(FullScareenViewController, animated: true)
//        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
        if let FullScareenViewController = storyboard.instantiateViewController(withIdentifier: "FullScareenViewController") as? FullScareenViewController {
            // Optionally, you can set data on wallpaperViewController if needed

            // Present the view controller modally
            FullScareenViewController.wallpaperData = wallpaperDictionary
          self.present(FullScareenViewController, animated: true, completion: nil)

        }
    }
    
    func fetchWallpapers(apiURL: String) {
        showFullScreenLoader()
        guard let urlString = apiURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else {
            hideFullScreenLoader()
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("563492ad6f9170000100000174f400583d2441ecb74761b76eb47361", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            defer {
                            DispatchQueue.main.async {
                                self.hideFullScreenLoader()
                            }
                        }
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let data = data {
                do {
                    // Parse the response into an NSMutableDictionary
                    let responseDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSMutableDictionary
                    
                    if let nonNilDictionary = responseDictionary, nonNilDictionary.count > 0 {
                        print("Full response dictionary: \(responseDictionary ?? [:])")
                        
                        if let photosArray = responseDictionary?["photos"] as? [[String: Any]] {
                            // Perform UI updates on the main thread if needed
                            DispatchQueue.main.async {
                                // Example: Reload your collection view or update the UI
                               // self.arrImg = photosArray;
                                self.arrImg.append(contentsOf: photosArray)
                                   self.ImageCollectionView.reloadData()
                            }
                        }
                    }
               
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }
        }

        task.resume()
    }

    @IBAction func SearchWallpaper(_ sender: Any) {
        
        SearchRun()

    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // Calculate the updated text after applying the replacement
//        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
//
//        // Check if the resulting text is empty
//        if updatedText.isEmpty {
//            // Text field is now empty, call SearchRun()
//            SearchRun()
//        }
//
//        // Continue with your existing logic or modify as needed
//        return true
//    }


    
    func SearchRun(){
        searchtextfiled.resignFirstResponder()
        // Assuming you have a UITextField named textField
        if let text = searchtextfiled.text {
            let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedText.isEmpty {
                print("TextField text is :\(text)")
                self.arrImg.removeAll()
                pageNumber=1
                urlString = "https://api.pexels.com/v1/search/?page=\(pageNumber)&per_page=80&query=\(text)"
                print("url is :\(urlString)")
                fetchWallpapers(apiURL: urlString)
            }else{
                print("TextField text is blank")
                self.arrImg.removeAll()
                pageNumber=1
              
                urlString = "https://api.pexels.com/v1/curated/?page=\(pageNumber)&per_page=80"
                fetchWallpapers(apiURL: urlString)
            }
            
            
            
        } else {
            // Handle the case where the text is nil
            print("TextField text is nil")
            self.arrImg.removeAll()
            pageNumber=1
          
            urlString = "https://api.pexels.com/v1/curated/?page=\(pageNumber)&per_page=80"
            fetchWallpapers(apiURL: urlString)
        }
    }
    func showFullScreenLoader() {
            overlayView = UIView(frame: view.bounds)
            overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)

            let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
            activityIndicator.center = overlayView!.center
            activityIndicator.startAnimating()

            overlayView?.addSubview(activityIndicator)
            view.addSubview(overlayView!)
        }
    
    func hideFullScreenLoader() {
            overlayView?.removeFromSuperview()
            overlayView = nil
        }
}
