//
//  RepositoriesListVC.swift
//  GitBrowser
//
//  Created by Prashant Rane
//  Copyright © 2019 prrane. All rights reserved.
//

import UIKit

class RepositoriesListVC: UITableViewController {

  private var detailViewController: RepositoryDetailsVC? = nil
  private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

  private var datasurce = [RepositoriesListViewModel]() {
    didSet {
      tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Setup UI, update datasource
    configureViewController()

    // Take care of split view
    if let split = splitViewController {

      let controllers = split.viewControllers
      guard controllers.count > 1, let detailViewController = (controllers[controllers.count-1] as? UINavigationController)?.topViewController as? RepositoryDetailsVC else {
        return
      }

      self.detailViewController = detailViewController
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? false
    super.viewWillAppear(animated)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

// MARK: - UI Setup

extension RepositoriesListVC {

  private func configureViewController() {

    // Configure table view
    configureTableView()
    
    // Setup activity indicator
    configureActivityIndicator()

    // Fetch datasource
    populateDatasource()
  }

  private func configureTableView() {
    tableView.register(RepositoryCell.nib, forCellReuseIdentifier: RepositoryCell.identifier)
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = RepositoryCell.estimatedHeight;
    tableView.tableFooterView = UIView()
  }

  private func configureActivityIndicator() {
    tableView.backgroundView = activityIndicator
    activityIndicator.startAnimating()
  }

  private func populateDatasource() {
    CacheManager.shared.repositoriesListViewModelDatasource { (datasource: [RepositoriesListViewModel]) in
      DispatchQueue.main.async { [weak self] in

        self?.activityIndicator.stopAnimating()

        guard !datasource.isEmpty else {
          let alert = UIAlertController(title: "Fetch Error", message: "Could not fetch starred projects list as of now, please try later.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
          self?.present(alert, animated: true, completion: nil)
          return
        }

        // Setup dataSource
        self?.datasurce = datasource
      }
    }
  }

}

// MARK: - UITableViewDataSource / Delegate

extension RepositoriesListVC {

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return datasurce.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.identifier, for: indexPath) as! RepositoryCell

    let repository = datasurce[indexPath.row]
    cell.name?.text = repository.repoName
    cell.stars?.text = "✩ \(repository.starsCount)"
    cell.details?.text = repository.details

    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: "showDetail", sender: tableView.cellForRow(at: indexPath))
  }
}

// MARK: - Segues

extension RepositoriesListVC {

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
      if let indexPath = tableView.indexPathForSelectedRow {
        let repository = datasurce[indexPath.row]
        let controller = (segue.destination as! UINavigationController).topViewController as! RepositoryDetailsVC
        controller.title = repository.repoName
        controller.repoDetails = CacheManager.shared.repositoryDetailsViewModel(for: repository.repositoryID)
        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        controller.navigationItem.leftItemsSupplementBackButton = true
      }
    }
  }

}
