//
//  SearchInputView.swift
//  Risk Inspections project
//
//  Created by Antoine Perry on 7/27/20.
//  Copyright © 2020 Antoine Perry. All rights reserved.
//

import UIKit

let reuseIdentifier = "SearchCell"

protocol SearchInputViewDelegate {
    func animateCenterMapButton(expansionState: SearchInputView.ExpansionState, hidebutton: Bool)
}

class SearchInputView: UIView {
    
    var inspectionArray: [InspectionModel]? {
        didSet {
            guard let inspectionArray = inspectionArray else { return }
            
        }
    }
    
    // MARK: - Properties
    
    var searchBar: UISearchBar!
    var tableView: UITableView!
    var expansionState: ExpansionState!
    var delegate: SearchInputViewDelegate?
    
    enum ExpansionState {
        case NotExpanded
        case PartiallyExpanded
        case FullyExpanded
    }
    
    let indicatorView: UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 5
        view.alpha = 0.8
        return view
    }()

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
        expansionState = .NotExpanded
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleSwipeGesture(sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            if expansionState == .NotExpanded {
                delegate?.animateCenterMapButton(expansionState: self.expansionState, hidebutton: false)
                
                animateInputView(targetPosition: self.frame.origin.y - 250) { (_) in
                    self.expansionState = .PartiallyExpanded
                }
            }
            if expansionState == .PartiallyExpanded {
                delegate?.animateCenterMapButton(expansionState: self.expansionState, hidebutton: true)
                
                animateInputView(targetPosition: self.frame.origin.y - 500) { (_) in
                    self.expansionState = .FullyExpanded
                }
            }
        } else {
            if expansionState == .FullyExpanded {
                self.searchBar.endEditing(true)
                self.searchBar.showsCancelButton = false
                
                animateInputView(targetPosition: self.frame.origin.y + 500) { (_) in
                    self.delegate?.animateCenterMapButton(expansionState: self.expansionState, hidebutton: false)
                    self.expansionState = .PartiallyExpanded
                }
            }
            if expansionState == .PartiallyExpanded {
                delegate?.animateCenterMapButton(expansionState: self.expansionState, hidebutton: false)
                
                animateInputView(targetPosition: self.frame.origin.y + 250) { (_) in
                    self.expansionState = .NotExpanded
                }
            }
        }
        
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
        
        addSubview(indicatorView)
        indicatorView.anchor(top: topAnchor, paddingTop: 8, width: 40, height: 8)
        indicatorView.centerX(inView: self)
        
        configureSearchBar()
        configureTableView()
        configureGestureRecognizers()
    }
    
    func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search for Inspections"
        searchBar.delegate = self
        searchBar.barStyle = .black
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        addSubview(searchBar)
        searchBar.anchor(top: indicatorView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingRight: 8, height: 50)
    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.rowHeight = 72
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SearchCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        addSubview(tableView)
        tableView.anchor(top: searchBar.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 100)
    }
    
    func configureGestureRecognizers() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeUp.direction = .up
        addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }
    
    func dismissOnSearch() {
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        
        animateInputView(targetPosition: self.frame.origin.y + 500) { (_) in
            self.delegate?.animateCenterMapButton(expansionState: self.expansionState, hidebutton: false)
            self.expansionState = .PartiallyExpanded
        }
    }
    
    func animateInputView(targetPosition: CGFloat, completion: @escaping(Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.frame.origin.y = targetPosition
        }, completion: completion)
    }

}

// MARK: - UISearchBarDelegate

extension SearchInputView: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if expansionState == .NotExpanded {
            delegate?.animateCenterMapButton(expansionState: self.expansionState, hidebutton: true)
            
            animateInputView(targetPosition: self.frame.origin.y - 750) { (_) in
                self.expansionState = .FullyExpanded
            }
        }
        
        if expansionState == .PartiallyExpanded {
            delegate?.animateCenterMapButton(expansionState: self.expansionState, hidebutton: true)
            
            animateInputView(targetPosition: self.frame.origin.y - 500) { (_) in
                self.expansionState = .FullyExpanded
            }
        }
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissOnSearch()
    }
}

extension SearchInputView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchCell
        cell.backgroundColor = .white
        cell.textLabel?.textColor = UIColor.black
        
        return cell
    }
    
    
}
