//
//  LibraryAPI.swift
//  BlueLibrarySwift
//
//  Created by Maciej Krolikowski on 07/02/15.
//  Copyright (c) 2015 Raywenderlich. All rights reserved.
//

import UIKit

class LibraryAPI: NSObject {
    //MARK: Computed variable will be initialized only when it will be used
    class var sharedInstance: LibraryAPI{
        struct Singleton {
            //MARK static works the same way like class var in class(we can call variable/method without creating structure). Declaring as STATIC also means that property only exists once and is implicitly lazy, which means that Instance is not created until it's needed. Also it's is constant property->once this instance is created it's not goint to create it a second time.
            static let instance = LibraryAPI()
        }
        return Singleton.instance
    }
    
    private let httpClient:HTTPClient
    private let persistencyManager:PersistencyManager
    private let isOnline:Bool
    
    override init() {
        persistencyManager = PersistencyManager()
        httpClient = HTTPClient()
        isOnline = false
        
        //MARK:We con't have to add ! sign to properties when we initialize super class at the end of init method rather than at the beginning
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "downloadImage:", name: "BLDownloadImageNotification", object: nil)
    }
    
    func getAlbums() -> [Album] {
        return persistencyManager.getAlbums()
    }
    
    func addAlbum(album:Album, index:Int) {
        persistencyManager.addAlbum(album, index: index)
        if isOnline {
            httpClient.postRequest("/api/addAlbum", body: album.description())
        }
    }
    
    func deleteAlbum(index:Int) {
        persistencyManager.deleteAlbumAtIndex(index)
        if isOnline {
            httpClient.postRequest("/api/deleteAlbum", body: "\(index)")
        }
    }
    
    func saveAlbums() {
        persistencyManager.saveAlbums()
    }
    
    func downloadImage(notification: NSNotification) {
        let userInfo = notification.userInfo as [String: AnyObject]
        var imageView = userInfo["imageView"] as UIImageView?
        var coverUrl = userInfo["coverUrl"] as NSString
        
        if let imageViewUnWrapped = imageView {
            imageViewUnWrapped.image = persistencyManager.getImage(coverUrl.lastPathComponent)
            if imageViewUnWrapped.image == nil {
                //instruction(block of code) will be added to dispatch_get_global_queue and executed asynchronously
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    let downloadedImage = self.httpClient.downloadImage(coverUrl)
                    
                    //alternative to performSelectorOnMainThread from objective-c
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        imageViewUnWrapped.image = downloadedImage
                        self.persistencyManager.saveImage(downloadedImage, filename: coverUrl.lastPathComponent)
                    })
                })
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
