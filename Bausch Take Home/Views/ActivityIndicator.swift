//
//  ActivityIndicator.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/19/22.
//

import Foundation
import UIKit

class ActivityIndicator: UIViewController {
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)

        override func viewDidLoad() {
            super.viewDidLoad()
            
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(activityIndicator)

            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.activityIndicator.startAnimating()
            }
        }
    
}
