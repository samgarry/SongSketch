//
//  ProjectTableFooter.swift
//  SongSketch
//
//  Created by Samuel Garry on 4/15/21.
//

import UIKit

class ProjectTableFooter: UIView {

    //Add New Project Button Variable
    var button: UIButton!
    
    //Symbol Variables
    var plus = UIImage()
    let configuration = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular, scale: .medium)
    
    //Button Closure
    var addProject: (() -> Void)?
    
    override init(frame: CGRect) {
       super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.layer.masksToBounds = true
        
        //Setup Button
        createButton()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createButton() {
        
        //Image Setup
        let originalPlus = UIImage(systemName: "plus")
        plus = (originalPlus?.withTintColor(.white, renderingMode: .alwaysOriginal))!
        
        button = UIButton()
        button.setImage(plus, for: .normal)
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        button.frame = button.currentImage!.accessibilityFrame
        button.addTarget(self, action: #selector(pressPlusButton), for: .touchUpInside)
        self.addSubview(button)
        
        //Constraint Setup
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    @objc func pressPlusButton() {
        addProject?()
    }
    
}
