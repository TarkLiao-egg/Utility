import UIKit

class PageViewController: UIPageViewController {
    
    var pages: [UIViewController] = []
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        let options = [UIPageViewController.OptionsKey.spineLocation : NSNumber(value: UIPageViewController.SpineLocation.min.rawValue)]
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: options)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        self.isDoubleSided = true
        for i in 0...5 {
            let vc = UIViewController()
            switch i {
            case 0:
                vc.view.backgroundColor = .black
            case 1:
                vc.view.backgroundColor = .white
            case 2:
                vc.view.backgroundColor = .brown
            case 3:
                vc.view.backgroundColor = .blue
            case 4:
                vc.view.backgroundColor = .green
            default:
                vc.view.backgroundColor = .yellow
            }
            pages.append(vc)
        }
        setViewControllers([pages[0]], direction: .forward, animated: true)
    }
    

}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else { return pages.last }

        guard pages.count > previousIndex else { return nil }

        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }

        let nextIndex = viewControllerIndex + 1

        guard nextIndex < pages.count else { return pages.first }

        guard pages.count > nextIndex else { return nil }

        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("finish")
        return
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {

        guard let firstVC = pageViewController.viewControllers?.first else {
            return 0
        }
        guard let firstVCIndex = pages.firstIndex(of: firstVC) else {
            return 0
        }

        return firstVCIndex
    }
}
