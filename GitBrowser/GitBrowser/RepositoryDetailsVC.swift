//
//  RepositoryDetailsVC.swift
//  GitBrowser
//
//  Created by Surya
//  Copyright © 2019 Github. All rights reserved.
//


import UIKit
import WebKit

class RepositoryDetailsVC: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var imageView: UIImageView!
    
    var repoDetails: RepositoryDetailsViewModel? {
    didSet {
        debugPrint(repoDetails)
        if isViewLoaded {
            configureView()
        }
    }
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
   
    
    
    
    configureView()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

    private func configureView() {
       
    guard let repoDetails = repoDetails,
          let repoImageURL = repoDetails.avatarURL,
          let readMeUrl = repoDetails.readmeSourceURL else { return }
        nameLabel.text = repoDetails.userName
        NetworkManager().fetchAvatar(from: repoImageURL) { data in
            // this is not main
            DispatchQueue.main.async {
                if let data = data {
                    print(Thread.isMainThread)
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
        fetchAndLoadReadMe(readMeURL: readMeUrl)
  }
    
    
    private func fetchAndLoadReadMe(readMeURL: URL) {
        NetworkManager().fetchReadmeURL(from: readMeURL) { [weak self] newHTMLURL in
            guard let self = self,
                  let urlString = newHTMLURL else {return}
            DispatchQueue.main.async {
                let request = URLRequest(url: URL(string: urlString)!)
                self.webView.load(request)
            }
          
        }
      }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.height/2
    }
  
}
