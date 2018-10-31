//
//  DetailViewController+Gesture.swift
//  LOTs
//
//  Created by 乃方 on 2018/10/30.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

extension DetailViewController: UIGestureRecognizerDelegate {
    
    func didSuccessfullyDragDownToDismiss() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func userWillCancelDissmissalByDraggingToTop(velocityY: CGFloat) {}
    
    func didCancelDismissalTransition() {
        
        // Clean up
        interactiveStartingPoint = nil
        dismissalAnimator = nil
        draggingDownToDismiss = false
        
    }
    
    // This handles both screen edge and dragdown pan. As screen edge pan is a subclass of pan gesture, this input param works.
    @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        
        let isScreenEdgePan = gesture.isKind(of: DismissalScreenEdgePanGesture.self)
        let canStartDragDownToDismissPan = !isScreenEdgePan && draggingDownToDismiss
        
        // Don't do anything when it's not in the drag down mode
        if canStartDragDownToDismissPan { return }
        
        let targetAnimatedView = gesture.view!
        let startingPoint: CGPoint
        
        if let p = interactiveStartingPoint {
            
            startingPoint = p
            
        } else {
            
            // Initial location
            startingPoint = gesture.location(in: nil)
            interactiveStartingPoint = startingPoint
            
        }
        
        let currentLocation = gesture.location(in: nil)
        let progress = isScreenEdgePan ? (gesture.translation(in: targetAnimatedView).x / 100) : (currentLocation.y - startingPoint.y) / 100
        let targetShrinkScale: CGFloat = 0.86
        let targetCornerRadius: CGFloat = GlobalConstants.cardCornerRadius
        
        func createInteractiveDismissalAnimatorIfNeeded() -> UIViewPropertyAnimator {
            
            if let animator = dismissalAnimator {
                
                return animator
                
            } else {
                
                let animator = UIViewPropertyAnimator(duration: 0, curve: .linear, animations: {
                    targetAnimatedView.transform = .init(scaleX: targetShrinkScale, y: targetShrinkScale)
                    targetAnimatedView.layer.cornerRadius = targetCornerRadius
                })
                
                animator.isReversed = false
                animator.pauseAnimation()
                animator.fractionComplete = progress
                return animator
                
            }
            
        }
        
        switch gesture.state {
            
        case .began:
            dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded()
            
        case .changed:
            dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded()
            
            let actualProgress = progress
            let isDismissalSuccess = actualProgress >= 1.0
            
            dismissalAnimator!.fractionComplete = actualProgress
            
            if isDismissalSuccess {
                
                dismissalAnimator!.stopAnimation(false)
                dismissalAnimator!.addCompletion { (pos) in
                    switch pos {
                    case .end:
                        self.didSuccessfullyDragDownToDismiss()
                    default:
                        fatalError("Must finish dismissal at end!")
                    }
                }
                
                dismissalAnimator!.finishAnimation(at: .end)
                
            }
            
        case .ended, .cancelled:
            
            if dismissalAnimator == nil {
                
                // Gesture's too quick that it doesn't have dismissalAnimator!
                print("Too quick there's no animator!")
                didCancelDismissalTransition()
                return
                
            }
            
            // Ended, Animate back to start
            dismissalAnimator!.pauseAnimation()
            dismissalAnimator!.isReversed = true
            
            // Disable gesture until reverse closing animation finishes.
            gesture.isEnabled = false
            
            dismissalAnimator!.addCompletion { [unowned self] (pos) in
                self.didCancelDismissalTransition()
                gesture.isEnabled = true
            }
            
            dismissalAnimator!.startAnimation()
            
        default:
            fatalError("Impossible gesture state? \(gesture.state.rawValue)")
            
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
}
