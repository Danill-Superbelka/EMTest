//
//  TodoDetailPresenterTests.swift
//  EmTestTests
//

import Testing
import Foundation
@testable import EmTest

// MARK: - Mocks

@MainActor
final class MockTodoDetailView: TodoDetailViewProtocol {
    var presenter: TodoDetailPresenterProtocol?

    var showTodoCalled = false
    var showErrorCalled = false
    var showLoadingCalled = false
    var hideLoadingCalled = false

    var displayedTodo: TodoItem?
    var errorMessage: String?

    func showTodo(_ todo: TodoItem) {
        showTodoCalled = true
        displayedTodo = todo
    }

    func showError(_ message: String) {
        showErrorCalled = true
        errorMessage = message
    }

    func showLoading() {
        showLoadingCalled = true
    }

    func hideLoading() {
        hideLoadingCalled = true
    }
}

final class MockTodoDetailInteractor: TodoDetailInteractorInputProtocol, @unchecked Sendable {
    weak var presenter: TodoDetailInteractorOutputProtocol?

    var saveTodoCalled = false
    var updateTodoCalled = false
    var getNextIdCalled = false

    var savedTodo: TodoItem?
    var updatedTodo: TodoItem?

    func saveTodo(_ item: TodoItem) async {
        saveTodoCalled = true
        savedTodo = item
        await presenter?.didSaveTodo(item)
    }

    func updateTodo(_ item: TodoItem) async {
        updateTodoCalled = true
        updatedTodo = item
        await presenter?.didUpdateTodo(item)
    }

    func getNextId() async -> Int64 {
        getNextIdCalled = true
        return 100
    }
}

final class MockTodoDetailDelegate: TodoDetailDelegate {
    var didSaveTodoCalled = false
    var didCreateTodoCalled = false
    var savedTodo: TodoItem?
    var createdTodo: TodoItem?

    func didSaveTodo(_ todo: TodoItem) {
        didSaveTodoCalled = true
        savedTodo = todo
    }

    func didCreateTodo(_ todo: TodoItem) {
        didCreateTodoCalled = true
        createdTodo = todo
    }
}

// MARK: - Tests

@Suite("TodoDetailPresenter Tests")
@MainActor
struct TodoDetailPresenterTests {

    private var presenter: TodoDetailPresenter
    private var mockView: MockTodoDetailView
    private var mockInteractor: MockTodoDetailInteractor
    private var mockDelegate: MockTodoDetailDelegate

    init() {
        presenter = TodoDetailPresenter()
        mockView = MockTodoDetailView()
        mockInteractor = MockTodoDetailInteractor()
        mockDelegate = MockTodoDetailDelegate()

        presenter.view = mockView
        presenter.interactor = mockInteractor
        mockInteractor.presenter = presenter
    }

    @Test("isNewTodo returns true when no existing todo")
    func isNewTodoWhenNoExistingTodo() {
        presenter.configure(todo: nil, delegate: mockDelegate)

        #expect(presenter.isNewTodo() == true)
    }

    @Test("isNewTodo returns false when existing todo")
    func isNewTodoWhenExistingTodo() {
        let todo = TodoItem(id: 1, title: "Test")
        presenter.configure(todo: todo, delegate: mockDelegate)

        #expect(presenter.isNewTodo() == false)
    }

    @Test("viewDidLoad shows existing todo")
    func viewDidLoadShowsExistingTodo() {
        let todo = TodoItem(id: 1, title: "Test", description: "Description")
        presenter.configure(todo: todo, delegate: mockDelegate)

        presenter.viewDidLoad()

        #expect(mockView.showTodoCalled)
        #expect(mockView.displayedTodo?.title == "Test")
    }

    @Test("saveTodo with empty title shows error")
    func saveTodoWithEmptyTitleShowsError() {
        presenter.configure(todo: nil, delegate: mockDelegate)

        presenter.saveTodo(title: "   ", description: "Description")

        #expect(mockView.showErrorCalled)
        #expect(mockInteractor.saveTodoCalled == false)
    }

    @Test("save new todo")
    func saveNewTodo() async throws {
        presenter.configure(todo: nil, delegate: mockDelegate)

        presenter.saveTodo(title: "New Task", description: "Description")

        try await Task.sleep(for: .milliseconds(150))

        #expect(mockView.showLoadingCalled)
        #expect(mockInteractor.getNextIdCalled)
        #expect(mockInteractor.saveTodoCalled)
    }

    @Test("update existing todo")
    func updateExistingTodo() async throws {
        let todo = TodoItem(id: 1, title: "Original")
        presenter.configure(todo: todo, delegate: mockDelegate)

        presenter.saveTodo(title: "Updated", description: "New Description")

        try await Task.sleep(for: .milliseconds(150))

        #expect(mockView.showLoadingCalled)
        #expect(mockInteractor.updateTodoCalled)
        #expect(mockInteractor.updatedTodo?.title == "Updated")
    }

    @Test("didSaveTodo notifies delegate with didCreateTodo")
    func didSaveTodoNotifiesDelegate() {
        presenter.configure(todo: nil, delegate: mockDelegate)
        let newTodo = TodoItem(id: 1, title: "New")

        presenter.didSaveTodo(newTodo)

        #expect(mockView.hideLoadingCalled)
        #expect(mockDelegate.didCreateTodoCalled)
    }

    @Test("didUpdateTodo notifies delegate with didSaveTodo")
    func didUpdateTodoNotifiesDelegate() {
        let todo = TodoItem(id: 1, title: "Original")
        presenter.configure(todo: todo, delegate: mockDelegate)
        let updatedTodo = TodoItem(id: 1, title: "Updated")

        presenter.didUpdateTodo(updatedTodo)

        #expect(mockView.hideLoadingCalled)
        #expect(mockDelegate.didSaveTodoCalled)
    }

    @Test("didFailSaving shows error")
    func didFailSavingShowsError() {
        let error = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Save failed"])

        presenter.didFailSaving(error: error)

        #expect(mockView.hideLoadingCalled)
        #expect(mockView.showErrorCalled)
        #expect(mockView.errorMessage == "Save failed")
    }
}
