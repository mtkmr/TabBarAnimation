//
//  UIView+.swift
//  TabBarAnimation
//
//  Created by Masato Takamura on 2021/09/24.
//

import UIKit

extension UIView {
    // 再起的にsubviewsを取得
    //https://qiita.com/shtnkgm/items/fac2756599b3dfcb7aa2
    var recursiveSubviews: [UIView] {
        return subviews + subviews.flatMap { $0.recursiveSubviews }
    }
}
