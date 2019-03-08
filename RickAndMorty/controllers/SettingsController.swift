//
//  SettingsControllerViewController.swift
//  RickAndMorty
//
//  Created by Karim Yarboua on 08/03/2019.
//  Copyright © 2019 Karim Yarboua. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var StatusSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwitch()
        setupNameLabel()
    }
    
    func setupSwitch() {
        StatusSwitch.setOn(UserDefaultsHelper().getStatus(), animated: true)
        statusLabel.text = "Status: \(UserDefaultsHelper().getStatusString())"
    }
    
    func setupNameLabel() {
        let name = UserDefaultsHelper().getName()
        if name == "" {
            nameTextField.placeholder = "Enter name"
        }
        else {
            nameTextField.text = name
        }
    }

    @IBAction func saveClicked(_ sender: Any) {
        UserDefaultsHelper().setName(name: nameTextField.text)
        navigationController?.popViewController(animated: true)
    }
    @IBAction func switchChanged(_ sender: UISwitch) {
        UserDefaultsHelper().setStatus(bool: sender.isOn)
        setupSwitch()
    }
}
