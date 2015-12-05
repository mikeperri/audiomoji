//
//  KeyboardViewController.swift
//  CustomKeyboard
//
//  Created by Michael Perri on 11/29/15.
//  Copyright © 2015 Michael Perri. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    var collectionView: UICollectionView!
    var keys: [KeyData]!
    
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
        keys.append(KeyData(imageResourceName: "pear", audioResourceName: "huh"))
        
        
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        //CGRect(x: 0,y: 0,width: 90,height: 90)
        collectionView = UICollectionView(frame: self.inputView!.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(KeyCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        
        self.inputView!.addSubview(collectionView)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! KeyCollectionViewCell
        let keyData = keys[indexPath.item]
        cell.backgroundColor = UIColor.greenColor()
        cell.imageView.image = UIImage(named: keyData.imageResourceName)
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let keyData = keys[indexPath.item]
        print("did select item at path...")
        pasteAudio(keyData.audioResourceName)
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
        self.nextKeyboardButton = UIButton(type: .System)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        let nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])
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
        print("attempting to paste")
        if let pasteboard: UIPasteboard = UIPasteboard.generalPasteboard() {
            print("got this far")
            print(resourceName)
            if let path = NSBundle.mainBundle().pathForResource(resourceName, ofType: "amr") {
                print("got THIS far")
                if let amrData = NSData(contentsOfFile: path) {
                    print("here we go")
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
