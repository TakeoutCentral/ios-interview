//
// Created by Michael Gray on 10/9/20.
// Copyright (c) 2020 Takeout Central. All rights reserved.
//

import Foundation

struct TextAppearance: DataStruct {
    let font: FontConvertible
    let color: ColorAsset
    let size: CGFloat
    let style: UIFont.TextStyle
    let lineHeight: CGFloat
    let alignment: NSTextAlignment
    let lineBreakMode: NSLineBreakMode

    init(
        font: FontConvertible,
        color: ColorAsset = Colors.textColor,
        size: CGFloat,
        style: UIFont.TextStyle,
        lineHeight: CGFloat = -1,
        alignment: NSTextAlignment = .natural,
        lineBreakMode: NSLineBreakMode = .byClipping
    ) {
        self.font = font
        self.color = color
        self.size = size
        self.style = style
        self.lineHeight = lineHeight
        self.alignment = alignment
        self.lineBreakMode = lineBreakMode
    }
}

extension TextAppearance {
    static func == (lhs: TextAppearance, rhs: TextAppearance) -> Bool {
        lhs.font == rhs.font &&
            lhs.color(CFACurrentTheme) == rhs.color(CFACurrentTheme) &&
            lhs.size == rhs.size &&
            lhs.style == rhs.style &&
            lhs.lineHeight == rhs.lineHeight &&
            lhs.alignment == rhs.alignment &&
            lhs.lineBreakMode == rhs.lineBreakMode
    }

    var attributes: [NSAttributedString.Key: Any] {
        var font = self.font.font(size: size)
        if #available(iOS 11.0, *) {
            font = UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        }
        let style = NSMutableParagraphStyle()
        style.lineSpacing = max(lineHeight - size, 0)
        style.alignment = alignment
        style.lineBreakMode = lineBreakMode

        return [
            NSAttributedString.Key.underlineStyle: 0,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color(CFACurrentTheme),
            NSAttributedString.Key.paragraphStyle: style
        ]
    }
}

extension String {
    func styled(with type: TextAppearance) -> NSAttributedString {
        NSAttributedString(string: self, attributes: type.attributes)
    }

    func styled(with attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        NSAttributedString(string: self, attributes: attributes)
    }
}

extension TextAppearance {
    static let Default = TextAppearance(
        font: FontFamily.OpenSans.regular,
        size: 12,
        style: .body
    )

    enum Metric {
        fileprivate static func `default`(
            color: ColorAsset = Colors.textColor
        ) -> TextAppearance {
            TextAppearance(
                font: FontFamily.Montserrat.bold,
                color: color,
                size: 32,
                style: .headline,
                alignment: .center,
                lineBreakMode: .byWordWrapping
            )
        }

        static let Default = `default`()
        static let Green = `default`(color: Colors.green)
    }

    enum Header {
        fileprivate static func `default`() -> TextAppearance {
            TextAppearance(
                font: FontFamily.Montserrat.bold,
                color: Colors.secondary,
                size: 20,
                style: .headline
            )
        }

        static let Default = `default`()
    }

    enum Header2 {
        fileprivate static func `default`(
            color: ColorAsset = Colors.textColor
        ) -> TextAppearance {
            TextAppearance(
                font: FontFamily.OpenSans.regular,
                color: color,
                size: 18,
                style: .subheadline
            )
        }

        static let Default = `default`()
        static let Secondary = `default`(color: Colors.secondary)
    }

    enum Button {
        fileprivate static func `default`() -> TextAppearance {
            TextAppearance(
                font: FontFamily.Montserrat.bold,
                color: Colors.textColorOnSecondary,
                size: 18,
                style: .subheadline,
                alignment: .center
            )
        }

        static let Default = `default`()
    }

    enum SubHeader {
        fileprivate static func `default`(
            color: ColorAsset = Colors.textColor,
            alignment: NSTextAlignment = .left
        ) -> TextAppearance {
            TextAppearance(
                font: FontFamily.Montserrat.regular,
                color: color,
                size: 16,
                style: .subheadline,
                alignment: alignment
            )
        }

        static let Default = `default`()
        static let Secondary = `default`(
            color: Colors.secondary
        )
        static let Center = `default`(
            color: Colors.secondary,
            alignment: .center
        )
    }

    enum Description {
        fileprivate static func `default`(
            font: FontConvertible = FontFamily.OpenSans.regular,
            color: ColorAsset = Colors.textColor
        ) -> TextAppearance {
            TextAppearance(
                font: font,
                color: color,
                size: 18,
                style: .body
            )
        }

        static let Default = `default`()

        static let Light = `default`(
            font: FontFamily.OpenSans.light
        )

        static let Secondary = `default`(
            color: Colors.secondary
        )

        static let Urgent = `default`(
            color: Colors.red
        )
    }

    enum Label {
        fileprivate static func `default`() -> TextAppearance {
            TextAppearance(
                font: FontFamily.Montserrat.bold,
                size: 12,
                style: .caption1,
                lineHeight: 12
            )
        }

        static let Default = `default`()
    }

    enum Caption {
        fileprivate static func `default`(
            font: FontConvertible = FontFamily.Montserrat.regular,
            alignment: NSTextAlignment = .natural
        ) -> TextAppearance {
            TextAppearance(
                font: font,
                size: 12,
                style: .caption2,
                lineHeight: 12,
                alignment: alignment
            )
        }

        static let Default = `default`()

        static let RightAligned = `default`(
            alignment: .right
        )

        static let Light = `default`(
            font: FontFamily.OpenSans.regular,
            alignment: .center
        )
    }
}
