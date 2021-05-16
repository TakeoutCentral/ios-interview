//
//  Label.swift
//  Takeout Central
//
//  Created by Michael Gray on 8/28/20.
//  Copyright © 2020 Takeout Central. All rights reserved.
//

import CFATheme
import UIKit

class Label: UILabel {
    var textAppearance: TextAppearance = .Default {
        didSet {
            styled(with: textAppearance)
        }
    }

    override var textAlignment: NSTextAlignment {
        get {
            textAppearance.alignment
        }
        set {
            if newValue != textAppearance.alignment {
                textAppearance = textAppearance.copy(
                    alignment: .new(newValue)
                )
            }
        }
    }

    override var lineBreakMode: NSLineBreakMode {
        get {
            textAppearance.lineBreakMode
        }
        set {
            if newValue != textAppearance.lineBreakMode {
                textAppearance = textAppearance.copy(
                    lineBreakMode: .new(newValue)
                )
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(
        text: String? = nil,
        textAppearance: TextAppearance = .Default,
        _ initializer: ((Label) -> Void)? = nil
    ) {
        super.init(frame: .zero)
        self.adjustsFontSizeToFitWidth = false
        self.textAppearance = textAppearance
        self.text = text

        initializer?(self)
    }

    override func layoutSubviews() {
        preferredMaxLayoutWidth = frame.size.width
        super.layoutSubviews()
    }

    override var text: String? {
        get { attributedText?.string }
        set { attributedText = newValue?.styled(with: textAppearance) }
    }

    override var textColor: UIColor? {
        get {
            textAppearance.color(CFACurrentTheme)
        }
        set {
            if let textColor = newValue {
                textAppearance = textAppearance.copy(
                    color: .new(.init(textColor, textColor))
                )
            } else {
                attributedText = text?.styled(with: textAppearance)
            }
        }
    }
}

extension UILabel {
    func styled(with type: TextAppearance) {
        guard let text = attributedText?.string ?? text else {
            return
        }

        attributedText = text.styled(with: type)
    }
}
