//
//  SelectedSectionBackgroundView.swift
//  SongSketch
//
//  Created by Samuel Garry on 3/31/21.
//

import UIKit

class SelectedSectionBackgroundView: UIView {
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.yellow.cgColor
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
