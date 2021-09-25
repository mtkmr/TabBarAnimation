//
//  CenterViewController.swift
//  TabBarAnimation
//
//  Created by Masato Takamura on 2021/09/25.
//

import UIKit

final class CenterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        navigationItem.title = "Center"

        let closeButton = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapCloseButton(_:)))
        navigationItem.rightBarButtonItem = closeButton
    }

    @objc private func didTapCloseButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
