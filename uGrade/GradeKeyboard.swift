//
//  GradeKeyboard.swift
//  uGrade
//
//  Created by Ben Fein on 6/6/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI

 struct TestTextfield: UIViewRepresentable {
    @Binding var grade: String
    var keyType: UIKeyboardType
    func makeUIView(context: Context) -> UITextField {
        let textfield = UITextField()
      textfield.keyboardType = keyType
        textfield.placeholder = "Grade"
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textfield.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textfield.doneButtonTapped(button:)))
        toolBar.items = [doneButton]
        toolBar.setItems([doneButton], animated: true)
        textfield.inputAccessoryView = toolBar
        return textfield
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = grade

    }
}

extension  UITextField{
    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
       self.resignFirstResponder()
    }

}


