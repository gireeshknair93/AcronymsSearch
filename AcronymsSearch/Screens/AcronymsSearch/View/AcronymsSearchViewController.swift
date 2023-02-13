//
//  AcronymsSearchViewController.swift
//  AcronymsSearch
//
//  Created by Gireesh on 11/02/23.
//

import UIKit

class AcronymsSearchViewController: UIViewController {
    
    @IBOutlet weak var acronymsSearchTableView: UITableView!
    @IBOutlet weak var searchInfoLabel: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    lazy var viewModel = {
        AcronymsSearchViewModel(acronymsSearchService: AcronymsSearchService())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initial UI setup
        initView()
        // Binding the search result to view
        viewModel.reloadAcronymsSearchResult = { [weak self] reloadMessage in
            self?.loader.isHidden = true
            if let reloadMessage = reloadMessage {
                self?.searchInfoLabel.isHidden = false
                self?.searchInfoLabel.text = reloadMessage
            } else {
                self?.searchInfoLabel.isHidden = true
            }
            self?.acronymsSearchTableView.reloadData()
        }
    }
    //Initial UI setup
    private func initView() {
        //Setting initial search info label message string
        searchInfoLabel.text = Messages.emptySearchField
        //Table setup
        acronymsSearchTableView.separatorStyle = .singleLine
        acronymsSearchTableView.allowsSelection = false
        acronymsSearchTableView.registerCell(identifier: AcronymsTableViewCell.identifier)
    }

}

//MARK: UITableView DataSource
extension AcronymsSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOrRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AcronymsTableViewCell.identifier, for: indexPath) as? AcronymsTableViewCell else { fatalError(Messages.xibLoadingError) }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        return cell
    }
}

//MARK: UITableView Delegate
extension AcronymsSearchViewController: UITableViewDelegate {
    //Setting the tableview height to auto dimension.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: SearchBar Delegate
extension AcronymsSearchViewController: UISearchBarDelegate {
    //Making the view model call each time when there is a text change
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        handleApiLoader(isAnimating: false)
        viewModel.getAcronymsFor(keyword: searchText) { [weak self] in
            self?.handleApiLoader(isAnimating: true)
        }
    }
    //Making the view model call when the user tap on the search button on keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        handleApiLoader(isAnimating: false)
        viewModel.getAcronymsFor(keyword: searchBar.text ?? "") { [weak self] in
            self?.handleApiLoader(isAnimating: true)
        }
    }
    //Show/Hide the loader
    //When isAnimating is true, will hide the loader else will show the loader
    func handleApiLoader(isAnimating: Bool) {
        self.loader.isHidden = isAnimating

    }
}

