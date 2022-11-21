//
//  Router.swift
//  CryptoConvertVIPER
//
//  Created by Дмитрий Пономаренко on 21.11.22.
//

import Foundation
import UIKit

//Object
//Entry point

typealias EntryPoint = UIViewController & AnyView

protocol AnyRouter {
    var entry: EntryPoint? { get }
    static func start() -> AnyRouter
}


class CryptoRouter: AnyRouter {
    var entry: EntryPoint?
    
    static func start() -> AnyRouter {
        
        let router = CryptoRouter()
        
        var view: AnyView = CryptoViewController()
        var interactor: AnyInteractor = CryptoIteractor()
        var presenter: AnyPresenter = CryptoPresenter()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
         
        router.entry = view as? EntryPoint
        
        return router
    }
    
    
    
}
