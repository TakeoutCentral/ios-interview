//
//  ViewController.swift
//  ios-interview
//
//  Created by Mike on 5/15/21.
//

import TinyConstraints
import UIKit

class ViewController: UIViewController {

    let label = UILabel()

    let mapButton = UIButton(type: .roundedRect)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(label)
        
        label.text = "Hello World"
        label.textColor = .black

//        label.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint(
//            item: label,
//            attribute: .centerX,
//            relatedBy: .equal,
//            toItem: view,
//            attribute: .centerX,
//            multiplier: 1,
//            constant: 0
//        ).isActive = true
//        NSLayoutConstraint(
//            item: label,
//            attribute: .centerY,
//            relatedBy: .equal,
//            toItem: view,
//            attribute: .centerY,
//            multiplier: 1,
//            constant: 0
//        ).isActive = true

        label.centerInSuperview()

        view.addSubview(mapButton)

        mapButton.setTitle("Map It", for: .normal)

        mapButton.centerXToSuperview()
        mapButton.topToBottom(of: label, offset: 20)

        mapButton.addTarget(self, action: #selector(mapIt), for: .touchUpInside)
    }

    @objc
    private func mapIt() {
        navigationController?.pushViewController(MapViewController(), animated: true)
    }
}

