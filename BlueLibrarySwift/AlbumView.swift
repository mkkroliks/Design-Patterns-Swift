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
        coverImage = UIImageView(frame: CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10))
        addSubview(coverImage)
        indicator = UIActivityIndicatorView()
        indicator.center = center //center -> UIView variable
        indicator.activityIndicatorViewStyle = .WhiteLarge
        indicator.startAnimating()
        addSubview(indicator)
    }
    
    func highlightAlbum(#didHighlighView:Bool) {
        if didHighlighView == true {
            backgroundColor = UIColor.whiteColor()
        } else {
            backgroundColor = UIColor.blackColor()
        }
    }
}
