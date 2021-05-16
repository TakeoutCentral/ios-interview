//
//  CartOptionTableViewCell.swift
//  Takeout Central Driver App
//
//  Created by Mike on 12/30/20.
//  Copyright © 2020 Takeout Central. All rights reserved.
//

import CFATheme
import Foundation
import Reusable
import TinyConstraints

final class CartOptionTableViewCell: UITableViewCell, Reusable {

    private let leadingLabel = Label(
        text: "–",
        textAppearance: TextAppearance.Description.Default
    )

    private let optionLabel = Label(textAppearance: TextAppearance.Description.Default) {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.accessibilityIdentifier = "optionLabel"
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadView()
        registerForThemeChanges()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadView() {
        selectionStyle = .none
        contentView.addSubview(leadingLabel)
        contentView.addSubview(optionLabel)

        optionLabel.edgesToSuperview(insets: .left(64) + .vertical(8) + .right(8))
        leadingLabel.firstBaseline(to: optionLabel)
        leadingLabel.trailingToLeading(of: optionLabel, offset: -4)
    }

    func bind(option: String) {
        optionLabel.text = option
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        optionLabel.text = nil
    }

    override func themeDidChange(_ theme: CFATheme) {
        backgroundColor = Colors.gray4(theme)
        leadingLabel.textColor = Colors.gray900(theme)
        optionLabel.textColor = Colors.gray900(theme)
    }
}
