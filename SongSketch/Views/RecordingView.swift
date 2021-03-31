//
//  RecordingView.swift
//  SongSketch
//
//  Created by Samuel Garry on 3/24/21.
//

import UIKit

class RecordingView: UIView {

    //End Recording Button
    var endButton: UIButton!
    
    
    //Button Functionality Closure -- Send these to the section view controller
    var endRecordTapped: (() -> Void)?
    
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.masksToBounds = true
        
        //Add Button
        createNewTakeButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func endRecord() {
        endRecordTapped?()
    }
    
    func createNewTakeButton() {
        //Button Properties
        endButton = UIButton()
        endButton.setImage(nil, for: .normal)
        endButton.addTarget(self, action: #selector(endRecord), for: .touchUpInside)
        self.addSubview(endButton)
        
        //Button Constraints
        endButton.translatesAutoresizingMaskIntoConstraints = false
        endButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        endButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        endButton.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        endButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
}
