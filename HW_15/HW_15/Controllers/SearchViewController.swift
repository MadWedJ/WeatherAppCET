//
//  SearchViewController.swift
//  HW_15
//
//  Created by Michael on 3/2/23.
//

import UIKit

// https://
// api.openweathermap.org - host
// /data/2.5/weather - path
// ?q={city name},{country code}&appid={API key} - parameters

// 925a9e21a69ce7f0647e5c381ba3c331

// https://api.openweathermap.org/data/2.5/weather?q=\(cityname)&appid=925a9e21a69ce7f0647e5c381ba3c331&units=metric

class SearchViewController: UIViewController {

    // %@ - String placeholder
    // %d - Int placeholder

    let netwrokManager = NetworkManager()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "City"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.setTitle("Search", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let topStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()

    lazy var favoriteBarButton = UIBarButtonItem(
        image: UIImage(systemName: "star.fill"),
        style: .plain,
        target: self,
        action: #selector(favoriteTapped)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        navigationItem.rightBarButtonItem = favoriteBarButton
    }
    
    func setup() {
        view.backgroundColor = .white
        view.addSubview(topStack)
        topStack.addArrangedSubview(textField)
        topStack.addArrangedSubview(searchButton)

        setConstraints()
        setupActions()
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            topStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            topStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchButton.heightAnchor.constraint(equalToConstant: 48),
            searchButton.widthAnchor.constraint(equalToConstant: 96)
        ])
    }

    func setupActions() {
        searchButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(screenTapped)))
    }
    
    @objc private func screenTapped() {
        view.endEditing(true)
    }
    
    @objc private func buttonPressed() {
        sendRequest()
    }

    @objc func favoriteTapped() {
        let destination = FavoriteViewController()
        navigationController?.pushViewController(destination, animated: true)
    }

    func sendRequest() {
        guard let city = textField.text, !city.isEmpty else { return }
        netwrokManager.fetchWeather(city: city) { result in
            DispatchQueue.main.async {
                self.handleWeatherResponse(response: result)
            }
        }
    }

    func handleWeatherResponse(response: Result<WeatherResponse, Error>) {
        textField.text = nil
        switch response {
        case .success(let weather):
            setWeather(weather: weather)
        case .failure(let error):
            print(error)
            showErrorAlert()
        }
    }

    func setWeather(weather: WeatherResponse) {
        let destination = WeatherBuilder().build(weather: weather)
        navigationController?.pushViewController(destination, animated: true)
    }

    func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Ops. Something went wrong", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}
