//
//  UserDefaults.swift
//  TODO2POO
//
//  Created by JohnAnge Kernodle on 4/3/24.
//

import Foundation

extension UserDefaults {
    
    func setStruct<T: Codable> (value: T?, key: String) {
        do {
            let json = try JSONEncoder().encode(value)
            set(json, forKey: key)
        } catch {
            print("Error encoding")
        }
    }
    
    func getStruct<T: Decodable> (value: T.Type, key: String) -> T?  {
        guard let data = data(forKey: key) else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Error decoding")
            return nil
        }
    }
}
