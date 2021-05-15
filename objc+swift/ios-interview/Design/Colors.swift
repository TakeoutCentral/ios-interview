//
// Created by Michael Gray on 10/9/20.
// Copyright (c) 2020 Takeout Central. All rights reserved.
//

import CFATheme
import Foundation

enum Colors {
    static let primary = ColorAsset(.orange600, gray3)
    static let primaryLight = ColorAsset(.orange300, .orange200)
    static let primaryDark = ColorAsset(.orange800, .black)
    static let secondary = ColorAsset(.blue500, .blue200)

    static let green = ColorAsset(.green800, .green300)
    static let red = ColorAsset(.red400, .red200)
    static let blue = ColorAsset(.blue500, .blue300)

    static let textColor = ColorAsset(.black, .gray2_light)
    static let textColorOnPrimary = ColorAsset(.white, .orange300)
    static let textColorOnSecondary = ColorAsset(.white, .gray2_dark)
    static let darkSurfaceColor = ColorAsset(.gray55, gray3)

    static let gray = UIColor(rgb: 0x9E9E9E)
    static let gray1 = ColorAsset(.gray1_light, .gray1_dark)
    static let gray2 = ColorAsset(.gray2_light, .gray2_dark)
    static let gray3 = ColorAsset(.gray3_light, .gray3_dark)
    static let gray4 = ColorAsset(.gray4_light, .gray4_dark)
    static let gray5 = ColorAsset(.gray5_light, .gray5_dark)
    static let gray6 = ColorAsset(.gray6_light, .gray6_dark)
    static let gray7 = ColorAsset(.gray7_light, .gray7_dark)
    static let gray8 = ColorAsset(.gray8_light, .gray8_dark)
    static let gray900 = ColorAsset(.gray900_light, .gray900_dark)
}

@dynamicCallable
struct ColorAsset {
    private let light: UIColor
    private var dark: (CFATheme) -> UIColor

    init(_ light: UIColor, _ dark: UIColor) {
        self.light = light
        self.dark = { _ in dark }
    }

    init(_ light: UIColor, _ dark: ColorAsset) {
        self.light = light
        self.dark = { theme in dark(theme) }
    }

    func dynamicallyCall(withArguments args: [CFATheme]) -> UIColor {
        switch args[0] {
        case .dark:
            return dark(args[0])

        default:
            return light
        }
    }
}
