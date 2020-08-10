//
//  AboutUsController.swift
//  Sabot Community
//
//  Created by Will Murphy on 8/10/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

// Some resources listed are not used on the iOS app. Do we still want to credit them or remove them? Will not add hyperlinking until full list is determined. Links for PP and TC are added. 

import UIKit
import SafariServices


class AboutUsController: UIViewController {
    
    @IBAction func ppTap(_ sender: Any) {
        showAboutWeb(for: "https://app.termly.io/document/privacy-policy/96bf5c01-d39b-496c-a30e-57353b49877c")
        print ("Opening Privacy Policy")
    }
    
    @IBAction func tcTap(_ sender: Any) {
        showAboutWeb(for: "https://sabotcommunity.com/termsandconditions.php")
        print ("Opening Terms and Conditions")
    }
    

    func showAboutWeb(for url: String) {
        guard let url = URL(string: url) else {
            self.view.showToast(toastMessage: "Error - Invalid URL!", duration:2)
            return
        }
        
        let privacyPolicy = SFSafariViewController(url: url)
        present(privacyPolicy, animated: true)
    }
    
}
