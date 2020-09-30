//
//  RepositoryDetailsVC.swift
//  GitBrowser
//
//  Created by Prashant Rane
//  Copyright © 2019 prrane. All rights reserved.
//

import UIKit
import WebKit

class RepositoryDetailsVC: UIViewController {

  var repoDetails: RepositoryDetailsViewModel? {
    didSet {
      // FIXME: use this details to populate detail view
      debugPrint(repoDetails)
      configureView()
    }
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Update UI as per model data
    configureView()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  private func configureView() {
  }
  
}
