//
//  RepositoryCell.swift
//  GitBrowser
//
//  Created by Prashant Rane
//  Copyright © 2019 prrane. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var stars: UILabel!
  @IBOutlet weak var details: UILabel!

  static let estimatedHeight: CGFloat = 90.0
  static let identifier = "RepositoryCell"
  static let nib = UINib(nibName: "RepositoryCell", bundle: Bundle.main)
  
  // FIXME: implement prepareForReuse method properly
  override func prepareForReuse() {
    super.prepareForReuse()
  }
}
