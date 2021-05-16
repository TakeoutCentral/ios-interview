//
// Created by Michael Gray on 10/9/20.
// Copyright (c) 2020 Takeout Central. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    @objc static func colorWithRGB(_ rgb: Int) -> UIColor {
        UIColor(rgb: rgb)
    }

    @objc static func colorWithARGB(_ argb: Int) -> UIColor {
        UIColor(argb: argb)
    }

    convenience init(rgb: Int) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0,
            alpha: 1
        )
    }

    convenience init(argb: Int) {
        self.init(
            red: CGFloat((argb >> 16) & 0xFF) / 255.0,
            green: CGFloat((argb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(argb & 0xFF) / 255.0,
            alpha: CGFloat((argb >> 24) & 0xFF) / 255.0
        )
    }

    // Primary
    @objc(tc_Orange50) static let orange50 = UIColor(rgb: 0xFAE9E7)
    @objc(tc_Orange100) static let orange100 = UIColor(rgb: 0xFCCCBD)
    @objc(tc_Orange200) static let orange200 = UIColor(rgb: 0xFBAB93)
    @objc(tc_Orange300) static let orange300 = UIColor(rgb: 0xF98B68)
    @objc(tc_Orange400) static let orange400 = UIColor(rgb: 0xF97346)
    @objc(tc_Orange500) static let orange500 = UIColor(rgb: 0xF85B26)
    @objc(tc_Orange600) static let orange600 = UIColor(rgb: 0xEC5522)
    @objc(tc_Orange700) static let orange700 = UIColor(rgb: 0xD14719)
    @objc(tc_Orange800) static let orange800 = UIColor(rgb: 0xB83B13)
    @objc(tc_Orange900) static let orange900 = UIColor(rgb: 0x982600)

    // Analogous
    @objc(tc_Red200) static let red200 = UIColor(rgb: 0xF98FA8)
    @objc(tc_Red400) static let red400 = UIColor(rgb: 0xF0406D)
    @objc(tc_Yellow600) static let yellow600 = UIColor(rgb: 0xF3CF2C)

    // Triadic
    @objc(tc_Lime500) static let lime500 = UIColor(rgb: 0xB4F32C)
    @objc(tc_Green300) static let green300 = UIColor(rgb: 0x2CF36B)
    @objc(tc_Green800) static let green800 = UIColor(rgb: 0x00AD00)

    // Secondary
    @objc(tc_Blue50) static let blue50 = UIColor(rgb: 0xDEF4FB)
    @objc(tc_Blue100) static let blue100 = UIColor(rgb: 0xABE1F7)
    @objc(tc_Blue200) static let blue200 = UIColor(rgb: 0x70CEF2)
    @objc(tc_Blue300) static let blue300 = UIColor(rgb: 0x22BAED)
    @objc(tc_Blue400) static let blue400 = UIColor(rgb: 0x01ACEC)
    @objc(tc_Blue500) static let blue500 = UIColor(rgb: 0x009EE9)
    @objc(tc_Blue600) static let blue600 = UIColor(rgb: 0x0090DA)
    @objc(tc_Blue700) static let blue700 = UIColor(rgb: 0x007FC7)
    @objc(tc_Blue800) static let blue800 = UIColor(rgb: 0x006DB3)
    @objc(tc_Blue900) static let blue900 = UIColor(rgb: 0x004E93)

    // Grayscale
    @objc(tc_Gray) static let gray = UIColor(rgb: 0x9E9E9E)
    @objc(tc_Gray400) static let gray400 = UIColor(rgb: 0xBDBDBD)
    @objc(tc_Gray700) static let gray700 = UIColor(rgb: 0x616161)

    // swiftlint:disable identifier_name
    @objc(tc_Gray1_light) static let gray1_light = UIColor(rgb: 0xFFFFFF)
    @objc(tc_Gray2_light) static let gray2_light = UIColor(rgb: 0xFBFBFB)
    @objc(tc_Gray3_light) static let gray3_light = UIColor(rgb: 0xF2F2F2)
    @objc(tc_Gray4_light) static let gray4_light = UIColor(rgb: 0xEBEBEB)
    @objc(tc_Gray5_light) static let gray5_light = UIColor(rgb: 0xE4E3E2)
    @objc(tc_Gray55) static let gray55 = UIColor(rgb: 0xD8D8D7)
    @objc(tc_Gray6_light) static let gray6_light = UIColor(rgb: 0xCDCECD)
    @objc(tc_Gray7_light) static let gray7_light = UIColor(rgb: 0xBFC1C0)
    @objc(tc_Gray8_light) static let gray8_light = UIColor(rgb: 0x8A8A8A)
    @objc(tc_Gray900_light) static let gray900_light = UIColor(rgb: 0x212121)

    @objc(tc_Gray1_dark) static let gray1_dark = UIColor(rgb: 0x000000)
    @objc(tc_Gray2_dark) static let gray2_dark = UIColor(rgb: 0x141414)
    @objc(tc_Gray3_dark) static let gray3_dark = UIColor(rgb: 0x222222)
    @objc(tc_Gray4_dark) static let gray4_dark = UIColor(rgb: 0x2E2E2E)
    @objc(tc_Gray5_dark) static let gray5_dark = UIColor(rgb: 0x373737)
    @objc(tc_Gray6_dark) static let gray6_dark = UIColor(rgb: 0x434444)
    @objc(tc_Gray7_dark) static let gray7_dark = UIColor(rgb: 0x4F4F50)
    @objc(tc_Gray8_dark) static let gray8_dark = UIColor(rgb: 0x6E6E6E)
    @objc(tc_Gray900_dark) static let gray900_dark = UIColor(rgb: 0xF5F5F5)
    // swiftlint:enable identifier_name
}
