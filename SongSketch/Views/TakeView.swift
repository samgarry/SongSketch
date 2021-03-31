//
//  TakeView.swift
//  SongSketch
//
//  Created by Samuel Garry on 3/22/21.
//

import UIKit

class TakeView: UITableViewCell {

    //Buttons
    var playButton: UIButton!
    var addNewTakeButton: UIButton!
    var takeLabel: UILabel!
    
    //UI Symbol Variables
    var plus = UIImage()
    var play = UIImage()
    var pause = UIImage()
    let configuration = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular, scale: .medium)
    
    //Button Functionality Closures -- Send these to the section view controller
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
        createTitleLabel()
        createPlayButton()
        createNewTakeButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title: String) {
        takeLabel.text = title
    }
    
    //Function that calls the recordTapped closure
    @objc func pressRecord() {
        recordTapped?()
    }
    
    //Function that calls the playTapped closure
    @objc func pressPlay() {
        playTapped?()
    }
    
    func createTitleLabel() {
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
    
    func createNewTakeButton() {
        //Button Properties
        addNewTakeButton = UIButton()
        addNewTakeButton.setImage(plus, for: .normal)
        addNewTakeButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        addNewTakeButton.addTarget(self, action: #selector(pressRecord), for: .touchUpInside)
        addNewTakeButton.frame = addNewTakeButton.currentImage!.accessibilityFrame
        self.addSubview(addNewTakeButton)
        
        //variable for setting constraint
//        let distance = self.widthAnchor
        print(self.frame.size.width)
        
        //Button Constraints
        addNewTakeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: addNewTakeButton!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 0.75, constant: 0).isActive = true
        NSLayoutConstraint(item: addNewTakeButton!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    func createPlayButton() {
        //Button Properties
        playButton = UIButton()
        playButton.setImage(play, for: .normal)
        playButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        playButton.addTarget(self, action: #selector(pressPlay), for: .touchUpInside)
        self.addSubview(playButton)
        
        //Button Constraints
        playButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: playButton!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.25, constant: 0).isActive = true
        NSLayoutConstraint(item: playButton!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
}
