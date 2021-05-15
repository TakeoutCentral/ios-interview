// Generated using Sourcery 1.4.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable all

import Foundation

func setValueOptional<T>(_ value: OptionalCopyValue<T>, _ defaultValue: T?) -> T? {
    switch(value) {
    case let .new(content):
        return content
    case .same:
        return defaultValue
    default:
        return nil
    }
}

func setValue<T>(_ value: CopyValue<T>, _ defaultValue: T) -> T {
    switch(value) {
    case let .new(content):
        return content
    case .same:
        return defaultValue
    }
}

public enum OptionalCopyValue<T> {
    case new(T?)
    case same
    case `nil`
}

public enum CopyValue<T> {
    case new(T)
    case same
}

// MARK: - TextAppearance
extension TextAppearance {

    public func copy(
        font copied_font: CopyValue<FontConvertible> = .same, 
        color copied_color: CopyValue<ColorAsset> = .same, 
        size copied_size: CopyValue<CGFloat> = .same, 
        style copied_style: CopyValue<UIFont.TextStyle> = .same, 
        lineHeight copied_lineHeight: CopyValue<CGFloat> = .same, 
        alignment copied_alignment: CopyValue<NSTextAlignment> = .same, 
        lineBreakMode copied_lineBreakMode: CopyValue<NSLineBreakMode> = .same
    ) -> TextAppearance {

        let font: FontConvertible = setValue(copied_font, self.font)
        let color: ColorAsset = setValue(copied_color, self.color)
        let size: CGFloat = setValue(copied_size, self.size)
        let style: UIFont.TextStyle = setValue(copied_style, self.style)
        let lineHeight: CGFloat = setValue(copied_lineHeight, self.lineHeight)
        let alignment: NSTextAlignment = setValue(copied_alignment, self.alignment)
        let lineBreakMode: NSLineBreakMode = setValue(copied_lineBreakMode, self.lineBreakMode)
        return TextAppearance(
            font: font, 
            color: color, 
            size: size, 
            style: style, 
            lineHeight: lineHeight, 
            alignment: alignment, 
            lineBreakMode: lineBreakMode
        )
    }

}

