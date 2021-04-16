//
//  ProjectCell.swift
//  SongSketch
//
//  Created by Samuel Garry on 4/14/21.
//

import Foundation
import UIKit

class ProjectCell: UITableViewCell {
    
    //Variables
    var projectLabel: UILabel!
    var button: UIButton!
    
    //Button Functionality Closure
    var cellTapped: (() -> Void)?

    
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(red: 0/255, green: 79/255, blue: 195/255, alpha: 0.35)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.masksToBounds = true
        
        //Add Labels
        createLabel()
        createButton()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createLabel() {
        projectLabel = UILabel()
        projectLabel.font = UIFont(name: "Courier New", size: 22)
        projectLabel.textAlignment = .center
        projectLabel.textColor = .white
        projectLabel.numberOfLines = 0
        projectLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(projectLabel)
        
        //Label Constraints
        projectLabel.translatesAutoresizingMaskIntoConstraints = false
        projectLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        projectLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    

    func createButton() {
        //Set up the button
        button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        //button.setTitle("Go to Project", for: .normal)
        button.addTarget(self, action: #selector(clickCell), for: .touchUpInside)
        //view.addSubview(button)
        self.contentView.addSubview(button)

        //Button Constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: button!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.25, constant: 0).isActive = true
        NSLayoutConstraint(item: button!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: button!, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
    }
    
    @objc func clickCell() {
        cellTapped?()
    }
}
