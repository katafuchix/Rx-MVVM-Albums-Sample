//
//  ViewModel.swift
//  Rx-MVVM-Albums-Sample
//
//  Created by cano on 2022/06/17.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx
import Action
import SwiftyJSON
import RxOptional

public enum ViewModelError {
    case internetError(String)
    case serverMessage(String)
}

protocol ViewModelInputs {
    var trigger: PublishSubject<Void> { get }
}

protocol ViewModelOutputs {
    var albums : BehaviorRelay<[Album]> { get }
    var tracks : BehaviorRelay<[Track]> { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<JsonError> { get }
}

protocol ViewModelType {
    var inputs: ViewModelInputs { get }
    var outputs: ViewModelOutputs { get }
}

class ViewModel: ViewModelType, ViewModelInputs, ViewModelOutputs {

    var inputs: ViewModelInputs { return self }
    var outputs: ViewModelOutputs { return self }

    // MARK: - Inputs
    let trigger = PublishSubject<Void>()

    // MARK: - Outputs
    let albums : BehaviorRelay<[Album]>
    let tracks : BehaviorRelay<[Track]>
    let isLoading: Observable<Bool>
    let error: Observable<JsonError>
    
    // 内部変数
    private let action: Action<(), JSON>
    private let json : BehaviorRelay<JSON>
    private let disposeBag = DisposeBag()
    
    init() {
        
        // 検索結果
        self.albums = BehaviorRelay<[Album]>(value: [])
        self.tracks = BehaviorRelay<[Track]>(value: [])
        self.json = BehaviorRelay<JSON>(value: JSON())
        
        // アクション定義
        self.action = Action { _ in
            let urlStr = "https://gist.githubusercontent.com/katafuchix/e7f68fd8bde63f54b1eed2c7cf08fa38/raw/3f602bc12d04f61e742953fc53a2170f477d6ca7/MvvmExampleApi.json"
            
            let url = URL(string:urlStr)!
            
            let request = URLRequest(url: url)
            return URLSession.shared.rx.response(request: request)
                            .filter{ $0.response.statusCode == 200 }
                            .map{ $0.data }
                            .map { try JSON(data: $0) }
                            .asObservable()
        }
        
        // アルバム
        self.action.elements
            .map { response in
                return response["Albums"].arrayValue
                        .compactMap { return Album(data: try! $0.rawData()) }
            }
            .bind(to:self.albums)
            .disposed(by: disposeBag)
        
        // トラック
        self.action.elements
            .map { response in
                return response["Tracks"].arrayValue
                        .compactMap { return Track(data: try! $0.rawData()) }
            }
            .bind(to:self.tracks)
            .disposed(by: disposeBag)
        
        // 起動
        self.trigger.asObservable()
            .bind(to:self.action.inputs)
            .disposed(by: disposeBag)
        
        // 検索中
        self.isLoading = action.executing.startWith(false)

        // エラー
        self.error = action.errors.flatMapjsonError()
    }
}
