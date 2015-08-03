//
//  ViewController.swift
//  Scriv
//
//  Created by Kenneth Wilcox on 8/2/15.
//  Copyright (c) 2015 Kenneth Wilcox. All rights reserved.
//

import UIKit
import SwiftyDropbox

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // Verify user is logged into Dropbox
    if let client = Dropbox.authorizedClient {
      
      // Get the current user's account info
      client.usersGetCurrentAccount().response { response, error in
        if let account = response {
          println("Hello \(account.name.givenName)")
        } else {
          println(error!)
        }
      }
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func linkToDropbox(sender: UIButton) {
    if (Dropbox.authorizedClient == nil) {
      Dropbox.authorizeFromController(self)
    } else {
      print("User is already authorized!")
    }
  }

}

