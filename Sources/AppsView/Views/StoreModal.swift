//
//  StoreModal.swift
//  AppsView
//
//  Created by Daniel Amitay on 10/4/23.
//

import StoreKit
import SwiftUI
import UIKit

internal struct StoreModal {
    static func present(itunesId: Int) {
        let parameters = [SKStoreProductParameterITunesItemIdentifier: String(itunesId)]
        let viewController = SKStoreProductViewController()
        viewController.loadProduct(withParameters: parameters) { loaded, _ in
            guard loaded else { return }
            let topMostViewController = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }.first?
                .windows.filter { $0.isKeyWindow }.first?
                .rootViewController?.topMostViewController
            guard let topMostViewController else { return }
            topMostViewController.present(viewController, animated: true)
        }
    }
}

fileprivate extension UIViewController {
    var topMostViewController: UIViewController {
        if let presentedViewController {
            return presentedViewController.topMostViewController
        }
        return self
    }
}

