//
//  Model.swift
//  uGrade
//
//  Created by Ben Fein on 11/13/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import Foundation
import SwiftUI

extension Notification.Name {
    static let my_onViewWillTransition = Notification.Name("MainUIHostingController_viewWillTransition")
}

class MyUIHostingController<Content> : UIHostingController<Content> where Content : View {

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        NotificationCenter.default.post(name: .my_onViewWillTransition, object: nil, userInfo: ["size": size])
        super.viewWillTransition(to: size, with: coordinator)
    }

}
class Model: ObservableObject {
    @Published var portrait: Bool = UIDevice.current.orientation == .portrait

    init(isPortrait: Bool) {
        self.portrait = isPortrait // Initial value
        NotificationCenter.default.addObserver(self, selector: #selector(onViewWillTransition(notification:)), name: .my_onViewWillTransition, object: nil)
    }

    @objc func onViewWillTransition(notification: Notification) {
        guard let size = notification.userInfo?["size"] as? CGSize else { return }

        portrait = size.width < size.height
    }
}
