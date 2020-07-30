//
//  Service.swift
//  Risk Inspections project
//
//  Created by Antoine Perry on 7/28/20.
//  Copyright © 2020 Antoine Perry. All rights reserved.
//

import UIKit

var inspectionArray = [InspectionModel]()

public class Service {
    
    static let shared = Service()
    
    let Base_URL = "https://data.cityofchicago.org/resource/j8a4-a59k.json?$limit=100"
    
    
    
    func fetchInspections(completion: @escaping([InspectionModel]) -> ()) {
        
        guard let url = URL(string: Base_URL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Failed to fetch data with error \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let resultsArray = try JSONDecoder().decode([InspectionModel].self, from: data)
                inspectionArray = resultsArray
                completion(inspectionArray)
            } catch let error {
                print("Failed to make json with error \(error.localizedDescription)")
            }
        }.resume()
    }
}
