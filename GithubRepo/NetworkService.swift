//
//  NetworkService.swift
//  GithubRepo
//
//  Created by Gilang Persada on 13/01/2022.
//

import Foundation
import RxSwift

class NetworkService{
    
    func fetch<T:Decodable>(url:URL) -> Observable<T>{
        
        return Observable.create { (observer) -> Disposable in
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                guard let data = data, let decoded = try? JSONDecoder().decode(T.self, from: data) else {
                    return
                }
                observer.onNext(decoded)
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create{
                task.cancel()
            }
        }
    }
    
}
