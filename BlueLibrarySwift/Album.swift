//
//  Album.swift
//  BlueLibrarySwift
//
//  Created by Maciej Krolikowski on 07/02/15.
//  Copyright (c) 2015 Raywenderlich. All rights reserved.
//

import UIKit

class Album: NSObject {
    //MARK: we have to add ! sign to each property beacause we initialize super class without these all properties
    var title:String!
    var artist:String!
    var genre:String!
    var coverURL:String!
    var year:String!
    var dupa:String!
    
    init(title:String, artist:String, genre:String, coverURL:String, year:String) {
        
        //TODO: Why do we call super.init() does it has any use in that application
        super.init()
        
        self.title = title
        self.artist = artist
        self.genre = genre
        self.coverURL = coverURL
        self.year = year
    }
    
    func description() -> String {
        return "title: \(title)" +
        "artist: \(artist)" +
        "genre: \(genre)" +
        "coverURL: \(coverURL)" +
        "year: \(year)"
    }
}
