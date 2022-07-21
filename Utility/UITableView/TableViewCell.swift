import UIKit

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
    
    func configure(_ data: Int) {
        label.text = String(data)
    }
}

extension TableViewCell {
    func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .red
        
        label = UILabel()
        label.font = UIFont.getDefaultFont(.regular, size: 18)
        label.textColor = .black
        label.textAlignment = .center
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
