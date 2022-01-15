//
//  RepositoryManager.swift
//  GithubRepo
//
//  Created by Gilang Persada on 13/01/2022.
//

import Foundation
import RxSwift

class GithubManager{
    private let networkService = NetworkService()
    private let baseUrl = "https://api.github.com"
    static let shared = GithubManager()
    
    func getUsers() -> Observable<[User]>{
        guard let url = URL(string: baseUrl + "/users") else {return Observable.empty()}
        return networkService.fetch(url: url)
    }
    
    func getUserRepos(user:String) -> Observable<[Repository]>{
        guard let url = URL(string: baseUrl + "/users/\(user)/repos") else {return Observable.empty()}
        return networkService.fetch(url: url)
    }
    
}
