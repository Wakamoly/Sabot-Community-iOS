//
//  UserListViewController.swift
//  Sabot Community
//
//  Created by Wakamoly on 8/5/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class UserListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var query: String = ""
    var queryID: String = ""
    var toProfileID:String = ""
    let defaultValues = UserDefaults.standard
    let deviceusername = UserDefaults.standard.string(forKey: "device_username")!
    let deviceuserid = UserDefaults.standard.string(forKey: "device_userid")!
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    @IBOutlet weak var userListTableView: UITableView!
    
    
    private var userListResult = [UserListModel]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //type of query, set title of navigation controller (doesn't work for some reason)
        switch query {
        case "connections":
            self.navigationItem.title = "Connections"
            break
        case "followers":
            self.navigationItem.title = "Followers"
            break
        case "following":
            self.navigationItem.title = "Following"
            break
        case "comment":
            self.navigationItem.title = "Comment Likes"
            break
        case "post":
            self.navigationItem.title = "Post Likes"
            break
        default:
            self.navigationItem.title = "Error!"
            break
        }
        
        //start loading indicator
        indicator.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        self.indicator.isOpaque = false
        self.indicator.layer.cornerRadius = 05
        self.indicator.backgroundColor = (UIColor .black .withAlphaComponent(0.6))
        self.indicator.startAnimating()
        
        //setting up post table view
        userListTableView.dataSource = self
        userListTableView.delegate = self
        
        //start query from server
        getQuery()
    }
    
    func getQuery(){
        AF.request(URLConstants.ROOT_URL+"user_list_query.php?queryid="+queryID+"&query="+query+"&userid="+deviceuserid+"&deviceusername="+deviceusername, method: .get).responseJSON{
            response in
            //printing response
            //print(response)
            
            switch response.result {
            case .success(let value):
                let jsonObject = JSON(value)
                for i in 0..<jsonObject.count{
                    let jsonData = jsonObject[i]
                    self.userListResult.append(UserListModel(
                        id: jsonData["id"].int,
                        user_id: jsonData["user_id"].rawString(),
                        profile_pic: jsonData["profile_pic"].rawString(),
                        nickname: jsonData["nickname"].rawString(),
                        username: jsonData["username"].rawString(),
                        verified: jsonData["verified"].rawString(),
                        online: jsonData["online"].rawString(),
                        desc: jsonData["desc"].rawString()))
                }
                //displaying data in tableview
                self.userListTableView.reloadData()
                self.indicator.stopAnimating()
            case let .failure(error):
                print(error)
                self.indicator.stopAnimating()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Profile posts table view
    
    
    ///the method returning size of the list
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return userListResult.count
    }
    
    ///handling cell view for table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userListCell") as! UserListTVC
        
        //getting the list result for the specified position
        let userListResultI: UserListModel
        userListResultI = userListResult[indexPath.row]
        
        //displaying values
        cell.username.text = "@"+userListResultI.username!
        cell.nickname.text = userListResultI.nickname
        cell.desc.text = userListResultI.desc
        
        if userListResultI.online == "yes"{
            cell.online.isHidden = false
            cell.online.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0).cgColor
            cell.online.layer.masksToBounds = true
            cell.online.contentMode = .scaleToFill
            cell.online.layer.borderWidth = 1
        }else{
            cell.online.isHidden = true
        }
        if userListResultI.verified == "yes"{
            cell.verified.isHidden = false
        }else{
            cell.verified.isHidden = true
        }
        
        let profilePicIndex = userListResultI.profile_pic?.firstIndex(of: ".")!
        let profile_pic = (userListResultI.profile_pic?.prefix(upTo: profilePicIndex!))!+"_r.JPG"
        cell.profileImage.af.setImage(
            withURL: URL(string:URLConstants.BASE_URL+profile_pic)!,
            imageTransition: .crossDissolve(0.2)
        )
        
        return cell
    }
    
    ///handling cell view taps
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //getting the list result for the specified position
        let userListResultI: UserListModel
        userListResultI = userListResult[indexPath.row]
        
        toProfileID = userListResultI.user_id!
        performSegue(withIdentifier: "loadUserProfile", sender: nil)
        
    }
    
    ///number of sections in table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    //Segue handling
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loadUserProfile" {
            if let destination = segue.destination as? ProfileViewController {
                destination.userProfileID = toProfileID
            }
        }
    }
 
}
