//
//  View.swift
//  CryptoConvertVIPER
//
//  Created by Дмитрий Пономаренко on 21.11.22.
//

import Foundation
import UIKit

//ViewController
//protocol
//reference presenter

protocol AnyView {
    var presenter: AnyPresenter? { get set }
    
    func update(with coinData: (CoinData))
    func update(error: String)
}

class CryptoViewController: UIViewController, AnyView {
    
    var presenter: AnyPresenter?
    
    let currencyArray = ["AUD", "BRL","BYN","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    private let currencyPicker: UIPickerView = {
        let currencyPicker = UIPickerView()
        currencyPicker.isHidden = false
        currencyPicker.translatesAutoresizingMaskIntoConstraints = false
        return currencyPicker
        
    }()
    
    private let bitcoinImage: UIImageView = {
        let bitcoinImage = UIImageView()
        bitcoinImage.image = UIImage(systemName: "bitcoinsign.circle.fill")
        bitcoinImage.translatesAutoresizingMaskIntoConstraints = false
        bitcoinImage.tintColor = .white
        bitcoinImage.isHidden = false
        return bitcoinImage
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = ""
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 25)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.isHidden = false
        return nameLabel
    }()
    
    private let priceLabel: UILabel = {
        let priceLaber = UILabel()
        priceLaber.text = "0.0"
        priceLaber.textAlignment = .center
        priceLaber.font = UIFont.systemFont(ofSize: 25)
        priceLaber.translatesAutoresizingMaskIntoConstraints = false
        priceLaber.isHidden = false
        return priceLaber
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        view.backgroundColor = .systemGreen
        view.addSubview(priceLabel)
        view.addSubview(nameLabel)
        view.addSubview(currencyPicker)
        view.addSubview(bitcoinImage)
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createConstraint()
       
    }
    
    //MARK: - Update Data
    func update(with coinData: (CoinData)) {
        DispatchQueue.main.async {
            self.nameLabel.text = coinData.asset_id_quote
            self.priceLabel.text = String(format: "%.2f", coinData.rate)
            self.priceLabel.isHidden = false
            self.bitcoinImage.isHidden = false
            self.nameLabel.isHidden = false
            self.currencyPicker.isHidden = false
        }
    }
    
    func update(error: String) {
        DispatchQueue.main.async {
            self.nameLabel.isHidden = true
            self.priceLabel.isHidden = true
            self.currencyPicker.isHidden = false
            self.bitcoinImage.isHidden = true
            self.makeAlert(title: "error", message: error)
        }
    }
    
    //MARK: - Alert
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Reply", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: - Constraint
    func createConstraint() {
        currencyPicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        currencyPicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        currencyPicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        priceLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        priceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        
        nameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 120).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        
        bitcoinImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35).isActive = true
        bitcoinImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        bitcoinImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        bitcoinImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}


//MARK: - UIPickerViewDataSourse and UIPickerDelegate
    
extension CryptoViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
}

extension CryptoViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nameLabel.text = currencyArray[row]
        presenter?.interactor?.getCoinPrice(for: currencyArray[row])
    }
}
