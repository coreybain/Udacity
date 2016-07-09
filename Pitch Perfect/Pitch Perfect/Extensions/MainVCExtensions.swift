//
//  MainVCExtensions.swift
//  Pitch Perfect
//
//  Created by Corey Baines on 3/7/16.
//  Copyright © 2016 Corey Baines. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension MainVC {
    
    func fadeInAndGrowMacCirlce() {
        // Move our fade out code from earlier
        self.timerView.hidden = false
        self.timerViewToMicContraint.constant = 48
        UIView.animateWithDuration(0.6, animations: {() -> Void in
            // Animate it to double the size
            let scale: CGFloat = 1.4
            self.micTimerCircle.transform = CGAffineTransformMakeScale(scale, scale)
           // self.timerView.frame = CGRectMake(self.timerView.frame.origin.x, (self.timerView.frame.origin.y - 30), self.timerView.frame.size.width, self.timerView.frame.size.height)
            self.view.layoutIfNeeded()
        })
        
    }
    
    func shrinkMicCirlce() {
        // Move our fade out code from earlier
        self.timerView.hidden = false
        self.timerViewToMicContraint.constant = 16
        UIView.animateWithDuration(0.6, animations: {() -> Void in
            // Animate it to double the size
            self.micTimerCircle.transform = CGAffineTransformIdentity
            self.view.layoutIfNeeded()
            //self.timerView.frame = CGRectMake(self.timerView.frame.origin.x, (self.timerView.frame.origin.y + 30), self.timerView.frame.size.width, self.timerView.frame.size.height)
        })
        
    }
    
    func updateRecordingTimeLabel(timer:NSTimer) {
        
        if audioRecorder.recording {
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime % 60)
            let s = String(format: "%02d:%02d", min, sec)
            timerLabel.text = s
            audioRecorder.updateMeters()
        }
    }
    
    func effectButtonBoarders(tag:Int) {
        if tag == 1 {
            self.effectButton1.layer.borderColor = UIColor.redColor().CGColor
            self.effectFileName = "Starwars-\(rawFileName)"
        } else if tag == 2 {
            self.effectButton2.layer.borderColor = UIColor.redColor().CGColor
            self.effectFileName = "Fast-\(rawFileName)"
        } else if tag == 3 {
            self.effectButton3.layer.borderColor = UIColor.redColor().CGColor
            self.effectFileName = "Animal-\(rawFileName)"
        } else if tag == 4 {
            self.effectButton4.layer.borderColor = UIColor.redColor().CGColor
            self.effectFileName = "Time-\(rawFileName)"
        } else if tag == 5 {
            self.effectButton5.layer.borderColor = UIColor.redColor().CGColor
            self.effectFileName = "Slow-\(rawFileName)"
        } else if tag == 6 {
            self.effectButton6.layer.borderColor = UIColor.redColor().CGColor
            self.effectFileName = "Echo-\(rawFileName)"
        }
        if tag != 1 {
            self.effectButton1.layer.borderColor = buttonBoarderMain
        }
        if tag != 2 {
            self.effectButton2.layer.borderColor = buttonBoarderMain
        }
        if tag != 3 {
            self.effectButton3.layer.borderColor = buttonBoarderMain
        }
        if tag != 4 {
            self.effectButton4.layer.borderColor = buttonBoarderMain
        }
        if tag != 5 {
            self.effectButton5.layer.borderColor = buttonBoarderMain
        }
        if tag != 6 {
            self.effectButton6.layer.borderColor = buttonBoarderMain
        }
    }
    
    func saveEffectAsset(asset:AVAsset, fileName:String) {
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let audioEffectFileURL = documentsDirectory.URLByAppendingPathComponent(fileName)
        
    
        if let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) {
            exporter.outputFileType = AVFileTypeAppleM4A
            exporter.outputURL = audioEffectFileURL
            exporter.audioTimePitchAlgorithm = AVAudioTimePitchAlgorithmVarispeed
            
            let duration = CMTimeGetSeconds(asset.duration)
            if (duration < 0.3) {
                print("sound is not long enough")
                return
            }
            
            exporter.exportAsynchronouslyWithCompletionHandler({
                switch exporter.status {
                case  AVAssetExportSessionStatus.Failed:
                    print("export failed \(exporter.error)")
                case AVAssetExportSessionStatus.Cancelled:
                    print("export cancelled \(exporter.error)")
                default:
                    print("export complete")
                    
                    let filemanager = NSFileManager.defaultManager()
                    let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                    let url = NSURL(fileURLWithPath: path)
                    let filePath = url.URLByAppendingPathComponent(self.rawFileName).path!
                    if filemanager.fileExistsAtPath(filePath) {
                        print("rawFileName sound exists")
                        print(filePath)
                        self.removefirstRecording(NSURL(fileURLWithPath: filePath))
                        
                    }
                    
                }
            })
        }
        
        
    }
    
    func removefirstRecording(url:NSURL) {
        
        print("removing file at \(url)")
        let fileManager = NSFileManager.defaultManager()
        
        do {
            try fileManager.removeItemAtURL(url)
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("error deleting recording")
        }
    }
}

extension String {
    
    func startsWith(string: String) -> Bool {
        
        guard let range = rangeOfString(string, options:[.AnchoredSearch, .CaseInsensitiveSearch]) else {
            return false
        }
        
        return range.startIndex == startIndex
    }
    
}