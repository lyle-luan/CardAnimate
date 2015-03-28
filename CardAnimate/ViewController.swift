//
//  ViewController.swift
//  CardAnimate
//
//  Created by Aaron on 3/28/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    
    var initLocation = CGPoint()
    var currentView = UIView()
    lazy var viewArray: [UIView] = {
        [self.view1, self.view2, self.view3]
        }()
    var isTrigger = false
    
    override func viewDidLoad()
    {
        for index in 0..<viewArray.count
        {
            let view = viewArray[index]
            transformView(view, atIndex: index)
            view.layer.cornerRadius = 5
            view.layer.anchorPoint = CGPointMake(0.5, 2)
        }
        super.viewDidLoad()
    }

    func transformView(view: UIView, atIndex index: Int)
    {
        let offset = 1-0.1*Float(index)
        var transform3D = CATransform3DIdentity
        transform3D.m34 = -1.5/500
        transform3D = CATransform3DTranslate(transform3D, 0, CGFloat(-3*index), 0)
        transform3D = CATransform3DScale(transform3D, CGFloat(offset), 1, 1)
        transform3D = CATransform3DRotate(transform3D, -CGFloat(M_PI_4*0.1), 1, 0, 0)
        view.layer.transform = transform3D
        view.layer.opacity = Float(offset)
    }
    
    @IBAction func flipCard(panGesture: UIPanGestureRecognizer)
    {
        let location = panGesture.locationInView(view)
        if panGesture.state == .Began
        {
            initLocation = location
            currentView = viewArray[0]
            isTrigger = isLocationWithin(location)
        }
        
        if isTrigger
        {
            UIView.animateWithDuration(0.01, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.currentView.layer.transform = CATransform3DTranslate(self.currentView.layer.transform, self.calculatXTransform(location), 0, 0)
                }){if $0 {}}
            
            currentView.layer.transform = CATransform3DTranslate(currentView.layer.transform, calculatXTransform(location), 0, 0)
            currentView.layer.transform = CATransform3DRotate(currentView.layer.transform, -calculateZRotate(location), 0, 0, 1)
            initLocation = location
            
            if panGesture.state == .Ended ||
                panGesture.state == .Cancelled
            {
                if isLocationOut(location)
                {
                    dropCard(currentView)
                }
                else
                {
                    reset(currentView)
                }
            }
            
//            if isLocationOut(currentView.center)
//            {
//                reArrange(currentView)
//            }
        }
    }
    
    func calculatXTransform(location: CGPoint) -> CGFloat
    {
        return (location.x-initLocation.x)/2
    }
    
    func calculateZRotate(location: CGPoint) -> CGFloat
    {
        func angelTan(location: CGPoint) -> CGFloat
        {
            return (view4.frame.size.width/2-location.x)/(2*view4.frame.size.height-location.y)/2
        }
        return atan(angelTan(location))-atan(angelTan(initLocation))
    }
    
    func reArrange(view: UIView)
    {
        
    }
    
    func dropCard(view: UIView)
    {
        let tmpView = viewArray[0]
        viewArray[0] = viewArray[2];
        viewArray[2] = tmpView
        
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            for index in 0..<self.viewArray.count
            {
                let view = self.viewArray[index]
                self.transformView(view, atIndex: index)
            }
            }){if $0 {}}
    }
    
    func reset(view: UIView)
    {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.transformView(self.currentView, atIndex: 0)
            self.currentView.layer.transform = CATransform3DRotate(self.currentView.layer.transform, 0, 0, 0, 1)
            }){if $0 {}}
    }
    
    func isLocationWithin(location: CGPoint) -> Bool
    {
        let view = viewArray[0] as UIView
        let frame = view.frame
        return frame.contains(location)
    }
    
    func isLocationOut(location: CGPoint) -> Bool
    {
        let frame = view4.frame
        return !frame.contains(location)
//        return false
    }
}

