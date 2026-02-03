//
//  DateFormatters.swift
//  EmTest
//

import Foundation

enum AppDateFormatters {

    // MARK: - Shared Formatters

    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }()

    static let fullDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    // MARK: - Convenience Methods

    static func shortDateString(from date: Date) -> String {
        shortDate.string(from: date)
    }

    static func fullDateString(from date: Date) -> String {
        fullDate.string(from: date)
    }

    static func timeString(from date: Date) -> String {
        time.string(from: date)
    }
}
