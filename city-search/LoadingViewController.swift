//
//  LoadingViewController.swift
//  city-search
//
//  Created by James Langdon on 11/1/18.
//  Copyright © 2018 corporatelangdon. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    @IBOutlet var dotLabel: [UILabel]!
    @IBOutlet weak var dataFileLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentLabel: UILabel!
    
    var cityManager: CityManager? {
        didSet {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "showSearchSegue", sender: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.isHidden = true
        percentLabel.isHidden = true
        animateDots()
        DispatchQueue.global().async {
            let data = FileLoader.load()
            self.cityManager = CityManager(data: data, delegate: self)
        }
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let navigationController = segue.destination as? UINavigationController,
            let searchViewController = navigationController.topViewController as? SearchViewController else { return }
        searchViewController.cityManager = cityManager
    }
}

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
            
            self?.progressView.progress = percent
            self?.percentLabel.text = "\(Int(percent * 100))%"
            switch true {
            case percent < 0.30:
                self?.dataFileLabel.text = "Optimizing Search Engine"
            case percent >= 0.30 && percent < 0.85:
                self?.dataFileLabel.text = "Doing stuff, you wouldn't get it"
            case percent >= 0.50 && percent < 0.99:
                self?.dataFileLabel.text = "Maybe grab a bite to eat"
            default:
                self?.dataFileLabel.text = "Almost there!!!"
            }
            if percent == 1.0 {
                self?.imageLabel.isHidden = false
                self?.imageLabel.text = "😀"
                self?.dotLabel.forEach({ $0.isHidden = false })
                self?.animateDots()
                self?.progressView.isHidden = true
                self?.percentLabel.isHidden = true
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
                    self?.imageLabel.text = "😴"
                    timer.invalidate()
                }
                Timer.scheduledTimer(withTimeInterval: 6, repeats: false) { timer in
                    self?.imageLabel.text = "☠️"
                    timer.invalidate()
                }
                Timer.scheduledTimer(withTimeInterval: 9, repeats: false) { timer in
                    self?.dataFileLabel.text = "AAGGHHH!"
                    self?.imageLabel.text = "🧟‍♂️"
                    timer.invalidate()
                }
            }
        }
    }
}
