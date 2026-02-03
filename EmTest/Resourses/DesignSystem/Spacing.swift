//
//  Spacing.swift
//  EmTest
//

import UIKit

enum AppSpacing {

    // MARK: - Base Grid (4pt)

    static let xxs: CGFloat = 4
    static let xs: CGFloat = 6
    static let s: CGFloat = 8
    static let m: CGFloat = 12
    static let l: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24

    // MARK: - Component Specific

    enum Cell {
        static let horizontalPadding: CGFloat = AppSpacing.l
        static let verticalPadding: CGFloat = AppSpacing.m
        static let checkboxSize: CGFloat = 24
        static let checkboxToContent: CGFloat = AppSpacing.m
        static let stackSpacing: CGFloat = AppSpacing.xs
    }

    enum Footer {
        static let height: CGFloat = 83
        static let topPadding: CGFloat = AppSpacing.l
        static let horizontalPadding: CGFloat = AppSpacing.xl
        static let buttonSize: CGFloat = 44
    }

    enum Detail {
        static let horizontalPadding: CGFloat = AppSpacing.l
        static let textViewHorizontalPadding: CGFloat = AppSpacing.m
        static let topPadding: CGFloat = AppSpacing.s
        static let sectionSpacing: CGFloat = AppSpacing.l
        static let labelSpacing: CGFloat = AppSpacing.s
    }

    enum Table {
        static let separatorInsetLeft: CGFloat = 52
    }
}
