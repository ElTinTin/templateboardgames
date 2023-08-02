//
//  RatingStar.swift
//  templateboardgames
//
//  Created by Quentin Deschamps on 19/07/2023.
//

import Foundation
import SwiftUI

struct RatingStar: View {
    var rating: CGFloat
    var color: Color
    var index: Int
    
    var maskRatio: CGFloat {
        let mask = rating - CGFloat(index)
        
        switch mask {
        case 1...: return 1
        case ..<0: return 0
        default: return mask
        }
    }

    init(rating: Decimal, color: Color, index: Int) {
        self.rating = CGFloat(Double(rating.description) ?? 0)
        self.color = color
        self.index = index
    }

    var body: some View {
        GeometryReader { star in
            Image(systemName: "star.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .foregroundColor(self.color)
                .mask(
                    Rectangle()
                        .size(
                            width: star.size.width * self.maskRatio,
                            height: star.size.height
                        )
                    
                )
        }
    }
}

struct FiveStarView: View {
    var rating: Decimal
    var color: Color
    var backgroundColor: Color

    public init(
        rating: Decimal,
        color: Color = .red,
        backgroundColor: Color = .gray
    ) {
        self.rating = rating
        self.color = color
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        ZStack {
            BackgroundStars(backgroundColor)
            ForegroundStars(rating: rating, color: color)
        }
    }
}


private struct StarImage: View {
    var body: some View {
        Image(systemName: "star.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}


private struct BackgroundStars: View {
    var color: Color

    init(_ color: Color) {
        self.color = color
    }

    var body: some View {
        HStack {
            ForEach(0..<5) { _ in
                StarImage()
            }
        }.foregroundColor(color)
    }
}


private struct ForegroundStars: View {
    var rating: Decimal
    var color: Color

    init(rating: Decimal, color: Color) {
        self.rating = rating
        self.color = color
    }

    var body: some View {
        HStack {
            ForEach(0..<5) { index in
                RatingStar(
                    rating: self.rating,
                    color: self.color,
                    index: index
                )
            }
        }
    }
}
