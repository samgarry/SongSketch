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
    
    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("recorded")
    let format = AVAudioFormat(commonFormat: .pcmFormatFloat64, sampleRate: 44100, channels: 2, interleaved: true)!

    @Published var data = RecorderData() {
        didSet {
            if data.isRecording {
                NodeRecorder.removeTempFiles() //COMMENTED THIS OUT FOR NOW CUZ I WANT THE AUDIO FILES TO BE STORED
                do {
                    try recorder?.record()
                } catch let err {
                    print(err)
                }
            } else {
                recorder?.stop()
            }

            if data.isPlaying {
                if let file = recorder?.audioFile {
                    player.file = file
                    player.play()
                }
            } else {
                player.stop()
            }
        }
    }

    init() {
        guard let input = engine.input else {
            fatalError()
        }

//        //File Setup
//        var audioFile = try! AVAudioFile(forWriting: url, settings: format.settings) //SHOULD IMPLEMENT A THROWS METHOD HERE

        
        do {
//            recorder = try NodeRecorder(node: input, file: audioFile)
            recorder = try NodeRecorder(node: input)
        } catch let err {
            fatalError("\(err)")
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
    
    func getDirectory() ->  URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
}
