//
//  LoginViewController.swift
//  SecondIphoneApp
//
//  Created by Wakamoly on 5/20/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController, UITextFieldDelegate {
    var email: String = ""
    var password: String = ""
    
    let URL_USER_LOGIN = URLConstants.URL_LOGIN
    let defaultValues = UserDefaults.standard
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBAction func buttonBackToRegister(_ sender: UIButton) {
        //switching the screen
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(registerViewController, animated: true)
        self.dismiss(animated: false,completion: nil)
    }
    @IBAction func buttonLogin(_ sender: UIButton) {
        if !(textFieldEmail.text==""&&textFieldPassword.text==""){
            login()
        }else{
            self.view.showToast(toastMessage: "Email and password fields must not be empty!", duration:2)
        }
    }
    
    func login(){
        let parameters: Parameters=["email":textFieldEmail.text!,
            "password":textFieldPassword.text!]
        AF.request(URL_USER_LOGIN, method: .post, parameters: parameters).responseJSON{
            response in
            //printing response
            print(response)
            
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                //self.labelMessage.text = jsonData["message"].string
                if (!((jsonData["error"].string != nil))) {
                    if (jsonData["error"]==false){
                        let userid = jsonData["userid"].int
                        let username = jsonData["username"].string
                        //print("Username = "+username!)
                        let nickname = jsonData["nickname"].string
                        let useremail = jsonData["email"].string
                        let profile_pic = jsonData["profilepic"].string
                        let blockedarray = jsonData["blockedarray"].string
                        //print("UserID = "+String(userid!))
                        self.defaultValues.set(String(userid!), forKey: "device_userid")
                        self.defaultValues.set(username, forKey: "device_username")
                        self.defaultValues.set(nickname, forKey: "device_nickname")
                        self.defaultValues.set(useremail, forKey: "device_email")
                        self.defaultValues.set(profile_pic, forKey: "device_profilepic")
                        self.defaultValues.set(blockedarray, forKey: "device_blockedarray")
                        
                        //switching the screen
                        self.performSegue(withIdentifier: "ToAppMainContent", sender: nil)
                    }else{
                        let message = jsonData["message"].string
                        self.view.showToast(toastMessage: message!, duration:2)
                    }
                }else{
                    self.view.showToast(toastMessage: "Network Error!", duration:2)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func loginFromRegister(_ email:String,_ password:String){
        let parameters: Parameters=["email":email,
            "password":password]
        AF.request(URL_USER_LOGIN, method: .post, parameters: parameters).responseJSON{
            response in
            //printing response
            print(response)
            
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                //self.labelMessage.text = jsonData["message"].string
                if (!((jsonData["error"].string != nil))) {
                    if (jsonData["error"]==false){
                        let userID = jsonData["id"].string
                        let username = jsonData["username"].string
                        let nickname = jsonData["nickname"].string
                        let useremail = jsonData["email"].string
                        let profile_pic = jsonData["profilepic"].string
                        let blockedarray = jsonData["blockedarray"].string
                        self.defaultValues.set(userID, forKey: "device_userid")
                        self.defaultValues.set(username, forKey: "device_username")
                        self.defaultValues.set(nickname, forKey: "device_nickname")
                        self.defaultValues.set(useremail, forKey: "device_email")
                        self.defaultValues.set(profile_pic, forKey: "device_profilepic")
                        self.defaultValues.set(blockedarray, forKey: "device_blockedarray")
                        
                        //switching the screen
                        /*let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                        self.navigationController?.pushViewController(profileViewController, animated: true)
                        self.dismiss(animated: false,completion: nil)*/
                        
                        self.performSegue(withIdentifier: "ToAppMainContent", sender: nil)
                    }else{
                        let message = jsonData["message"].string
                        self.view.showToast(toastMessage: message!, duration:2)
                    }
                }else{
                    self.view.showToast(toastMessage: "Network Error!", duration:2)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAppMainContent" {
            _ = segue.destination as? ProfileViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldEmail.delegate = self
        self.textFieldPassword.delegate = self
        //print(email+" "+password)
        if !(email==""&&password=="") {
            loginFromRegister(email, password)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

