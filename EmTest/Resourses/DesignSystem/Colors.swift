//
//  Colors.swift
//  EmTest
//

import UIKit

enum AppColors {

    // MARK: - Background

    static let background = UIColor.background
    static let backgroundSecondary = UIColor.backgroundSecondary
    static let backgroundTertiary = UIColor.backgroundTertiary

    // MARK: - Text

    static let textPrimary = UIColor.textPrimary
    static let textSecondary = UIColor.textSecondary
    static let textPlaceholder = UIColor.textSecondary

    // MARK: - Accent

    static let accent = UIColor.accent
    static let accentSecondary = UIColor.textSecondary

    // MARK: - Semantic

    static let destructive = UIColor.destructive
    static let separator = UIColor.separator

    // MARK: - Components

    enum Checkbox {
        static let completed = AppColors.accent
        static let uncompleted = AppColors.accentSecondary
    }

    enum NavigationBar {
        static let background = AppColors.background
        static let title = AppColors.textPrimary
        static let tint = AppColors.accent
    }

    enum SearchBar {
        static let background = AppColors.backgroundTertiary
        static let text = AppColors.textPrimary
        static let placeholder = AppColors.textPlaceholder
        static let tint = AppColors.textPrimary
    }

    enum Cell {
        static let background = AppColors.background
        static let title = AppColors.textPrimary
        static let titleCompleted = AppColors.textSecondary
        static let description = AppColors.textPrimary
        static let date = AppColors.textSecondary
    }

    enum Footer {
        static let background = AppColors.backgroundSecondary
        static let text = AppColors.textPrimary
    }
}
