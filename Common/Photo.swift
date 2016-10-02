//
//  Photo.swift
//  Chomper
//
//  Created by Danning Ge on 9/25/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

public struct Photo {
    public var id = ""
    public var width = 0
    public var height = 0
    public var url = ""
    
    public init(id: String, width: Int, height: Int, url: String) {
        self.id = id
        self.width = width
        self.height = height
        self.url = url
    }
}