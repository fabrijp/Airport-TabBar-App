//
//  ViewController.swift
//  TabBar App
//
//  Created by Fabri on 2021/07/21.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        self.setTabView()
    }

    func setTabView() {

        // Set the Fonts
        let systemFontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)]
        UITabBarItem.appearance().setTitleTextAttributes(systemFontAttributes, for: .normal)

        let firstTabView = UINavigationController(rootViewController: AirportViewController())
        firstTabView.title = "Airports"
        firstTabView.tabBarItem.image = UIImage(systemName: "map")
        let secondTabView = UINavigationController(rootViewController: FlightsViewController())
        secondTabView.title = "Flights"
        secondTabView.tabBarItem.image = UIImage(systemName: "airplane")
        let thirdTabView = UINavigationController(rootViewController: SettingsViewController())
        thirdTabView.title = "Settings"
        thirdTabView.tabBarItem.image = UIImage(systemName: "gearshape")
        self.setViewControllers([firstTabView, secondTabView, thirdTabView], animated: false)

    }

}
