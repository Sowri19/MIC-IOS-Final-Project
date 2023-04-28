//
//  GlobalFunctions.swift
//  MIC
//
//  Created by Rikin Parekh on 4/28/23.
//

import Foundation

var filteredEvents: [[String: Any]] = []

func fetchEvents(completion: @escaping ([[String : Any]]?, Error?) -> Void) {
    do {
        guard let url = URL(string: "http://localhost:8080/events/getAll") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request){ data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    do {
                        // make sure this JSON is in the format we expect
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                            // try to read out a string array
                            DispatchQueue.main.async {
                                completion(json, nil)
                            }
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                } else {
                    print("Server Error: \(httpResponse.statusCode)")
                    DispatchQueue.main.async {
                        completion(nil, NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil))
                    }
                }
            }
        }
        task.resume()
    } catch {
        print(error.localizedDescription)
    }
}
