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
  
  var client: DropboxClient?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // Verify user is logged into Dropbox
    if let client = Dropbox.authorizedClient {
      self.client = client
      
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
  
  func showNetworkActivity(status: Bool) {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = status
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
  
  @IBAction func listFolderContents(sender: UIButton) {
    if let client = self.client {
      showNetworkActivity(true)
      self.client!.filesListFolder(path: "").response { response, error in
        self.showNetworkActivity(false)
        if let result = response {
          println("Folder contents:")
          for entry in result.entries {
            println(entry.name)
          }
        } else {
          println(error!)
        }
      }
    } else {
      println("client is not set")
    }
  }
  
  @IBAction func uploadAFile(sender: AnyObject) {
    if let client = self.client {
      let fileData = "Hello World!".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
      showNetworkActivity(true)
      client.filesUpload(path: "/hello.txt", body: fileData!).response { response, error in
        if let metadata = response {
          println("Uploaded file name: \(metadata.name)")
          println("Uploaded file revision: \(metadata.rev)")
          self.showNetworkActivity(false)
          
          // Get file (or folder) metadata
          self.showNetworkActivity(true)
          client.filesGetMetadata(path: "/hello.txt").response { response, error in
            self.showNetworkActivity(true)
            if let metadata = response {
              println("Name: \(metadata.name)")
              if let file = metadata as? Files.FileMetadata {
                println("This is a file.")
                println("File size: \(file.size)")
              } else if let folder = metadata as? Files.FolderMetadata {
                println("This is a folder.")
              }
            } else {
              println(error!)
            }
          }
        } else {
          println(error!)
        }
      }
    } else {
      println("client not set")
    }
  }
  
  @IBAction func downloadFile(sender: AnyObject) {
    if let client = self.client {
      // Download a file
      client.filesDownload(path: "/hello.txt").response { response, error in
        if let (metadata, data) = response {
          println("Dowloaded file name: \(metadata.name)")
          println("Downloaded file data: \(data)")
          var datastring = NSString(data:data, encoding:NSUTF8StringEncoding) as! String
          println("File contents: \(datastring)")
        } else {
          println(error!)
        }
      }
    } else {
      println("client not set")
    }
  }
}

