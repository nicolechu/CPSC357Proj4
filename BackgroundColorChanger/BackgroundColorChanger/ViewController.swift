//
//  ViewController.swift
//  BackgroundColorChanger
//
//  Created by Christopher Boyd on 9/28/20.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var sliderR: UISlider!
    @IBOutlet weak var sliderG: UISlider!
    @IBOutlet weak var sliderB: UISlider!
    @IBOutlet weak var sliderA: UISlider!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var inputR: UITextField!
    @IBOutlet weak var inputG: UITextField!
    @IBOutlet weak var inputB: UITextField!
    @IBOutlet weak var inputA: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var activeTextField: UITextField? = nil
    
    @IBAction func adjustInput(_ sender: Any) {
        let inputRed = Float(inputR.hasText ? inputR.text! : "255") ?? 255
        let inputGreen = Float(inputG.hasText ? inputG.text! : "255") ?? 255
        let inputBlue = Float(inputB.hasText ? inputB.text! : "255") ?? 255
        let inputAlpha = Float(inputA.hasText ? inputA.text! : "255") ?? 255

        sliderR.value = inputRed
        sliderG.value = inputGreen
        sliderB.value = inputBlue
        sliderA.value = inputAlpha
        
        adjustSlider(self)
    }

    @IBAction func clickSave(_ sender: Any) {
        let inputRed = Int(sliderR.value)
        let inputGreen = Int(sliderG.value)
        let inputBlue = Int(sliderB.value)
        let inputAlpha = Int(sliderA.value)
        
        StorageHandler.set(value: Color(red: inputRed, green: inputGreen, blue: inputBlue, alpha: inputAlpha))
    }
    
    @IBAction func adjustSlider(_ sender: Any) {
        let inputRed = CGFloat(sliderR.value)/255
        let inputGreen = CGFloat(sliderG.value)/255
        let inputBlue = CGFloat(sliderB.value)/255
        let inputAlpha = CGFloat(sliderA.value)/255
        
        let newColor = UIColor(red: inputRed, green: inputGreen, blue: inputBlue, alpha: inputAlpha)
	
        inputR.text = String(Int(sliderR.value))
        inputG.text = String(Int(sliderG.value))
        inputB.text = String(Int(sliderB.value))
        inputA.text = String(Int(sliderA.value))
        
        mainView.backgroundColor = newColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        inputR.delegate = self
        inputG.delegate = self
        inputB.delegate = self
        inputA.delegate = self
        
        sliderR.value = 255
        sliderG.value = 255
        sliderB.value = 255
        sliderA.value = 255
        
        StorageHandler.getStorage()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

          guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {

            // if keyboard size is not available for some reason, dont do anything
            return
          }

          var shouldMoveViewUp = false

          // if active text field is not nil
          if let activeTextField = activeTextField {

            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            
            let topOfKeyboard = self.view.frame.height - keyboardSize.height

            // if the bottom of Textfield is below the top of keyboard, move up
            if bottomOfTextField > topOfKeyboard {
              shouldMoveViewUp = true
            }
          }

          if(shouldMoveViewUp) {
            self.view.frame.origin.y = 0 - keyboardSize.height
          }
        }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }

    @objc func didTapView() {
        self.view.endEditing(true)
    }

}

extension ViewController : UITextFieldDelegate {
  // when user select a textfield, this method will be called
  func textFieldDidBeginEditing(_ textField: UITextField) {
    // set the activeTextField to the selected textfield
    self.activeTextField = textField
  }
    
  // when user click 'done' or dismiss the keyboard
  func textFieldDidEndEditing(_ textField: UITextField) {
    self.activeTextField = nil
  }
}
