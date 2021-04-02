//
//  SongViewController.swift
//  SongSketch
//
//  Created by Samuel Garry on 2/25/21.
//

import Foundation
import UIKit
import AVFoundation


class SongViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    //Functional Model Variables
    //var recorders = [SongSketch.Conductor]()
    //var recorder = SongSketch.Conductor()
    var playButtons = [Int: UIButton]()
    
    //UI View Variables
    let leftSpacer = UIView()       //Spacer
    let midSpacer = UIView()        //Spacer
    let rightSpacer = UIView()      //Spacer
    let toolbarView = ToolbarView()

    
    //NEW STUFF
    var sections = [SectionViewController(0)] //Array of the six section view controllers
    var sectionContainerView = UIView()
    var size: Int = 0
    var sizeSetter = UIView()

                
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(red: 3/255, green: 50/255, blue: 105/255, alpha: 1)

        //Container Views Set Up
        view.addSubview(sectionContainerView)
        //view.addSubview(topContainerView)
        view.addSubview(toolbarView)
        toolbarView.translatesAutoresizingMaskIntoConstraints = false
        sectionContainerView.translatesAutoresizingMaskIntoConstraints = false

        
        //Toolbar Constraint Set up
        NSLayoutConstraint(item: toolbarView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: toolbarView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: toolbarView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1/3, constant: 0).isActive = true
        
        
        //Section Container Constraint Set up
        NSLayoutConstraint(item: sectionContainerView, attribute: .top, relatedBy: .equal, toItem: toolbarView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sectionContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -50).isActive = true
        NSLayoutConstraint(item: sectionContainerView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sectionContainerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true


        //Create spacer views
        createSpacers()
        
        //Create the empty view that determines the size of the section view controller children
        getSectionSize()

        //Create the section view controllers
        var i = 1
        for row in 0..<3 {
            for column in 0..<2 {
                setupSectionViewControllers(column, row, i, size)
                i += 1
            }
        }
    }
    
    func createSpacers() {
        //Add spacers to the button view
        sectionContainerView.addSubview(leftSpacer)
        sectionContainerView.addSubview(midSpacer)
        sectionContainerView.addSubview(rightSpacer)
        
        //Spacer Constraints
        //left spacer
        leftSpacer.translatesAutoresizingMaskIntoConstraints = false
        leftSpacer.leadingAnchor.constraint(equalTo: sectionContainerView.leadingAnchor).isActive = true
        leftSpacer.widthAnchor.constraint(equalTo: sectionContainerView.widthAnchor, multiplier: 0.05).isActive = true
        leftSpacer.heightAnchor.constraint(equalTo: sectionContainerView.heightAnchor, multiplier: 1).isActive = true
        
        //mid spacer
        midSpacer.translatesAutoresizingMaskIntoConstraints = false
        midSpacer.centerXAnchor.constraint(equalTo: sectionContainerView.centerXAnchor).isActive = true
        midSpacer.widthAnchor.constraint(equalTo: sectionContainerView.widthAnchor, multiplier: 0.1).isActive = true
        midSpacer.heightAnchor.constraint(equalTo: sectionContainerView.heightAnchor, multiplier: 1).isActive = true
        
        //right spacer
        rightSpacer.translatesAutoresizingMaskIntoConstraints = false
        rightSpacer.trailingAnchor.constraint(equalTo: sectionContainerView.trailingAnchor).isActive = true
        rightSpacer.widthAnchor.constraint(equalTo: sectionContainerView.widthAnchor, multiplier: 0.05).isActive = true
        rightSpacer.heightAnchor.constraint(equalTo: sectionContainerView.heightAnchor, multiplier: 1).isActive = true
    }
    
    func getSectionSize() {
        view.addSubview(sizeSetter)
        sizeSetter.backgroundColor = .red
        sizeSetter.translatesAutoresizingMaskIntoConstraints = false
        sizeSetter.leadingAnchor.constraint(equalTo: leftSpacer.trailingAnchor).isActive = true
        sizeSetter.topAnchor.constraint(equalTo: sectionContainerView.topAnchor).isActive = true
        sizeSetter.widthAnchor.constraint(equalTo: sectionContainerView.widthAnchor, multiplier: 0.40).isActive = true
        sizeSetter.heightAnchor.constraint(equalTo: sectionContainerView.widthAnchor, multiplier: 0.40).isActive = true
    }
    
    
    //Set up the section view controllers
    func setupSectionViewControllers(_ column: Int, _ row: Int, _ index: Int, _ size: Int) {
        let section = SectionViewController(index)
        sections.append(section)
        
        //Add the section to the section array for accessing/modifying later
        self.add(sections[index], CGRect(width: size, height: size))
        
        //Set up the initial constraints
        sections[index].view.translatesAutoresizingMaskIntoConstraints = false

        if column == 0 {
            sections[index].view.leadingAnchor.constraint(equalTo: leftSpacer.trailingAnchor).isActive = true
        }
        else {
            sections[index].view.leadingAnchor.constraint(equalTo: midSpacer.trailingAnchor).isActive = true
        }
        if row == 0 {
            sections[index].view.topAnchor.constraint(equalTo: sectionContainerView.topAnchor).isActive = true
        }
        else if row == 1 {
            sections[index].view.centerYAnchor.constraint(equalTo: sectionContainerView.centerYAnchor).isActive = true
        }
        else {
            sections[index].view.bottomAnchor.constraint(equalTo: sectionContainerView.bottomAnchor).isActive = true
        }
        
        //Set the height and width of the button views
        sections[index].view.widthAnchor.constraint(equalTo: sectionContainerView.widthAnchor, multiplier: 0.40).isActive = true
        sections[index].view.heightAnchor.constraint(equalTo: sectionContainerView.widthAnchor, multiplier: 0.40).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Conductor.shared.fileFinishedDelegate = self
                
//        let recorder = SongSketch.Conductor()
//        recorder.start()
        
//        for i in 0..<sections.count {
//            let recorder = SongSketch.Conductor()
//            recorder.fileFinishedDelegate = self
//            recorders.append(recorder)
//        }
        
        //let recorder = Son
        
//        for i in 0..<recorders.count {
//            //Start the recorder engines
//            recorders[i].start()
//        }
    }
    
    override func viewDidLayoutSubviews() {
        //Set the section view controllers' cell properties and set up its table view
        for i in 0..<sections.count {
            sections[i].cellSize = sizeSetter.frame.height
            //sections[i].configureTableView()
            sizeSetter.removeFromSuperview() //Delete the unnecessary view now that the size has been retreived
        }
    }

//    @objc func recordTapped(sender: UIButton) {
//        switch sender.tag {
//            case 0:
//                pressRecord(i: 0, sender: sender)
//            case 1:
//                pressRecord(i: 1, sender: sender)
//            case 2:
//                pressRecord(i: 2, sender: sender)
//            case 3:
//                pressRecord(i: 3, sender: sender)
//            case 4:
//                pressRecord(i: 4, sender: sender)
//            default:
//                pressRecord(i: 5, sender: sender)
//        }
//    }
        
//    func pressRecord(i: Int, sender: UIButton) {
//        let currRec = recorders[i]
//
//        //To start the recording
//        if (currRec.data.isRecording != true) {
//            currRec.data.isRecording.toggle()
//            sender.setImage(nil, for: .normal)
//            sender.backgroundColor = UIColor.red
//        }
//        //To stop the recording
//        else {
//            currRec.data.isRecording.toggle()
//            sender.isHidden = true //Delete the record button now that it's used
//            createPlayButtons(i: i) //Create a new play button to sit on top of the view
//        }
//    }

//    @objc func playTapped(sender: UIButton) {
//        switch sender.tag {
//        case 0:
//            pressPlay(i: 0, sender: sender)
//        case 1:
//            pressPlay(i: 1, sender: sender)
//        case 2:
//            pressPlay(i: 2, sender: sender)
//        case 3:
//            pressPlay(i: 3, sender: sender)
//        case 4:
//            pressPlay(i: 4, sender: sender)
//        default:
//            pressPlay(i: 5, sender: sender)
//        }
//    }
    
//    func pressPlay(i: Int, sender: UIButton) {
//        //let current = recorders[i]
//
//        //To start playing
//        if current.data.isPlaying != true {
//            current.data.isPlaying.toggle()
//            sender.setImage(pause, for: .normal)
//            sender.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
//        }
//        //To stop playing
//        else {
//            print("Entered the else statement")
//            current.data.isPlaying.toggle()
//            sender.setImage(play, for: .normal)
//            sender.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
//        }
//    }
    
    func updatePlayButton(i: Int) {
        DispatchQueue.main.async {
            print("i", i)
            print("playButtons size: ", self.playButtons.count)
            //self.recorders[i].data.isPlaying.toggle() //set the recorder to not playing now that it is finished
            //self.playButtons[i]!.setImage(self.play, for: .normal)
            //self.playButtons[i]!.setPreferredSymbolConfiguration(self.configuration, forImageIn: .normal)
        }
    }
}
