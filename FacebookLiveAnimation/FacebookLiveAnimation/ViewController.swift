//
//  ViewController.swift
//  FacebookLiveAnimation
//
//  Created by Maksym Bondar on 10/6/19.
//  Copyright © 2019 Maksym Bondar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let curvedView = CurvedView(frame: view.frame)
        curvedView.backgroundColor = .yellow
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc func handleTap() {
        (0...10).forEach { _ in
            drawAnimatedView()
        }
    }
    
    fileprivate func drawAnimatedView() {
        let image = drand48() > 0.5 ? #imageLiteral(resourceName: "love") : #imageLiteral(resourceName: "like")
        let imageViewEmoji = UIImageView(image: image)
        let dimension = 20 + drand48() * 10
        imageViewEmoji.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
       
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            imageViewEmoji.removeFromSuperview()
        })
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = customPath().cgPath
        animation.duration = 2.0 + drand48() * 3
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunctions = [CAMediaTimingFunction(name: .easeOut)]
        imageViewEmoji.layer.add(animation, forKey: nil)

        CATransaction.commit()
        view.addSubview(imageViewEmoji)
    }

}

func customPath() -> UIBezierPath {
    let path = UIBezierPath()
    
    path.move(to: CGPoint(x: 0, y: 200))
    let endPoint = CGPoint(x: 420, y: 200)
    let randomYShift = 200 + drand48() * 300
    let cp1 = CGPoint(x: 100, y: 100 - randomYShift)
    let cp2 = CGPoint(x: 200, y: 300 + randomYShift)
    path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
    
    return path
}

class CurvedView: UIView {
    override func draw(_ rect: CGRect) {
        let path = customPath()
        path.lineWidth = 3.0
        
        path.stroke()
    }
}
