//
//  CartItemTableViewCell.swift
//  Takeout Central Driver App
//
//  Created by Mike on 12/29/20.
//  Copyright © 2020 Takeout Central. All rights reserved.
//

import CFATheme
import CocoaLumberjack
import Foundation
import Reusable
import TinyConstraints

final class CartItemTableViewCell: UITableViewCell, Reusable {

    private let amountLabel = Label(textAppearance: TextAppearance.Description.Default) {
        $0.textAlignment = .right
        $0.accessibilityIdentifier = "amountLabel"
    }

    private let itemLabel = Label(textAppearance: TextAppearance.Description.Default) {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.accessibilityIdentifier = "itemLabel"
    }

    private let checkboxView: Checkbox = {
        let checkbox = Checkbox()
        checkbox.checkmarkStyle = .tick
        checkbox.checkmarkLineWidth = 2
        checkbox.accessibilityIdentifier = "checkboxView"
        return checkbox
    }()

    override init(style _: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        loadView()
        registerForThemeChanges()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadView() {
        selectionStyle = .none
        contentView.addSubview(amountLabel)
        contentView.addSubview(itemLabel)
        contentView.addSubview(checkboxView)

        amountLabel.edgesToSuperview(excluding: .trailing)
        amountLabel.trailingToLeading(of: contentView, offset: 60)

        itemLabel.leadingToTrailing(of: amountLabel, offset: 4)
        itemLabel.verticalToSuperview(insets: .vertical(10))
        itemLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        checkboxView.leadingToTrailing(of: itemLabel, offset: 8)
        checkboxView.centerYToSuperview()
        checkboxView.trailingToSuperview(offset: 16)
        checkboxView.widthToHeight(of: checkboxView)
        checkboxView.width(25)

        checkboxView.isUserInteractionEnabled = false
    }

    func bind(quantity: Int, item: String, showCheckbox: Bool) {
        amountLabel.text = "\(quantity) x"
        itemLabel.text = item
        checkboxView.isHidden = !showCheckbox
    }

    var isPickedUp: Bool {
        get {
            checkboxView.isChecked
        }
        set {
            checkboxView.isChecked = newValue
            itemLabel.setStrikethrough(newValue)
            setNeedsDisplay()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        amountLabel.text = nil
        itemLabel.text = nil
    }

    override func themeDidChange(_ theme: CFATheme) {
        backgroundColor = Colors.gray4(theme)
        amountLabel.textColor = Colors.gray900(theme)
        itemLabel.textColor = Colors.gray900(theme)
        checkboxView.tintColor = Colors.secondary(theme)
    }
}

private extension Label {
    func setStrikethrough(_ enable: Bool) {
        guard let attributedText = attributedText else { return }

        let newText = NSMutableAttributedString(attributedString: attributedText)
        let range = NSRange(location: 0, length: newText.length)
        if enable {
            newText.addAttributes(
                [
                    NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    NSAttributedString.Key.strikethroughColor: textAppearance.color(CFACurrentTheme)
                ],
                range: range
            )
        } else {
            newText.removeAttribute(
                NSAttributedString.Key.strikethroughStyle,
                range: range
            )
            newText.removeAttribute(
                NSAttributedString.Key.strikethroughColor,
                range: range
            )
        }

        self.attributedText = newText
    }
}
