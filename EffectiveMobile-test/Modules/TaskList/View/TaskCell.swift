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
    
    private var task: Task?
    
    var onToggleButton: ((Task) -> Void)?
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
       let date = UILabel()
        date.textColor = .gray
        date.font = UIFont.systemFont(ofSize: 12)
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    private let descriptionLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let completedButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        button.tintColor = .systemYellow
        return button
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YY"
        return formatter
    }()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        completedButton.addTarget(self, action: #selector(completedAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(completedButton)
        contentView.addSubview(dateLabel)
        
        completedButton.snp.makeConstraints { button in
            button.left.equalToSuperview().offset(15)
            button.centerY.equalToSuperview().offset(-20)
            button.height.equalTo(30)
            button.width.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { title in
            title.top.equalToSuperview().offset(20)
            title.left.equalTo(completedButton.snp.left).offset(40)
        }
        
        descriptionLabel.snp.makeConstraints { description in
            description.top.equalTo(titleLabel.snp.bottom).offset(15)
            description.left.equalTo(titleLabel.snp.left)
        }
        
        dateLabel.snp.makeConstraints { date in
            date.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            date.left.equalTo(descriptionLabel.snp.left)
        }
        
    }
    
    
    
    func configure(with task: Task) {
        self.task = task
        titleLabel.attributedText = attributedText(task.todo, completed: task.completed)
        descriptionLabel.attributedText = attributedText(task.description ?? "some description", completed: task.completed)
        completedButton.isSelected = task.completed
        
        if let date = task.date {
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = "09/10/24"
        }
    }
    
    private func attributedText(_ text: String, completed: Bool) -> NSAttributedString {
        if completed {
            return NSAttributedString(
                string: text,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.gray
                ]
            )
        } else {
            return NSAttributedString(
                string: text,
                attributes: [
                    .foregroundColor: UIColor.white
                ]
            )
        }
    }
    
    @objc
    func completedAction() {
        guard var task = task else { return }
        task.completed.toggle()
        self.task = task
        titleLabel.attributedText = attributedText(task.todo, completed: task.completed)
        descriptionLabel.attributedText = attributedText(task.description ?? "some description", completed: task.completed)
        completedButton.isSelected = task.completed
        print(task)
        onToggleButton?(task)
    }
}

