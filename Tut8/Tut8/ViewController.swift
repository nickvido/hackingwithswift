//
//  ViewController.swift
//  Tut8
//
//  Created by nickvido on 10/5/15.
//  Copyright © 2015 nickvido. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

    var level = 0
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    @IBOutlet weak var cluesLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var onSubmitTapped: UIButton!
    
    @IBAction func onSubmitTapped(sender: AnyObject) {
        if let solutionPosition = solutions.indexOf(currentAnswer.text!) {
            activatedButtons.removeAll()
            
            var splitClues = answersLabel.text!.componentsSeparatedByString("\n")
            splitClues[solutionPosition] = currentAnswer.text!
            answersLabel.text = splitClues.joinWithSeparator("\n")
            
            currentAnswer.text = "Tap buttons to guess"
            ++score
            
            if score % 7 == 0 {
                let ac = UIAlertController(title: "Level up!", message: "Are you ready?", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .Default, handler: levelUp))
                presentViewController(ac, animated: true, completion: nil)
                
            }
        }
    }
    
    @IBAction func onClearTapped(sender: AnyObject) {
        currentAnswer.text = "Tap buttons to guess"
        for btn in activatedButtons {
            btn.hidden = false
        }
        activatedButtons.removeAll()

    }
    
    
    @IBOutlet weak var currentAnswer: UITextField!
    
    @IBOutlet weak var answersLabel: UILabel!
    
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for subview in view.subviews where subview.tag == 1001 {
            let btn = subview as! UIButton
            letterButtons.append(btn)
            btn.addTarget(self, action: "letterTapped:", forControlEvents: .TouchUpInside)
        }
        
        loadLevel()
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFilePath = NSBundle.mainBundle().pathForResource("level\(level)", ofType: "txt") {
            if let levelContents = try? String(contentsOfFile: levelFilePath, usedEncoding: nil) {
                var lines = levelContents.componentsSeparatedByString("\n")
                lines = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(lines) as! [String]
                
                for (index, line) in lines.enumerate() {
                    let parts = line.componentsSeparatedByString(": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    let solutionWord = answer.stringByReplacingOccurrencesOfString("|", withString: "")
                    solutionString += "\(solutionWord.characters.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.componentsSeparatedByString("|")
                    letterBits += bits
                }
                
                cluesLabel.text = clueString
                answersLabel.text = solutionString
                    
                letterBits = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(letterBits) as! [String]
                self.letterButtons = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(self.letterButtons) as! [UIButton]
                    
                 if letterBits.count == letterButtons.count {
                    for i in 0 ..< letterBits.count {
                        letterButtons[i].setTitle(letterBits[i], forState: .Normal)
                    }
                }
            }
        }
    }
    
    func letterTapped(btn: UIButton) {
        if activatedButtons.count == 0 {
            currentAnswer.text = ""
        }
        
        currentAnswer.text = currentAnswer.text! + btn.titleLabel!.text!
        activatedButtons.append(btn)
        btn.hidden = true
    }
    
    func levelUp(action: UIAlertAction!) {
        ++level
        solutions.removeAll(keepCapacity: true)
        
        loadLevel()
        
        for btn in letterButtons {
            btn.hidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

