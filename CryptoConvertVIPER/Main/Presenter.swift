//
//  Presenter.swift
//  CryptoConvertVIPER
//
//  Created by Дмитрий Пономаренко on 21.11.22.
//

import Foundation
import UIKit


enum NetworkError: Error {
    case NetworkFailed
    case ParsingFailed
}


// object
// protocol
// ref to router, interactor, view


protocol AnyPresenter {
    var router: AnyRouter? { get set }
    var interactor: AnyInteractor? { get set }
    var view: AnyView? { get set }
    
    func interactorDownloadData(with result: Result<(CoinData), Error>)
}

class CryptoPresenter: AnyPresenter {
    var interactor: AnyInteractor?
    
    var router: AnyRouter?
    
//    var interactor: AnyInteractor? {
//        didSet {
//            
//        }
//    }
    
    var view: AnyView?
    
    func interactorDownloadData(with result: Result<(CoinData), Error>) {
        switch result {
        case .success(let coinData):
            view?.update(with: coinData)
        case .failure(let _):
            view?.update(error: "Somethig wrong")
        }
        
    }
    
}
