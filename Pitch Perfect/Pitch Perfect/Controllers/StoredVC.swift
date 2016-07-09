//
//  StoredVC.swift
//  Pitch Perfect
//
//  Created by Corey Baines on 6/7/16.
//  Copyright © 2016 Corey Baines. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class StoredVC: UIViewController, UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate {
    
    var recordings = [NSURL]()
    var audioPlayer: AVAudioPlayer!
    var audioFile:AVAudioFile!
    var tag = 0
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listAllRecordings()
        
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recordings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SavedEffectCell
        
        //cell.effectImage = ""
        print(recordings.reverse()[indexPath.row])
        var name = recordings.reverse()[indexPath.row].lastPathComponent
        print("\((name?.componentsSeparatedByString("-"))![0])")
        cell.effectImage.image = UIImage(named: "\((name?.componentsSeparatedByString("-"))![0]).png")
        cell.fileName.text = name
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("CLICK")
        let recording = recordings.reverse()[indexPath.row]
        let name = recordings.reverse()[indexPath.row].lastPathComponent
        let effectName = (name?.componentsSeparatedByString("-"))![0]
        playAudioFile(recording, effectName: effectName)
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.deleteRecording(self.recordings.reverse()[indexPath.row])
           // objects.removeAtIndex(indexPath.row)
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
 
    // MARK: -- Functions
    
    func listAllRecordings() {
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        do {
            let urls = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsDirectory, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles)
            self.recordings = urls.filter( { (name: NSURL) -> Bool in
                return name.lastPathComponent!.hasSuffix("m4a")
            })
                
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("something went wrong listing recordings")
        }
            
        
    }

    func deleteRecording(url:NSURL) {
        
        print("removing file at \(url.absoluteString)")
        print("removing file at \(url.lastPathComponent)")
        let fileManager = NSFileManager.defaultManager()
        
        do {
            try fileManager.removeItemAtURL(url)
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("error deleting recording")
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.listAllRecordings()
            self.tableView?.reloadData()
        })
    }
    
    func setSessionPlayback() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }

    func playAudioFile(filename:NSURL, effectName:String) {
        audioPlayer?.stop()
        stopAudio()
        let url = filename
        print("playing \(url)")
        print(effectName)
        
        do {
            self.audioFile = try AVAudioFile(forReading: url)
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: url)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            if effectName == "Raw" {
                audioPlayer.volume = 1.0
                audioPlayer.play()
            } else if effectName == "Starwars" {
                PlayEffect.playEffect.playWithEffect(pitch: -1000, rawAudioFile: audioFile)
            } else if effectName == "Fast" {
                PlayEffect.playEffect.playWithEffect(rate: 1.5, rawAudioFile: audioFile)
            } else if effectName == "Animal" {
                PlayEffect.playEffect.playWithEffect(pitch: 1000, rawAudioFile: audioFile)
            } else if effectName == "Time" {
                PlayEffect.playEffect.playWithEffect(reverb: true, rawAudioFile: audioFile)
            } else if effectName == "Slow" {
                PlayEffect.playEffect.playWithEffect(rate: 0.5, rawAudioFile: audioFile)
            } else if effectName == "Echo" {
                PlayEffect.playEffect.playWithEffect(echo: true, rawAudioFile: audioFile)
            }
        } catch let error as NSError {
            self.audioPlayer = nil
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