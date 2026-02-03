//
//  TodoListPresenterTests.swift
//  EmTestTests
//

import XCTest
@testable import EmTest

final class TodoListPresenterTests: XCTestCase {

    var presenter: TodoListPresenter!
    var mockView: MockTodoListView!
    var mockInteractor: MockTodoListInteractor!

    override func setUp() {
        super.setUp()
        presenter = TodoListPresenter()
        mockView = MockTodoListView()
        mockInteractor = MockTodoListInteractor()

        presenter.view = mockView
        presenter.interactor = mockInteractor
        mockInteractor.presenter = presenter
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        super.tearDown()
    }

    func testViewDidLoadCallsLoadFromAPI() {
        presenter.viewDidLoad()

        XCTAssertTrue(mockView.showLoadingCalled)
        XCTAssertTrue(mockInteractor.loadFromAPIIfNeededCalled)
    }

    func testDidTapToggleCompleteCallsInteractor() {
        let todos = [TodoItem(id: 1, title: "Test")]
        presenter.didFetchTodos(todos)

        presenter.didTapToggleComplete(at: 0)

        XCTAssertTrue(mockInteractor.toggleTodoCompleteCalled)
        XCTAssertEqual(mockInteractor.toggledItem?.id, 1)
    }

    func testDidTapDeleteCallsInteractor() {
        let todos = [TodoItem(id: 1, title: "Test")]
        presenter.didFetchTodos(todos)

        presenter.didTapDelete(at: 0)

        XCTAssertTrue(mockInteractor.deleteTodoCalled)
        XCTAssertEqual(mockInteractor.deletedId, 1)
    }

    func testDidSearchCallsInteractor() {
        presenter.didSearch(query: "test query")

        XCTAssertTrue(mockView.showLoadingCalled)
        XCTAssertTrue(mockInteractor.searchTodosCalled)
        XCTAssertEqual(mockInteractor.searchQuery, "test query")
    }

    func testDidFetchTodosUpdatesView() {
        let todos = [
            TodoItem(id: 1, title: "Task 1"),
            TodoItem(id: 2, title: "Task 2")
        ]

        presenter.didFetchTodos(todos)

        XCTAssertTrue(mockView.hideLoadingCalled)
        XCTAssertTrue(mockView.showTodosCalled)
        XCTAssertEqual(mockView.displayedTodos.count, 2)
    }

    func testDidFailFetchingTodosShowsError() {
        let error = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"])

        presenter.didFailFetchingTodos(error: error)

        XCTAssertTrue(mockView.hideLoadingCalled)
        XCTAssertTrue(mockView.showErrorCalled)
        XCTAssertEqual(mockView.errorMessage, "Test error")
    }

    func testDidUpdateTodoUpdatesView() {
        let todos = [TodoItem(id: 1, title: "Test", isCompleted: false)]
        presenter.didFetchTodos(todos)

        let updatedTodo = TodoItem(id: 1, title: "Test", isCompleted: true)
        presenter.didUpdateTodo(updatedTodo)

        XCTAssertTrue(mockView.updateTodoStatusCalled)
        XCTAssertEqual(mockView.updatedIndex, 0)
        XCTAssertTrue(mockView.updatedIsCompleted ?? false)
    }

    func testDidDeleteTodoRemovesFromView() {
        let todos = [
            TodoItem(id: 1, title: "Task 1"),
            TodoItem(id: 2, title: "Task 2")
        ]
        presenter.didFetchTodos(todos)

        presenter.didDeleteTodo(id: 1)

        XCTAssertTrue(mockView.removeTodoCalled)
        XCTAssertEqual(mockView.removedIndex, 0)
    }

    func testNumberOfTodos() {
        XCTAssertEqual(presenter.numberOfTodos(), 0)

        let todos = [TodoItem(id: 1, title: "Test")]
        presenter.didFetchTodos(todos)

        XCTAssertEqual(presenter.numberOfTodos(), 1)
    }

    func testTodoAtIndex() {
        let todos = [TodoItem(id: 1, title: "Test")]
        presenter.didFetchTodos(todos)

        let todo = presenter.todo(at: 0)
        XCTAssertNotNil(todo)
        XCTAssertEqual(todo?.title, "Test")

        let nilTodo = presenter.todo(at: 10)
        XCTAssertNil(nilTodo)
    }
}
