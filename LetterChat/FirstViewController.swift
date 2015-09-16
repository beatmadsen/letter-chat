//
//  FirstViewController.swift
//  LetterChat
//
//  Created by Erik Madsen on 12/09/2015.
//  Copyright (c) 2015 Erik Madsen. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet var drawView: DrawView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearTapped() {
        drawView.clearLines()
    }
    
    @IBAction func changeColour(sender: UIButton) {
        switch sender.titleLabel?.text {
        case .Some("Red"):
            drawView.colour = UIColor.redColor()
        case .Some("Black"):
            drawView.colour = UIColor.blackColor()
        default:
            42
        }
    }
    

}

