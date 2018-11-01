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
        displayedCities = cityManager?.allCities ?? []
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mapViewController = segue.destination as? MapViewController,
        let indexPath = sender as? IndexPath else { return }
        mapViewController.coordinates = displayedCities[indexPath.row].coord
    }
}

// MARK: - UITableView Data Source
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell") else { return UITableViewCell() }
        cell.textLabel?.text = displayedCities[indexPath.row].fullName
        cell.detailTextLabel?.text = displayedCities[indexPath.row].coordinates
        return cell
    }
    
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cityManager?.executeFetchTask(with: searchText) { [weak self] cities in
            guard let cities = cities else { return }
            self?.handleDisplay(for: cities)
        }
    }
    
    fileprivate func handleDisplay(for cities: [City]) {
        DispatchQueue.main.async { [weak self] in
            self?.displayedCities = cities
            self?.tableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "mapSegue", sender: indexPath)
    }
}
