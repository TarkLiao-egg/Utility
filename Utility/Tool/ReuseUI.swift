import Foundation
import UIKit
import SnapKit

class ReuseUI {
    static func getNavBarView(title: String, titleColor: UIColor = .white, backBtnString: String = "back", backBtn: inout UIButton?, settingBtnString: String = "menu", settingBtn: inout UIButton?) -> UIView {
        let navBarView = UIView()
        navBarView.forSelf {
            $0.backgroundColor = UIColor.hex(0x23476A)
        }
        
        let titleLabel = UILabel()
        titleLabel.forSelf {
            $0.text = title
            $0.font = UIFont.getDefaultFont(.regular, size: 18)
            $0.textColor = titleColor
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: 4)
            $0.layer.shadowRadius = 4
            $0.layer.shadowOpacity = 0.2
        }
        navBarView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        if backBtn != nil {
            backBtn?.forSelf {
                $0.setImage(UIImage(named: backBtnString)?.withRenderingMode(.alwaysTemplate), for: .normal)
                $0.tintColor = titleColor
                $0.layer.shadowColor = UIColor.black.cgColor
                $0.layer.shadowOffset = CGSize(width: 0, height: 4)
                $0.layer.shadowRadius = 4
                $0.layer.shadowOpacity = 0.2
            }
            navBarView.addSubview(backBtn!)
            backBtn?.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().inset(16)
                make.width.height.equalTo(40)
            }
        }
        
        if settingBtn != nil {
            settingBtn?.setImage(UIImage(named: settingBtnString), for: .normal)
            navBarView.addSubview(settingBtn!)
            settingBtn?.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(12)
                make.width.height.equalTo(40)
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
    
    static func getLineView() -> UIView {
        return UIView().S { view in
            UIView().VS({
                $0.backgroundColor = UIColor.hex(0x666666)
            }, view) { make in
                make.top.bottom.equalToSuperview()
                make.height.equalTo(1)
                make.leading.trailing.equalToSuperview().inset(17)
            }
        }
    }
    
    static func getStringView(_ str: String) -> UIView {
        return UIView().S { view in
            UILabel().VS({
                $0.setProperty(.white, .medium, 16, str, .center, 0)
            }, view) { make in
                make.top.bottom.equalToSuperview()
                make.center.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.8)
            }
        }
    }
}
