//
//  Typography.swift
//  EmTest
//

import UIKit

enum AppTypography {

    // MARK: - Large Title (Dynamic Type)

    static var largeTitle: UIFont {
        UIFont.preferredFont(forTextStyle: .largeTitle).withWeight(.bold)
    }

    // MARK: - Title (Dynamic Type)

    static var title: UIFont {
        UIFont.preferredFont(forTextStyle: .body).withWeight(.medium)
    }

    // MARK: - Body (Dynamic Type)

    static var body: UIFont {
        UIFont.preferredFont(forTextStyle: .body)
    }

    static var bodySmall: UIFont {
        UIFont.preferredFont(forTextStyle: .subheadline)
    }

    // MARK: - Caption (Dynamic Type)

    static var caption: UIFont {
        UIFont.preferredFont(forTextStyle: .caption1)
    }

    static var captionSmall: UIFont {
        UIFont.preferredFont(forTextStyle: .caption2)
    }
}

// MARK: - UIFont Extension

extension UIFont {

    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        let descriptor = fontDescriptor.addingAttributes([
            .traits: [UIFontDescriptor.TraitKey.weight: weight]
        ])
        return UIFont(descriptor: descriptor, size: 0)
    }
}
