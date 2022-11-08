import UIKit
import SnapKit

class TableViewCell: UITableViewCell {
    var label: UILabel!
    
    var initValue: Int = 0
    
    init(initValue: Int) {
        self.initValue = initValue
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func configure(_ model: Any) {
        if let model = model as? Int {
            label.text = String(model)
        }
    }
}

extension TableViewCell {
}

extension TableViewCell {
    func setupUI() {
        backgroundColor = .white
        contentView.backgroundColor = .clear
        
        getView().VS({
            $0.backgroundColor = .clear
        }, contentView) { make in
            
        }
    }
    
    func getView() -> UIView {
        return UIView().S { view in
            label = UILabel().VS({
                $0.textColor = .black
                $0.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
            }, view, { make in
                make.edges.equalToSuperview()
            })
        }
    }
}
