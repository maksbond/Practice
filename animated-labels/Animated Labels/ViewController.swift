//
//  ViewController.swift
//  Animated Labels
//
//  Created by Maksym Bondar on 8/20/19.
//  Copyright © 2019 Maksym Bondar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // UI Elements
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    private var isAnimating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUILabel()
        setupStackView()
    
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }
    
    /// Setup UI labels for showing at stack view.
    fileprivate func setupUILabel() {
        titleLabel.text = "Welcome to my company"
        bodyLabel.text = "Hello there! It is interesting animation for UILabels."
        
        titleLabel.font = UIFont(name: "Futura", size: 34)
        titleLabel.numberOfLines = 0
        bodyLabel.numberOfLines = 0
    }

    /// Setup stack view at view.
    fileprivate func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
    }
    
    /// Handle tap gesture to create animation for UILabels.
    @objc fileprivate func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        if !isAnimating {
            isAnimating = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.titleLabel.transform = CGAffineTransform(translationX: -30, y: 0)
            }) { _ in
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.titleLabel.alpha = 0
                    self.titleLabel.transform = self.titleLabel.transform.translatedBy(x: 0, y: -self.view.center.y)
                }) { _ in
                    UIView.animate(withDuration: 0, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        self.titleLabel.alpha = 1
                        self.titleLabel.transform = .identity
                    })
                }
            }
            
            UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.bodyLabel.transform = CGAffineTransform(translationX: -30, y: 0)
            }) { _ in
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.bodyLabel.alpha = 0
                    self.bodyLabel.transform = self.titleLabel.transform.translatedBy(x: 0, y: -self.view.center.y)
                }) { _ in
                    UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        self.bodyLabel.alpha = 1
                        self.bodyLabel.transform = .identity
                    }) { _ in
                        self.isAnimating = false
                    }
                }
            }
        }
    }

}

