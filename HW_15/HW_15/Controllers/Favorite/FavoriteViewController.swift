//
//  FavoriteViewController.swift
//  HW_15
//
//  Created by Michael on 3/2/23.
//

import UIKit

class FavoriteViewController: UIViewController {

    var dataSource: [WeatherNameAndId] = []

    let databaseManager = DatabaseManager()
    let networkManager = NetworkManager()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
        return table
    }()

    override func loadView() {
        // устанавливаем таблицу в качестве корневой view у контроллера
        self.view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTable()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTable()
    }

    func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func updateTable() {
        dataSource = databaseManager.getSavedWeather()
        tableView.reloadData()
    }

    func loadCity(for name: String) {
        view.isUserInteractionEnabled = false
        networkManager.fetchWeather(city: name) { result in
            DispatchQueue.main.async {
                self.handleWeatherResponse(response: result)
            }
        }
    }

    func handleWeatherResponse(response: Result<WeatherResponse, Error>) {
        view.isUserInteractionEnabled = true
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

extension FavoriteViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier) as? FavoriteTableViewCell else {
            return UITableViewCell()
        }
        cell.set(text: dataSource[indexPath.row].name)
        return cell
    }
}

extension FavoriteViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadCity(for: dataSource[indexPath.row].name)
    }
}
