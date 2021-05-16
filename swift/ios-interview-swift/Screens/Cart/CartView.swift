//
//  CartView.swift
//  Takeout Central Driver App
//
//  Created by Mike on 12/29/20.
//  Copyright © 2020 Takeout Central. All rights reserved.
//

import CFATheme
import Foundation
import Reusable
import TinyConstraints

final class CartView: UIView {

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.tableHeaderView = UIView(
            frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude)
        )
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.register(headerFooterViewType: CartHeaderViewCell.self)
        tableView.register(cellType: CartItemTableViewCell.self)
        tableView.register(cellType: CartOptionTableViewCell.self)
        tableView.register(cellType: CartCommentTableViewCell.self)
        tableView.estimatedRowHeight = 44.0
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 44.0
        return tableView
    }()

    init() {
        super.init(frame: .zero)
        loadView()
        registerForThemeChanges()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadView() {
        addSubview(tableView)
        tableView.edgesToSuperview()
    }

    override func themeDidChange(_ theme: CFATheme) {
        tableView.backgroundColor = Colors.gray7(theme)
        tableView.separatorColor = Colors.gray7(theme)
    }
}
