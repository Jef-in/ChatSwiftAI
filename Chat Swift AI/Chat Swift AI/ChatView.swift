//
//  ChatView.swift
//  Chat Swift AI
//
//  Created by Jefin on 19/01/23.
//

import Combine
import OpenAISwift
import UIKit

class ChatView: UIViewController {

    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Type in your query here"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.returnKeyType = .done
        return textField
    }()
    
    private let table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    let viewModel = ChatViewModel()
    var cancellable: AnyCancellable?
    var models = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initialSetup()
    }
    
    func initialSetup() {
        setupView()
        table.dataSource = self
        textField.delegate = self
        subscribeOnChatResponse()
    }

    func setupView() {
        view.addSubview(textField)
        view.addSubview(table)
        table.backgroundColor = .clear
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 50),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            textField.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            
            table.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            table.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.bottomAnchor.constraint(equalTo: textField.topAnchor)
        ])
    }
    
    func subscribeOnChatResponse() {
        cancellable = viewModel.$aiResponse.sink(receiveCompletion: { _ in }, receiveValue: { response in
            if !response.isEmpty {
            self.models.append(response)
            DispatchQueue.main.async {
                self.table.reloadData()
                self.scrollToCurrentCell()
            }
            }
        })
    }
    
    func scrollToCurrentCell() {
        self.table.scrollToRow(at: IndexPath(row: self.models.count - 1, section: 0), at: .top, animated: true)
    }
}

extension ChatView: UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = .white
        cell.textLabel?.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = "  "
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty, !text.replacingOccurrences(of: " ", with: "").isEmpty {
            let modelText = text.replacingOccurrences(of: "  ", with: "")
            models.append(modelText)
            DispatchQueue.main.async {
                self.textField.text = "  "
                self.table.reloadData()
            }
            viewModel.getResponseFromAI(for: modelText)
        }
        return true
    }
}
