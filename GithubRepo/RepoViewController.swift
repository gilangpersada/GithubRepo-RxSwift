//
//  RepoViewController.swift
//  GithubRepo
//
//  Created by Gilang Persada on 14/01/2022.
//

import UIKit
import RxSwift
import RxCocoa

class RepoViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    var user:String
    let searchText = BehaviorRelay<String>(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        
        var reposObserver = GithubManager.shared.getUserRepos(user: user).share()
        
        
        searchBar.rx.text.orEmpty.distinctUntilChanged().debounce(.milliseconds(100), scheduler: MainScheduler.instance).subscribe { [weak self] (event) in
            if let element = event.element{
                self?.searchText.accept(element)
            }
        }.disposed(by: disposeBag)
        
        reposObserver.subscribe { [weak self] (event) in
            if event.isCompleted{
                DispatchQueue.main.async {
                    self?.title = self?.user
                }
            }
        }.disposed(by: disposeBag)
        
        reposObserver = Observable.combineLatest(reposObserver, searchText).map{ repos, search in
            search.isEmpty ? repos :
            repos.filter{
                repo -> Bool in
                return repo.name.lowercased().range(of: search,options: .caseInsensitive) != nil
            }
        }
        
        reposObserver.bind(to: tableView.rx.items(cellIdentifier: "repoCell", cellType: RepoTableViewCell.self)){
            indexPath, repo, cell in
            cell.nameLabel.text = repo.name
            cell.fullNameLabel.text = repo.full_name
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Repository.self).subscribe { [weak self] (event) in
            if let repo = event.element{
                let webVC = WebViewController(url: repo.html_url)
                self?.navigationController?.pushViewController(webVC, animated: true)
            }
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe { [weak self] (event) in
            if let indexPath = event.element{
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }
        }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchBar.resignFirstResponder()
        self.searchBar.text = ""
        self.searchText.accept("")
    }
    
    init(user:String){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registerNib(){
        let repoNib = UINib(nibName: "RepoTableViewCell", bundle: nil)
        tableView.register(repoNib, forCellReuseIdentifier: "repoCell")
    }
    
    
    
}
