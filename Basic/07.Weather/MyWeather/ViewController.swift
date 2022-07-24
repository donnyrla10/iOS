//
//  ViewController.swift
//  MyWeather
//
//  Created by 김영선 on 2022/01/28.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var weatherStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tabSearchButton(_ sender: UIButton) {
        if let cityName = self.cityNameTextField.text{
            self.getCurrentWeather(cityName: cityName)
            self.view.endEditing(true)
        }
    }
    
    func configureView(weatherInformation: WeatherInformation){
        self.cityNameLabel.text = weatherInformation.name
        if let weather = weatherInformation.weather.first { //weather.first = id
            self.weatherLabel.text = weather.description    //weatherLabel에 날씨 정보 할당
        }
        self.tempLabel.text = "\(Int(weatherInformation.temp.temp - 273.15))℃"
        self.minTempLabel.text = "\(Int(weatherInformation.temp.minTemp - 273.15))℃"
        self.maxTempLabel.text = "\(Int(weatherInformation.temp.maxTemp - 273.15))℃"
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCurrentWeather(cityName: String){
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=097fc42dcab2e4228227ac8913fb661c") else {return}
        let session = URLSession(configuration: .default)
        session.dataTask(with: url){ [weak self] data, response, error in
            let successRange = (200..<300)
            guard let data = data, error == nil else {return}
            let decoder = JSONDecoder()
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode){
                guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else {return}
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false //등장
                    self?.configureView(weatherInformation: weatherInformation)
                }
            }else{
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else {return}
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }
        }.resume()
        
        
    }
}

