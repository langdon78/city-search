//
//  ViewController.swift
//  city-search
//
//  Created by James Langdon on 10/31/18.
//  Copyright © 2018 corporatelangdon. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var cityManager: CityManager?
    var displayedCities: [City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = FileLoader.load()
        cityManager = CityManager(data: data)
        displayedCities = cityManager?.allCities ?? []
        tableView.reloadData()
    }


}

// MARK: - UITableView Data Source
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell") else { return UITableViewCell() }
        cell.textLabel?.text = displayedCities[indexPath.row].name
        return cell
    }
    
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            displayedCities = cityManager?.allCities ?? []
        } else {
            displayedCities = cityManager?.fetch(with: searchText) ?? []
        }
        tableView.reloadData()
    }

}
