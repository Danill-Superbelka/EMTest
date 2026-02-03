//
//  Icons.swift
//  EmTest
//

import UIKit

enum AppIcons {

    // MARK: - Icon Size

    static let defaultSize: CGFloat = 24

    // MARK: - SF Symbols

    enum Name {
        static let checkboxCompleted = "checkmark.circle"
        static let checkboxUncompleted = "circle"
        static let add = "square.and.pencil"
        static let back = "chevron.left"
        static let delete = "trash"
        static let edit = "pencil"
        static let share = "square.and.arrow.up"
    }

    // MARK: - Configured Icons

    static func icon(_ name: String, size: CGFloat = defaultSize, weight: UIImage.SymbolWeight = .regular) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: size, weight: weight)
        return UIImage(systemName: name, withConfiguration: config)
    }

    static var checkboxCompleted: UIImage? {
        icon(Name.checkboxCompleted)
    }

    static var checkboxUncompleted: UIImage? {
        icon(Name.checkboxUncompleted)
    }

    static var add: UIImage? {
        icon(Name.add)
    }

    static var back: UIImage? {
        icon(Name.back)
    }

    static var delete: UIImage? {
        icon(Name.delete)
    }

    static var edit: UIImage? {
        icon(Name.edit)
    }

    static var share: UIImage? {
        icon(Name.share)
    }
}
