//
//  AlertActionConvertible.swift
//  D-Day
//
//  Created by hana on 2023/01/29.
//

import UIKit

protocol AlertActionConvertible{
    var title: String { get }
    var style: UIAlertAction.Style { get }
}
