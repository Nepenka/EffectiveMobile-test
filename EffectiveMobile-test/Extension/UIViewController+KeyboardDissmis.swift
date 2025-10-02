//
//  UIViewController+KeyboardDissmis.swift
//  EffectiveMobile-test
//
//  Created by Владислав Перелыгин on 02/10/2025.
//

import UIKit


extension UIViewController {
    
    func setupKeyboardDismissRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self,action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
