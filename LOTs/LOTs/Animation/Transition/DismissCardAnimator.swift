//
//  DismissCardAnimator.swift
//  LOTs
//
//  Created by 乃方 on 2018/10/24.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

final class DismissCardAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    struct Params {
        
        let fromCardFrame: CGRect
        let fromCardFrameWithoutTransform: CGRect
        let fromCell: MainCell
    
    }
    
    struct Constants {
        
        static let relativeDurationBeforeNonInteractive: TimeInterval = 0.5
        static let minimumScaleBeforeNonInteractive: CGFloat = 0.8
    
    }
    
    private let params: Params
    
    init(params: Params) {
        
        self.params = params
        super.init()
    
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return GlobalConstants.dismissalAnimationDuration
    
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let ctx = transitionContext
        let container = ctx.containerView
        let screens: (cardDetail: DetailViewController, home: UITabBarController) = (
            ctx.viewController(forKey: .from)! as! DetailViewController,
            ctx.viewController(forKey: .to)! as! UITabBarController
        )
        
        let cardDetailView = ctx.view(forKey: .from)!
        
        let animatedContainerView = UIView()
        
        if GlobalConstants.isEnabledDebugAnimatingViews {
            animatedContainerView.layer.borderColor = UIColor.yellow.cgColor
            animatedContainerView.layer.borderWidth = 4
            cardDetailView.layer.borderColor = UIColor.red.cgColor
            cardDetailView.layer.borderWidth = 2
        }
        
        animatedContainerView.translatesAutoresizingMaskIntoConstraints = false
        cardDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        container.removeConstraints(container.constraints)
        
        container.addSubview(animatedContainerView)
        animatedContainerView.addSubview(cardDetailView)
        
        // Card fills inside animated container view
        cardDetailView.edges(to: animatedContainerView)
        
        container.frame = params.fromCardFrame
        
//        let animatedContainerTopConstraint = animatedContainerView.topAnchor.constraint(equalTo: animatedContainerView.centerYAnchor, constant: 0)
//        let animatedContainerLeadingConstraint = animatedContainerView.leadingAnchor.constraint(equalTo: animatedContainerView.centerXAnchor, constant: 0)
//        let animatedContainerWidthConstraint = animatedContainerView.widthAnchor.constraint(equalToConstant: cardDetailView.frame.width)
//        let animatedContainerHeightConstraint = animatedContainerView.heightAnchor.constraint(equalToConstant: cardDetailView.frame.height)
        
//        animatedContainerView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
//        animatedContainerView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
//        let animatedContainerTopConstraint = animatedContainerView.topAnchor.constraint(equalTo: container.topAnchor, constant: 0)
//        let animatedContainerLeadingConstraint = animatedContainerView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0)
        
        let animatedContainerCenterXConstraint = animatedContainerView.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: 0)
        let animatedContainerCenterYConstraint = animatedContainerView.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 0)
        let animatedContainerWidthConstraint = animatedContainerView.widthAnchor.constraint(equalToConstant: cardDetailView.frame.width)
        let animatedContainerHeightConstraint = animatedContainerView.heightAnchor.constraint(equalToConstant: cardDetailView.frame.height)
//
//        NSLayoutConstraint.activate([animatedContainerTopConstraint,
//                                     animatedContainerLeadingConstraint,
//                                     animatedContainerWidthConstraint,
//                                     animatedContainerHeightConstraint])

        NSLayoutConstraint.activate([animatedContainerCenterXConstraint,
                                     animatedContainerCenterYConstraint,
                                     animatedContainerWidthConstraint,
                                     animatedContainerHeightConstraint])
        
        // Fix weird top inset
        let topTemporaryFix = screens.cardDetail.tableView.topAnchor.constraint(equalTo: cardDetailView.topAnchor, constant: 0)
        topTemporaryFix.isActive = GlobalConstants.isEnabledWeirdTopInsetsFix
        
        container.layoutIfNeeded()
        
        // Force card filling bottom
        let stretchCardToFillBottom = screens.cardDetail.tableView.bottomAnchor.constraint(equalTo: cardDetailView.bottomAnchor)
        
        func animateCardViewBackToPlace() {
            
            stretchCardToFillBottom.isActive = true
//            screens.cardDetail.isFontStateHighlighted = false
            // Back to identity
            // NOTE: Animated container view in a way, helps us to not messing up `transform` with `AutoLayout` animation.
            cardDetailView.transform = CGAffineTransform.identity
//            animatedContainerTopConstraint.constant = self.params.fromCardFrameWithoutTransform.minY
//            animatedContainerLeadingConstraint.constant = self.params.fromCardFrameWithoutTransform.minX
//            animatedContainerCenterXConstraint.constant = self.params.fromCardFrameWithoutTransform.midX
//            animatedContainerCenterYConstraint.constant = self.params.fromCardFrameWithoutTransform.midY
            animatedContainerWidthConstraint.constant = self.params.fromCardFrameWithoutTransform.width
            animatedContainerHeightConstraint.constant = self.params.fromCardFrameWithoutTransform.height
            container.layoutIfNeeded()
            
        }
        
        func completeEverything() {
            
            let success = !ctx.transitionWasCancelled
            animatedContainerView.removeConstraints(animatedContainerView.constraints)
            animatedContainerView.removeFromSuperview()
            
            if success {
                
                cardDetailView.removeFromSuperview()
                self.params.fromCell.isHidden = false
                
            } else {
//                screens.cardDetail.isFontStateHighlighted = true
                
                // Remove temporary fixes if not success!
                topTemporaryFix.isActive = false
                stretchCardToFillBottom.isActive = false
                
                cardDetailView.removeConstraint(topTemporaryFix)
                cardDetailView.removeConstraint(stretchCardToFillBottom)
                
                container.removeConstraints(container.constraints)
                
                container.addSubview(cardDetailView)
                cardDetailView.edges(to: container)
            }
            
            ctx.completeTransition(success)
        
        }
        
        UIView.animate(withDuration: transitionDuration(using: ctx), delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            animateCardViewBackToPlace()
        }) { (finished) in
            completeEverything()
        }
        
        UIView.animate(withDuration: transitionDuration(using: ctx) * 0.6) {
//            screens.cardDetail.scrollView.contentOffset = .zero
            screens.cardDetail.tableView.contentOffset = .zero
        }
    }
}