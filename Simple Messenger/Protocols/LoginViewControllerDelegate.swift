//
//  LoginViewControllerDelegate.swift
//  Simple Messenger
//
//  Created by Дмитрий Никольский on 29.11.2022.
//

import UIKit

protocol LoginViewControllerDelegate {
    func openRegVC()
    func openAuthVC()
    func closeVC()
    func startApp()
}


