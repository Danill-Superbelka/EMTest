//
//  TodoDetailPresenterTests.swift
//  EmTestTests
//

import XCTest
@testable import EmTest

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

final class MockTodoDetailInteractor: TodoDetailInteractorInputProtocol {
    weak var presenter: TodoDetailInteractorOutputProtocol?

    var saveTodoCalled = false
    var updateTodoCalled = false
    var getNextIdCalled = false

    var savedTodo: TodoItem?
    var updatedTodo: TodoItem?

    func saveTodo(_ item: TodoItem) {
        saveTodoCalled = true
        savedTodo = item
        presenter?.didSaveTodo(item)
    }

    func updateTodo(_ item: TodoItem) {
        updateTodoCalled = true
        updatedTodo = item
        presenter?.didUpdateTodo(item)
    }

    func getNextId(completion: @escaping (Int64) -> Void) {
        getNextIdCalled = true
        completion(100)
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

final class TodoDetailPresenterTests: XCTestCase {

    var presenter: TodoDetailPresenter!
    var mockView: MockTodoDetailView!
    var mockInteractor: MockTodoDetailInteractor!
    var mockDelegate: MockTodoDetailDelegate!

    override func setUp() {
        super.setUp()
        presenter = TodoDetailPresenter()
        mockView = MockTodoDetailView()
        mockInteractor = MockTodoDetailInteractor()
        mockDelegate = MockTodoDetailDelegate()

        presenter.view = mockView
        presenter.interactor = mockInteractor
        mockInteractor.presenter = presenter
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockDelegate = nil
        super.tearDown()
    }

    func testIsNewTodoWhenNoExistingTodo() {
        presenter.configure(todo: nil, delegate: mockDelegate)

        XCTAssertTrue(presenter.isNewTodo())
    }

    func testIsNewTodoWhenExistingTodo() {
        let todo = TodoItem(id: 1, title: "Test")
        presenter.configure(todo: todo, delegate: mockDelegate)

        XCTAssertFalse(presenter.isNewTodo())
    }

    func testViewDidLoadShowsExistingTodo() {
        let todo = TodoItem(id: 1, title: "Test", description: "Description")
        presenter.configure(todo: todo, delegate: mockDelegate)

        presenter.viewDidLoad()

        XCTAssertTrue(mockView.showTodoCalled)
        XCTAssertEqual(mockView.displayedTodo?.title, "Test")
    }

    func testSaveTodoWithEmptyTitleShowsError() {
        presenter.configure(todo: nil, delegate: mockDelegate)

        presenter.saveTodo(title: "   ", description: "Description")

        XCTAssertTrue(mockView.showErrorCalled)
        XCTAssertFalse(mockInteractor.saveTodoCalled)
    }

    func testSaveNewTodo() {
        presenter.configure(todo: nil, delegate: mockDelegate)

        let expectation = self.expectation(description: "Save new todo")

        presenter.saveTodo(title: "New Task", description: "Description")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockView.showLoadingCalled)
            XCTAssertTrue(self.mockInteractor.getNextIdCalled)
            XCTAssertTrue(self.mockInteractor.saveTodoCalled)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testUpdateExistingTodo() {
        let todo = TodoItem(id: 1, title: "Original")
        presenter.configure(todo: todo, delegate: mockDelegate)

        presenter.saveTodo(title: "Updated", description: "New Description")

        XCTAssertTrue(mockView.showLoadingCalled)
        XCTAssertTrue(mockInteractor.updateTodoCalled)
        XCTAssertEqual(mockInteractor.updatedTodo?.title, "Updated")
    }

    func testDidSaveTodoNotifiesDelegate() {
        presenter.configure(todo: nil, delegate: mockDelegate)
        let newTodo = TodoItem(id: 1, title: "New")

        presenter.didSaveTodo(newTodo)

        XCTAssertTrue(mockView.hideLoadingCalled)
        XCTAssertTrue(mockDelegate.didCreateTodoCalled)
    }

    func testDidUpdateTodoNotifiesDelegate() {
        let todo = TodoItem(id: 1, title: "Original")
        presenter.configure(todo: todo, delegate: mockDelegate)
        let updatedTodo = TodoItem(id: 1, title: "Updated")

        presenter.didUpdateTodo(updatedTodo)

        XCTAssertTrue(mockView.hideLoadingCalled)
        XCTAssertTrue(mockDelegate.didSaveTodoCalled)
    }

    func testDidFailSavingShowsError() {
        let error = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Save failed"])

        presenter.didFailSaving(error: error)

        XCTAssertTrue(mockView.hideLoadingCalled)
        XCTAssertTrue(mockView.showErrorCalled)
        XCTAssertEqual(mockView.errorMessage, "Save failed")
    }
}
