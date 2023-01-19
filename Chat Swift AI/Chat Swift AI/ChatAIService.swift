//
//  ChatAIService.swift
//  Chat Swift AI
//
//  Created by Jefin on 19/01/23.
//

import Combine
import OpenAISwift
import Foundation

final class ChatAIService {
    static let shared = ChatAIService()
    
    private var client: OpenAISwift?
    
    public func setupClient() {
        client = OpenAISwift(authToken: Constants.apiKey)
    }
    
    func getResponsefromAI(for input: String, completion: @escaping (Result<String, Error>) -> Void){
        client?.sendCompletion(with: input, completionHandler: { result in
            switch result {
            case .success(let result):
                let output = result.choices.first?.text ?? ""
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
