//
//  ViewController.swift
//  ios-interview-swift
//
//  Created by Mike on 5/16/21.
//

import TinyConstraints
import UIKit

class ViewController: UIViewController {

    private let label = UILabel()
    private let button = UIButton(type: .roundedRect)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = .white
        view.addSubview(label)
        label.textColor = .black
        label.text = "Hello World"
        label.centerInSuperview()

        view.addSubview(button)
        button.setTitle("Cart", for: .normal)
        button.centerXToSuperview()
        button.topToBottom(of: label, offset: 20)

        button.addTarget(self, action: #selector(cart), for: .touchUpInside)
    }

    @objc
    private func cart() {
        navigationController?.pushViewController(CartViewController(cartID: "1234"), animated: true)
    }
}

