//
//  serverFunc.swift
//  Studious
//
//  Created by Alex on 7/2/24.
//

import Foundation

let baseURL = "http://127.0.0.1:5000"

class ServerManager {
    static let shared = ServerManager()
    
    private init() {}
    
    func fetchTimings(completion: @escaping ([String: ComboData]?) -> Void) {
        let url = URL(string: "\(baseURL)/get_tasks")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let userCode = UserDefaults.standard.string(forKey: "userCode") {
            request.addValue(userCode, forHTTPHeaderField: "user")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received from server")
                completion(nil)
                return
            }
            
            do {
                let fetchedData = try JSONDecoder().decode([String: ComboData].self, from: data)
                completion(fetchedData)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    func postSessionData(subject: String, workTime: Int, timeRemaining: Int) {
        guard let url = URL(string: "\(baseURL)/sync_timeData") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let userCode = UserDefaults.standard.string(forKey: "userCode") {
            request.addValue(userCode, forHTTPHeaderField: "user")
        }
        let body: [AnyHashable] = [subject, workTime - timeRemaining]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(response)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func postConnected() {
        guard let url = URL(string: "\(baseURL)/connect") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let userCode = UserDefaults.standard.string(forKey: "userCode") {
            request.addValue(userCode, forHTTPHeaderField: "user")
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(response)
            } catch {
                print(error)
            }
        }.resume()
    }
}

struct ChartData: Decodable {
    let name: String
    let value: Float
}

class DataService {
    
    static let shared = DataService()
        
    func fetchPieData(completion: @escaping (Result<[ChartData], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/get_sum_data") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let userCode = UserDefaults.standard.string(forKey: "userCode") {
            request.addValue(userCode, forHTTPHeaderField: "user")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])
                completion(.failure(error))
                return
            }
            
            do {
                let fetchedData = try JSONDecoder().decode([String: Float].self, from: data)
                let chartData = fetchedData.map { ChartData(name: $0.key, value: $0.value) }
                completion(.success(chartData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchBarData(completion: @escaping (Result<[ChartData], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/get_time") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let userCode = UserDefaults.standard.string(forKey: "userCode") {
            request.addValue(userCode, forHTTPHeaderField: "user")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])
                completion(.failure(error))
                return
            }
            
            do {
                let fetchedData = try JSONDecoder().decode([String: Float].self, from: data)
                let chartData = fetchedData.map { ChartData(name: $0.key, value: $0.value) }
                completion(.success(chartData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
