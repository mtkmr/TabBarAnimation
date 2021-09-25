//
//  TabBarViewController.swift
//  TabBarAnimation
//
//  Created by Masato Takamura on 2021/09/24.
//

import UIKit

enum Tab: Int {
    case home = 1
    case search
    case center
    case notification
    case message
}

final class TabBarViewController: UITabBarController {

    private lazy var homeVC: HomeViewController = {
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "house"),
            tag: Tab.home.rawValue
        )
        return homeVC
    }()

    private lazy var searchVC: SearchViewController = {
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "magnifyingglass"),
            tag: Tab.search.rawValue
        )
        return searchVC
    }()

    private lazy var centerVC: CenterViewController = {
        let centerVC = CenterViewController()
        return centerVC
    }()

    private lazy var notificationVC: NotificationViewController = {
        let notificationVC = NotificationViewController()
        notificationVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "bell"),
            tag: Tab.notification.rawValue
        )
        return notificationVC
    }()

    private lazy var messageVC: MessageViewController = {
        let messageVC = MessageViewController()
        messageVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "envelope"),
            tag: Tab.message.rawValue
        )
        return messageVC
    }()



    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    /// TabBarの設定
    private func setupTabBar() {
        //カスタムなUITabBarをセット
        setValue(CustomTabBar(frame: tabBar.frame), forKey: "tabBar")
        //子VCをセット
        viewControllers = [
            UINavigationController(rootViewController: homeVC),
            UINavigationController(rootViewController: searchVC),
            centerVC,
            UINavigationController(rootViewController: notificationVC),
            UINavigationController(rootViewController: messageVC)
        ]

        delegate = self

        //centerButtonがタップされたときの処理
        guard let tabBar = tabBar as? CustomTabBar else { return }
        tabBar.didTapCenterButton = { [weak self] in
            let centerVC = CenterViewController()
            let nav = UINavigationController(rootViewController: centerVC)
            nav.modalPresentationStyle = .overFullScreen
            self?.present(
                nav,
                animated: true,
                completion: nil
            )
        }
    }
}

// MARK: - Create VCs
private extension TabBarViewController {

    ///tabbarのimageViewを取得する
    func barImageView(_ tabBar: UITabBar, index: Int) -> UIImageView? {
        let view = tabBar.subviews[index + 1]
        return view.recursiveSubviews.compactMap { $0 as? UIImageView }.first
    }

}

//MARK: - UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
    //tabBarのタブが選択されたとき
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //タブのimageViewを取得
        guard
            let index = tabBar.items?.firstIndex(of: item),
            let tabImageView = barImageView(tabBar, index: index)
        else { return }
        //imageViewをアニメーション
        UIView.animate(
            withDuration: 0,
            animations: {
                tabImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { complete in
            UIView.animate(
                withDuration: 0.2,
                animations: {
                    tabImageView.transform = .identity
                },
                completion: nil
            )
        }
    }


    //タブが選択されるとき
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //真ん中のVCならば、遷移を許可しない
        if viewController is CenterViewController {
            return false
        }
        //基本的には遷移を許可する
        return true
    }

}
