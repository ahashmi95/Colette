//
//  PaddingTextField.swift
//  ColetteAppiOS
//
//  Created by Abdulrahman A. Hashmi on 31/03/2021.
//

import Foundation
import UIKit

class InsetTextField: UITextField {

  let inset: CGFloat = 10

  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: inset, dy: inset)
  }


  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: inset, dy: inset)
  }

  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: inset, dy: inset)
  }

}
