//
//  TodoListPresenterTests.swift
//  EmTestTests
//

import Testing
import Foundation
@testable import EmTest

@Suite("TodoListPresenter Tests")
@MainActor
struct TodoListPresenterTests {

    private var presenter: TodoListPresenter
    private var mockView: MockTodoListView
    private var mockInteractor: MockTodoListInteractor

    init() {
        presenter = TodoListPresenter()
        mockView = MockTodoListView()
        mockInteractor = MockTodoListInteractor()

        presenter.view = mockView
        presenter.interactor = mockInteractor
        mockInteractor.presenter = presenter
    }

    @Test("viewDidLoad calls loadFromAPI")
    func viewDidLoadCallsLoadFromAPI() {
        presenter.viewDidLoad()

        #expect(mockView.showLoadingCalled)
        #expect(mockInteractor.loadFromAPIIfNeededCalled)
    }

    @Test("didTapToggleComplete calls interactor")
    func didTapToggleCompleteCallsInteractor() {
        let todos = [TodoItem(id: 1, title: "Test")]
        presenter.didFetchTodos(todos)

        presenter.didTapToggleComplete(at: 0)

        #expect(mockInteractor.toggleTodoCompleteCalled)
        #expect(mockInteractor.toggledItem?.id == 1)
    }

    @Test("didTapDelete calls interactor")
    func didTapDeleteCallsInteractor() {
        let todos = [TodoItem(id: 1, title: "Test")]
        presenter.didFetchTodos(todos)

        presenter.didTapDelete(at: 0)

        #expect(mockInteractor.deleteTodoCalled)
        #expect(mockInteractor.deletedId == 1)
    }

    @Test("didSearch calls interactor")
    func didSearchCallsInteractor() {
        presenter.didSearch(query: "test query")

        #expect(mockView.showLoadingCalled)
        #expect(mockInteractor.searchTodosCalled)
        #expect(mockInteractor.searchQuery == "test query")
    }

    @Test("didFetchTodos updates view")
    func didFetchTodosUpdatesView() {
        let todos = [
            TodoItem(id: 1, title: "Task 1"),
            TodoItem(id: 2, title: "Task 2")
        ]

        presenter.didFetchTodos(todos)

        #expect(mockView.hideLoadingCalled)
        #expect(mockView.showTodosCalled)
        #expect(mockView.displayedTodos.count == 2)
    }

    @Test("didFailFetchingTodos shows error")
    func didFailFetchingTodosShowsError() {
        let error = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"])

        presenter.didFailFetchingTodos(error: error)

        #expect(mockView.hideLoadingCalled)
        #expect(mockView.showErrorCalled)
        #expect(mockView.errorMessage == "Test error")
    }

    @Test("didUpdateTodo updates view")
    func didUpdateTodoUpdatesView() {
        let todos = [TodoItem(id: 1, title: "Test", isCompleted: false)]
        presenter.didFetchTodos(todos)

        let updatedTodo = TodoItem(id: 1, title: "Test", isCompleted: true)
        presenter.didUpdateTodo(updatedTodo)

        #expect(mockView.updateTodoStatusCalled)
        #expect(mockView.updatedIndex == 0)
        #expect(mockView.updatedIsCompleted == true)
    }

    @Test("didDeleteTodo removes from view")
    func didDeleteTodoRemovesFromView() {
        let todos = [
            TodoItem(id: 1, title: "Task 1"),
            TodoItem(id: 2, title: "Task 2")
        ]
        presenter.didFetchTodos(todos)

        presenter.didDeleteTodo(id: 1)

        #expect(mockView.removeTodoCalled)
        #expect(mockView.removedIndex == 0)
    }

    @Test("numberOfTodos returns correct count")
    func numberOfTodos() {
        #expect(presenter.numberOfTodos() == 0)

        let todos = [TodoItem(id: 1, title: "Test")]
        presenter.didFetchTodos(todos)

        #expect(presenter.numberOfTodos() == 1)
    }

    @Test("todo(at:) returns correct item")
    func todoAtIndex() {
        let todos = [TodoItem(id: 1, title: "Test")]
        presenter.didFetchTodos(todos)

        let todo = presenter.todo(at: 0)
        #expect(todo?.title == "Test")

        let nilTodo = presenter.todo(at: 10)
        #expect(nilTodo == nil)
    }
}
