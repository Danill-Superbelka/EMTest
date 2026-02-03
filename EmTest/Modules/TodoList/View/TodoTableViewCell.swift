//
//  TodoTableViewCell.swift
//  EmTest
//

import UIKit
import SnapKit

protocol TodoTableViewCellDelegate: AnyObject {
    func didTapCheckbox(in cell: TodoTableViewCell)
}

final class TodoTableViewCell: UITableViewCell {

    static let identifier = "TodoTableViewCell"

    weak var delegate: TodoTableViewCellDelegate?

    private lazy var checkboxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = AppColors.Checkbox.completed
        button.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppTypography.title
        label.textColor = AppColors.Cell.title
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = AppTypography.bodySmall
        label.textColor = AppColors.Cell.description
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = AppTypography.caption
        label.textColor = AppColors.Cell.date
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private lazy var containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = AppSpacing.Cell.stackSpacing
        return stack
    }()

    private var isCompleted: Bool = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = AppColors.Cell.background
        contentView.backgroundColor = AppColors.Cell.background
        selectionStyle = .none

        contentView.addSubview(checkboxButton)
        contentView.addSubview(containerStack)

        containerStack.addArrangedSubview(titleLabel)
        containerStack.addArrangedSubview(descriptionLabel)
        containerStack.addArrangedSubview(dateLabel)

        checkboxButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppSpacing.Cell.horizontalPadding)
            make.top.equalToSuperview().offset(AppSpacing.Cell.verticalPadding)
            make.size.equalTo(AppSpacing.Cell.checkboxSize)
        }

        containerStack.snp.makeConstraints { make in
            make.leading.equalTo(checkboxButton.snp.trailing).offset(AppSpacing.Cell.checkboxToContent)
            make.trailing.equalToSuperview().offset(-AppSpacing.Cell.horizontalPadding)
            make.top.equalToSuperview().offset(AppSpacing.Cell.verticalPadding)
            make.bottom.equalToSuperview().offset(-AppSpacing.Cell.verticalPadding)
        }
    }

    @objc private func checkboxTapped() {
        AppHaptics.light()
        delegate?.didTapCheckbox(in: self)
    }

    func configure(with todo: TodoItem) {
        isCompleted = todo.isCompleted
        updateCheckboxImage()
        updateTitleStyle(todo.title)

        descriptionLabel.text = todo.description
        descriptionLabel.isHidden = todo.description.isEmpty

        dateLabel.text = AppDateFormatters.shortDateString(from: todo.createdAt)
    }

    func updateCompletionStatus(_ isCompleted: Bool) {
        self.isCompleted = isCompleted
        updateCheckboxImage()
        if let text = titleLabel.text {
            updateTitleStyle(text)
        }
    }

    private func updateCheckboxImage() {
        let image = isCompleted ? AppIcons.checkboxCompleted : AppIcons.checkboxUncompleted
        checkboxButton.setImage(image, for: .normal)
        checkboxButton.tintColor = isCompleted ? AppColors.Checkbox.completed : AppColors.Checkbox.uncompleted
    }

    private func updateTitleStyle(_ text: String) {
        if isCompleted {
            let attributedString = NSAttributedString(
                string: text,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: AppColors.Cell.titleCompleted
                ]
            )
            titleLabel.attributedText = attributedString
            descriptionLabel.textColor = AppColors.Cell.titleCompleted
        } else {
            titleLabel.attributedText = nil
            titleLabel.text = text
            titleLabel.textColor = AppColors.Cell.title
            descriptionLabel.textColor = AppColors.Cell.title
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
        descriptionLabel.isHidden = false
    }
}
