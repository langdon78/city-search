//
//  LoadingViewController.swift
//  city-search
//
//  Created by James Langdon on 11/1/18.
//  Copyright © 2018 corporatelangdon. All rights reserved.
//

import UIKit

final class LoadingViewController: UIViewController {
    
    @IBOutlet var dotLabel: [UILabel]!
    @IBOutlet weak var dataFileLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentLabel: UILabel!
    
    let searchSegue = "showSearchSegue"
    
    var cityManager: CityRepository? {
        didSet {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: self.searchSegue, sender: nil)
            }
        }
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.isHidden = true
        percentLabel.isHidden = true
        animateDots()
        DispatchQueue.global().async {
            let data = FileLoader.load()
            self.cityManager = CityRepository(data: data, delegate: self)
        }
    }
    
    // Custom methods
    func animateDots() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat], animations: {
            let dot = self.dotLabel.first(where: { $0.tag == 3 })
            dot?.alpha = 0.0
        }, completion: nil)
        UIView.animate(withDuration: 1.0, delay: 0.8, options: [.repeat], animations: {
            let dot = self.dotLabel.first(where: { $0.tag == 2 })
            dot?.alpha = 0.0
        }, completion: nil)
        UIView.animate(withDuration: 1.0, delay: 1.6, options: [.repeat], animations: {
            let dot = self.dotLabel.first(where: { $0.tag == 1 })
            dot?.alpha = 0.0
        }, completion: nil)
    }
    
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let navigationController = segue.destination as? UINavigationController,
            let searchViewController = navigationController.topViewController as? SearchViewController else { return }
        searchViewController.cityManager = cityManager
    }
    
}

//MARK: - Progress Delegate methods
extension LoadingViewController: ProgressDelegate {
    
    func fileLoaded() {
        DispatchQueue.main.async { [weak self] in
            self?.dotLabel.forEach({ $0.isHidden = true })
            self?.imageLabel.isHidden = true
            self?.progressView.isHidden = false
            self?.percentLabel.isHidden = false
        }
    }
    
    func loadingDataTrie(_ percent: Float) {
        DispatchQueue.main.async { [weak self] in
            self?.showProgressBar(for: percent)

        }
    }
    
    private func showProgressBar(for percent: Float) {
        progressView.progress = percent
        percentLabel.text = "\(Int(percent * 100))%"
        switch percent {
        case 0..<0.30:
            dataFileLabel.text = "Optimizing Search Engine"
        case 0.30..<0.85:
            dataFileLabel.text = "Doing some other stuff"
        case 0.50...0.99:
            dataFileLabel.text = "Maybe grab a bite to eat"
        default:
            showFinalLoading()
            dataFileLabel.text = "Almost there!!!"
        }
    }
    
    private func showFinalLoading() {
        imageLabel.isHidden = false
        imageLabel.text = "😀"
        dotLabel.forEach({ $0.isHidden = false })
        animateDots()
        progressView.isHidden = true
        percentLabel.isHidden = true
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] timer in
            self?.imageLabel.text = "😴"
            timer.invalidate()
        }
        Timer.scheduledTimer(withTimeInterval: 6, repeats: false) { [weak self] timer in
            self?.imageLabel.text = "☠️"
            timer.invalidate()
        }
        Timer.scheduledTimer(withTimeInterval: 9, repeats: false) { [weak self] timer in
            self?.dataFileLabel.text = "AAGGHHH!"
            self?.imageLabel.text = "🧟‍♂️"
            timer.invalidate()
        }
    }
    
}
