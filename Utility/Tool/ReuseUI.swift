import Foundation
import UIKit
import SnapKit

class ReuseUI {
    static func getNavBarView(title: String, backBtn: inout UIButton?, settingBtn: inout UIButton?) -> UIView {
        let navBarView = UIView()
        navBarView.forSelf {
            $0.backgroundColor = UIColor.hex(0x2E2C2C, opacity: 0.8)
        }
        
        let titleLabel = UILabel()
        titleLabel.forSelf {
            $0.text = title
            $0.font = UIFont.getDefaultFont(.medium, size: 18)
            $0.textColor = .white
        }
        navBarView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        if backBtn != nil {
            backBtn?.setImage(UIImage(named: "back"), for: .normal)
            navBarView.addSubview(backBtn!)
            backBtn?.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().inset(16)
                make.width.height.equalTo(30)
            }
        }
        
        if settingBtn != nil {
            settingBtn?.setImage(UIImage(named: "menu"), for: .normal)
            navBarView.addSubview(settingBtn!)
            settingBtn?.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(12)
                make.width.height.equalTo(30)
            }
        }
        return navBarView
    }
    
    static func getPadding(height: CGFloat) -> UIView {
        let paddingView = UIView()
        paddingView.backgroundColor = .clear
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        paddingView.heightAnchor.constraint(equalToConstant: height).isActive = true
        return paddingView
    }
    
    static func getClearView() -> UIView {
        let clearView = UIView()
        clearView.backgroundColor = .clear
        return clearView
    }
    
    static func getLineView() -> UIView {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.hex(0x666666)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return lineView
    }
}
