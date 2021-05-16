//
//  CartHeaderViewCell.swift
//  Takeout Central Driver App
//
//  Created by Mike on 12/29/20.
//  Copyright © 2020 Takeout Central. All rights reserved.
//

import CFATheme
import Foundation
import Reusable
import TinyConstraints

final class CartHeaderViewCell: UITableViewHeaderFooterView, Reusable {

    private let restaurantLabel = Label(textAppearance: TextAppearance.Header.Default) {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }

    private let instructionsLabel = Label(textAppearance: TextAppearance.Header2.Secondary) {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        loadView()
        registerForThemeChanges()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadView() {
        let stackView = UIStackView(
            arrangedSubviews: [
                restaurantLabel,
                UIView().then {
                    $0.addSubview(instructionsLabel)
                }
            ]
        ).then {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .equalSpacing
        }
        contentView.addSubview(stackView)

        stackView.edgesToSuperview(insets: .uniform(8))
        instructionsLabel.edgesToSuperview(insets: .left(20))
    }

    func bind(orderName: String, status: String?, instructions: String?) {
        if let status = status {
            restaurantLabel.text = "\(orderName): \(status)"
        } else {
            restaurantLabel.text = orderName
        }
        instructionsLabel.isHidden = instructions.isNilOrEmpty
        instructionsLabel.text = instructions
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        restaurantLabel.text = nil
        instructionsLabel.text = nil
    }

    override func themeDidChange(_ theme: CFATheme) {
        contentView.backgroundColor = Colors.darkSurfaceColor(theme)

        restaurantLabel.textColor = Colors.secondary(theme)
        instructionsLabel.textColor = Colors.secondary(theme)
    }
}
