# Todo App

iOS-приложение для управления задачами с чистой архитектурой и современным стеком технологий.

## Особенности

### Архитектура VIPER
Полноценная реализация паттерна VIPER с четким разделением ответственности:
- **View** — отображение UI, получение действий пользователя
- **Interactor** — бизнес-логика, работа с данными
- **Presenter** — связь между View и Interactor, подготовка данных для отображения
- **Entity** — модели данных
- **Router** — навигация между экранами

### Swift Concurrency
- Полный переход на `async/await`
- `@MainActor` для потокобезопасной работы с UI
- `Sendable` протоколы для безопасной передачи данных между потоками

### CoreData
- Локальное хранение задач
- Фоновые контексты для операций записи
- Bridging к async/await через `withCheckedThrowingContinuation`

### Дизайн-система
Централизованное управление визуальными константами:
- `Colors` — цветовая палитра через Asset Catalog
- `Typography` — шрифты с поддержкой Dynamic Type
- `Spacing` — отступы и размеры
- `Icons` — SF Symbols
- `Haptics` — тактильная обратная связь
- `DateFormatters` — форматирование дат

### UX-фичи
- **Pull to Refresh** — обновление списка свайпом вниз
- **Empty State** — информативный экран при пустом списке
- **Поиск** — фильтрация задач по названию и описанию
- **Swipe Actions** — удаление задач свайпом

## Технологии

| Категория | Технология |
|-----------|------------|
| UI | UIKit, Auto Layout (программно) |
| Архитектура | VIPER |
| Хранение | CoreData |
| Сеть | URLSession + async/await |
| Тесты | Swift Testing |
| Минимальная iOS | 16.0 |

## API

Приложение использует [DummyJSON](https://dummyjson.com/todos) для первоначальной загрузки задач при первом запуске.

## Структура проекта

```
EmTest/
├── Core/
│   ├── CoreData/          # CoreData stack и entities
│   └── Network/           # Сетевой слой
├── Entities/              # Модели данных
├── Modules/
│   ├── TodoList/          # Экран списка задач
│   │   ├── View/
│   │   ├── Interactor/
│   │   ├── Presenter/
│   │   └── Router/
│   └── TodoDetail/        # Экран деталей задачи
│       ├── View/
│       ├── Interactor/
│       ├── Presenter/
│       └── Router/
├── Services/              # Сервисы (Storage)
└── Resources/
    └── DesignSystem/      # Цвета, шрифты, отступы
```

## Тестирование

Проект использует современный фреймворк **Swift Testing**:

```swift
@Suite("TodoItem Tests")
struct TodoItemTests {
    @Test("Initialization")
    func initialization() {
        let todo = TodoItem(id: 1, title: "Test")
        #expect(todo.id == 1)
    }
}
```

Покрытие тестами:
- Unit-тесты Presenter'ов
- Unit-тесты Interactor'ов
- Тесты моделей данных
- Тесты сетевого слоя

Запуск: `Cmd + U` в Xcode

## Требования

- Xcode 16.0+
- iOS 16.0+
- Swift 5.9+
