//
//  TodoListInteractorTests.swift
//  EmTestTests
//

import XCTest
@testable import EmTest

final class TodoListInteractorTests: XCTestCase {

    var interactor: TodoListInteractor!
    var mockPresenter: MockTodoListPresenter!
    var mockStorageService: MockTodoStorageService!
    var mockNetworkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockPresenter = MockTodoListPresenter()
        mockStorageService = MockTodoStorageService()
        mockNetworkService = MockNetworkService()

        interactor = TodoListInteractor(
            storageService: mockStorageService,
            networkService: mockNetworkService
        )
        interactor.presenter = mockPresenter
    }

    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        mockStorageService = nil
        mockNetworkService = nil
        super.tearDown()
    }

    func testFetchTodosSuccess() {
        let todos = [TodoItem(id: 1, title: "Test")]
        mockStorageService.todos = todos

        let expectation = self.expectation(description: "Fetch todos")

        interactor.fetchTodos()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockPresenter.didFetchTodosCalled)
            XCTAssertEqual(self.mockPresenter.fetchedTodos.count, 1)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testFetchTodosFailure() {
        mockStorageService.shouldFail = true

        let expectation = self.expectation(description: "Fetch todos failure")

        interactor.fetchTodos()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockPresenter.didFailFetchingTodosCalled)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testLoadFromAPIWhenNotFirstLaunch() {
        mockStorageService.isFirstLaunchValue = false
        let todos = [TodoItem(id: 1, title: "Test")]
        mockStorageService.todos = todos

        let expectation = self.expectation(description: "Load from storage")

        interactor.loadFromAPIIfNeeded()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockPresenter.didFetchTodosCalled)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testLoadFromAPIWhenFirstLaunch() {
        mockStorageService.isFirstLaunchValue = true
        mockNetworkService.mockTodos = [
            TodoAPIItem(id: 1, todo: "API Task", completed: false, userId: 1)
        ]

        let expectation = self.expectation(description: "Load from API")

        interactor.loadFromAPIIfNeeded()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertTrue(self.mockPresenter.didFetchTodosCalled)
            XCTAssertFalse(self.mockStorageService.isFirstLaunch())
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testToggleTodoComplete() {
        let todo = TodoItem(id: 1, title: "Test", isCompleted: false)
        mockStorageService.todos = [todo]

        let expectation = self.expectation(description: "Toggle complete")

        interactor.toggleTodoComplete(item: todo)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockPresenter.didUpdateTodoCalled)
            XCTAssertTrue(self.mockPresenter.updatedTodo?.isCompleted ?? false)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testDeleteTodo() {
        let todo = TodoItem(id: 1, title: "Test")
        mockStorageService.todos = [todo]

        let expectation = self.expectation(description: "Delete todo")

        interactor.deleteTodo(id: 1)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockPresenter.didDeleteTodoCalled)
            XCTAssertEqual(self.mockPresenter.deletedId, 1)
            XCTAssertTrue(self.mockStorageService.todos.isEmpty)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testSearchTodos() {
        mockStorageService.todos = [
            TodoItem(id: 1, title: "Buy milk"),
            TodoItem(id: 2, title: "Go to gym")
        ]

        let expectation = self.expectation(description: "Search todos")

        interactor.searchTodos(query: "milk")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockPresenter.didFetchTodosCalled)
            XCTAssertEqual(self.mockPresenter.fetchedTodos.count, 1)
            XCTAssertEqual(self.mockPresenter.fetchedTodos.first?.title, "Buy milk")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
}
