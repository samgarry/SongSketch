//
//  ToolbarView.swift
//  SongSketch
//
//  Created by Samuel Garry on 3/30/21.
//

import UIKit

class ToolbarView: UIView {

    //UI Symbol Variables
    var trashImage = UIImage()
    var editImage = UIImage()
    var notesImage = UIImage()
    let configuration = UIImage.SymbolConfiguration(pointSize: 40, weight: .ultraLight, scale: .small)
    
    //UI Button Variables
    var trashButton: UIButton!
    var editButton: UIButton!
    var notesButton: UIButton!

    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setupToolbar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupToolbar() {
        //Metronome Symbol
        let trash = UIImage(systemName: "trash")
        trashImage = (trash?.withTintColor(.white, renderingMode: .alwaysOriginal))!
        
        //Edit Symbol
        let edit = UIImage(systemName: "pencil")
        editImage = (edit?.withTintColor(.white, renderingMode: .alwaysOriginal))!
        
        //Notes Symbol
        let notes = UIImage(systemName: "book")
        notesImage = (notes?.withTintColor(.white, renderingMode: .alwaysOriginal))!
        
        //Metronome Button Properties
        trashButton = UIButton()
        trashButton.setImage(trashImage, for: .normal)
        trashButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        //metronomeButton.addTarget(self, action: #selector(pressRecord), for: .touchUpInside)
        //metronomeButton.frame = addNewTakeButton.currentImage!.accessibilityFrame
        self.addSubview(trashButton)
        trashButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: trashButton!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: trashButton!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: trashButton!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 1).isActive = true
        
        //Edit Button Properties
        editButton = UIButton()
        editButton.setImage(editImage, for: .normal)
        editButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        //metronomeButton.addTarget(self, action: #selector(pressRecord), for: .touchUpInside)
        //metronomeButton.frame = addNewTakeButton.currentImage!.accessibilityFrame
        self.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint(item: editButton!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -75).isActive = true
        NSLayoutConstraint(item: editButton!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: editButton!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 1).isActive = true
        
        //Notes Button Properties
        notesButton = UIButton()
        notesButton.setImage(notesImage, for: .normal)
        notesButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        //metronomeButton.addTarget(self, action: #selector(pressRecord), for: .touchUpInside)
        //metronomeButton.frame = addNewTakeButton.currentImage!.accessibilityFrame
        self.addSubview(notesButton)
        notesButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: notesButton!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 75).isActive = true
        NSLayoutConstraint(item: notesButton!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: notesButton!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 1).isActive = true
    }
}
