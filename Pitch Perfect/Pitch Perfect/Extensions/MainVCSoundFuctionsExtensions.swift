//
//  MainVCSoundFuctionsExtensions.swift
//  Pitch Perfect
//
//  Created by Corey Baines on 5/7/16.
//  Copyright © 2016 Corey Baines. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension MainVC {
    
    // MARK: -- Play Audio
    
    func playAudioFile(tag:Int) {
        audioPlayer?.stop()
        stopAudio()
        var url:NSURL?
        if self.audioRecorder != nil {
            url = self.audioRecorder.url
        } else {
            url = self.fileNameURL!
        }
        print("playing \(url)")
        
        do {
            self.audioFile = try AVAudioFile(forReading: url!)
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: url!)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            if tag == 0 {
                audioPlayer.volume = 1.0
                audioPlayer.play()
            } else if tag == 1 {
                PlayEffect.playEffect.playWithEffect(pitch: -1000, rawAudioFile: audioFile)
            } else if tag == 2 {
                PlayEffect.playEffect.playWithEffect(rate: 1.5, rawAudioFile: audioFile)
            } else if tag == 3 {
                PlayEffect.playEffect.playWithEffect(pitch: 1000, rawAudioFile: audioFile)
            } else if tag == 4 {
                PlayEffect.playEffect.playWithEffect(reverb: true, rawAudioFile: audioFile)
            } else if tag == 5 {
                PlayEffect.playEffect.playWithEffect(rate: 0.5, rawAudioFile: audioFile)
            } else if tag == 6 {
                PlayEffect.playEffect.playWithEffect(echo: true, rawAudioFile: audioFile)
            }
        } catch let error as NSError {
            self.audioPlayer = nil
            print(error.localizedDescription)
        }
    }
    
    // Mark: -- Setup Audio Recorder
    
    func startAudioRecorderWithPermissions(permissions: Bool) {
        if recordingSession.respondsToSelector(#selector(AVAudioSession.requestRecordPermission(_:))) {
            AVAudioSession.sharedInstance().requestRecordPermission({ (permissionGranted: Bool) in
                if permissionGranted {
                    self.setSessionPlayAndRecord()
                    if permissions {
                        self.setupRecorder()
                    }
                    self.audioRecorder.record()
                    self.recordingTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(MainVC.updateRecordingTimeLabel(_:)), userInfo: nil, repeats: true)
                } else {
                    print("The user has not granted permission to record content")
                }
            })
        } else {
            print("requestRecordPermission unrecognized")
        }
    }
    
    func setupRecorder() {
        let format = NSDateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        rawFileName = "\(format.stringFromDate(NSDate())).m4a"
        print(rawFileName)
        
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        self.fileNameURL = documentsDirectory.URLByAppendingPathComponent(rawFileName)
        
        if NSFileManager.defaultManager().fileExistsAtPath(fileNameURL.absoluteString) {
            // probably won't happen. want to do something about it?
            print("soundfile \(fileNameURL.absoluteString) exists")
        }
        
        let recordSettings:[String : AnyObject] = [
            AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 44100.0
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(URL: fileNameURL, settings: recordSettings)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch let error as NSError {
            audioRecorder = nil
            print(error.localizedDescription)
        }
        
    }
    
    func stopAudio() {
        if let audioPlayerNode = audioPlayerNode {
            audioPlayerNode.stop()
        }
        
        if let audioEngine = audioEngine {
            audioEngine.stop()
            audioEngine.reset()
        }
    }
    
}