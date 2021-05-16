//
//  CartCommentTableViewCell.swift
//  Takeout Central Driver App
//
//  Created by Mike on 12/30/20.
//  Copyright © 2020 Takeout Central. All rights reserved.
//

import CFATheme
import Foundation
import Reusable
import TinyConstraints

final class CartCommentTableViewCell: UITableViewCell, Reusable {

    private let commentLabel = Label(textAppearance: TextAppearance.Description.Light) {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
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
        contentView.addSubview(commentLabel)

        commentLabel.edgesToSuperview(insets: .left(64) + .vertical(8) + .right(8))
    }

    func bind(comment: String) {
        commentLabel.text = comment
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        commentLabel.text = nil
    }

    override func themeDidChange(_ theme: CFATheme) {
        backgroundColor = Colors.gray4(theme)
        commentLabel.textColor = Colors.gray900(theme)
    }
}
