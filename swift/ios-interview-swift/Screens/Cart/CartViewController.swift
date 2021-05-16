//
//  CartViewController.swift
//  Takeout Central Driver App
//
//  Created by Mike on 12/29/20.
//  Copyright © 2020 Takeout Central. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift

final class CartViewController: UIViewController {

    private var binding: CartView {
        // swiftlint:disable:next force_cast
        view as! CartView
    }

    private let viewModel = CartViewModel()
    private let disposeBag = DisposeBag()
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<OrderCartInfo>(configureCell: configureCell)

    init(cartID: String) {
        try? viewModel.load(cartID: cartID)

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = CartView()
        title = "Cart"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        binding.tableView.delegate = self
        binding.tableView.dataSource = nil

        viewModel.cartInfo
            .drive(binding.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    private func configureCell(
        dataSource _: TableViewSectionedDataSource<OrderCartInfo>,
        tableView: UITableView,
        indexPath: IndexPath,
        item: OrderCartInfo.Item
    ) -> UITableViewCell {
        switch item {
        case let .item(name, quantity, pickedUp, _):
            let cell: CartItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            let restStatus = dataSource[indexPath.section].restStatus
            let showChecklist = viewModel.showChecklist && restStatus != .sent
            cell.bind(quantity: quantity, item: name, showCheckbox: showChecklist)
            cell.isPickedUp = showChecklist ? pickedUp : false
            return cell

        case let .option(name):
            let cell: CartOptionTableViewCell =
                tableView.dequeueReusableCell(for: indexPath)
            cell.bind(option: name)
            return cell

        case let .comment(label),
             let .whofor(label):
            let cell: CartCommentTableViewCell =
                tableView.dequeueReusableCell(for: indexPath)
            cell.bind(comment: label)
            return cell
        }
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header: CartHeaderViewCell = tableView.dequeueReusableHeaderFooterView() else {
            return nil
        }

        let rest = dataSource[section]
        var status: String?
        switch rest.restStatus {
        case .atrest,
             .pickedup:
            status = String(describing: rest.restStatus)

        default: break
        }
        header.bind(
            orderName: rest.orderName,
            status: status,
            instructions: rest.instructions
        )
        return header
    }

    func tableView(_: UITableView, estimatedHeightForHeaderInSection _: Int) -> CGFloat {
        44.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard viewModel.showChecklist else { return }

        let item = dataSource[indexPath]
        guard case let .item(_, _, _, rowID) = item,
              let cell = tableView.cellForRow(at: indexPath) as? CartItemTableViewCell
        else { return }

        let restStatus = dataSource[indexPath.section].restStatus
        switch restStatus {
        case .pickedup:
            Alerts.presentPickedUpAlert()

        case .atrest:
            cell.isPickedUp.toggle()
            viewModel.setPickedUp(cell.isPickedUp, for: rowID)

        default:
            break
        }
    }
}
