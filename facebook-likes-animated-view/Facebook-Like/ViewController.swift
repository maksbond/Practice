//
//  ViewController.swift
//  Facebook-Like
//
//  Created by Maksym Bondar on 8/19/19.
//  Copyright © 2019 Maksym Bondar. All rights reserved.
//

import UIKit

/// Enum with all emoji types.
enum Emoji: String, CaseIterable {
    case like, love, haha, wow, sad, angry
    
    typealias AllCases = [Emoji]
}

class ViewController: UIViewController {
    
    /// Container with image views for likes.
    let containerViewLikes: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        let padding: CGFloat = 6
        let height: CGFloat = 38
        let likeViews =  Emoji.allCases.map({ name -> UIImageView in
            guard let image = UIImage(named: name.rawValue) else {
                return UIImageView()
            }
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = height / 2
            imageView.isUserInteractionEnabled = true
            return imageView
        })
        
        let stackView = UIStackView(arrangedSubviews: likeViews)
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        let width = CGFloat(Emoji.allCases.count) * height + (CGFloat(Emoji.allCases.count) + 1) * padding
        containerView.addSubview(stackView)
        containerView.frame = CGRect(x: 0, y: 0, width: width, height: height + 2 * padding)
        stackView.frame = containerView.frame
        
        containerView.layer.cornerRadius = containerView.frame.height / 2
        containerView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        containerView.layer.shadowRadius = padding
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: padding / 2)
        
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLongPressGesture()
    }
    
    private func setupView() {
        view.backgroundColor = .blue
    }
    
    /// setup Long press gesture recognizer
    private func setupLongPressGesture() {
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:))))
    }

    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            handleLongPressBegan(gesture)
        } else if gesture.state == .ended {
            handleLongPressEnded(gesture)
        } else if gesture.state == .changed {
            handleLongPressChanged(gesture)
        }
    }
    
    /// Add likes view to superview with animation.
    private func handleLongPressBegan(_ gesture: UILongPressGestureRecognizer) {
        let positionOfPress = gesture.location(in: view)
        let centerX = (view.frame.width - containerViewLikes.frame.width) / 2
        
        view.addSubview(containerViewLikes)
        containerViewLikes.transform = CGAffineTransform(translationX: centerX, y: positionOfPress.y)
        containerViewLikes.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.containerViewLikes.alpha = 1.0
            self.containerViewLikes.transform = CGAffineTransform(translationX: centerX, y: positionOfPress.y - self.containerViewLikes.frame.height)
        })
    }
    
    /// Remove likes view from superview with animation.
    private func handleLongPressEnded(_ gesture: UILongPressGestureRecognizer) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.containerViewLikes.alpha = 0.0
            /// Clean up animations
            let stackView = self.containerViewLikes.subviews.first
            stackView?.subviews.forEach({ imageView in
                imageView.transform = .identity
            })
            self.containerViewLikes.transform = self.containerViewLikes.transform.translatedBy(x: 0, y: self.containerViewLikes.frame.height)
        }) { _ in
            self.containerViewLikes.removeFromSuperview()
        }
    }
    
    private func handleLongPressChanged(_ gesture: UILongPressGestureRecognizer) {
        let positionOfPress = gesture.location(in: containerViewLikes)
        
        let fixedContainerYLocation = CGPoint(x: positionOfPress.x, y: containerViewLikes.frame.height / 2)
        
        let hitView = containerViewLikes.hitTest(fixedContainerYLocation, with: nil)
        
        if hitView is UIImageView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.containerViewLikes.subviews.first
                stackView?.subviews.forEach({ imageView in
                    imageView.transform = .identity
                })
                hitView?.transform = CGAffineTransform(translationX: 0, y: -self.containerViewLikes.frame.height)
            })
        }
    }
    
}

