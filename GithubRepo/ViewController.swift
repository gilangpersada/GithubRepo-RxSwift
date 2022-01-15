//
//  ViewController.swift
//  GithubRepo
//
//  Created by Gilang Persada on 13/01/2022.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //    private let githubManager = GithubManager()
    private let disposeBag = DisposeBag()
    let searchText = BehaviorRelay<String>(value: "")
    var userOberver = GithubManager.shared.getUsers().share()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Loading..."
        registerNib()
        
        searchBar.rx.text.orEmpty.distinctUntilChanged().debounce(.milliseconds(100), scheduler: MainScheduler.instance).subscribe { [weak self] (event) in
            if let element = event.element{
                self?.searchText.accept(element)
            }
        }.disposed(by: disposeBag)
        
        userOberver.subscribe { [weak self] (event) in
            if event.isCompleted{
                DispatchQueue.main.async {
                    self?.title = "Github Users"
                }
            }
        }.disposed(by: disposeBag)
        
        userOberver = Observable.combineLatest(userOberver, searchText).map{ users, search in
            search.isEmpty ? users :
            users.filter{
                user -> Bool in
                return user.login.lowercased().range(of: search,options: .caseInsensitive) != nil
            }
        }
        
        userOberver.bind(to: tableView.rx.items(cellIdentifier: "userCell", cellType: UserTableViewCell.self)){
            indexPath, user, cell in
            //            print(user.login)
            
            cell.nameLabel.text = user.login
            if let avatar_data = user.avatar_data{
                cell.avatarView.image = UIImage(data: avatar_data)
            }
        }.disposed(by: disposeBag)
        
        //        userOberver.bind(to: tableView.rx.items(cellIdentifier: "userCell", cellType: UserTableViewCell.self)){
        //            indexPath, user, cell in
        ////            print(user.login)
        //
        //            cell.nameLabel.text = user.login
        //            if let avatar_data = user.avatar_data{
        //                cell.avatarView.image = UIImage(data: avatar_data)
        //            }
        //        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(User.self).subscribe { [weak self] (event) in
            if let user = event.element{
                let repoVC = RepoViewController(user: user.login)
                repoVC.title = "Loading..."
                //            repoVC.user = event.element?.login
                self?.navigationController?.pushViewController(repoVC, animated: true)
            }
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe { [weak self] (event) in
            if let indexPath = event.element{
                //                let cell = self?.tableView.cellForRow(at: indexPath)
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }
        }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.searchBar.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchBar.resignFirstResponder()
        self.searchText.accept("")
    }
    
    func registerNib(){
        let userNib = UINib(nibName: "UserTableViewCell", bundle: nil)
        tableView.register(userNib, forCellReuseIdentifier: "userCell")
    }
    
    
}

