//
//  UploadPhotoController.swift
//  Sabot Community
//
//  Created by Wakamoly on 7/29/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CropViewController

protocol NotifyReloadProfileData{
    func notifyDelegate()
}

class UploadPhotoController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, CropViewControllerDelegate {
    
    var delegate: NotifyReloadProfileData?
    
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    let defaultValues = UserDefaults.standard
    let deviceusername = UserDefaults.standard.string(forKey: "device_username")!
    let deviceuserid = UserDefaults.standard.string(forKey: "device_userid")!
    
    var imageUploadTo = ""
    var uploadURL = ""
    var imageToCrop:UIImage? = nil
    
    @IBAction func choosePhotoButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var imageToUpload: UIImageView!
    @IBOutlet weak var uploadButtonView: UIButton!
    
    @IBAction func uploadButton(_ sender: Any) {
        uploadImage(imageToUpload: imageToUpload.image!, uploadURLS:uploadURL)
    }
    
    @IBOutlet weak var uploadingLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if imageUploadTo == "cover" {
            uploadURL = URLConstants.ROOT_URL+"uploadCoverProfile.php"
        }else if imageUploadTo == "profile_pic" {
            uploadURL = URLConstants.ROOT_URL+"uploadProfilePhoto.php"
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func uploadImage(imageToUpload: UIImage, uploadURLS:String) {
        
        self.uploadButtonView.isHidden = true
        
        indicator.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        indicator.startAnimating()
        
        //self.uploadingLabel.isHidden = false
        var request = URLRequest(url: NSURL(string: uploadURLS)! as URL)
        request.httpMethod = "POST";
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let imageData:NSData = imageToUpload.jpegData(compressionQuality: 0.75)! as NSData
        // convert the NSData to base64 encoding
        let encodedImage:String = imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        
        let jsonObject = ["name":Int64(Date().timeIntervalSince1970 * 1000),
                          "userid":deviceuserid,
                          "username":deviceusername,
                          "image":encodedImage] as [String : Any]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObject)
        // probably shouldn't uncomment this, could crash mac -> print(jsonObject)
        
        AF.request(request)
            .responseJSON { response in
                print(response)
                
                switch response.result {
                case .success(let value):
                    let jsonData = JSON(value)
                    if (jsonData["success"]==1){
                        //unwind segue?
                        let message = jsonData["message"].string
                        self.view.showToast(toastMessage: message!, duration:2)
                        self.delegate?.notifyDelegate()
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.uploadButtonView.isHidden = false
                        let message = jsonData["message"].string
                        self.view.showToast(toastMessage: message!, duration:2)
                    }
                    self.indicator.stopAnimating()
                case let .failure(error):
                    print(error)
                    self.uploadButtonView.isHidden = false
                    self.view.showToast(toastMessage: "Network error!", duration:2)
                }
        }
    }
    
    //MARK: ImagePicker Controller Delegate methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        imageToCrop = (info[.originalImage] as? UIImage)!
        picker.dismiss(animated: true, completion: nil)
        presentCropViewController()
    }
    
    func presentCropViewController() {
        let image: UIImage = imageToCrop!
        
        var cropViewController:CropViewController? = nil
        if imageUploadTo == "profile_pic"{
            cropViewController = CropViewController(croppingStyle: .circular, image: image)
        }else{
            cropViewController = CropViewController(image: image)
        }
        cropViewController!.delegate = self
        present(cropViewController!, animated: true, completion: nil)
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage croppedImage: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        imageToUpload.image = croppedImage
        self.uploadButtonView.isHidden = false
        cropViewController.dismiss(animated: false, completion: nil)
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage croppedImage: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        imageToUpload.image = croppedImage
        self.uploadButtonView.isHidden = false
        cropViewController.dismiss(animated: false, completion: nil)
    }
    
}
