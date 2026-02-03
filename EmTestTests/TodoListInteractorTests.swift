//
//  TodoListInteractorTests.swift
//  EmTestTests
//

import Testing
import Foundation
@testable import EmTest

@Suite("TodoListInteractor Tests")
@MainActor
struct TodoListInteractorTests {

    private var interactor: TodoListInteractor
    private var mockPresenter: MockTodoListPresenter
    private var mockStorageService: MockTodoStorageService
    private var mockNetworkService: MockNetworkService

    init() {
        mockPresenter = MockTodoListPresenter()
        mockStorageService = MockTodoStorageService()
        mockNetworkService = MockNetworkService()

        interactor = TodoListInteractor(
            storageService: mockStorageService,
            networkService: mockNetworkService
        )
        interactor.presenter = mockPresenter
    }

    @Test("fetchTodos success")
    func fetchTodosSuccess() async throws {
        let todos = [TodoItem(id: 1, title: "Test")]
        mockStorageService.todos = todos

        await interactor.fetchTodos()

        #expect(mockPresenter.didFetchTodosCalled)
        #expect(mockPresenter.fetchedTodos.count == 1)
    }

    @Test("fetchTodos failure")
    func fetchTodosFailure() async throws {
        mockStorageService.shouldFail = true

        await interactor.fetchTodos()

        #expect(mockPresenter.didFailFetchingTodosCalled)
    }

    @Test("loadFromAPI when not first launch loads from storage")
    func loadFromAPIWhenNotFirstLaunch() async throws {
        mockStorageService.isFirstLaunchValue = false
        let todos = [TodoItem(id: 1, title: "Test")]
        mockStorageService.todos = todos

        await interactor.loadFromAPIIfNeeded()

        #expect(mockPresenter.didFetchTodosCalled)
    }

    @Test("loadFromAPI when first launch fetches from API")
    func loadFromAPIWhenFirstLaunch() async throws {
        mockStorageService.isFirstLaunchValue = true
        mockNetworkService.mockTodos = [
            TodoAPIItem(id: 1, todo: "API Task", completed: false, userId: 1)
        ]

        await interactor.loadFromAPIIfNeeded()

        #expect(mockPresenter.didFetchTodosCalled)
        #expect(mockStorageService.isFirstLaunch() == false)
    }

    @Test("toggleTodoComplete")
    func toggleTodoComplete() async throws {
        let todo = TodoItem(id: 1, title: "Test", isCompleted: false)
        mockStorageService.todos = [todo]

        await interactor.toggleTodoComplete(item: todo)

        #expect(mockPresenter.didUpdateTodoCalled)
        #expect(mockPresenter.updatedTodo?.isCompleted == true)
    }

    @Test("deleteTodo")
    func deleteTodo() async throws {
        let todo = TodoItem(id: 1, title: "Test")
        mockStorageService.todos = [todo]

        await interactor.deleteTodo(id: 1)

        #expect(mockPresenter.didDeleteTodoCalled)
        #expect(mockPresenter.deletedId == 1)
        #expect(mockStorageService.todos.isEmpty)
    }

    @Test("searchTodos filters correctly")
    func searchTodos() async throws {
        mockStorageService.todos = [
            TodoItem(id: 1, title: "Buy milk"),
            TodoItem(id: 2, title: "Go to gym")
        ]

        await interactor.searchTodos(query: "milk")

        #expect(mockPresenter.didFetchTodosCalled)
        #expect(mockPresenter.fetchedTodos.count == 1)
        #expect(mockPresenter.fetchedTodos.first?.title == "Buy milk")
    }
}
