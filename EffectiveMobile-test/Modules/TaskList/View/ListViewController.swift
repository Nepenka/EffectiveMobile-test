//
//  ListViewController.swift
//  EffectiveMobile-test
//
//  Created by Владислав Перелыгин on 30/09/2025.
//


import UIKit
import SnapKit

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
    private var filteredTasks: [Task] = []
    private var isFilter: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        presenter?.viewDidLoad()
        _ = searchController.searchBar
        setupSubviews()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Задачи"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTaskAction))
        navigationItem.searchController = searchController
        tableView.dataSource = self
        tableView.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.snp.makeConstraints { table in
            table.edges.equalToSuperview()
        }
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
    
    @objc
    func addTaskAction() {
        print("Добавить задачу")
    }
    
}

//MARK: - UITableViewDelegate, DataSource
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFilter ? filteredTasks.count : task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell else { return UITableViewCell() }
        let taskItem = isFilter ? filteredTasks[indexPath.row] : task[indexPath.row]
        cell.configure(with: taskItem)
        
        cell.onToggleButton = { [weak self] updateTask in
            guard let self = self else {return}
            if let index = self.task.firstIndex(where: { $0.id == updateTask.id }) {
                    self.task[index] = updateTask
                }
                if self.isFilter {
                    if let index = self.filteredTasks.firstIndex(where: { $0.id == updateTask.id }) {
                        self.filteredTasks[index] = updateTask
                    }
                }

                self.presenter?.toggleTask(updateTask)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
//    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        <#code#>
//    }
}


//MARK: - UISearchBar
extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        filteredTasks = task.filter { task in
            task.todo.lowercased().contains(text.lowercased()) ||
            (task.description?.lowercased().contains(text.lowercased()) ?? false)
        }
            self.tableView.reloadData()
    }
}
