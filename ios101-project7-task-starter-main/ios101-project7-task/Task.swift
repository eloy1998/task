//
//  Task.swift
//

import Foundation

// MARK: - Task Model

struct Task: Codable, Equatable {
    var title: String
    var note: String?
    var dueDate: Date
    var isComplete: Bool = false {
        didSet {
            completedDate = isComplete ? Date() : nil
        }
    }

    private(set) var completedDate: Date?
    private(set) var createdDate: Date = Date()
    private(set) var id: String = UUID().uuidString

    // Initializer
    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
    }

    // Required for Equatable
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Task Persistence with UserDefaults

extension Task {
    private static let userDefaultsKey = "tasks"

    // Save all tasks to UserDefaults
    static func save(_ tasks: [Task]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(tasks)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Error saving tasks: \(error)")
        }
    }

    // Load tasks from UserDefaults
    static func getTasks() -> [Task] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            return []
        }

        let decoder = JSONDecoder()
        do {
            return try decoder.decode([Task].self, from: data)
        } catch {
            print("Error loading tasks: \(error)")
            return []
        }
    }

    // Save or update this task
    func save() {
        var tasks = Task.getTasks()
        if let index = tasks.firstIndex(where: { $0.id == self.id }) {
            tasks[index] = self
        } else {
            tasks.append(self)
        }
        Task.save(tasks)
    }

    // Delete this task
    func delete() {
        var tasks = Task.getTasks()
        tasks.removeAll { $0.id == self.id }
        Task.save(tasks)
    }
}
