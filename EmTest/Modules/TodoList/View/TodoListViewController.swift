//
//  TodoListViewController.swift
//  EmTest
//

import UIKit
import SnapKit

final class TodoListViewController: UIViewController, TodoListViewProtocol {

    var presenter: TodoListPresenterProtocol?

    private var todos: [TodoItem] = []

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = String(localized: "search_placeholder")
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = AppColors.SearchBar.tint
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = AppColors.SearchBar.text
            textField.backgroundColor = AppColors.SearchBar.background
            textField.attributedPlaceholder = NSAttributedString(
                string: String(localized: "search_placeholder"),
                attributes: [.foregroundColor: AppColors.SearchBar.placeholder]
            )
        }
        return searchController
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = AppColors.background
        tableView.separatorColor = AppColors.separator
        tableView.separatorInset = UIEdgeInsets(top: 0, left: AppSpacing.Table.separatorInsetLeft, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.identifier)
        tableView.contentInsetAdjustmentBehavior = .automatic
        return tableView
    }()

    private lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.Footer.background
        return view
    }()

    private lazy var todoCountLabel: UILabel = {
        let label = UILabel()
        label.font = AppTypography.captionSmall
        label.textColor = AppColors.Footer.text
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(AppIcons.add, for: .normal)
        button.tintColor = AppColors.accent
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = AppColors.textPrimary
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        presenter?.viewDidLoad()
    }

    private func setupNavigationBar() {
        title = String(localized: "tasks_title")

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true
    }

    private func setupUI() {
        view.backgroundColor = AppColors.background
        extendedLayoutIncludesOpaqueBars = true

        view.addSubview(tableView)
        view.addSubview(footerView)
        footerView.addSubview(todoCountLabel)
        footerView.addSubview(addButton)
        view.addSubview(activityIndicator)

        footerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(AppSpacing.Footer.height)
        }

        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(footerView.snp.top)
        }

        todoCountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AppSpacing.Footer.topPadding)
        }

        addButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-AppSpacing.Footer.horizontalPadding)
            make.centerY.equalTo(todoCountLabel)
            make.size.equalTo(AppSpacing.Footer.buttonSize)
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    @objc private func addButtonTapped() {
        AppHaptics.medium()
        presenter?.didTapAddTodo()
    }

    private func updateTodoCount() {
        let count = todos.count
        todoCountLabel.text = String(localized: "tasks_count \(count)")
    }

    // MARK: - TodoListViewProtocol

    func showTodos(_ todos: [TodoItem]) {
        self.todos = todos
        tableView.reloadData()
        updateTodoCount()
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: String(localized: "error_title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String(localized: "ok_button"), style: .default))
        present(alert, animated: true)
    }

    func showLoading() {
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
    }

    func updateTodoStatus(at index: Int, isCompleted: Bool) {
        guard index < todos.count else { return }
        todos[index].isCompleted = isCompleted
        if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TodoTableViewCell {
            cell.updateCompletionStatus(isCompleted)
        }
    }

    func removeTodo(at index: Int) {
        todos.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        updateTodoCount()
    }
}

// MARK: - UITableViewDataSource
extension TodoListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodoTableViewCell.identifier,
            for: indexPath
        ) as? TodoTableViewCell else {
            return UITableViewCell()
        }

        let todo = todos[indexPath.row]
        cell.configure(with: todo)
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TodoListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectTodo(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            AppHaptics.warning()
            self?.presenter?.didTapDelete(at: indexPath.row)
            completion(true)
        }
        deleteAction.image = AppIcons.delete
        deleteAction.backgroundColor = AppColors.destructive

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let editAction = UIAction(title: String(localized: "edit_action"), image: AppIcons.edit) { _ in
                self?.presenter?.didSelectTodo(at: indexPath.row)
            }

            let shareAction = UIAction(title: String(localized: "share_action"), image: AppIcons.share) { _ in
                guard let todo = self?.todos[indexPath.row] else { return }
                let text = "\(todo.title)\n\(todo.description)"
                let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
                self?.present(activityVC, animated: true)
            }

            let deleteAction = UIAction(title: String(localized: "delete_action"), image: AppIcons.delete, attributes: .destructive) { _ in
                self?.presenter?.didTapDelete(at: indexPath.row)
            }

            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
}

// MARK: - UISearchResultsUpdating
extension TodoListViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        presenter?.didSearch(query: query)
    }
}

// MARK: - TodoTableViewCellDelegate
extension TodoListViewController: TodoTableViewCellDelegate {

    func didTapCheckbox(in cell: TodoTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.didTapToggleComplete(at: indexPath.row)
    }
}
