//
//  UINavigationController+PushPop.swift
//  ChatAjaTest
//
//  Created by Muhammad Nizar on 08/11/19.
//  Copyright © 2019 Muhammad Nizar. All rights reserved.
//

import UIKit

extension UINavigationController {
    /**
     Pop current view controller to previous view controller.
     
     - parameter type:     transition animation type.
     - parameter duration: transition animation duration.
     */
    func pop(transitionType type: CATransitionType = .fade, duration: CFTimeInterval = 0.3) {
        self.addTransition(transitionType: type, duration: duration)
        self.popViewController(animated: false)
    }
    
    /**
     Push a new view controller on the view controllers's stack.
     
     - parameter vc:       view controller to push.
     - parameter type:     transition animation type.
     - parameter duration: transition animation duration.
     */
    func push(viewController vc: UIViewController, transitionType type: CATransitionType = .fade, duration: CFTimeInterval = 0.3) {
        self.addTransition(transitionType: type, duration: duration)
        self.pushViewController(vc, animated: false)
    }
    
    private func addTransition(transitionType type: CATransitionType = .fade, duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = type
        self.view.layer.add(transition, forKey: nil)
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        self.pushViewController(viewController, animated: animated)
        self.callCompletion(animated: animated, completion: completion)
    }
    
    func popViewController(animated: Bool, completion: @escaping () -> Void) -> [UIViewController]? {
        let viewController = self.popToRootViewController(animated: animated)
        self.callCompletion(animated: animated, completion: completion)
        return viewController
    }
    
    private func callCompletion(animated: Bool, completion: @escaping () -> Void) {
        if animated, let coordinator = self.transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}
