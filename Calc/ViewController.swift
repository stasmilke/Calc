//
//  ViewController.swift
//  Calc
//
//  Created by Admin on 27/12/2018.
//  Copyright © 2018 stas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ostatok: UILabel!
    @IBOutlet weak var action: UILabel!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var clrbutton: UIButton!
    var numberFromScreen:Double = 0
    var firstNum:Double = 0
    var lastAction:Int = 0
    var strMBClrd = true
    var actSec = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    @IBAction func digits(_ sender: UIButton) {
        if result.text!.count < 8 {
            if !strMBClrd{
                result.text = result.text! + String(sender.tag)
            }
            else {
                result.text = String(sender.tag)
                if result.text != "0" {
                    clrbutton.setTitle("C", for: .normal)
                    strMBClrd = false
                }
            }
            numberFromScreen = Double(result.text!)!
        }
    }
    
    @IBAction func buttons(_ sender: UIButton) {
        action.text = sender.title(for: .normal)
        if actSec && sender.tag == lastAction{
            calculating(act: sender.tag)
        }
        else if firstNum == 0 {
            firstNum = numberFromScreen
        }
        actSec = true
        lastAction = sender.tag
        strMBClrd = true
    }
    
    @IBAction func otherActs(_ sender: UIButton) {
        if lastAction != 0{
            calculating(act: lastAction)
            strMBClrd = true
            actSec = false
        }
    }
    
    @IBAction func clearing(_ sender: UIButton) {
        firstNum = 0
        lastAction = 0
        action.text = ""
        ostatok.text = ""
        clrbutton.setTitle("AC", for: .normal)
        result.text = "0"
        numberFromScreen = 0
        actSec = false
        strMBClrd = true
    }
    
    @IBAction func oneCharClr(_ sender: UIButton) {
        if result.text!.count > 1 {
            result.text!.removeLast()
        }
        else {
            result.text = "0"
            strMBClrd = true
        }
        numberFromScreen = Double(result.text!)!
    }
    
    func calculating( act: Int){
        switch act {
        case 11:
            firstNum /= numberFromScreen
            break
        case 12:
            firstNum *= numberFromScreen
            break
        case 13:
            firstNum -= numberFromScreen
            break
        case 14:
            firstNum += numberFromScreen
            break
        default:
            break
        }
        if (firstNum >= 100000000) || (firstNum <= -10000000) {
            result.text = "Ошибка"
            action.text = ""
            ostatok.text = "Нажмите С"
            firstNum = 100000000
        }
        else {
            result.text = String(Int(firstNum))
            ostatok.text = "+ " + String(firstNum - firstNum.rounded(.towardZero))
        }
    }
}
