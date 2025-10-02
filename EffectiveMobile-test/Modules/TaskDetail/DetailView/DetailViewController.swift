//
//  DetailViewController.swift
//  EffectiveMobile-test
//
//  Created by Владислав Перелыгин on 30/09/2025.
//




import UIKit
import SnapKit

protocol DetailViewProtocol: AnyObject {
    func showTask(_ task: Task)
}

final class DetailViewController: UIViewController, DetailViewProtocol {
    var presenter: DetailPresenterProtocol?
    private var task: Task?
    var onSave: (() -> Void)?
    
    private let titleField: UITextField = {
        let title = UITextField()
        title.placeholder = "Название задачи"
        title.font = .boldSystemFont(ofSize: 25)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .white
        title.layer.borderWidth = 1
        title.layer.cornerRadius = 5
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        title.leftView = paddingView
        title.leftViewMode = .always
        title.layer.borderColor = UIColor.systemYellow.cgColor
        return title
    }()
    
    
    private let detailDateLabel: UILabel = {
        let date = UILabel()
         date.textColor = .gray
         date.font = UIFont.systemFont(ofSize: 14)
         date.translatesAutoresizingMaskIntoConstraints = false
         return date
    }()
    
    private let descriptionField: UITextView = {
        let description = UITextView()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.textColor = .white
        description.layer.borderWidth = 1
        description.isEditable = true
        description.layer.cornerRadius = 5
        description.layer.borderColor = UIColor.systemYellow.cgColor
        description.font = .systemFont(ofSize: 16)
        return description
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,target: self,action: #selector(saveAction))
        presenter?.viewDidLoad()
        setupSubviews()
    }
    
    func setupSubviews() {
        view.addSubview(titleField)
        view.addSubview(descriptionField)
        view.addSubview(detailDateLabel)
        
        titleField.snp.makeConstraints { title in
            title.top.equalToSuperview().offset(180)
            title.left.equalToSuperview().offset(30)
            title.right.equalToSuperview().offset(-30)
            title.height.equalTo(50)
            
        }
        
        descriptionField.snp.makeConstraints { description in
            description.top.equalTo(detailDateLabel.snp.bottom).offset(20)
            description.left.equalTo(titleField.snp.left)
            description.right.equalToSuperview().offset(-30)
            description.height.equalTo(200)
        }
        
        detailDateLabel.snp.makeConstraints { date in
            date.top.equalTo(titleField.snp.bottom).offset(20)
            date.left.equalTo(titleField.snp.left)
        }
    }
    
    func showTask(_ task: Task) {
        titleField.text = task.todo
        descriptionField.text = task.description
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YY"
            detailDateLabel.text = formatter.string(from: task.date ?? Date())
    }
    
    @objc func saveAction() {
        presenter?.saveTask(title: titleField.text ?? "", description: descriptionField.text ?? "")
        onSave?()
        navigationController?.popViewController(animated: true)
    }
}

