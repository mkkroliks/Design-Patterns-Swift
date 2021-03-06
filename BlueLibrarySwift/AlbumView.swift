//
//  AlbumView.swift
//  BlueLibrarySwift
//
//  Created by Maciej Krolikowski on 07/02/15.
//  Copyright (c) 2015 Raywenderlich. All rights reserved.
//

import UIKit

class AlbumView: UIView {
    
    //MARK: he have to add(but we won't use it) this method because UIView conforms to NSCoder
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        //TODO: Check if it will work
    }
    
    //MARK: Again we have to add ! sign because we not initialize super class with coverImage and indicator
    private let coverImage:UIImageView!
    private let indicator:UIActivityIndicatorView!
    
    init(frame: CGRect, albumCover: String) {
        //MARK: we are basically initialize only super view, because it has only(not our class) implemented methods which will display our AlbumView
        super.init(frame: frame)
        backgroundColor = UIColor.blackColor()
        //MARK: we place coverImage based on SuperView
        //here we resize Image is its to big
        coverImage = UIImageView(frame: CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10))
        addSubview(coverImage)
        indicator = UIActivityIndicatorView()
        indicator.center = center //center -> UIView variable
        indicator.activityIndicatorViewStyle = .WhiteLarge
        indicator.startAnimating()
        addSubview(indicator)
        
        coverImage.addObserver(self, forKeyPath: "image", options: nil, context: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("BLDownloadImageNotification", object: self, userInfo: ["imageView":coverImage, "coverUrl":albumCover])
    }
    
    //when value of coverImage(which during initialization is nil) will change this fuction will be called
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "image" {
            indicator.stopAnimating()
        }
    }
    
    func highlightAlbum(#didHighlighView:Bool) {
        if didHighlighView == true {
            backgroundColor = UIColor.whiteColor()
        } else {
            backgroundColor = UIColor.blackColor()
        }
    }
    //MARK:Remember that when we work with observers we have to unregister them durinig deinitialization
    deinit {
        coverImage.removeObserver(self, forKeyPath: "image")
    }
}
