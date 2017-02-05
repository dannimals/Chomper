//
//  DataExtensions.swift
//  Chomper
//
//  Created by Danning Ge on 2/5/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

extension Data {
    static func dataFromJson(file: String) -> Data! {
        class TestClass: NSObject { }
        let bundle = Bundle(for: TestClass.self)
        let path = bundle.path(forResource: file, ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        return data
    }
}
