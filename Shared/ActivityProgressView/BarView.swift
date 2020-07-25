//
//  BarView.swift
//  ActivityCountdown
//
//  Created by Aidan Pendlebury on 25/07/2020.
//

import SwiftUI

struct BarView: View {
    
    var value: Int
    var width: CGFloat
    var height: CGFloat
    var colour: LinearGradient
    
    var body: some View {
        Capsule()
            .fill(colour)
            .frame(width: width, height: height)
        
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(value: 325, width: 150, height: 10, colour: Gradients.activity)
    }
}
