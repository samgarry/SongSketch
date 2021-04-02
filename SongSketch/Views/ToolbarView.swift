//
//  ToolbarView.swift
//  SongSketch
//
//  Created by Samuel Garry on 3/30/21.
//

import UIKit

class ToolbarView: UIView {

    //UI Symbol Variables
    var metronomeImage = UIImage()
    var editImage = UIImage()
    var notesImage = UIImage()
    let configuration = UIImage.SymbolConfiguration(pointSize: 40, weight: .ultraLight, scale: .small)
    
    //UI Button Variables
    var metronomeButton: UIButton!
    var editButton: UIButton!
    var notesButton: UIButton!
    
    //Title Variables
    var songLabel: UILabel!

    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setupToolbar()
        setupTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTitle() {
        //SONG LABEL
        songLabel = UILabel()
        songLabel.translatesAutoresizingMaskIntoConstraints = false
        songLabel.textAlignment = .center
        songLabel.font = UIFont(name: "Courier New", size: 48)
        //songLabel.font = UIFont.systemFont(ofSize: 24)
        songLabel.textColor = UIColor.white
        songLabel.text = "Song 1"
        self.addSubview(songLabel)
        
        NSLayoutConstraint(item: songLabel!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1/3, constant: 50).isActive = true
        NSLayoutConstraint.activate([
            songLabel.topAnchor.constraint(equalTo: self.topAnchor),
            songLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    func setupToolbar() {
        //Metronome Symbol
        let metronome = UIImage(systemName: "metronome")
        metronomeImage = (metronome?.withTintColor(.white, renderingMode: .alwaysOriginal))!
        
        //Edit Symbol
        let edit = UIImage(systemName: "pencil")
        editImage = (edit?.withTintColor(.white, renderingMode: .alwaysOriginal))!
        
        //Notes Symbol
        let notes = UIImage(systemName: "book")
        notesImage = (notes?.withTintColor(.white, renderingMode: .alwaysOriginal))!
        
        //Metronome Button Properties
        metronomeButton = UIButton()
        metronomeButton.setImage(metronomeImage, for: .normal)
        metronomeButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        //metronomeButton.addTarget(self, action: #selector(pressRecord), for: .touchUpInside)
        //metronomeButton.frame = addNewTakeButton.currentImage!.accessibilityFrame
        self.addSubview(metronomeButton)
        metronomeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: metronomeButton!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: metronomeButton!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: metronomeButton!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 1).isActive = true
        
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
