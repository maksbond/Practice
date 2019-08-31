//
//  ViewController.swift
//  CustomCountingLabel
//
//  Created by Maksym Bondar on 8/29/19.
//  Copyright © 2019 Maksym Bondar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let countingLabel: UILabel = {
        let label = UILabel()
        label.text = "1234"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(countingLabel)
        countingLabel.frame = view.frame
        
        let displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink.add(to: .main, forMode: .default)
    }
    
    var startValue: Double = 0
    let endValue: Double = 1000
    let animationDuration = 1.5
    
    let animationStartDate = Date()
    
    @objc func handleUpdate() {
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        
        if elapsedTime > animationDuration {
            countingLabel.text = "\(endValue)"
        } else {
            let percentage = elapsedTime / animationDuration
            let value = startValue + percentage * (endValue - startValue)
            countingLabel.text = "\(value)"
        }
    }

}

