//
//  ViewController.swift
//  SwiftCalc
//
//  Created by Zach Zeleznick on 9/20/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Width and Height of Screen for Layout
    var w: CGFloat!
    var h: CGFloat!
    let division = "/"
    let multiplication = "*"
    let subtraction = "-"
    let addition = "+"
    let equals = "="
    

    // IMPORTANT: Do NOT modify the name or class of resultLabel.
    //            We will be using the result label to run autograded tests.
    // MARK: The label to display our calculations
    var resultLabel = UILabel()
    
    
    // TODO: This looks like a good place to add some data structures.
    //       One data structure is initialized below for reference.
    var someDataStructure: [String] = [""]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        w = view.bounds.size.width
        h = view.bounds.size.height
        navigationItem.title = "Calculator"
        // IMPORTANT: Do NOT modify the accessibilityValue of resultLabel.
        //            We will be using the result label to run autograded tests.
        resultLabel.accessibilityValue = "resultLabel"
        makeButtons()
       // self.view.addSubview(resultLabel)
        
        // Do any additional setup here.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: A method to update your data structure(s) would be nice.
    //       Modify this one or create your own.
    func updateSomeDataStructure(_ content: String) {
        someDataStructure.append(content)
    }
    
    // TODO: Ensure that resultLabel gets updated.
    //       Modify this one or create your own.
    func updateResultLabel(_ content: String) {
        let operators = ["/", "*", "-", "+"]
        if (resultLabel.text == "0"){
            if (content == ".") {
                resultLabel.text = "0."
                updateSomeDataStructure("0")
                updateSomeDataStructure(".")
            } else {
                resultLabel.text = content
                updateSomeDataStructure(content)
            }
        } else if(resultLabel.text == "-0") {
            resultLabel.text = "-" + content
            updateSomeDataStructure(content)
        }else if (resultLabel.text!.range(of: ".") == nil && content == ".") {
            resultLabel.text = resultLabel.text! + content
            updateSomeDataStructure(content)
        } else if (resultLabel.text!.range(of: ".") != nil && content == ".") {
            return
        } else if (operators.contains(someDataStructure.last!)){
            resultLabel.text = content
            updateSomeDataStructure(content)
        } else if (resultLabel.text!.characters.count < 7){
            resultLabel.text = resultLabel.text! + content
            updateSomeDataStructure(content)
        }
        }
    
    
    // TODO: A calculate method with no parameters, scary!
    //       Modify this one or create your own.
    func calculate() -> String {
        var isInt = true
        var isarg1 = true
        var prevop = false
        var arg1 = ""
        var arg2 = ""
        var op1 = ""
        var isarg1Pos = true;
        var isarg2Pos = true;
        let operators = ["/", "*", "-", "+"]
        print("printing all of someDataStructure")
        for item in someDataStructure.enumerated(){
            print(item)
        }
        
        for (index, value) in someDataStructure.enumerated() {
            if (isarg1) {
                if (value == ".") {
                    isInt = false
                }
                if (value == "+/-"){
                    isarg1Pos = !isarg1Pos;
                } else if operators.contains(value) {
                    isarg1 = false
                    op1 = value
                    prevop = true
                } else if (value == "=") {
                    someDataStructure.removeAll()
                    someDataStructure.append(arg1)
                    return arg1
                } else {
                    arg1 = arg1 + value
                }
            } else if (!isarg1) {
                if (value == ".") {
                    isInt = false
                }
                if (value == "+/-"){
                    isarg2Pos = !isarg2Pos;
                } else if operators.contains(value) {
                    if (prevop) {
                        op1 = value
                    } else if (isInt) {
                        
                        if (!isarg1Pos) {
                            arg1 = "-" + arg1
                        }
                        if (!isarg2Pos) {
                            arg2 = "-" + arg2
                        }
                        var result = whichCalc(a1: arg1, b1: arg2, op: op1, isitInt: isInt)
                        /* IF MORE THAN 7
                        if (result.characters.count > 7){
                            result = result.substring(to: 6)
                        }
 */
                        prevop = false
                        someDataStructure.removeAll()
                        someDataStructure.append(result)
                        someDataStructure.append(value)
                        return result
                    }
                } else if (value == "="){
                    if (!isarg1Pos) {
                        arg1 = "-" + arg1
                    }
                    if (!isarg2Pos) {
                        arg2 = "-" + arg2
                    }
                    someDataStructure.removeAll()
                    var result = whichCalc(a1: arg1, b1: arg2, op: op1, isitInt: isInt)
                   someDataStructure.append(result)
                    return result
                } else {
                    arg2 = arg2 + value
                    prevop = false
                }
            }
            
            
        }
        return "0"
    }
    
    func whichCalc (a1: String, b1: String, op: String, isitInt: Bool) -> String {
        var result = "0"
        var isInt = isitInt
        var intarg1 = 0
        var intarg2 = 0
        if (a1.characters.index(of: ".") != nil || b1.characters.index(of: ".") != nil) {
            isInt = false
        }
        if (isInt) {
            intarg1 = Int(a1)!
            intarg2 = Int(b1)!
        }
        if (isitInt && op == "/" && (Int(intarg1) % Int(intarg2)) != 0) {
            isInt = false
        }
        if(isInt) {
            let intResult = intCalculate(a: Int(intarg1), b: Int(intarg2), operation: op)
            result = String(intResult)
        } else if (!isInt) {
            let  doubleResult = calculate(a: a1, b: b1, operation: op)
            result = String(doubleResult)
        }
        return result
    
    }
    
    // TODO: A simple calculate method for integers.
    //       Modify this one or create your own.
    func intCalculate(a: Int, b:Int, operation: String) -> Int {
        print("Calculation requested for \(a) \(operation) \(b)")
        switch operation {
        case division:
            return Int(a)/Int(b)
        case subtraction:
            return Int(a) - Int(b)
        case multiplication:
            return Int(a) * Int(b)
        case addition:
            return Int(a) + Int(b)
        default:
            return 0
        }
    }
    
    // TODO: A general calculate method for doubles
    //       Modify this one or create your own.
    func calculate(a: String, b:String, operation: String) -> Double {
        print("Calculation requested for \(a) \(operation) \(b)")
        
        var result = 0.0
        let doubleA = Double(a)!
        let doubleB = Double(b)!
        switch operation {
        case division:
            result = doubleA / doubleB
            return result
        case subtraction:
            result = doubleA - doubleB
            return result
        case multiplication:
            result = doubleA * doubleB
            return result
        case addition:
            result = doubleA + doubleB
            return result
        default:
            return 0.0
        }
    }
    
    // REQUIRED: The responder to a number button being pressed.
    func numberPressed(_ sender: CustomButton) {
        guard Int(sender.content) != nil else { return }
        print("The number \(sender.content) was pressed")
        //numbers except 0??
        updateResultLabel(sender.content)
    }
    
    // REQUIRED: The responder to an operator button being pressed.
    func operatorPressed(_ sender: CustomButton) {
        // Fill me in!
        //operators and others
        let operators = ["/", "*", "-", "+"]
        if (sender.content == "C") {
            resultLabel.text = "0"
            someDataStructure.removeAll();
        } else if (sender.content == "+/-") {
            someDataStructure.append(sender.content)
            if (resultLabel.text!.hasPrefix("-")){
                resultLabel.text!.remove(at: resultLabel.text!.startIndex)
                //TO DO splice
            } else {
                resultLabel.text = "-" + resultLabel.text!
            }
        } else if (operators.contains(sender.content)) {
            var alreadyHasOp = false
            for item in someDataStructure {
                if (operators.contains(item)) {
                    alreadyHasOp = true
                }
            }
           
            if (alreadyHasOp && !operators.contains(someDataStructure.last!)) {
                someDataStructure.append("=")
                resultLabel.text = calculate()
            }
             someDataStructure.append(sender.content)
        } else if (sender.content == "=") {
             someDataStructure.append(sender.content)
             resultLabel.text = calculate()
        }

    }
    
    // REQUIRED: The responder to a number or operator button being pressed.
    func buttonPressed(_ sender: CustomButton) {
       // Fill me in!
        //special buttons
        updateResultLabel(sender.content)
    }
    
    // IMPORTANT: Do NOT change any of the code below.
    //            We will be using these buttons to run autograded tests.
    
    func makeButtons() {
        // MARK: Adds buttons
        let digits = (1..<10).map({
            return String($0)
        })
        let operators = ["/", "*", "-", "+", "="]
        let others = ["C", "+/-", "%"]
        let special = ["0", "."]
        
        let displayContainer = UIView()
        view.addUIElement(displayContainer, frame: CGRect(x: 0, y: 0, width: w, height: 160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }
        displayContainer.addUIElement(resultLabel, text: "0", frame: CGRect(x: 70, y: 70, width: w-70, height: 90)) {
            element in
            guard let label = element as? UILabel else { return }
            label.textColor = UIColor.white
            label.font = UIFont(name: label.font.fontName, size: 60)
            label.textAlignment = NSTextAlignment.right
        }
        
        let calcContainer = UIView()
        view.addUIElement(calcContainer, frame: CGRect(x: 0, y: 160, width: w, height: h-160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }

        let margin: CGFloat = 1.0
        let buttonWidth: CGFloat = w / 4.0
        let buttonHeight: CGFloat = 100.0
        
        // MARK: Top Row
        for (i, el) in others.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Second Row 3x3
        for (i, digit) in digits.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: digit), text: digit,
            frame: CGRect(x: x, y: y+101.0, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
            }
        }
        // MARK: Vertical Column of Operators
        for (i, el) in operators.enumerated() {
            let x = (CGFloat(3) + 1.0) * margin + (CGFloat(3) * buttonWidth)
            let y = (CGFloat(i) + 1.0) * margin + (CGFloat(i) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.backgroundColor = UIColor.orange
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Last Row for big 0 and .
        for (i, el) in special.enumerated() {
            let myWidth = buttonWidth * (CGFloat((i+1)%2) + 1.0) + margin * (CGFloat((i+1)%2))
            let x = (CGFloat(2*i) + 1.0) * margin + buttonWidth * (CGFloat(i*2))
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: 405, width: myWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            }
        }
    }

}

