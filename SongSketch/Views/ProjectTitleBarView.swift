//
//  ProjectTitleView.swift
//  SongSketch
//
//  Created by Samuel Garry on 4/14/21.
//

import UIKit

class ProjectTitleBarView: UIView {

    //Variables
    //var songLabel: UILabel!
    var songLabel: UITextField!
    var backImage = UIImage()
    var backButton: UIButton!
    let configuration = UIImage.SymbolConfiguration(pointSize: 40, weight: .ultraLight, scale: .small)
    
    //Back Button Functionality Closure -- Send this to the ProjectViewController()
    var backPressed: (() -> Void)?
    
    //MAYBE DELETE THIS
    public var initialTitle = String()
    
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        setupTitle()
        setupBackButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //PROBABLY DELETE THIS AND USE PROTOCOL/DELEGATION FOR THE SONG TITLE
    public func setInitialTitle() {
        let string = initialTitle.dropLast(9)
        songLabel.text = String(string)
    }
    
    func setupBackButton() {
        //Back Button Symbol
        let back = UIImage(systemName: "arrowtriangle.left")
        backImage = (back?.withTintColor(.white, renderingMode: .alwaysOriginal))!
        
        //Back Button Properties
        backButton = UIButton()
        backButton.setImage(backImage, for: .normal)
        backButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        backButton.addTarget(self, action: #selector(backToHomeScreen), for: .touchUpInside)
        //metronomeButton.frame = addNewTakeButton.currentImage!.accessibilityFrame
        self.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: backButton!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20).isActive = true
//        NSLayoutConstraint(item: backButton!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: backButton!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 1).isActive = true
    }
    
//    func setupTitle() {
//
//        //SONG LABEL
//        songLabel = UILabel()
//        songLabel.translatesAutoresizingMaskIntoConstraints = false
//        songLabel.textAlignment = .center
//        songLabel.font = UIFont(name: "Courier New", size: 40)
//        //songLabel.font = UIFont.systemFont(ofSize: 24)
//        songLabel.textColor = UIColor.white
//        songLabel.text = "Song 1"
//        self.addSubview(songLabel)
//
//        NSLayoutConstraint(item: songLabel!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 10).isActive = true
//        NSLayoutConstraint.activate([
//            songLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            songLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            songLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
//        ])
//    }
    
    func setupTitle() {
        
        //SONG LABEL
        songLabel = UITextField()
        songLabel.translatesAutoresizingMaskIntoConstraints = false
        songLabel.textAlignment = .center
        songLabel.font = UIFont(name: "Courier New", size: 40)
        //songLabel.font = UIFont.systemFont(ofSize: 24)
        songLabel.textColor = UIColor.white
        songLabel.text = "Song 1"
        self.addSubview(songLabel)
        
        NSLayoutConstraint(item: songLabel!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint.activate([
            songLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            songLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            songLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
    
    @objc func backToHomeScreen() {
        backPressed?()
    }

}
