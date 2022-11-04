import UIKit

enum DatePickerViewStyle {
    case hourMinSec
    case hourMin
    case minSec
}

struct DateObject {
    var hourMinSec: Int
    var hour: Int
    var min: Int
    var sec: Int
}

class DatePickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    let style: DatePickerViewStyle
    let selectAction: ((DateObject) -> Void)
    
    init(syle: DatePickerViewStyle, _ selectAction: @escaping ((DateObject) -> Void)) {
        self.style = syle
        self.selectAction = selectAction
        super.init(frame: .zero)
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch style {
        case .hourMinSec:
            return 3
        case .hourMin, .minSec:
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch style {
        case .hourMinSec, .hourMin:
            return component == 0 ? 24 : 60
        case .minSec:
            return 60
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch style {
        case .hourMinSec:
            let secs = self.selectedRow(inComponent: 0) * 60 * 60 + self.selectedRow(inComponent: 1) * 60 + self.selectedRow(inComponent: 2)
            selectAction(DateObject(hourMinSec: secs, hour: self.selectedRow(inComponent: 0), min: self.selectedRow(inComponent: 1), sec: self.selectedRow(inComponent: 2)))
        case .hourMin:
            let secs = self.selectedRow(inComponent: 0) * 60 * 60 + self.selectedRow(inComponent: 1) * 60
            selectAction(DateObject(hourMinSec: secs, hour: self.selectedRow(inComponent: 0), min: self.selectedRow(inComponent: 1), sec: 0))
        case .minSec:
            let secs = self.selectedRow(inComponent: 0) * 60 + self.selectedRow(inComponent: 1)
            selectAction(DateObject(hourMinSec: secs, hour: 0, min: self.selectedRow(inComponent: 0), sec: self.selectedRow(inComponent: 21)))
        }
    }
}
