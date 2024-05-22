//
//  BMICalculatorViewController.swift
//  BMICalculator
//
//  Created by 장예지 on 5/21/24.
//

import UIKit

class BMICalculatorViewController: UIViewController {
    
    enum AlertType {
        case isEmpty
        case invalidValue
        case invalidHeightRange
        case invalidWeightRange
        case calculatedValue(bmiValue: Double)
        
        var title: String {
            switch self {
            case .isEmpty, .invalidValue, .invalidHeightRange, .invalidWeightRange:
                return "오류"
            case .calculatedValue:
                return "확인"
            }
        }
        
        var message: String {
            switch self {
            case .isEmpty:
                return "빈칸이 입력되었습니다."
            case .invalidValue:
                return "다시 입력해주세요."
            case .invalidHeightRange:
                return "100~250cm 범위로 입력해주세요."
            case .invalidWeightRange:
                return "30~200kg 범위로 입력해주세요."
            case .calculatedValue(bmiValue: let value):
                var type = ""
                switch value {
                case 30...:
                    type = "고도비만"
                case 25..<30:
                    type = "경도비만"
                case 23..<25:
                    type = "과체중"
                case 18.5..<23:
                    type = "정상"
                case ..<18.5:
                    type = "저체중"
                default:
                    type = ""
                }
                
                return "\(String(format: "%.2f", value))로 \(type)입니다."
            }
        }
    }
    
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var heightView: UIView!
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var weightView: UIView!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var hideWeightValueButton: UIButton!
    @IBOutlet var resultButton: UIButton!
    
    var isHideWeight: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        subTitleLabel.text = "당신의 BMI 지수를\n알려드릴게요."
        
        setTextFieldUI(textField: heightTextField, backgroundView: heightView, placehorder: "cm 단위로 입력해 주세요.")
        setTextFieldUI(textField: weightTextField, backgroundView: weightView, placehorder: "kg 단위로 입력해 주세요.")
        hideWeightValueButtonTapped(hideWeightValueButton)
        
        resultButton.layer.cornerRadius = 15
        resultButton.titleLabel?.font = .systemFont(ofSize: 18)
    }
    
    @IBAction func randomButtonTapped(_ sender: UIButton) {
        let randomHeight = Double.random(in: 100...250)
        let randomWeight = Double.random(in: 30...200)
        
        heightTextField.text = String(format: "%.2f", randomHeight)
        weightTextField.text = String(format: "%.2f", randomWeight)
        presentCalculateBMIValue(height: randomHeight, weight: randomWeight)
    }
    
    @IBAction func presentValue(_ sender: Any) {
        guard let heightStr = heightTextField.text, let weightStr = weightTextField.text else {
            setAlert(type: .invalidValue)
            return
        }
        
        if heightStr.isEmpty || weightStr.isEmpty {
            setAlert(type: .isEmpty)
            return
        }
        
        if let height = Double(heightStr), let weight = Double(weightStr) {
            if height < 100 || height > 250 {
                setAlert(type: .invalidHeightRange)
            } else if weight < 30 || weight > 200 {
                setAlert(type: .invalidWeightRange)
            } else {
                presentCalculateBMIValue(height: height, weight: weight)
            }
            
        } else {
            setAlert(type: .invalidValue)
        }
        
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func hideWeightValueButtonTapped(_ sender: UIButton) {
        weightTextField.isSecureTextEntry = isHideWeight ? true : false
        
        guard let hideImage = UIImage(systemName: "eye"), let showImage = UIImage(systemName: "eye.slash") else {
            return
        }
        hideWeightValueButton.setImage(isHideWeight ? hideImage : showImage, for: .normal)
        isHideWeight.toggle()
    }
    
    private func presentCalculateBMIValue(height: Double, weight: Double){
        let bmi = weight / ((height * height) * 0.0001)
        setAlert(type:.calculatedValue(bmiValue: bmi))
    }
    
    private func setTextFieldUI(textField: UITextField, backgroundView uiView: UIView, placehorder: String = ""){
        uiView.layer.cornerRadius = 15
        uiView.layer.borderWidth = 2
        uiView.layer.borderColor = UIColor.darkGray.cgColor
        textField.borderStyle = .none
        textField.placeholder = placehorder
    }
    
    private func setAlert(type: AlertType){
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}
