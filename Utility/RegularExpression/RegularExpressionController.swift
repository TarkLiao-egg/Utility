import UIKit

class RegularExpressionController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let test = "http://220.135.99.195:8080/APP/QRCode/CheckinQR_Reply?pid=r1nCyA77rI5O%2FEE%2BkCClKO4S%2Fl7uBSdH6MGceRhdsUpzhNmoPoi7EQrPwh7uKXy9"
        
        print(check(str: test))
    }
    
    private func check(str: String) -> String? {
        let pattern = "[A-Za-z0-9:/_?%.]*pid="
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive) else { return nil }
        let res = regex.matches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.count))
        guard let range = res.first?.range else { return nil }
        let matchStr = String((str as NSString).substring(with: range))
        return str.replacingOccurrences(of: matchStr, with: "")
    }
    
}
