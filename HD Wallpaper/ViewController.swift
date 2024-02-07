//
//  ViewController.swift
//  HD Wallpaper
//
//  Created by mac-high-13 on 06/02/24.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                   self.pushWallpaperViewController()
               }
    }
//    func presentWallpaperViewController() {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
//            if let wallpaperViewController = storyboard.instantiateViewController(withIdentifier: "WallpaperViewController") as? WallpaperViewController {
//                // Optionally, you can set data on wallpaperViewController if needed
//
//                // Present the view controller modally
//              self.present(wallpaperViewController, animated: true, completion: nil)
//
//            }
//        }
    func pushWallpaperViewController() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
            if let wallpaperViewController = storyboard.instantiateViewController(withIdentifier: "WallpaperViewController") as? WallpaperViewController {
                // Optionally, you can set data on wallpaperViewController if needed

                // Push the view controller onto the navigation stack
                self.navigationController?.pushViewController(wallpaperViewController, animated: true)
            }
        }

}

