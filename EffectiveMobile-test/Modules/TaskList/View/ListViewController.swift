//
//  ListViewController.swift
//  EffectiveMobile-test
//
//  Created by Владислав Перелыгин on 30/09/2025.
//


import UIKit


protocol ListViewProtocool: AnyObject {
    func showTask(_ task: [Task])
    func showError(_ message: String)
}

final class ListViewController: UIViewController, ListViewProtocool {
    var presenter: ListPresenterProtocool?
    
    private let tableView: UITableView = {
       let table = UITableView()
        return table
    }()
    
    private var task: [Task] = []
    
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Задачи"
        navigationItem.searchController = searchController
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    func showTask(_ task: [Task]) {
        self.task = task
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    func showError(_ message: String) {
        print("Ошибка: \(message)")
    }
    
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell else { return UITableViewCell() }
        
        let taskItem = task[indexPath.row]
        cell.configure(with: taskItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
