//
//  Model.swift
//  GithubRepo
//
//  Created by Gilang Persada on 13/01/2022.
//

import Foundation

struct User:Codable{
    let login:String
    let avatar_url:String
    
    var avatar_data:Data? {
        if let url = URL(string: avatar_url){
            if let data = NSData(contentsOf: url){
//                print("download")
                return data as Data
            }
        }
        return nil
    }
}

struct Repository:Codable{
    let name:String
    let full_name:String
    let html_url:String
}
