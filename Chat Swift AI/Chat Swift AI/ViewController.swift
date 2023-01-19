//
//  ViewController.swift
//  Chat Swift AI
//
//  Created by Jefin on 19/01/23.
//

import OpenAISwift
import UIKit

class ViewController: UIViewController {

    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type in your query here"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .lightGray
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initialSetup()
    }
    
    func initialSetup() {
        view.addSubview(textField)
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 50),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            textField.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
}

