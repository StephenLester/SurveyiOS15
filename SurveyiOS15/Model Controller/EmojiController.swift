//
//  EmojiController.swift
//  SurveyiOS15
//
//  Created by Steve Lester on 10/5/17.
//  Copyright © 2017 Steve Lester. All rights reserved.
//

import Foundation

class SurveyController {
    static let shared = SurveyController()
    
    // MARK: - Source of Truth
    var surveys: [Survey] = []
    
    /*
     The empty compleation is a great way to notify the caller of the function that you are done running your code. You can complete with an object or an array of objects when the caller needs to access them. Both options give you the benefit of knowing exactly when that function is done running. This is always nice when you are running async code.
     Because you don't know HOW LONG IT WILL TAKE!
     */
    
    private let baseURL = URL(string: "https://favemojiios15-a0261.firebaseio.com/")
    
    func putSurvey(wirh name: String, emoji: String, completion: @escaping(_ success: Bool) -> Void) {
        
        // Create an instance of Survey
        let survey = Survey(name: name, emoji: emoji)
        
        guard let url = baseURL else { fatalError("Bad URL")}
        
        // Build the url
        let requestURL = url.appendingPathExtension("json")
        
        // Create the request
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        request.httpBody = survey.jsonData
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            var success = false
            defer { completion(success)}
            
            // som Super Duper error handling
            if let error = error {
                print("Steve broke our request \(error.localizedDescription) \(#function)")
            }
            guard let data = data,
                let responceDataString = String(data: data, encoding: .utf8) else { return }
            if let error = error {
                print("Error: \(error.localizedDescription) \(#function)")
            } else {
                print("Successfully saved data to endpint \(responceDataString)")
            }
            // add survey to our Source Of Truth
            self.surveys.append(survey)
            
            success = true
            
            }.resume()
    }
    func fetchEmoji(completion: @escaping ([Survey]?) -> Void) {
        
        guard let url = baseURL?.appendingPathExtension("json") else {
            print("Bad baseURL")
            completion([])
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
            print("Error Fetching \(error.localizedDescription) \(#function) \(#file)")
            completion([])
            return
        }
            guard let data = data else {
                print("No data returned from data task")
                completion([])
                return
            }
            // Serialize our data
            guard let surveyDictionries = (try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: String]]) else {
                print("Fetching from JSONObject")
                completion([])
                return
                }
            guard let surveys = surveyDictionries?.flatMap({Survey(dictionary: $0.value, identifier: $0.key)}) else { return }
            self.surveys = surveys
            completion(surveys)
    }.resume()
    
}

}
