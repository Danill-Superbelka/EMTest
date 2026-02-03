//
//  TodoDetailViewController.swift
//  EmTest
//

import UIKit
import SnapKit

final class TodoDetailViewController: UIViewController, TodoDetailViewProtocol {

    var presenter: TodoDetailPresenterProtocol?

    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = AppTypography.largeTitle
        textField.textColor = AppColors.textPrimary
        textField.attributedPlaceholder = NSAttributedString(
            string: String(localized: "task_title_placeholder"),
            attributes: [.foregroundColor: AppColors.textPlaceholder]
        )
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.adjustsFontForContentSizeCategory = true
        return textField
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = AppTypography.caption
        label.textColor = AppColors.textSecondary
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = AppTypography.body
        textView.textColor = AppColors.textPrimary
        textView.backgroundColor = .clear
        textView.isScrollEnabled = true
        textView.delegate = self
        textView.adjustsFontForContentSizeCategory = true
        return textView
    }()

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "task_description_placeholder")
        label.font = AppTypography.body
        label.textColor = AppColors.textPlaceholder
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = AppColors.textPrimary
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private var currentDate: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        presenter?.viewDidLoad()
        updateDateLabel()
    }

    private func setupUI() {
        view.backgroundColor = AppColors.background

        view.addSubview(titleTextField)
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(placeholderLabel)
        view.addSubview(activityIndicator)

        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(AppSpacing.Detail.topPadding)
            make.leading.equalToSuperview().offset(AppSpacing.Detail.horizontalPadding)
            make.trailing.equalToSuperview().offset(-AppSpacing.Detail.horizontalPadding)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(AppSpacing.Detail.labelSpacing)
            make.leading.equalToSuperview().offset(AppSpacing.Detail.horizontalPadding)
            make.trailing.equalToSuperview().offset(-AppSpacing.Detail.horizontalPadding)
        }

        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(AppSpacing.Detail.sectionSpacing)
            make.leading.equalToSuperview().offset(AppSpacing.Detail.textViewHorizontalPadding)
            make.trailing.equalToSuperview().offset(-AppSpacing.Detail.textViewHorizontalPadding)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-AppSpacing.Detail.sectionSpacing)
        }

        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView).offset(AppSpacing.Detail.labelSpacing)
            make.leading.equalTo(descriptionTextView).offset(5)
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = AppColors.NavigationBar.tint
        navigationItem.largeTitleDisplayMode = .never

        let backButton = UIBarButtonItem(
            image: AppIcons.back,
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func backButtonTapped() {
        saveAndGoBack()
    }

    private func saveAndGoBack() {
        let title = titleTextField.text ?? ""
        let description = descriptionTextView.text ?? ""

        if !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            presenter?.saveTodo(title: title, description: description)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    private func updateDateLabel() {
        dateLabel.text = AppDateFormatters.shortDateString(from: currentDate)
    }

    // MARK: - TodoDetailViewProtocol

    func showTodo(_ todo: TodoItem) {
        titleTextField.text = todo.title
        descriptionTextView.text = todo.description
        currentDate = todo.createdAt
        updateDateLabel()
        placeholderLabel.isHidden = !todo.description.isEmpty
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: String(localized: "error_title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String(localized: "ok_button"), style: .default))
        present(alert, animated: true)
    }

    func showLoading() {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
}

// MARK: - UITextViewDelegate
extension TodoDetailViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
