//
//  CustomTabBar.swift
//  TabBarAnimation
//
//  Created by Masato Takamura on 2021/09/25.
//

import UIKit

class CustomTabBar: UITabBar {

    //ボタンがタップされたときの処理をクロージャを通じて通知する
    var didTapCenterButton: (() -> Void)?

    //真ん中に配置するボタン
    private lazy var centerButton: UIButton = {
        let centerButton = UIButton()
        centerButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        centerButton.tintColor = .white
        centerButton.setImage(
            UIImage(systemName: "plus"),
            for: .normal
        )
        centerButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        centerButton.layer.shadowRadius = 10
        centerButton.layer.shadowColor = UIColor.gray.cgColor
        centerButton.layer.shadowOpacity = 0.7

        centerButton.addTarget(
            self,
            action: #selector(didTapCenterButton(_:)),
            for: .touchUpInside
        )
        return centerButton
    }()

    //レイアウト
    override func layoutSubviews() {
        super.layoutSubviews()
        let centerButtonWidth: CGFloat = 60
        centerButton.frame = CGRect(
            x: frame.width / 2 - centerButtonWidth / 2,
            y: -centerButtonWidth / 2,
            width: centerButtonWidth,
            height: centerButtonWidth
        )
        centerButton.layer.cornerRadius = centerButton.frame.size.width / 2
    }

    //イニシャライザ
    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = .darkGray
        self.addSubview(centerButton)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

///ボタンがタップされたときの処理
    @objc
    private func didTapCenterButton(_ sender: UIButton) {
        didTapCenterButton?()
    }

    ///ボタンがタップされたときの判定を取得する
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }

        return self.centerButton.frame.contains(point) ? self.centerButton : super.hitTest(point, with: event)
    }

//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        var sizeThatFits = super.sizeThatFits(size)
//        sizeThatFits.height = 100
//        return sizeThatFits
//    }

    //tabBarを描く
    private var shapeLayer: CALayer?
    private func addShape() {
        //shapeLayerの設定
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        //描画
        shapeLayer.path = createPath()

        //tabbarの上の影
        shapeLayer.shadowOffset = CGSize(width:0, height:0)
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowColor = UIColor.gray.cgColor
        shapeLayer.shadowOpacity = 0.3

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    func createPath() -> CGPath {
        let height: CGFloat = 48.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        path.move(to: CGPoint(x: 0, y: 0)) // start top left
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0)) // the beginning of the trough

        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height))

        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 35, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))

        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()

        return path.cgPath
    }

    override func draw(_ rect: CGRect) {
        self.addShape()
    }

}
