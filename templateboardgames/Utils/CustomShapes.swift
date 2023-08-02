//
//  CustomShapes.swift
//  templateboardgames
//
//  Created by Quentin Deschamps on 18/07/2023.
//

import Foundation
import SwiftUI

struct CustomCardCutBackground: Shape {
    let minX = 0
    let midX = 0
    let maxX = 125
    let minY = 0
    let maxY = 150
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 150, y: 0))
        path.addLine(to: CGPoint(x: 125, y: 200))
        path.addLine(to: CGPoint(x: 0, y: 200))
        path.addLine(to: CGPoint(x: 0, y: 0))
        return path
    }
}
