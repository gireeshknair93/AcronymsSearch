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
    
    private func initView() {
        searchInfoLabel.text = Messages.emptySearchField
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AcronymsTableViewCell.identifier, for: indexPath) as? AcronymsTableViewCell else { fatalError("xib does not exists") }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        return cell
    }
}

//MARK: UITableView Delegate
extension AcronymsSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: SearchBar Delegate
extension AcronymsSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        handleApiLoader(isAnimating: false)
        viewModel.getAcronymsFor(keyword: searchText) { [weak self] in
            self?.handleApiLoader(isAnimating: true)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        handleApiLoader(isAnimating: false)
        viewModel.getAcronymsFor(keyword: searchBar.text ?? "") { [weak self] in
            self?.handleApiLoader(isAnimating: true)
        }
    }
    
    func handleApiLoader(isAnimating: Bool) {
        self.loader.isHidden = isAnimating

    }
}

