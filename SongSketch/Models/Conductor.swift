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
    func fileFinished(i: Int)
}

class Conductor {
    var fileFinishedDelegate: FileFinishedDelegate!
    
    var tag: Int = 0
    
    let engine = AudioEngine()
    var recorder: NodeRecorder?
    let player = AudioPlayer()
    var silencer: Fader?
    let mixer = Mixer()

    @Published var data = RecorderData() {
        didSet {
            if data.isRecording {
                //NodeRecorder.removeTempFiles() //COMMENTED THIS OUT FOR NOW CUZ I WANT THE AUDIO FILES TO BE STORED
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

    init(i: Int) {
        guard let input = engine.input else {
            fatalError()
        }

        do {
            recorder = try NodeRecorder(node: input)
        } catch let err {
            fatalError("\(err)")
        }
        //Set this recorder's tag (from the project view controller)
        tag = i
        //Audio setup
        let silencer = Fader(input, gain: 0)
        self.silencer = silencer
        mixer.addInput(silencer)
        mixer.addInput(player)
        player.completionHandler = playingEnded
        engine.output = mixer
    }

    func playingEnded() {
        fileFinishedDelegate.fileFinished(i: tag)
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
}
