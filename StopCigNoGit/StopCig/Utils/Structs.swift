//
//  Structs.swift
//  StopCig
//
//  Created by Hook on 04/08/2024.
//

import SwiftUI
import UIKit

struct DismissKeyboardView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let tapGesture = UITapGestureRecognizer(target: viewController, action: #selector(viewController.dismissKeyboard))
        viewController.view.addGestureRecognizer(tapGesture)
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: ()) {
        uiViewController.view.gestureRecognizers?.forEach(uiViewController.view.removeGestureRecognizer)
    }
}

private extension UIViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
