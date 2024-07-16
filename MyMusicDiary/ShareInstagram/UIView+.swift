//
//  UIView+.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 7/15/24.
//

import UIKit

// UIView를 UIImage로 변환
extension UIView {
    func asRenderedImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
