//
//  Colors.swift
//  EmTest
//

import UIKit

enum AppColors {

    // MARK: - Background

    static let background = UIColor(named: "Colors/Background") ?? .black
    static let backgroundSecondary = UIColor(named: "Colors/BackgroundSecondary") ?? UIColor(white: 0.1, alpha: 1.0)
    static let backgroundTertiary = UIColor(named: "Colors/BackgroundTertiary") ?? UIColor(white: 0.15, alpha: 1.0)

    // MARK: - Text

    static let textPrimary = UIColor(named: "Colors/TextPrimary") ?? .white
    static let textSecondary = UIColor(named: "Colors/TextSecondary") ?? .gray
    static let textPlaceholder = UIColor(named: "Colors/TextSecondary") ?? .gray

    // MARK: - Accent

    static let accent = UIColor(named: "Colors/Accent") ?? .systemYellow
    static let accentSecondary = UIColor(named: "Colors/TextSecondary") ?? .gray

    // MARK: - Semantic

    static let destructive = UIColor(named: "Colors/Destructive") ?? .systemRed
    static let separator = UIColor(named: "Colors/Separator") ?? .darkGray

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
