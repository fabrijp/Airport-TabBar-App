//
//  SettingsViewController.swift
//  TabBar App
//
//  Created by Fabri on 2021/07/30.
//

import UIKit

class SettingsViewController: UIViewController {

    // Metric buttons
    let kmButton = UIButton(type: .roundedRect)
    let milesButton = UIButton(type: .roundedRect)

    // Data
    let settingsData = PersistenceStorage()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        setOptions()
    }

    func setOptions() {

        let buttonView = UIView()
        buttonView.backgroundColor = .white
        buttonView.addSubview(kmButton)
        buttonView.addSubview(milesButton)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        // Button styles
        setButtons()

        // Button actions
        kmButton.addTarget(self, action: #selector(kmButtonTap(_:)), for: .touchUpInside)
        milesButton.addTarget(self, action: #selector(milesButtonTap(_:)), for: .touchUpInside)

        self.view = buttonView

    }

    func setButtons() {

        // UI/UX Design is out of scope for this project
        let metrics = settingsData.loadSettings()

        kmButton.frame = CGRect(x: 30, y: 120, width: 100, height: 50)
        kmButton.setTitle("Kilometers", for: .normal)
        kmButton.isEnabled = metrics.unit == .kilometers ? false:true
        kmButton.backgroundColor = metrics.unit == .kilometers ? .lightGray:.clear
        kmButton.tintColor = metrics.unit == .kilometers ? .white:.black
        milesButton.frame = CGRect(x: view.frame.width - 140, y: 120, width: 100, height: 50)
        milesButton.setTitle("Miles", for: .normal)
        milesButton.isEnabled = metrics.unit == .miles ? false:true
        milesButton.backgroundColor = metrics.unit == .miles ? .lightGray:.clear
        milesButton.tintColor = metrics.unit == .miles ? .white:.black

    }

    @objc func kmButtonTap(_ sender: UIButton) {
        settingsData.updateSettingsUnit(value: .kilometers)
        DispatchQueue.main.async { self.setButtons() }
    }

    @objc func milesButtonTap(_ sender: UIButton) {
        settingsData.updateSettingsUnit(value: .miles)
        DispatchQueue.main.async { self.setButtons() }
    }

}
