//
//  TakeView.swift
//  SongSketch
//
//  Created by Samuel Garry on 3/22/21.
//

import UIKit

class TakeView: UITableViewCell {

    //Buttons
    var playPauseButton: UIButton!
    var addNewTakeButton: UIButton!
    var takeLabel: UILabel!
    var sectionLabel: UILabel!
    
    //UI Symbol Variables
    var plus = UIImage()
    var play = UIImage()
    var pause = UIImage()
    let configuration = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular, scale: .medium)
    
    //Button Functionality Closures -- Send these to the section view controller
    //var recordTapped: ((UITableViewCell) -> Void)?
    var recordTapped: (() -> Void)?
    var playTapped: (() -> Void)?
    
    func createSymbols() {
        //Plus Symbol
        let originalPlus = UIImage(systemName: "plus")
        plus = (originalPlus?.withTintColor(.white, renderingMode: .alwaysOriginal))!
        
        //Play Symbol
        let originalPlay = UIImage(systemName: "play.fill")
        play = (originalPlay?.withTintColor(.white, renderingMode: .alwaysOriginal))!
        
        //Pause Symbol
        let originalPause = UIImage(systemName: "pause.fill")
        pause = (originalPause?.withTintColor(.white, renderingMode: .alwaysOriginal))!
    }
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(red: 0/255, green: 79/255, blue: 195/255, alpha: 0.35)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        //self.layer.borderWidth = 1
        //self.layer.borderColor = UIColor.white.cgColor
        self.layer.masksToBounds = true
        
        //Set images to symbols
        createSymbols()
        
        //Add Buttons
        createTakeLabel()
        createSectionLabel()
        createPlayButton()
        createNewTakeButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func set(label: String, section: String) {
//        takeLabel.text = label
//        sectionLabel.text = section
//    }
    
    //Function that calls the recordTapped closure
    @objc func pressRecord() {
        recordTapped?()/*(self)*/
    }
    
    //Function that calls the playTapped closure
    @objc func pressPlay() {
        playTapped?()
    }
    
    func updateButton(playing: Bool) {
        if playing {
            playPauseButton.setImage(pause, for: .normal)
            playPauseButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        }
        else {
            playPauseButton.setImage(play, for: .normal)
            playPauseButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        }
    }
    
    
    func createTakeLabel() {
        takeLabel = UILabel()
        takeLabel.font = UIFont(name: "Courier New", size: 22)
        takeLabel.textAlignment = .center
        takeLabel.textColor = .white
        takeLabel.numberOfLines = 0
        takeLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(takeLabel)
        
        //Label Constraints
        takeLabel.translatesAutoresizingMaskIntoConstraints = false
        takeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        takeLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        takeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        takeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    func createSectionLabel() {
        sectionLabel = UILabel()
        sectionLabel.font = UIFont(name: "Courier New", size: 22)
        sectionLabel.textAlignment = .center
        sectionLabel.textColor = .white
        takeLabel.numberOfLines = 0
        takeLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(sectionLabel)
        
        //Section Label Constraints
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        sectionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sectionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        sectionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    func createNewTakeButton() {
        //Button Properties
        addNewTakeButton = UIButton()
        addNewTakeButton.setImage(plus, for: .normal)
        addNewTakeButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        addNewTakeButton.addTarget(self, action: #selector(pressRecord), for: .touchUpInside)
        addNewTakeButton.frame = addNewTakeButton.currentImage!.accessibilityFrame
        self.contentView.addSubview(addNewTakeButton)
        
        //Button Constraints
        addNewTakeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: addNewTakeButton!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 0.75, constant: 0).isActive = true
        NSLayoutConstraint(item: addNewTakeButton!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    func createPlayButton() {
        //Button Properties
        playPauseButton = UIButton()
        playPauseButton.setImage(play, for: .normal)
        playPauseButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        playPauseButton.addTarget(self, action: #selector(pressPlay), for: .touchUpInside)
        self.contentView.addSubview(playPauseButton)
        
        //Button Constraints
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: playPauseButton!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.25, constant: 0).isActive = true
        NSLayoutConstraint(item: playPauseButton!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
}
