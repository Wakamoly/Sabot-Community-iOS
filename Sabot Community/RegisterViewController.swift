//
//  RegisterViewController.swift
//  SabotCommunity
//
//  Created by Wakamoly on 5/18/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,8}"
let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)

extension String {
    func isEmail() -> Bool {
        return __emailPredicate.evaluate(with: self)
    }
}

extension UITextField {
    func isEmail() -> Bool {
        return self.text!.isEmail()
    }
}

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    let URL_USER_REGISTER = URLConstants.URL_REGISTER
    let defaultValues = UserDefaults.standard
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldEmail:UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldHDYFU: UITextField!
    @IBOutlet weak var textFieldPasswordAgain: UITextField!
    @IBOutlet weak var contentView: UIView!
    @IBAction func privacyButton(_ sender: Any) {
        if let privacyurl = NSURL(string: "https://app.termly.io/document/privacy-policy/96bf5c01-d39b-496c-a30e-57353b49877c"){             UIApplication.shared.open(privacyurl as URL, options: [:], completionHandler: nil) }
    }
    @IBAction func tosButton(_ sender: Any) {
        if let tosurl = NSURL(string: "https://sabotcommunity.com/termsandconditions.php"){             UIApplication.shared.open(tosurl as URL, options: [:], completionHandler: nil) }
    }
    @IBAction func sendToLogin(_ sender: UIButton) {
        //print("sendToLogin Pressed!")
        //switching the screen
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginViewController, animated: true)
        self.dismiss(animated: false,completion: nil)
    }
    
    @IBAction func buttonRegister(_ sender: UIButton) {
        let email = textFieldEmail.text
        let username = textFieldUsername.text
        let password = textFieldPassword.text
        let password2 = textFieldPasswordAgain.text
        let hdyfu = textFieldHDYFU.text
        
        if (username!.count<4||username!.count>20) {
            self.view.showToast(toastMessage: "Username must be between 4 and 20 characters!", duration:2)
        }else{
            if(password==password2 && !(password!.count<4)){
                if isValidEmail(email!) {
                    let parameters: Parameters=["username":username!,
                                                "email":email!,
                                                "password":password!,
                                                "howdidyoufindus":hdyfu!]
                    
                    AF.request(URL_USER_REGISTER, method: .post, parameters:parameters).responseJSON{
                        response in
                        print(response)
                        
                        switch response.result {
                        case .success(let value):
                            let jsonData = JSON(value)
                            if jsonData["error"].int==0 {
                                self.sendToLoginFunc(email!,password!)
                            }else{
                                let message = jsonData["message"].string
                                self.view.showToast(toastMessage: message!, duration:2)
                            }
                            case let .failure(error):
                            print(error)
                        }
                    }
                }else{
                    self.view.showToast(toastMessage: "Invalid Email Address!", duration:2)
                }
            }else{
                self.view.showToast(toastMessage: "Passwords much match and be greater than 3 characters!", duration:2)
            }
        }
    }
    
    func sendToLoginFunc(_ email:String,_ password:String){
        //switching the screen
            /*let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(loginViewController, animated: true)
            self.dismiss(animated: false,completion: nil)*/
        /*let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginViewController.email = email;
        loginViewController.password = password;
        self.navigationController?.pushViewController(loginViewController, animated: true)
        self.dismiss(animated: false,completion: nil)*/
        performSegue(withIdentifier: "ToLogin", sender: nil)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        return __emailPredicate.evaluate(with: email)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        indicator.startAnimating()
        
        self.textFieldUsername.delegate = self
        self.textFieldPassword.delegate = self
        self.textFieldPasswordAgain.delegate = self
        self.textFieldHDYFU.delegate = self
        self.textFieldEmail.delegate = self
        //if user is already logged in switching to profile screen
        if defaultValues.string(forKey: "device_username") != nil{
            /*let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(profileViewController, animated: true)*/
            self.performSegue(withIdentifier: "ToAppMainContent", sender: nil)
        }else{
            contentView.isHidden = false
        }
        indicator.stopAnimating()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToLogin" {
            if let destination = segue.destination as? LoginViewController {
                destination.email = textFieldEmail.text!
                destination.password = textFieldPassword.text!
            }
        }else if segue.identifier == "ToAppMainContent" {
            _ = segue.destination as? ProfileViewController
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

