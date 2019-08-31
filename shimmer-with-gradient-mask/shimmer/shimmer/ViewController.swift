//
//  ViewController.swift
//  shimmer
//
//  Created by Maksym Bondar on 8/31/19.
//  Copyright © 2019 Maksym Bondar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let darkTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Shimmer"
        label.textColor = UIColor(white: 1, alpha: 0.2)
        label.font = UIFont.systemFont(ofSize: 80)
        label.textAlignment = .center
        return label
    }()
    
    let shinyTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Shimmer"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 80)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        darkTextLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2)
        shinyTextLabel.frame = darkTextLabel.frame
        view.addSubview(darkTextLabel)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.frame = darkTextLabel.frame
        
        let angle: CGFloat = 45.0 * .pi / 180.0
        gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -view.frame.width
        animation.toValue = view.frame.width
        animation.duration = 2
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "animation translation")
        
        shinyTextLabel.layer.mask = gradientLayer
        view.addSubview(shinyTextLabel)
    }


}

