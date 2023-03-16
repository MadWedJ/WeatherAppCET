//
//  InfoView.swift
//  HW_15
//
//  Created by Michael on 3/16/23.
//

import UIKit

enum WeatherInfoType {
    case pressure(String)
    case humidity(String)
    case visibility(String)
    case tempMin(String)
    case tempMax(String)
    case feelsLike(String)
    case windSpeed(String)
    case windDegree(String)

    var value: String {
        switch self {
        case .pressure(let value):
            return value
        case .humidity(let value):
            return value
        case .visibility(let value):
            return value
        case .tempMin(let value):
            return value
        case .tempMax(let value):
            return value
        case .feelsLike(let value):
            return value
        case .windSpeed(let value):
            return value
        case .windDegree(let value):
            return value
        }
    }
    
    var humanReadableDescription: String {
        switch self {
        case .pressure:
            return "Pressure"
        case .humidity:
            return "Humidity"
        case .visibility:
            return "Visibility"
        case .tempMin:
            return "Min temp"
        case .tempMax:
            return "Max temp"
        case .feelsLike:
            return "Feels like"
        case .windSpeed:
            return "Wind speed"
        case .windDegree:
            return "Wind direction"
        }
    }

    var icon: UIImage? {
        switch self {
        case .pressure:
            return UIImage(named: "pressure")
        case .humidity:
            return UIImage(named: "humidity")
        case .visibility:
            return UIImage(named: "visibility")
        case .tempMin:
            return UIImage(named: "tempMin")
        case .tempMax:
            return UIImage(named: "tempMax")
        case .feelsLike:
            return UIImage(named: "feelsLike")
        case .windSpeed:
            return UIImage(named: "windSpeed")
        case .windDegree:
            return UIImage(named: "windDegree")
        }
    }
}

class WeatherInfoView: UIView {

    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()

    let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()

    let desctiptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.init(200), for: .horizontal)
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()

    let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(desctiptionLabel)
        stackView.addArrangedSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            imageView.heightAnchor.constraint(equalToConstant: 36),
            imageView.widthAnchor.constraint(equalToConstant: 36)
        ])
    }

    func set(info: WeatherInfoType) {
        desctiptionLabel.text = info.humanReadableDescription
        imageView.image = info.icon
        valueLabel.text = info.value
    }
    
}
