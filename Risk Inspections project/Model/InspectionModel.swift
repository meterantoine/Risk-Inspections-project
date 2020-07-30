//
//  InspectionModel.swift
//  Risk Inspections project
//
//  Created by Antoine Perry on 7/28/20.
//  Copyright © 2020 Antoine Perry. All rights reserved.
//

import UIKit

struct InspectionModel: Codable {
    var risk: Risk
    var latitude, longitude: String?
}

enum Risk: String, Codable {
    case risk1High = "Risk 1 (High)"
    case risk2Medium = "Risk 2 (Medium)"
    case risk3Low = "Risk 3 (Low)"
}
