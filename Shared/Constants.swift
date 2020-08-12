//
//  Constants.swift
//  ActivityCountdown
//
//  Created by Aidan Pendlebury on 20/07/2020.
//

import SwiftUI

enum Colors {
    static var pinkDark = Color(hex: "fb0f5a")
    static var pinkLight = Color(hex: "fa3b89")
    static var yellowDark = Color(hex: "afff02")
    static var yellowLight = Color(hex: "d4fe02")
    static var blueLight = Color(hex: "00fff8")
    static var blueDark = Color(hex: "00ffbc")
}

enum SFSymbols {
    static var checkMark = Image(systemName: "checkmark.circle.fill")
    static var info = Image(systemName: "info.circle")
}

enum Gradients {
    static var activity = LinearGradient(gradient: Gradient(colors: [Colors.pinkDark, Colors.pinkLight]), startPoint: .leading, endPoint: .trailing)
    static var exercise = LinearGradient(gradient: Gradient(colors: [Colors.yellowDark, Colors.yellowLight]), startPoint: .leading, endPoint: .trailing)
    static var standing = LinearGradient(gradient: Gradient(colors: [Colors.blueDark, Colors.blueLight]), startPoint: .leading, endPoint: .trailing)
}

enum RingType {
    case activity, exercise, standing
}
