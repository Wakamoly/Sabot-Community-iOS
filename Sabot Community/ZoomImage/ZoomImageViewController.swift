//
//  ZoomImageViewController.swift
//  Sabot Community
//
//  Created by Wakamoly on 8/22/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

import UIKit
import Alamofire
import ImageScrollView

class ZoomImageViewController: UIViewController {
    
    @IBOutlet weak var imageZoom: ImageScrollView!
    var image:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageZoom.setup()
        
        AF.request(URLConstants.BASE_URL+image,method: .get).response{ response in
           switch response.result {
            case .success(let responseData):
                let imageFromURL = UIImage(data: responseData!, scale:1)
                self.imageZoom.display(image: imageFromURL!)
            case .failure(let error):
                print("error--->",error)
            }
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
