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

class UserListViewController: UIViewController {
    
    var query: String = ""
    var queryID: String = ""
    let defaultValues = UserDefaults.standard
    let deviceusername = UserDefaults.standard.string(forKey: "device_username")!
    let deviceuserid = UserDefaults.standard.string(forKey: "device_userid")!
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Query: "+query+" QueryID: "+queryID)
        
        switch query {
        case "connections":
            self.navigationController?.title = "Connections"
            break
        case "followers":
            self.navigationController?.title = "Followers"
            break
        case "following":
            self.navigationController?.title = "Following"
            break
        case "comment":
            self.navigationController?.title = "Comment Likes"
            break
        case "post":
            self.navigationController?.title = "Post Likes"
            break
        default:
            self.navigationController?.title = "Error!"
            break
        }
        
        self.indicator.startAnimating()
        getQuery()
    }
    
    func getQuery(){
        AF.request(URLConstants.ROOT_URL+"user_list_query.php?queryid="+queryID+"&query="+query+"&userid="+deviceuserid+"&deviceusername="+deviceusername, method: .get).responseJSON{
            response in
            //printing response
            print(response)
            
            switch response.result {
            case .success(let value):
                let jsonObject = JSON(value)
//                for i in 0..<jsonObject.count{
//                    let jsonData = jsonObject[i]
//                    self.profileNews.append(ProfileNewsModel(
//                        id: jsonData["id"].int,
//                        type: jsonData["type"].string,
//                        likes: jsonData["likes"].rawString(),
//                        body: jsonData["body"].rawString(),
//                        added_by: jsonData["added_by"].rawString(),
//                        user_to: jsonData["user_to"].rawString(),
//                        date_added: jsonData["date_added"].rawString(),
//                        user_closed: jsonData["user_closed"].rawString(),
//                        deleted: jsonData["deleted"].rawString(),
//                        image: jsonData["image"].rawString(),
//                        user_id: jsonData["user_id"].rawString(),
//                        profile_pic: jsonData["profile_pic"].rawString(),
//                        verified: jsonData["verified"].rawString(),
//                        online: jsonData["online"].rawString(),
//                        nickname: jsonData["nickname"].rawString(),
//                        username: jsonData["username"].rawString(),
//                        commentcount: jsonData["commentcount"].rawString(),
//                        likedbyuser: jsonData["likedbyuseryes"].rawString(),
//                        form: jsonData["form"].rawString(),
//                        edited: jsonData["edited"].rawString()))
//                }
                //displaying data in tableview
//                self.profilePostsTableView.reloadData()
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
 
}
