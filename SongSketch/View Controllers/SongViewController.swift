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
    var songLabel: UILabel!
    var recorders = [SongSketch.Conductor]()
    var recordButton: UIButton!
    var playButton: UIButton!
    var playButtons = [Int: UIButton]()
    
    //UI View Variables
    var buttonViews = [UIView]() //Array of button views
    let sectionsHolder = UIView() //Button view object
    let leftSpacer = UIView() //Spacers
    let midSpacer = UIView()
    let rightSpacer = UIView()
    
    //UI Symbol Variables
    var plus = UIImage()
    var play = UIImage()
    var pause = UIImage()
    var metronomeImage = UIImage()
    var editImage = UIImage()
    var notesImage = UIImage()
    let configuration = UIImage.SymbolConfiguration(pointSize: 40, weight: .ultraLight, scale: .small)
    
    
    
    //NEW STUFF
    var sections = [SectionViewController(0)]
    var sectionContainerView = UIView()
    var topContainerView = UIView()
    var size: Int = 0
    var sizeSetter = UIView()
    var metronomeButton: UIButton!
    var editButton: UIButton!
    var notesButton: UIButton!
        
    //Waveform visualizer
    //var audioInputPlot: EZAudioPlot!

                
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(red: 3/255, green: 50/255, blue: 105/255, alpha: 1)
        
        //PRACTICE STUFF
        //self.add(take, CGRect(x: 0, y: 0, width: 100, height: 100))
//        let practiceFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        self.add(take, practiceFrame)
//        section.view.autoresizingMask = []
//        self.add(section, CGRect(x: 100, y: 100, width: 100, height: 100))

        //Container Views Set Up
        view.addSubview(sectionContainerView)
        view.addSubview(topContainerView)
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        sectionContainerView.translatesAutoresizingMaskIntoConstraints = false

        
        //Top Container Constraint Set up
        NSLayoutConstraint(item: topContainerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: topContainerView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: topContainerView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1/3, constant: 0).isActive = true
        
        
        //Section Container Constraint Set up
        NSLayoutConstraint(item: sectionContainerView, attribute: .top, relatedBy: .equal, toItem: topContainerView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sectionContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -50).isActive = true
        NSLayoutConstraint(item: sectionContainerView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sectionContainerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
//        NSLayoutConstraint.activate([
//            //SONG LABEL
//            songLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
//            songLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
//
//            //Section Container View
//            sectionContainerView.topAnchor.constraint(equalTo: songLabel.bottomAnchor, constant: 200),
//            sectionContainerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
//            sectionContainerView.widthAnchor.constraint(equalTo: view.widthAnchor),
//            sectionContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        ])
        
        //Create the song title label
        setupTitle()
        
        //Create the editing toolbar
        setupToolbar()

        //Create spacer views
        createSpacers()
        
        //Create the empty view that determines the size of the section view controller children
        getSectionSize()

        //Create the section view controllers
        var i = 0
        for row in 0..<3 {
            for column in 0..<2 {
                setupSectionViewControllers(column, row, i, size)
                i += 1
            }
        }
    }
    
    func createButtons(i: Int) {
        //Button Properties
        recordButton = UIButton()
        recordButton.setImage(plus, for: .normal)
        recordButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        recordButton.titleLabel?.font = UIFont.init(name: "Courier New", size: 14)
        recordButton.tag = i
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        buttonViews[i].addSubview(recordButton)
        
        //Button Constraints
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.centerXAnchor.constraint(equalTo: buttonViews[i].centerXAnchor).isActive = true
        recordButton.centerYAnchor.constraint(equalTo: buttonViews[i].centerYAnchor).isActive = true
        recordButton.widthAnchor.constraint(equalTo: buttonViews[i].widthAnchor).isActive = true
        recordButton.heightAnchor.constraint(equalTo: buttonViews[i].heightAnchor).isActive = true
    }
    
    
    func createSpacers() {
        //Add spacers to the button view
        sectionContainerView.addSubview(leftSpacer)
        sectionContainerView.addSubview(midSpacer)
        sectionContainerView.addSubview(rightSpacer)
        
        //Spacer Constraints
        leftSpacer.translatesAutoresizingMaskIntoConstraints = false
        leftSpacer.leadingAnchor.constraint(equalTo: sectionContainerView.leadingAnchor).isActive = true
        leftSpacer.widthAnchor.constraint(equalTo: sectionContainerView.widthAnchor, multiplier: 0.05).isActive = true
        leftSpacer.heightAnchor.constraint(equalTo: sectionContainerView.heightAnchor, multiplier: 1).isActive = true
        
        midSpacer.translatesAutoresizingMaskIntoConstraints = false
        midSpacer.centerXAnchor.constraint(equalTo: sectionContainerView.centerXAnchor).isActive = true
        midSpacer.widthAnchor.constraint(equalTo: sectionContainerView.widthAnchor, multiplier: 0.1).isActive = true
        midSpacer.heightAnchor.constraint(equalTo: sectionContainerView.heightAnchor, multiplier: 1).isActive = true
        
        rightSpacer.translatesAutoresizingMaskIntoConstraints = false
        rightSpacer.trailingAnchor.constraint(equalTo: sectionContainerView.trailingAnchor).isActive = true
        rightSpacer.widthAnchor.constraint(equalTo: sectionContainerView.widthAnchor, multiplier: 0.05).isActive = true
        rightSpacer.heightAnchor.constraint(equalTo: sectionContainerView.heightAnchor, multiplier: 1).isActive = true
    }
    
    func createPlayButtons(i: Int) {
           //Button Properties
           playButton = UIButton()
           playButton.setImage(play, for: .normal)
           playButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
           playButton.tag = i
           playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
           buttonViews[i].addSubview(playButton)
   
           //Button Constraints
           playButton.translatesAutoresizingMaskIntoConstraints = false
           playButton.centerXAnchor.constraint(equalTo: buttonViews[i].centerXAnchor).isActive = true
           playButton.centerYAnchor.constraint(equalTo: buttonViews[i].centerYAnchor).isActive = true
           playButton.widthAnchor.constraint(equalTo: buttonViews[i].widthAnchor).isActive = true
           playButton.heightAnchor.constraint(equalTo: buttonViews[i].heightAnchor).isActive = true
   
           //Add play button to the array of play buttons for accessing/modifying later
           playButtons[i] = playButton
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
        topContainerView.addSubview(metronomeButton)
        metronomeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: metronomeButton!, attribute: .centerX, relatedBy: .equal, toItem: topContainerView, attribute: .centerX, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: metronomeButton!, attribute: .bottom, relatedBy: .equal, toItem: topContainerView, attribute: .bottom, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: metronomeButton!, attribute: .height, relatedBy: .equal, toItem: topContainerView, attribute: .height, multiplier: 1, constant: 1).isActive = true
        
        //Edit Button Properties
        editButton = UIButton()
        editButton.setImage(editImage, for: .normal)
        editButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        //metronomeButton.addTarget(self, action: #selector(pressRecord), for: .touchUpInside)
        //metronomeButton.frame = addNewTakeButton.currentImage!.accessibilityFrame
        topContainerView.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint(item: editButton!, attribute: .trailing, relatedBy: .equal, toItem: topContainerView, attribute: .trailing, multiplier: 1, constant: -75).isActive = true
        NSLayoutConstraint(item: editButton!, attribute: .bottom, relatedBy: .equal, toItem: topContainerView, attribute: .bottom, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: editButton!, attribute: .height, relatedBy: .equal, toItem: topContainerView, attribute: .height, multiplier: 1, constant: 1).isActive = true
        
        //Notes Button Properties
        notesButton = UIButton()
        notesButton.setImage(notesImage, for: .normal)
        notesButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        //metronomeButton.addTarget(self, action: #selector(pressRecord), for: .touchUpInside)
        //metronomeButton.frame = addNewTakeButton.currentImage!.accessibilityFrame
        topContainerView.addSubview(notesButton)
        notesButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: notesButton!, attribute: .leading, relatedBy: .equal, toItem: topContainerView, attribute: .leading, multiplier: 1, constant: 75).isActive = true
        NSLayoutConstraint(item: notesButton!, attribute: .bottom, relatedBy: .equal, toItem: topContainerView, attribute: .bottom, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: notesButton!, attribute: .height, relatedBy: .equal, toItem: topContainerView, attribute: .height, multiplier: 1, constant: 1).isActive = true
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
        topContainerView.addSubview(songLabel)
        
        NSLayoutConstraint(item: songLabel!, attribute: .height, relatedBy: .equal, toItem: topContainerView, attribute: .height, multiplier: 1/3, constant: 50).isActive = true
        NSLayoutConstraint.activate([
            songLabel.topAnchor.constraint(equalTo: topContainerView.topAnchor),
            songLabel.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor),
        ])
    }
    
    func getSectionSize() {
        view.addSubview(sizeSetter)
        sizeSetter.backgroundColor = .red
        sizeSetter.translatesAutoresizingMaskIntoConstraints = false
        sizeSetter.leadingAnchor.constraint(equalTo: leftSpacer.trailingAnchor).isActive = true
        sizeSetter.topAnchor.constraint(equalTo: sectionContainerView.topAnchor).isActive = true
        sizeSetter.widthAnchor.constraint(equalTo: sectionContainerView.widthAnchor, multiplier: 0.40).isActive = true
        sizeSetter.heightAnchor.constraint(equalTo: sectionContainerView.widthAnchor, multiplier: 0.40).isActive = true
        //let size = section.frame.width
        //sizeSetter.removeFromSuperview()
        //return Int(size)
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
        
        for i in 0..<buttonViews.count {
            createButtons(i: i)
            let recorder = SongSketch.Conductor(i: i)
            recorder.fileFinishedDelegate = self
            recorders.append(recorder)
        }
        
        for i in 0..<recorders.count {
            //Start the recorder engines
            recorders[i].start()
        }
    }
    
    override func viewDidLayoutSubviews() {
        //Set the section view controllers' cell properties and set up its table view
        for i in 0..<sections.count {
            sections[i].cellSize = sizeSetter.frame.height
            sections[i].configureTableView()
            sizeSetter.removeFromSuperview() //Delete the unnecessary view now that the size has been retreived
        }
    }
    

//    func setupPlot() {
//
//        let plot = AKNodeOutputPlot(recorder.mic, frame: audioInputPlot.bounds)
//        audioInputPlot.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
//        audioInputPlot.plotType = EZPlotType.buffer
//        audioInputPlot.shouldFill = true
//        audioInputPlot.shouldMirror = true
//        audioInputPlot.color = UIColor.black
//        audioInputPlot.addSubview(plot)
//        self.view.addSubview(audioInputPlot)
//    }
//
    
    //Waveform plot setup
//    func setupPlot() {
//         let plot = AKNodeOutputPlot(mic, frame: audioInputPlot.bounds)
//         plot.plotType = .rolling
//         plot.shouldFill = true
//         plot.shouldMirror = true
//         plot.color = UIColor.blue
//         audioInputPlot.addSubview(plot)
//     }

    @objc func recordTapped(sender: UIButton) {
        switch sender.tag {
            case 0:
                pressRecord(i: 0, sender: sender)
            case 1:
                pressRecord(i: 1, sender: sender)
            case 2:
                pressRecord(i: 2, sender: sender)
            case 3:
                pressRecord(i: 3, sender: sender)
            case 4:
                pressRecord(i: 4, sender: sender)
            default:
                pressRecord(i: 5, sender: sender)
        }
    }
        
    func pressRecord(i: Int, sender: UIButton) {
        let currRec = recorders[i]
        
        //To start the recording
        if (currRec.data.isRecording != true) {
            currRec.data.isRecording.toggle()
            sender.setImage(nil, for: .normal)
            sender.backgroundColor = UIColor.red
        }
        //To stop the recording
        else {
            currRec.data.isRecording.toggle()
            sender.isHidden = true //Delete the record button now that it's used
            createPlayButtons(i: i) //Create a new play button to sit on top of the view
        }
    }

    @objc func playTapped(sender: UIButton) {
        switch sender.tag {
        case 0:
            pressPlay(i: 0, sender: sender)
        case 1:
            pressPlay(i: 1, sender: sender)
        case 2:
            pressPlay(i: 2, sender: sender)
        case 3:
            pressPlay(i: 3, sender: sender)
        case 4:
            pressPlay(i: 4, sender: sender)
        default:
            pressPlay(i: 5, sender: sender)
        }
    }
    
    func pressPlay(i: Int, sender: UIButton) {
        let current = recorders[i]
        
        //To start playing
        if current.data.isPlaying != true {
            current.data.isPlaying.toggle()
            sender.setImage(pause, for: .normal)
            sender.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        }
        //To stop playing
        else {
            print("Entered the else statement")
            current.data.isPlaying.toggle()
            sender.setImage(play, for: .normal)
            sender.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        }
    }
    
    func updatePlayButton(i: Int) {
        DispatchQueue.main.async {
            print("i", i)
            print("playButtons size: ", self.playButtons.count)
            self.recorders[i].data.isPlaying.toggle() //set the recorder to not playing now that it is finished
            self.playButtons[i]!.setImage(self.play, for: .normal)
            self.playButtons[i]!.setPreferredSymbolConfiguration(self.configuration, forImageIn: .normal)
        }
    }
}

//Delegate to notify the view controller that the file has finished playing and to update the play button
extension SongViewController: FileFinishedDelegate {
    func fileFinished(i: Int) {
        self.updatePlayButton(i: i)
    }
}
