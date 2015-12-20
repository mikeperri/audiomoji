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
    var collectionViewHeightConstraint: NSLayoutConstraint!
    var keys: [KeyData]!
    var hud: MBProgressHUD = MBProgressHUD()
    var audioPlayer: AVAudioPlayer!
    var bundle: NSBundle = NSBundle.mainBundle()
    
    //var keyboardView: UIView!
    var nextKeyboardButton: UIButton!
    var backspaceButton: UIButton!
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
        layout.itemSize = CGSize(width: 42, height: 42)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        //CGRect(x: 0,y: 0,width: 90,height: 90)
        collectionView = UICollectionView(frame: self.inputView!.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(KeyCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        //Long press
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        longPressGestureRecognizer.delegate = self
        longPressGestureRecognizer.minimumPressDuration = 1.0
        collectionView.addGestureRecognizer(longPressGestureRecognizer)
        
        
        self.inputView!.addSubview(collectionView)
        
        let collectionViewLeftSideConstraint = NSLayoutConstraint(item: collectionView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 10.0)
        let collectionViewTopConstraint = NSLayoutConstraint(item: collectionView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 20.0)
        let collectionViewBottomConstraint = NSLayoutConstraint(item: collectionView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -30.0)
        let collectionViewRightSideConstraint = NSLayoutConstraint(item: collectionView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: -10.0)
        collectionViewHeightConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (layout.itemSize.height * 2) + 40)
        
        view.addConstraints([collectionViewLeftSideConstraint, collectionViewTopConstraint, collectionViewBottomConstraint, collectionViewRightSideConstraint, collectionViewHeightConstraint])
        
        addNextKeyboardButton()
        addTitleLabel()
        addHintLabel()
        addBackspaceButton()
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
    
    func addTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("SOUNDS", comment: "Hint label text")
        titleLabel.textColor = UIColor.lightGrayColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(12)
        titleLabel.sizeToFit()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let titleLabelLeftSideConstraint = NSLayoutConstraint(item: titleLabel, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 15.0)
        let titleLabelTopConstraint = NSLayoutConstraint(item: titleLabel, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 10.0)
        view.addConstraints([titleLabelLeftSideConstraint, titleLabelTopConstraint])
    }
    
    func addNextKeyboardButton() {
        nextKeyboardButton = UIButton(type: .System)
        
        nextKeyboardButton.setTitle(NSLocalizedString("ABC", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        nextKeyboardButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        nextKeyboardButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        nextKeyboardButton.sizeToFit()
        nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
        view.addSubview(nextKeyboardButton)
        
        let nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 10.0)
        let nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -7.0)
        view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])
    }

    func addHintLabel() {
        let hintLabel = UILabel()
        hintLabel.text = NSLocalizedString("Tap to copy, hold to preview", comment: "Hint label text")
        hintLabel.textColor = UIColor.lightGrayColor()
        hintLabel.font = UIFont.systemFontOfSize(14)
        hintLabel.textAlignment = NSTextAlignment.Center
        //hintLabel.sizeToFit()
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hintLabel)
        
        let hintLabelLeftSideConstraint = NSLayoutConstraint(item: hintLabel, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 25.0)
        let hintLabelRightSideConstraint = NSLayoutConstraint(item: hintLabel, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: -25.0)
        let hintLabelBottomConstraint = NSLayoutConstraint(item: hintLabel, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -14.0)
        view.addConstraints([hintLabelLeftSideConstraint, hintLabelRightSideConstraint, hintLabelBottomConstraint])
    }
    
    func addBackspaceButton() {
        backspaceButton = UIButton(type: .System)
        
        backspaceButton.setTitle("DEL", forState: .Normal)
        backspaceButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        backspaceButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        backspaceButton.sizeToFit()
        backspaceButton.translatesAutoresizingMaskIntoConstraints = false

        backspaceButton.addTarget(self, action: "backspace:", forControlEvents: .TouchUpInside)
        
        view.addSubview(backspaceButton)
        
        let backspaceButtonLeftSideConstraint = NSLayoutConstraint(item: backspaceButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: -10.0)
        let backspaceButtonBottomConstraint = NSLayoutConstraint(item: backspaceButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -7.0)
        view.addConstraints([backspaceButtonLeftSideConstraint, backspaceButtonBottomConstraint])
    }
    
    func backspace() {
        self.textDocumentProxy.deleteBackward()
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