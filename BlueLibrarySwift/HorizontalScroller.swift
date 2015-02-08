//
//  HorizontalScroller.swift
//  BlueLibrarySwift
//
//  Created by Maciej Krolikowski on 07/02/15.
//  Copyright (c) 2015 Raywenderlich. All rights reserved.
//

import UIKit

@objc protocol HorizontalScrollerDelegate {
    func numberOfViewsForHorizontalScroller(scroller: HorizontalScroller) -> Int
    func horizontalScrollerViewAtIndex(scroller: HorizontalScroller, index:Int) -> UIView
    func horizontalScrollerClickedViewAtIndex(scroller: HorizontalScroller, index:Int)
    optional func initialViewIndex(scroller: HorizontalScroller) -> Int
}

class HorizontalScroller: UIView {

    weak var delegate: HorizontalScrollerDelegate?
    private let VIEW_PADDING = 10
    private let VIEW_DIMENSIONS = 100
    private let VIEW_OFFSET = 100
    
    private var scroller : UIScrollView!
    
    var viewArray = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeScrollView()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeScrollView()
    }
    
    func initializeScrollView() {
        scroller = UIScrollView()
        addSubview(scroller)
        
        //MARK: Turn autoresizing mask so it will be able to apply own constraints
        scroller.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        //MARK: Appy constraints to scrollView. I want to scroll view to completely fill the HorizontalScroller
        //scroller.view = 1.0*self.view + 0.0 and we do it for every constraint side(.Leading, .Trailing, .Top, .Bottom)
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        
                                                 //target is recepient of action message(so class in which action method is implemented)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("scrollerTapped:"))
        //attach tapRecognizer to specific view
        scroller.addGestureRecognizer(tapRecognizer)
    }
    
    //MARK:Nice gesture recognizer example
    func scrollerTapped(gesture:UITapGestureRecognizer) {
        let location = gesture.locationInView(gesture.view)
        if let delegate = self.delegate {
            for index in 0..<delegate.numberOfViewsForHorizontalScroller(self) {
                let view = scroller.subviews[index] as UIView
                if CGRectContainsPoint(view.frame, location) {
                    delegate.horizontalScrollerClickedViewAtIndex(self, index: index)
                    scroller.setContentOffset(CGPointMake(view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, 0), animated: true)
                    break
                }
            }
        }
    }
    
    func viewAtIndex(index:Int) -> UIView {
        return viewArray[index]
    }
    
    func reload() {
        if let delegate = self.delegate {
            viewArray = []
            let views:NSArray = scroller.subviews
            
            views.enumerateObjectsUsingBlock {
                (object: AnyObject!, idx: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                object.removeFromSuperview()
            }
            
            var xValue = VIEW_OFFSET
            for index in 0..<delegate.numberOfViewsForHorizontalScroller(self) {
                xValue += VIEW_PADDING
                let view = delegate.horizontalScrollerViewAtIndex(self, index: index)
                //here we override view and place its frame accoring to xValue
                view.frame = CGRectMake(CGFloat(xValue), CGFloat(VIEW_PADDING), CGFloat(VIEW_DIMENSIONS), CGFloat(VIEW_DIMENSIONS))
                scroller.addSubview(view)
                xValue += VIEW_DIMENSIONS + VIEW_PADDING
                viewArray.append(view)
            }
            
            scroller.contentSize = CGSizeMake(CGFloat(xValue + VIEW_OFFSET), frame.size.height)
            
            if let initialView = delegate.initialViewIndex?(self) {
                scroller.setContentOffset(CGPointMake(CGFloat(initialView)*CGFloat((VIEW_DIMENSIONS + (2 * VIEW_PADDING))), 0), animated: true)
            }
        }
    }
    
    override func didMoveToSuperview() {
        reload()
    }
    
    //It will never be called. Something doesn't work 
    func centerCurrentView() {
        var xFinal = scroller.contentOffset.x + CGFloat((VIEW_OFFSET/2) + VIEW_PADDING)
        let viewIndex = xFinal / CGFloat((VIEW_DIMENSIONS + (2 * VIEW_PADDING)))
        xFinal = viewIndex * CGFloat(VIEW_DIMENSIONS + (2*VIEW_PADDING))
        scroller.setContentOffset(CGPointMake(xFinal, 0), animated: true)
        if let delegate = self.delegate {
            delegate.horizontalScrollerClickedViewAtIndex(self, index: Int(viewIndex))
        }
    }
}

extension HorizontalScroller: UIScrollViewDelegate {
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            centerCurrentView()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        centerCurrentView()
    }
}