//
//  Album.swift
//  BlueLibrarySwift
//
//  Created by Maciej Krolikowski on 07/02/15.
//  Copyright (c) 2015 Raywenderlich. All rights reserved.
//

import UIKit

class Album: NSObject, NSCoding {
    //MARK: we have to add ! sign to each property beacause we initialize super class without these all properties
    var title:String!
    var artist:String!
    var genre:String!
    var coverURL:String!
    var year:String!
    
    //MARK: writing decodeObjectForKey with camel notation such as coverURL won't work it has to be cover_url
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.title = aDecoder.decodeObjectForKey("title") as String?
        self.artist = aDecoder.decodeObjectForKey("artist") as String?
        self.genre = aDecoder.decodeObjectForKey("genre") as String?
        self.coverURL = aDecoder.decodeObjectForKey("cover_url") as String?
        self.year = aDecoder.decodeObjectForKey("year") as String?
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(artist, forKey: "artist")
        aCoder.encodeObject(genre, forKey: "genre")
        aCoder.encodeObject(coverURL, forKey: "cover_url")
        aCoder.encodeObject(year, forKey: "year")
    }
    
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
