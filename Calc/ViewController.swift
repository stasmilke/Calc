//
//  ViewController.swift
//  Calc
//
//  Created by Admin on 27/12/2018.
//  Copyright © 2018 stas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fNum: UILabel!
    @IBOutlet weak var action: UILabel!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var clrbutton: UIButton!
    var numberFromScreen:Float = 0
    var firstNum:Float = 0
    var lastAction:Int = 0
    var strMBClrd = true
    var actSec = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    @IBAction func digits(_ sender: UIButton) {
        if result.text!.count < 10 || strMBClrd{
            if result.text == "-" && sender.tag == 0{
                result.text = "0"
                strMBClrd = true
            }
            else if !strMBClrd {
                result.text = result.text! + String(sender.tag)
            }
            else {
                result.text = String(sender.tag)
                if result.text != "0" {
                    clrbutton.setTitle("C", for: .normal)
                    strMBClrd = false
                }
                if !action.text!.isEmpty{
                    fNum.text = String(firstNum)
                }
            }
            numberFromScreen = Float(result.text!)!
            actSec = false
        }
    }
    
    @IBAction func buttons(_ sender: UIButton) {
        action.text = sender.title(for: .normal)
        if firstNum == 0 || !actSec{
            firstNum = numberFromScreen
            fNum.text = String(firstNum)
        }
        actSec = true
        lastAction = sender.tag
        strMBClrd = true
    }
    
    @IBAction func equals(_ sender: UIButton) {
        if lastAction != 0{
            calculating(act: lastAction)
            strMBClrd = true
            actSec = false
        }
    }
    
    @IBAction func plusMinus(_ sender: UIButton) {
        if result.text == "-"{
            result.text = "0"
            strMBClrd = true
            numberFromScreen = Float(result.text!)!
        }
        else if result.text!.hasPrefix("-"){
            result.text!.removeFirst()
            numberFromScreen = Float(result.text!)!
        }
        else if strMBClrd && result.text == "0"{
            result.text = "-"
            strMBClrd = false
        }
        else{
            result.text = "-" + result.text!
            numberFromScreen = Float(result.text!)!
        }
    }
    
    @IBAction func putADot(_ sender: UIButton) {
        if !result.text!.hasSuffix("."){
            result.text! += "."
            numberFromScreen = Float(result.text!)!
            strMBClrd = false
            actSec = false
        }
    }
    
    @IBAction func clearing(_ sender: UIButton) {
        firstNum = 0
        fNum.text = ""
        lastAction = 0
        action.text = ""
        clrbutton.setTitle("AC", for: .normal)
        result.text = "0"
        numberFromScreen = 0
        actSec = false
        strMBClrd = true
    }
    
    @IBAction func oneCharClr(_ sender: UIButton) {
        if result.text!.count > 1 && !result.text!.contains("e") && !result.text!.contains("ч"){
            result.text!.removeLast()
        }
        else {
            result.text = "0"
            strMBClrd = true
        }
        if result.text != "-"{
            numberFromScreen = Float(result.text!)!
        }
        actSec = false
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
        
        if (firstNum >= 10000000000) || (firstNum <= -1000000000) {
            result.text = String(firstNum)
        }
        else {
            if firstNum.truncatingRemainder(dividingBy: 1) == 0{
                result.text = String(Int(firstNum))
            }
            else {
                result.text = String(firstNum)
            }
        }
        switch result.text {
        case "nan", "inf":
            result.text = "Не число"
            break
        default:
            break
        }
        fNum.text = ""
        numberFromScreen = Float(result.text!)!
    }
}
