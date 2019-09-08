//
//  ViewController.swift
//  CircularLoader
//
//  Created by Maksym Bondar on 9/2/19.
//  Copyright © 2019 Maksym Bondar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {

    /// Track layer.
    let trackLayer = CAShapeLayer()
    
    /// Animated layer.
    let shapeLayer = CAShapeLayer()
    
    /// Percentage label.
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    /// URL with string to download some image.
    let urlString = "https://www.google.com/logos/doodles/2017/vietnam-national-day-2017-4796763729821696-2x.png"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAnimateLayer()
    }
    
    private func setupAnimateLayer() {
        // Track layer
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2.0 * .pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.red.withAlphaComponent(0.25).cgColor
        trackLayer.lineWidth = 10
        trackLayer.lineCap = .round
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.position = view.center
        
        // Filled layer.
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.position = view.center
        shapeLayer.transform = CATransform3DMakeRotation(-.pi / 2, 0, 0, 1)
        
        //
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
        
        view.layer.addSublayer(trackLayer)
        view.layer.addSublayer(shapeLayer)
        view.addSubview(percentageLabel)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    /// De
    private func beginDownloadingFile() {
        shapeLayer.strokeEnd = 0
        
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        guard let url = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }

    fileprivate func animateCircle() {
        print("Animated circle")
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 1
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "animateStroke")
    }
    
    /// Handle tap gesture to perform animation.
    @objc private func handleTap() {
        beginDownloadingFile()
//        animateCircle()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        print("total bytes written \(totalBytesWritten) from \(totalBytesExpectedToWrite)")
        print("Percentage: \(percentage)")
        
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(percentage * 100))%"
            self.shapeLayer.strokeEnd = percentage
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished download")
    }

}

