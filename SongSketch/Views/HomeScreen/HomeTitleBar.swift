//
//  HomeTitleBar.swift
//  SongSketch
//
//  Created by Samuel Garry on 4/14/21.
//

import UIKit

class HomeTitleBar: UIView {
   
    //Variables
    var titleLabel: UILabel!
    
    
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setupTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTitle() {
        
        //Title LABEL
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Avenir", size: 48)
        titleLabel.textColor = UIColor.white
        titleLabel.text = "Song Sketch"
        self.addSubview(titleLabel)
        
        NSLayoutConstraint(item: titleLabel!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
    
}
