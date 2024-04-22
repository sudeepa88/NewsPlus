//
//  ViewController.swift
//  NewsApp
//
//  Created by Sudeepa Pal on 19/04/24.
//

import UIKit
import SafariServices
// TableView
// Custom cell
// Api caller
// Open the news story
// Search for the news story 

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "News"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        APICaller.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
               // break
                self?.articles = articles 
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        subtitle: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
                
            case .failure(let error):
                print(error)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    
    
    
// MARK:  ALL the functions of table view is here
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        //cell.textLabel?.text = "Something"
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //let viewModel = viewModels[indexPath.row]
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

}

