//
//  TaskCell.swift
//  EffectiveMobile-test
//
//  Created by Владислав Перелыгин on 30/09/2025.
//



import UIKit
import SnapKit


class TaskCell: UITableViewCell {
    static let identifier = "cell"
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let completedButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: ""), for: .normal)
        
        return button
    }()
    
//    var stackView: UIStackView = {
//        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, completedButton])
//        
//        
//        return stack
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configure(with task: Task) {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        titleLabel.snp.makeConstraints { title in
            title.center.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { description in
            description.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        titleLabel.text = task.todo
        descriptionLabel.text = (task.description) ?? "some description"
        
    }
}

