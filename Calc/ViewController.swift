//
//  ViewController.swift
//  Calc
//
//  Created by Admin on 27/12/2018.
//  Copyright © 2018 stas. All rights reserved.
//

import UIKit

class ResponsiveView: UIView{
    override var canBecomeFirstResponder: Bool{
        return true
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var fNum: UILabel!
    @IBOutlet weak var action: UILabel!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var clrbutton: UIButton!
    var numberFromScreen:Double = 0
    var firstNum:Double = 0
    var lastAction:Int = 0
    var strMBClrd = true
    var responsiveView: ResponsiveView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        responsiveView = ResponsiveView()
        
        responsiveView.frame = result.frame
        self.view.addSubview(responsiveView)
        
        responsiveView.isUserInteractionEnabled = true
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        longPressGR.minimumPressDuration = 0.3
        responsiveView.addGestureRecognizer(longPressGR)
    }
    
    @objc func longPressHandler(sender: UILongPressGestureRecognizer){
        guard sender.state == .began,
            let senderView = sender.view,
            let superView = sender.view?.superview
            else { return }
        
        senderView.becomeFirstResponder()
        
        let copyMenyItem = UIMenuItem(title: "Скопировать", action: #selector(copyTapped))
        UIMenuController.shared.menuItems = [copyMenyItem]
        UIMenuController.shared.setTargetRect(CGRect(origin: sender.location(in: superView), size: CGSize(width: 1, height: 1)), in: superView)
        UIMenuController.shared.setMenuVisible(true, animated: true)
    }
    
    @objc func copyTapped(){
        UIPasteboard.general.string = result.text!
        responsiveView.resignFirstResponder()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    @IBAction func digits(_ sender: UIButton) {
        if result.text!.count < 15 || strMBClrd{
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
                    showVar(label: fNum, number: &firstNum)
                }
            }
            numberFromScreen = Double(result.text!)!
        }
    }
    
    @IBAction func buttons(_ sender: UIButton) {
        action.text = sender.title(for: .normal)
        if firstNum == 0 {
            firstNum = numberFromScreen
            showVar(label: fNum, number: &firstNum)
        }
        lastAction = sender.tag
        strMBClrd = true
    }
    
    @IBAction func percent(_ sender: UIButton) {
        if firstNum != 0{
            numberFromScreen = (firstNum * numberFromScreen) / 100
            showVar(label: result, number: &numberFromScreen)
            strMBClrd = true
        }
    }
    
    @IBAction func equals(_ sender: UIButton) {
        if lastAction != 0 {
            calculating(act: lastAction)
            strMBClrd = true
        }
    }
    
    @IBAction func plusMinus(_ sender: UIButton) {
        if result.text == "-"{
            result.text = "0"
            strMBClrd = true
            numberFromScreen = Double(result.text!)!
        }
        else if result.text!.hasPrefix("-"){
            result.text!.removeFirst()
            numberFromScreen = Double(result.text!)!
        }
        else if strMBClrd && result.text == "0"{
            result.text = "-"
            strMBClrd = false
        }
        else{
            result.text = "-" + result.text!
            numberFromScreen = Double(result.text!)!
        }
    }
    
    @IBAction func putADot(_ sender: UIButton) {
        if !result.text!.contains(".") && !result.text!.contains("n"){
            sender.showsTouchWhenHighlighted = true
            result.text! += "."
            numberFromScreen = Double(result.text!)!
            strMBClrd = false
        }
        else{
            sender.showsTouchWhenHighlighted = false
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
        strMBClrd = true
    }
    
    @IBAction func oneCharClr(_ sender: UIButton) {
        if result.text!.count > 1 && !result.text!.contains("n"){
            result.text!.removeLast()
        }
        else {
            result.text = "0"
            strMBClrd = true
        }
        if result.text != "-"{
            numberFromScreen = Double(result.text!)!
            if firstNum != 0{
                showVar(label: fNum, number: &firstNum)
            }
        }
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
        showVar(label: result, number: &firstNum)
        fNum.text = ""
    }
    
    func showVar(label: UILabel, number: inout Double){
        if number.truncatingRemainder(dividingBy: 1) == 0 && number < 1.0e16{
            label.text = String(Int64(number))
        }
        else {
            label.text = String(Double(number))
        }
    }
}
