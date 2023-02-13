//
//  AcronymsSearchViewModel.swift
//  AcronymsSearch
//
//  Created by Gireesh on 11/02/23.
//

import Foundation

class AcronymsSearchViewModel {
    
    private var acronymsSearchService: AcronymsSearchProtocol
    var reloadAcronymsSearchResult: ((_ reloadMessage: String?) -> Void)?
    var acronymsCellViewModels = [AcronymsCellViewModel]()
    var timer: Timer?
    //Creating the search service object via depedency injection
    init(acronymsSearchService: AcronymsSearchProtocol) {
        self.acronymsSearchService = acronymsSearchService
    }
    
    //MARK: Acronyms API Call
    func getAcronymsFor(keyword: String, completion: @escaping()->Void) {
        timer?.invalidate()
        guard validateSearchInput(keyword: keyword) else {
            return
        }
        //Using timer bto fire the api call with a delay of 0.5 sec to reduce the frequency of api call
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] timer in
            let request = AcronymsSearchRequest(lf: "", sf: keyword)
            self?.acronymsSearchService.getAcronyms(request: request) { [weak self] acronyms, apiError in
                if let apiError = apiError {
                    self?.returnErrorMessage(error: apiError)
                    completion()
                    return
                }
                self?.fetchData(acronyms: acronyms)
                completion()
            }
        })
        
    }
    
    //MARK: API Response processing
    //Clearing the existing search results
    private func clearSearch() {
        acronymsCellViewModels = []
    }
    
    private func returnErrorMessage(error: ApiError) {
        clearSearch()
        reloadAcronymsSearchResult?(Messages.apiError)
    }
    //Processing the api result response and creating the cell models
    private func fetchData(acronyms: [AcronymsSearchResponseModel]?) {
        clearSearch()
        if let acronyms = acronyms?.first {
            var cellModels = [AcronymsCellViewModel]()
            for acronym in acronyms.lfs {
                cellModels.append(AcronymsCellViewModel(acronyms: acronym.lf))
            }
            acronymsCellViewModels = cellModels
            self.reloadAcronymsSearchResult?(nil)
        } else {
            self.reloadAcronymsSearchResult?(Messages.noResultFound)
        }
    }
    
    //MARK: Cell View Model
    //Return the number of search result to be shown
    func numberOrRows() -> Int {
        return self.acronymsCellViewModels.count
    }
    //Return the cell view model for the corresponding cell based on the indexpath
    func getCellViewModel(at indexPath: IndexPath) -> AcronymsCellViewModel {
        return acronymsCellViewModels[indexPath.row]
    }
    
}

extension AcronymsSearchViewModel {
    //MARK: Input Validation
    final func validateSearchInput(keyword: String)->Bool {
        guard !keyword.isEmpty else {
            clearSearch()
            self.reloadAcronymsSearchResult?(Messages.emptySearchField)
            return false
        }
        // Checking wether the input string is containing any numbers, special char etc
        // Validation fails if the input string is start with white space
        if keyword.isStartWithWhiteSpace || keyword.isStartWithNumber || keyword.containsSpecialCharacters {
            clearSearch()
            self.reloadAcronymsSearchResult?(Messages.invalidInput)
            return false
        } else {
            return true
        }
    }
}
