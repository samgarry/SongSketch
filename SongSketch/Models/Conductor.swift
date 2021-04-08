//
//  Conductor.swift
//  SongSketch
//
//  Created by Samuel Garry on 3/4/21.
//

import UIKit
import AudioKit
import AVFoundation

struct RecorderData {
    var isRecording = false
    var isPlaying = false
}

protocol FileFinishedDelegate {
    func fileFinished()
}

class Conductor {
    
    // Singleton of the Conductor class to avoid multiple instances of the audio engine
    static let shared = Conductor()
    
    var fileFinishedDelegate: FileFinishedDelegate!
    
    var tag: Int = 0
    
    let engine = AudioEngine()
    var recorder: NodeRecorder?
    let player = AudioPlayer()
    var silencer: Fader?
    let mixer = Mixer()
    
    var numberOfRecords = 0
    
    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("recorded")
    let format = AVAudioFormat(commonFormat: .pcmFormatFloat64, sampleRate: 44100, channels: 2, interleaved: true)!
    let playbackFormat = AVAudioCommonFormat(rawValue: 100)
    var audioFile: AVAudioFile!
    var readingFile: AVAudioFile!
    
    //Might find a replacement for this after incorporating Core Data or do something with delegation
    public var currentSection: Int = 0
    
    //This will need to be sent via core data since i will need to save num of takes 
    public var numOfTakes: Int = 0

    @Published var data = RecorderData() {
        didSet {
            if data.isRecording {
                //NodeRecorder.removeTempFiles() //COMMENTED THIS OUT FOR NOW CUZ I WANT THE AUDIO FILES TO BE STORED
                do {
                    //iterate the number of recordings variable
                    print("num: \(numberOfRecords)")
                    numberOfRecords += 1
                    
                    //Setting up the file to write to
                    do {
                        let filename = getDirectory(index: currentSection).appendingPathComponent("Take \(numOfTakes).caf")
                        //let filename = getDocumentsDirectory().appendingPathComponent("\(2).caf")
                        try audioFile = AVAudioFile(forWriting: filename, settings: format.settings)
                    } catch let err {
                        fatalError("\(err)")
                    }
                    
                    //Grab the input from the Audio Kit engine
                    guard let input = engine.input else {
                        fatalError()
                    }
                    
                    //Set up the recorder object
                    do {
                        recorder = try NodeRecorder(node: input, file: audioFile)
                        //recorder = try NodeRecorder(node: input)
                    } catch let err {
                        fatalError("\(err)")
                    }

                    //try recorder = NodeRecorder(node: input, file: audioFile)
                    try recorder?.record()
                    
                    //audioFile = recorder?.audioFile
                } catch let err {
                    print(err)
                }
            } else {
                print("stopping recorder")
                recorder?.stop()
            }

            if data.isPlaying {
                print("section: \(currentSection)")
                //reading file setup
                do {
                    let filename = getDirectory(index: currentSection).appendingPathComponent("Take \(numOfTakes).caf")
                    //let filename = getDocumentsDirectory().appendingPathComponent("\(2).caf")
                    try readingFile = AVAudioFile(forReading: filename, commonFormat: playbackFormat!, interleaved: true)
                } catch let err {
                    fatalError("\(err)")
                }
                
                //if let file = recorder?.audioFile {
                if let file = self.readingFile {
                    print("got here")
                    player.file = file
                    player.play()
                }
            } else {
                player.stop()
            }
        }
    }

    init() {
        
        //Directory Setup
        setupDirectoryFolders()
        
        
        
        guard let input = engine.input else {
            fatalError()
        }
        
        //Audio setup
        let silencer = Fader(input, gain: 0)
        self.silencer = silencer
        mixer.addInput(silencer)
        mixer.addInput(player)
        player.completionHandler = playingEnded
        engine.output = mixer
    }

    func playingEnded() {
        fileFinishedDelegate.fileFinished()
        print("File is finished playing")
    }
    
    
    func start() {
        do {
            try engine.start()
        } catch let err {
            print(err)
        }
    }

    func stop() {
        engine.stop()
    }
    
    func dateString() -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = "ddMMMYY_hhmmssa"
      let fileName = formatter.string(from: Date())
      return "\(fileName).aif"
    }
    
    func setupDirectoryFolders() {
        let manager = FileManager.default
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        for i in 1..<7 {
            let newFolderURL = url.appendingPathComponent("Section \(i)")
            do {
                try manager.createDirectory(at: newFolderURL, withIntermediateDirectories: true, attributes: [:])
            } catch let err {
                fatalError("\(err)")
            }
        }
    }
    
    func getDirectory(index: Int) -> URL {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let fileUrl = url!.appendingPathComponent("Section \(index)")
        return fileUrl
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
}
