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
    
    //Button Functionality Closures -- Send these to the project view controller
    var trashTapped: (() -> Void)?
    var editTapped: (() -> Void)?
    var notesTapped: (() -> Void)?


    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setupToolbar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupToolbar() {
        //Metronome Symbol
//        let trash = UIImage(systemName: "trash")
//        trashButton.setImage(trash, for: .normal)
//        trashButton.tintColor = .gray
        //trashImage = (trash?.withTintColor(.gray, renderingMode: .alwaysTemplate))!
        
        //Edit Symbol
//        let edit = UIImage(systemName: "pencil")
//        editButton.setImage(edit, for: .normal)
//        editButton.tintColor = .gray
        //editImage = (edit?.withTintColor(.gray, renderingMode: .alwaysTemplate))!
        
        //Notes Symbol
//        let notes = UIImage(systemName: "book")
//        notesButton.setImage(notes, for: .normal)
//        notesButton.tintColor = .gray
        //notesImage = (notes?.withTintColor(.gray, renderingMode: .alwaysTemplate))!
        
        //Metronome Button Properties
        trashButton = UIButton()
        let trash = UIImage(systemName: "trash")
        trashButton.setImage(trash, for: .normal)
        trashButton.tintColor = .gray
        trashButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        trashButton.isEnabled = false
        trashButton.addTarget(self, action: #selector(pressTrash), for: .touchUpInside)
        //metronomeButton.frame = addNewTakeButton.currentImage!.accessibilityFrame
        self.addSubview(trashButton)
        trashButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: trashButton!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: trashButton!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: trashButton!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 1).isActive = true
        
        //Edit Button Properties
        editButton = UIButton()
        let edit = UIImage(systemName: "pencil")
        editButton.setImage(edit, for: .normal)
        editButton.tintColor = .gray
        editButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        editButton.isEnabled = false
        editButton.addTarget(self, action: #selector(pressEdit), for: .touchUpInside)
        //metronomeButton.frame = addNewTakeButton.currentImage!.accessibilityFrame
        self.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint(item: editButton!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -75).isActive = true
        NSLayoutConstraint(item: editButton!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: editButton!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 1).isActive = true
        
        //Notes Button Properties
        notesButton = UIButton()
        let notes = UIImage(systemName: "book")
        notesButton.setImage(notes, for: .normal)
        notesButton.tintColor = .gray
        notesButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        notesButton.isEnabled = false
        notesButton.addTarget(self, action: #selector(pressNotes), for: .touchUpInside)
        //metronomeButton.frame = addNewTakeButton.currentImage!.accessibilityFrame
        self.addSubview(notesButton)
        notesButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: notesButton!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 75).isActive = true
        NSLayoutConstraint(item: notesButton!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: notesButton!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 1).isActive = true
    }
    
    
    //Button Actions
    @objc func pressTrash() {
        trashTapped?()
    }
    @objc func pressEdit() {
        editTapped?()
    }
    @objc func pressNotes() {
        notesTapped?()
    }
    
}
