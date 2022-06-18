//
//  Action+Rx.swift
//  Rx-MVVM-Albums-Sample
//
//  Created by cano on 2022/06/18.
//


import Foundation
import RxSwift
import RxCocoa
import Action

extension ObservableType where Element == ActionError {
    func flatMapjsonError() -> Observable<JsonError> {
        return flatMap { e -> Observable<JsonError> in
            switch e {
            case .underlyingError(let error):
                return Observable.just(JsonError(error: error))
            case .notEnabled:
                return Observable.empty()
            }
        }
    }

    func flatMapError() -> Observable<Error> {
        return flatMap { e -> Observable<Error> in
            switch e {
            case .underlyingError(let error):
                return Observable.just(error)
            case .notEnabled:
                return Observable.empty()
            }
        }
    }
}

protocol ActionErrorType {
    var actionError: ActionError { get }
}

extension ActionError: ActionErrorType {
    var actionError: ActionError { return self }
}

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element: ActionErrorType {
    func flatMapDMMAPIError() -> Driver<JsonError> {
        return flatMap { e -> Driver<JsonError> in
            switch e.actionError {
            case .underlyingError(let error):
                return Driver.just(JsonError(error: error))
            case .notEnabled:
                return Driver.empty()
            }
        }
    }

    func flatMapError() -> Driver<Error> {
        return flatMap { e -> Driver<Error> in
            switch e.actionError {
            case .underlyingError(let error):
                return Driver.just(error)
            case .notEnabled:
                return Driver.empty()
            }
        }
    }
}
