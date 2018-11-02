//
//  ViewController.swift
//  city-search
//
//  Created by James Langdon on 10/31/18.
//  Copyright © 2018 corporatelangdon. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let cityCellName = "cityCell"
    let mapSegueName = "mapSegue"
    
    var cityManager: CityRepository?
    var displayedCities: [City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayedCities = cityManager?.allCities ?? []
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mapViewController = segue.destination as? MapViewController,
        let indexPath = sender as? IndexPath else { return }
        mapViewController.city = displayedCities[indexPath.row]
    }
    
}

//MARK: - UIScrollViewDelegate
extension SearchViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cityCellName) else { return UITableViewCell() }
        let city = displayedCities[indexPath.row]
        cell.textLabel?.text = city.fullName
        cell.detailTextLabel?.text = city.coordinates
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: mapSegueName, sender: indexPath)
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
