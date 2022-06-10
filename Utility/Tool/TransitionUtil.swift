import Foundation
import UIKit

///通用转场工具类
class TransitionUtil: NSObject {
    ///转场类型
    var transitionType: TransitionType?
    //交互转场
    var interactive = false
    let interactionTransition = UIPercentDrivenInteractiveTransition()
    
    override init() {
        super.init()
        
    }
    
    func transitionAnimation(transitionContext: UIViewControllerContextTransitioning) {
        //获得容器视图（转场动画发生的地方）
        let containerView = transitionContext.containerView
        //动画执行时间
        let duration = self.transitionDuration(using: transitionContext)
        
        //fromVC (即将消失的视图)
        let fromVC = transitionContext.viewController(forKey: .from)!
        let fromView = fromVC.view!
        //toVC (即将出现的视图)
        let toVC = transitionContext.viewController(forKey: .to)!
        let toView = toVC.view!
        
        var offset = containerView.frame.width
        var fromTransform = CGAffineTransform.identity
        var toTransform = CGAffineTransform.identity
        
        switch transitionType {
        case .modal(let operation):
            offset = containerView.frame.height
            let fromY = operation == .presentation ? 0 : offset
            fromTransform = CGAffineTransform(translationX: 0, y: fromY)
            let toY = operation == .presentation ? offset : 0
            toTransform = CGAffineTransform(translationX: 0, y: toY)
            if operation == .presentation {
                containerView.addSubview(toView)
            }
            
        case .navigation(let operation):
            offset = operation == .push ? offset : -offset
            fromTransform = CGAffineTransform(translationX: -offset, y: 0)
            toTransform = CGAffineTransform(translationX: offset, y: 0)
            containerView.insertSubview(toView, at: 0)
            //containerView.addSubview(toView)
            
        case .tabBar(let direction):
            offset = direction == .left ? offset : -offset
            fromTransform = CGAffineTransform(translationX: offset, y: 0)
            toTransform = CGAffineTransform(translationX: -offset, y: 0)
            containerView.addSubview(toView)
            
        case nil:
            break
        }
        
        toView.transform = toTransform
        UIView.animate(withDuration: duration, animations: {
            fromView.transform = fromTransform
            toView.transform = .identity
        }) { (finished) in
            fromView.transform = .identity
            toView.transform = .identity
            //考虑到转场中途可能取消的情况，转场结束后，恢复视图状态。(通知是否完成转场)
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        }
    }
}
///转场类型
enum TransitionType {
    //导航栏
    case navigation(_ operation: UINavigationController.Operation)
    //tabBar切换
    case tabBar(_ direction: TabBarOperationDirection)
    //模态跳转
    case modal(_ operation: ModalOperation)
}

enum TabBarOperationDirection {
    case left
    case right
}

enum ModalOperation {
    case presentation
    case dismissal
}

///自定义模态转场动画时使用
extension TransitionUtil: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transitionType = .modal(.presentation)
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transitionType = .modal(.dismissal)
        return self
    }
    
    //interactive false:非交互转场， true: 交互转场
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? self.interactionTransition : nil
    }
    
    //interactive false:非交互转场， true: 交互转场
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? self.interactionTransition : nil
    }
}

/// 自定义navigation转场动画时使用
extension TransitionUtil: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transitionType = .navigation(operation)
        return self
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? self.interactionTransition : nil
    }
}

/// 自定义tab转场动画时使用
extension TransitionUtil: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let fromIndex = tabBarController.viewControllers?.firstIndex(of: fromVC) ?? 0
        let toIndex = tabBarController.viewControllers?.firstIndex(of: toVC) ?? 0
        let direction: TabBarOperationDirection = fromIndex < toIndex ? .right : .left
        self.transitionType = .tabBar(direction)
        return self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? self.interactionTransition : nil
    }
}

extension TransitionUtil: UIViewControllerAnimatedTransitioning {
    //控制转场动画执行时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    //执行动画的地方，最核心的方法。
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionAnimation(transitionContext: transitionContext)
    }
}
