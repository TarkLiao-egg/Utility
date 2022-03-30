import UIKit

class FunctionViewController: UIViewController {
    
    @IBOutlet weak var useStoryBoardView: FunctionCodeView!
    var useCodeView: FunctionCodeView!
    var story1NSLayoutconstraints: [NSLayoutConstraint]!
    var story2NSLayoutconstraints: [NSLayoutConstraint]!
    var code1NSLayoutconstraints: [NSLayoutConstraint]!
    var code2NSLayoutconstraints: [NSLayoutConstraint]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUseCodeView()
        setupUseStoryView()
    }
    
    @IBAction func location1ButtonPressed() {
        useStoryBoardView.translatesAutoresizingMaskIntoConstraints = false
        useCodeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.deactivate(story2NSLayoutconstraints)
        NSLayoutConstraint.activate(story1NSLayoutconstraints)
        NSLayoutConstraint.deactivate(code2NSLayoutconstraints)
        NSLayoutConstraint.activate(code1NSLayoutconstraints)
        view.layoutIfNeeded()
        useStoryBoardView.reDraw()
        useCodeView.reDraw()
    }
    
    @IBAction func location2ButtonPressed() {
        useStoryBoardView.translatesAutoresizingMaskIntoConstraints = false
        useCodeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.deactivate(story1NSLayoutconstraints)
        NSLayoutConstraint.activate(story2NSLayoutconstraints)
        NSLayoutConstraint.deactivate(code1NSLayoutconstraints)
        NSLayoutConstraint.activate(code2NSLayoutconstraints)
        view.layoutIfNeeded()
        useStoryBoardView.reDraw()
        useCodeView.reDraw()
    }
    
    func setupUseCodeView() {
        useCodeView = FunctionCodeView()
        view.addSubview(useCodeView)
        useCodeView.gradientStartColor = .yellow
        useCodeView.gradientEndColor = .red
        useCodeView.gradientStartPoint = CGPoint(x: 0, y: 0.5)
        useCodeView.gradientEndPoint = CGPoint(x: 1, y: 0.5)
        useCodeView.corners  = [.topLeft, .bottomRight]
        useCodeView.isCircle = true
        useCodeView.borderWidth = 3
        useCodeView.borderStartColor = .white
        useCodeView.borderEndColor = .black
        useCodeView.shadowWidth = 5
        useCodeView.shadowColor = .yellow
        code1NSLayoutconstraints = [
            useCodeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            useCodeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            useCodeView.widthAnchor.constraint(equalToConstant: 100),
            useCodeView.heightAnchor.constraint(equalToConstant: 100)
        ]
        code2NSLayoutconstraints = [
            useCodeView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            useCodeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -10),
            useCodeView.widthAnchor.constraint(equalToConstant: 150),
            useCodeView.heightAnchor.constraint(equalToConstant: 150)
        ]
    }
    
    func setupUseStoryView() {
        useStoryBoardView.gradientStartColor = .green
        useStoryBoardView.gradientEndColor = .blue
        useStoryBoardView.gradientStartPoint = CGPoint(x: 0.5, y: 0)
        useStoryBoardView.gradientEndPoint = CGPoint(x: 0.5, y: 1)
        useStoryBoardView.corners  = [.topLeft, .bottomRight]
        useStoryBoardView.shadowWidth = 5
        useStoryBoardView.shadowColor = .black
        useStoryBoardView.cornerRadius = 20
        useStoryBoardView.isCircle = false
        useStoryBoardView.borderWidth = 7
        useStoryBoardView.borderColor = .red
        useStoryBoardView.borderStartColor = .red
        useStoryBoardView.borderEndColor = .green
        
        story1NSLayoutconstraints = [
            useStoryBoardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            useStoryBoardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            useStoryBoardView.widthAnchor.constraint(equalToConstant: 200),
            useStoryBoardView.heightAnchor.constraint(equalToConstant: 300)
        ]
        story2NSLayoutconstraints = [
            useStoryBoardView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            useStoryBoardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            useStoryBoardView.widthAnchor.constraint(equalToConstant: 300),
            useStoryBoardView.heightAnchor.constraint(equalToConstant: 100)
        ]
    }
}
