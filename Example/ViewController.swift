//
//  ViewController.swift
//  Example
//
//  Created by Khoi Lai on 2/27/18.
//  Copyright © 2018 StatsdClient. All rights reserved.
//

import UIKit
import StatsdClient

class ViewController: UIViewController {
    
    let statsD = StatsD(transport: HTTPTransport(endpoint: URL(string: "http://localhost:8127")!, configuration: .default))
    
    @IBOutlet weak var countBucketLabel: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func countPressed(_ sender: Any) {
        statusLabel.text = ""
        statsD.increment(countBucketLabel.text ?? "", by: 1) { (success) in
            DispatchQueue.main.async {
                self.statusLabel.text = "\(success)"
            }
        }
    }
    
}

