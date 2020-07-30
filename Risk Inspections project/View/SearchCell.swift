//
//  SearchCell.swift
//  Risk Inspections project
//
//  Created by Antoine Perry on 7/27/20.
//  Copyright © 2020 Antoine Perry. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    //MARK: - Properties
    
    var inspectionArray: [InspectionModel]? {
        didSet {
            guard let inspectionArray = inspectionArray else { return }
            for location in inspectionArray {
                if location.risk.rawValue == self.getRiskString(risk: .risk2Medium) || location.risk.rawValue == self.getRiskString(risk: .risk3Low) {
                    nameLabel.text = location.risk.rawValue

                }
            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Risk"
        label.backgroundColor = .clear
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    
    func getRiskString(risk: Risk) -> String {
        return risk.rawValue
    }
    
    func riskCase(risk: Risk) {
        switch risk {
        case .risk1High:
            print("N/A")
        case .risk2Medium:
            print("Medium")
        case .risk3Low:
            print("Low")
        }
    }
    
    func configureUI() {
        backgroundColor = .white
        
        addSubview(nameLabel)
        
        nameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
}
