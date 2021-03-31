//
//  EmptySectionView.swift
//  SongSketch
//
//  Created by Samuel Garry on 3/23/21.
//

import UIKit

class EmptySectionView: UIView {
    
    //Button Symbol Properties
    var plus = UIImage()
    let configuration = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular, scale: .medium)
    
    //Record Button
    var recordButton: UIButton!
    
    //Button Functionality Closures -- Send these to the section view controller
    var recordTapped: (() -> Void)?
    
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.masksToBounds = true
        
        //Plus Symbol
        let originalPlus = UIImage(systemName: "plus")
        plus = (originalPlus?.withTintColor(.white, renderingMode: .alwaysOriginal))!
        
        //Add Record Button
        createRecordButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Function that calls the recordTapped closure
    @objc func pressRecord() {
        recordTapped?()
    }
    
    //Create the record button that covers the entire view
    func createRecordButton() {
        //Button Properties
        recordButton = UIButton()
        recordButton.setImage(plus, for: .normal)
        recordButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        recordButton.titleLabel?.font = UIFont.init(name: "Courier New", size: 14)
        recordButton.addTarget(self, action: #selector(pressRecord), for: .touchUpInside)
        self.addSubview(recordButton)
        
        //Button Constraints
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        recordButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        recordButton.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        recordButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
