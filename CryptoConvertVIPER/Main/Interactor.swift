//
//  Interactor.swift
//  CryptoConvertVIPER
//
//  Created by Дмитрий Пономаренко on 21.11.22.
//

import Foundation


//object
//protocol
//ref to presenter


protocol AnyInteractor {
    var presenter: AnyPresenter? { get set }
    
    func getCoinPrice(for currency: String)
    func getCoinData(with urlString: String)
}

class CryptoIteractor: AnyInteractor {

    
    var presenter: AnyPresenter?
    
    var baseurl = "https://rest.coinapi.io/v1/exchangerate/BTC"
    var APIKey = "574F363A-07DA-41FF-83FF-E88E28C04F0A"
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseurl)/\(currency)?apikey=\(APIKey)"
        getCoinData(with: urlString)
    }
    
     
    func getCoinData(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [weak self] data, _, error in
        
            guard let data = data, error == nil else {
                self?.presenter?.interactorDownloadData(with: .failure(NetworkError.NetworkFailed))
                return
            }
            
            do {
                let entities = try JSONDecoder().decode((CoinData).self, from: data)
                self?.presenter?.interactorDownloadData(with: .success(entities))
            } catch {
                self?.presenter?.interactorDownloadData(with: .failure(NetworkError.ParsingFailed))
            }
        }
        task.resume()
    }
    
}
