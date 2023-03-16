//
//  WeatherViewController.swift
//  HW_15
//
//  Created by Michael on 3/2/23.
//

import UIKit
import Kingfisher

class WeatherViewController: UIViewController {
    
    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.textAlignment = .center
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    let infoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var favoriteBarButton = UIBarButtonItem(
        image: UIImage(systemName: "star.fill"),
        style: .plain,
        target: self,
        action: #selector(favoriteTapped)
    )
    
    let databaseManager = DatabaseManager()
    
    // переменная контейнер в которую мы планируем передавать значение
    var weather: WeatherResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBarButton()
    }
    
    @objc func favoriteTapped() {
        if databaseManager.isWeatherInFavorite(id: weather.id) {
            databaseManager.deleteWeather(id: weather.id)
        } else {
            databaseManager.saveWeather(name: weather.name, id: weather.id)
        }
        updateButtonState()
    }
    
    func setup() {
        view.addSubview(weatherImageView)
        view.addSubview(tempLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(infoStack)
        
        setConstraints()
        setWeather()
        
    }
    
    func setWeather() {
        tempLabel.text = String(format: "%.1f°C", weather.main.temp)
        descriptionLabel.text = weather.weather[0].main + ", " + weather.weather[0].description
        weatherImageView.kf.setImage(with: URL(string: weather.iconUrl))
        let infoData = weather.weatherInfoData
        
        for info in infoData {
            let weatherView = WeatherInfoView()
            weatherView.translatesAutoresizingMaskIntoConstraints = false
            weatherView.set(info: info)
            infoStack.addArrangedSubview(weatherView)
        }
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            weatherImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            weatherImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherImageView.heightAnchor.constraint(equalToConstant: 84),
            weatherImageView.widthAnchor.constraint(equalToConstant: 84),
            
            tempLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: 0),
            tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            infoStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32),
            infoStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            infoStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            
        ])
    }
    
    func setupBarButton() {
        navigationItem.rightBarButtonItem = favoriteBarButton
        updateButtonState()
    }
    
    func updateButtonState() {
        favoriteBarButton.image = databaseManager.isWeatherInFavorite(id: weather.id) ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    }
    
}
