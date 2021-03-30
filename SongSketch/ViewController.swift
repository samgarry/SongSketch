
//
//  ViewController.swift
//  SongSketch
//
//  Created by Samuel Garry on 2/25/21.
//

import Foundation
import UIKit
import AVFoundation


class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    //Functional Model Variables
    var songLabel: UILabel!
    var recorders = [Conductor]()
    var recordButton: UIButton!
    var playButton: UIButton!
    var playButtons = [Int: UIButton]()
    
    //UI View Variables
    var buttonViews = [UIView]() //Array of button views
    let buttonsView = UIView() //Button view object
    let leftSpacer = UIView() //Spacers
    let midSpacer = UIView()
    let rightSpacer = UIView()
    
    //UI Symbol Variables
    var plus = UIImage()
    var play = UIImage()
    var pause = UIImage()
    let configuration = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular, scale: .medium)
    
        
    //Waveform visualizer
    //var audioInputPlot: EZAudioPlot!
                
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(red: 3/255, green: 50/255, blue: 105/255, alpha: 1)
        
        //SONG LABEL
        songLabel = UILabel()
        songLabel.translatesAutoresizingMaskIntoConstraints = false
        songLabel.textAlignment = .center
        songLabel.font = UIFont(name: "Courier New", size: 48)
        //songLabel.font = UIFont.systemFont(ofSize: 24)
        songLabel.textColor = UIColor.white
        songLabel.text = "Song 1"
        view.addSubview(songLabel)
        
        //BUTTONS VIEW
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)

        
        NSLayoutConstraint.activate([
            //SONG LABEL
            songLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            songLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            //RECORD BUTTONS
            buttonsView.topAnchor.constraint(equalTo: songLabel.bottomAnchor, constant: 200),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            buttonsView.widthAnchor.constraint(equalTo: view.widthAnchor),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        //Create spacer views
        createSpacers()
        
        //Create the button views
        for row in 0..<3 {
            for column in 0..<2 {
                createButtonViews(column: column, row: row)
            }
        }
    }
    
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
    
    func createSpacers() {
        //Add spacers to the button view
        buttonsView.addSubview(leftSpacer)
        buttonsView.addSubview(midSpacer)
        buttonsView.addSubview(rightSpacer)
        
        //Spacer Constraints
        leftSpacer.translatesAutoresizingMaskIntoConstraints = false
        leftSpacer.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor).isActive = true
        leftSpacer.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: 0.05).isActive = true
        leftSpacer.heightAnchor.constraint(equalTo: buttonsView.heightAnchor, multiplier: 1).isActive = true
        midSpacer.translatesAutoresizingMaskIntoConstraints = false
        midSpacer.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor).isActive = true
        midSpacer.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: 0.1).isActive = true
        midSpacer.heightAnchor.constraint(equalTo: buttonsView.heightAnchor, multiplier: 1).isActive = true
        rightSpacer.translatesAutoresizingMaskIntoConstraints = false
        rightSpacer.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor).isActive = true
        rightSpacer.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: 0.05).isActive = true
        rightSpacer.heightAnchor.constraint(equalTo: buttonsView.heightAnchor, multiplier: 1).isActive = true
    }
    
    func createButtonViews(column: Int, row: Int) {
        
        //Button Parameters
        let buttonView = UIView()
        buttonView.backgroundColor = .clear
        buttonView.layer.cornerRadius = 10
        buttonView.layer.borderWidth = 1
        buttonView.layer.borderColor = UIColor.white.cgColor
        buttonView.layer.masksToBounds = true
        buttonsView.addSubview(buttonView)
        
        
        //Button Constraint Code
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        if column == 0 {
            buttonView.leadingAnchor.constraint(equalTo: leftSpacer.trailingAnchor).isActive = true
            //NSLayoutConstraint(item: buttonView, attribute: .leading, relatedBy: .equal, toItem: leftSpacer, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        }
        else {
            buttonView.leadingAnchor.constraint(equalTo: midSpacer.trailingAnchor).isActive = true
        }
        if row == 0 {
            buttonView.topAnchor.constraint(equalTo: buttonsView.topAnchor).isActive = true
        }
        else if row == 1 {
            buttonView.centerYAnchor.constraint(equalTo: buttonsView.centerYAnchor).isActive = true
        }
        else {
            buttonView.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor).isActive = true
        }
        
        //Set the height and width of the button views
        buttonView.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: 0.40).isActive = true
        buttonView.heightAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: 0.40).isActive = true
        
        
        //Add button view to the array of button views for accessing/modifying later
        buttonViews.append(buttonView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize the UI symbols
        createSymbols()
        
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

//    func setupPlot() {
//
//        let plot = AKNodeOutputPlot(recorder.mic, frame: audioInputPlot.bounds)
//        audioInputPlot.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
//        audioInputPlot.plotType = EZPlotType.buffer
//        audioInputPlot.shouldFill = true
//        audioInputPlot.shouldMirror = true
//        audioInputPlot.color = UIColor.black
//        audioInputPlot.addSubview(plot)
//        self.view.addSubview( audioInputPlot )
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
            self.recorders[i].data.isPlaying.toggle()
            self.playButtons[i]!.setImage(self.play, for: .normal)
            self.playButtons[i]!.setPreferredSymbolConfiguration(self.configuration, forImageIn: .normal)
        }
    }
}

//Delegate to notify the view controller that the file has finished playing and to update the play button
extension ViewController: FileFinishedDelegate {
    func fileFinished(i: Int) {
        self.updatePlayButton(i: i)
    }
}
