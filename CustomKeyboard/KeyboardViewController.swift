//
//  KeyboardViewController.swift
//  CustomKeyboard
//
//  Created by Michael Perri on 11/29/15.
//  Copyright © 2015 Michael Perri. All rights reserved.
//

import UIKit
import AVFoundation

class KeyboardViewController: UIInputViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIGestureRecognizerDelegate {

    var collectionView: UICollectionView!
    var keys: [KeyData]!
    var hud: MBProgressHUD = MBProgressHUD()
    var audioPlayer: AVAudioPlayer!
    var bundle: NSBundle = NSBundle.mainBundle()
    
    //var keyboardView: UIView!
    @IBOutlet var nextKeyboardButton: UIButton!
    var buttons = [UIButton]()
    var audioButtonDict = Dictionary<Int, String>()

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //TODO: load from plist
        keys = [KeyData]()
        keys.append(KeyData(text: "📣", audioResourceName: "airhorn"))
        keys.append(KeyData(text: "👏", audioResourceName: "applause"))
        keys.append(KeyData(text: "🍺", audioResourceName: "beer"))
        keys.append(KeyData(text: "💰", audioResourceName: "cash"))
        keys.append(KeyData(text: "🐱", audioResourceName: "cat"))
        keys.append(KeyData(text: "🔕", audioResourceName: "crickets"))
        keys.append(KeyData(text: "🐶", audioResourceName: "dog"))
        keys.append(KeyData(text: "🍐", audioResourceName: "huh"))
        keys.append(KeyData(text: "🎶", audioResourceName: "mmg"))
        keys.append(KeyData(text: "🍑", audioResourceName: "peach"))
        keys.append(KeyData(text: "😹", audioResourceName: "rimshot"))
        keys.append(KeyData(text: "🚀", audioResourceName: "rocket"))
        keys.append(KeyData(text: "🐓", audioResourceName: "rooster"))
        keys.append(KeyData(text: "😿", audioResourceName: "sad-trombone"))
        keys.append(KeyData(text: "🚔", audioResourceName: "siren"))
        keys.append(KeyData(text: "🦃", audioResourceName: "turkey"))
        
        
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 50, height: 50)
        
        //CGRect(x: 0,y: 0,width: 90,height: 90)
        collectionView = UICollectionView(frame: self.inputView!.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(KeyCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.purpleColor()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        //Long press
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        longPressGestureRecognizer.delegate = self
        longPressGestureRecognizer.minimumPressDuration = 1.0
        collectionView.addGestureRecognizer(longPressGestureRecognizer)
        
        
        self.inputView!.addSubview(collectionView)
        
        addNextKeyboardButton()
        addHintLabel()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! KeyCollectionViewCell
        let keyData = keys[indexPath.item]
        //cell.backgroundColor = UIColor.greenColor()
        cell.layer.cornerRadius = 16
        cell.label.text = keyData.text
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let keyData = keys[indexPath.item]
        let progressHUD = MBProgressHUD.showHUDAddedTo(self.view.superview, animated: true)
        progressHUD.mode = MBProgressHUDMode.CustomView
        progressHUD.labelText = "Copied"
        progressHUD.hide(true, afterDelay: 1)
        
        pasteAudio(keyData.audioResourceName)
    }
    
    func handleLongPress(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Ended || sender.state == UIGestureRecognizerState.Cancelled {
            print("cancelled gesture, state was")
            print(sender.state)
            audioPlayer?.stop()
        }
        
        if sender.state == UIGestureRecognizerState.Began {
            let p = sender.locationInView(self.collectionView)
            
            if let indexPath = self.collectionView.indexPathForItemAtPoint(p) {
                //var cell = self.collectionView.cellForItemAtIndexPath(index)
                // do stuff with your cell, for example print the indexPath
                let keyData = keys[indexPath.item]
                print(keyData.audioResourceName)
                if let soundPath = bundle.pathForResource(keyData.audioResourceName, ofType: "wav") {
                    let soundURL = NSURL(fileURLWithPath: soundPath)
                    
                    do {
                        try audioPlayer = AVAudioPlayer(contentsOfURL: soundURL)
                        audioPlayer.play()
                        print("played")
                    } catch {
                        
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        
        if (self.nextKeyboardButton != nil) {
            let proxy = self.textDocumentProxy
            if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
                textColor = UIColor.whiteColor()
            } else {
                textColor = UIColor.blackColor()
            }
            self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
        }
    }
    
    func addNextKeyboardButton() {
        nextKeyboardButton = UIButton(type: .System)
        
        nextKeyboardButton.setTitle(NSLocalizedString("ABC", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        nextKeyboardButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        nextKeyboardButton.sizeToFit()
        nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
        view.addSubview(nextKeyboardButton)
        
        let nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 10.0)
        let nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])
    }
    
    func addHintLabel() {
        let hintLabel = UILabel()
        hintLabel.text = NSLocalizedString("Tap to copy, hold to preview", comment: "Hint label text")
        hintLabel.textColor = UIColor.whiteColor()
        hintLabel.font = UIFont.systemFontOfSize(14)
        hintLabel.sizeToFit()
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hintLabel)
        
        let hintLabelRightSideConstraint = NSLayoutConstraint(item: hintLabel, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: -10.0)
        let hintLabelBottomConstraint = NSLayoutConstraint(item: hintLabel, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -5.0)
        view.addConstraints([hintLabelRightSideConstraint, hintLabelBottomConstraint])
    }
    
    func addAudioButton(imageResourceName: String, audioResourceName: String){
        let button = UIButton(type: .System)
        let image = UIImage(named: imageResourceName + ".png")
        
        button.frame = CGRectMake(0, 0, 50, 50)
        button.layer.cornerRadius = 10
        button.setBackgroundImage(image, forState: .Normal)
        button.backgroundColor = UIColor.greenColor()
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        button.tag = buttons.count
        audioButtonDict[button.tag] = audioResourceName
        buttons.append(button)
        
        self.view.addSubview(button)
        
        /*let leftSideConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([leftSideConstraint, topConstraint])*/
    }
    
    func buttonAction(sender: UIButton) {
        if let audioResourceName = audioButtonDict[sender.tag] {
            pasteAudio(audioResourceName)
        }
    }

    func pasteAudio(resourceName: String) {
        if let pasteboard: UIPasteboard = UIPasteboard.generalPasteboard() {
            if let path = NSBundle.mainBundle().pathForResource(resourceName, ofType: "amr") {
                print("got path")
                if let amrData = NSData(contentsOfFile: path) {
                    let dict = NSMutableDictionary(capacity: 3)
                    dict.setValue("Audio Message.amr", forKey: "public.url-name")
                    dict.setValue("Audio Message.amr", forKey: "public.utf8-plain-text")
                    dict.setValue(amrData, forKey: "org.3gpp.adaptive-multi-rate-audio")
                    pasteboard.items = NSArray(object: dict) as [AnyObject]
                }
            }
        }
    }
}