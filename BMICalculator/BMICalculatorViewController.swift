//
//  BMICalculatorViewController.swift
//  BMICalculator
//
//  Created by 장예지 on 5/21/24.
//

import UIKit

class BMICalculatorViewController: UIViewController {
    
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var heightView: UIView!
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var weightView: UIView!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var hideWeightValueButton: UIButton!
    @IBOutlet var resultButton: UIButton!
    @IBOutlet var heightStatusLabel: UILabel!
    @IBOutlet var weightStatusLabel: UILabel!
    
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
        let randomWeight = Double.random(in: 10...200)
        
        heightTextField.text = String(format: "%.2f", randomHeight)
        weightTextField.text = String(format: "%.2f", randomWeight)
        presentCalculateBMIValue(height: randomHeight, weight: randomWeight)
    }
    
    @IBAction func presentValue(_ sender: Any) {
        guard let heightStr = heightTextField.text, let weightStr = weightTextField.text else {
            setAlert(title: "오류", message: "다시 입력해주세요.")
            return
        }
        
        if heightStr.isEmpty || weightStr.isEmpty {
            setAlert(title: "오류", message: "빈칸이 입력되었습니다.")
            return
        }
        
        if let height = Double(heightStr), let weight = Double(weightStr) {
            presentCalculateBMIValue(height: height, weight: weight)
        } else {
            setAlert(title: "오류", message: "다시 입력해주세요.")
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
        
        var value = ""
        
        let bmi = weight / ((height * height) * 0.0001)
        
        switch bmi {
        case 30...:
            value = "고도비만"
        case 25..<30:
            value = "경도비만"
        case 23..<25:
            value = "과체중"
        case 18.5..<23:
            value = "정상"
        case ..<18.5:
            value = "저체중"
        default:
            value = ""
        }
        
        setAlert(title: "결과", message: value)
    }
    
    private func setTextFieldUI(textField: UITextField, backgroundView uiView: UIView, placehorder: String = ""){
        uiView.layer.cornerRadius = 15
        uiView.layer.borderWidth = 2
        uiView.layer.borderColor = UIColor.darkGray.cgColor
        textField.borderStyle = .none
        textField.placeholder = placehorder
    }
    
    private func setAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}
