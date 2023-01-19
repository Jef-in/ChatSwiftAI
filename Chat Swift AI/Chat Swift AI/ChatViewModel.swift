//
//  ChatViewModel.swift
//  Chat Swift AI
//
//  Created by Jefin on 19/01/23.
//

import Foundation

class ChatViewModel {
    
    @Published var aiResponse = ""
    
    let chatService = ChatAIService.shared
    
    func getResponseFromAI(for query: String) {
        chatService.getResponsefromAI(for: query) { result in
            switch result {
            case .success(let response):
                guard !response.isEmpty else { return }
                DispatchQueue.main.async {
                    self.aiResponse = response
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
