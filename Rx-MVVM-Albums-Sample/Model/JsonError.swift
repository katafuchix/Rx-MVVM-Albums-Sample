//
//  JsonError.swift
//  Rx-MVVM-Albums-Sample
//
//  Created by cano on 2022/06/18.
//

import Foundation
import SwiftyJSON

struct JsonError: Error {

    // MARK: - Properties
    let domain: String
    let statusCode: StatusCode
    let responseObject: Any?
    var responseJSON: JSON? {
        guard let object = responseObject else { return nil }
        return JSON(object)
    }

    // swiftlint:disable variable_name
    var _domain: String {
        return domain
    }
    var _code: Int {
        return statusCode.rawValue
    }

    // swiftlint:enable variable_name
    // MARK: - Initialize
    init(error: Error) {
        if let error = error as? JsonError {
            self.domain = error.domain
            self.statusCode = error.statusCode
            self.responseObject = error.responseObject
        } else {
            self.domain = error._domain
            self.statusCode = StatusCode(code: error._code)
            self.responseObject = nil
        }
    }

    init(domain: String, statusCode: StatusCode, responseObject: Any?) {
        self.domain = domain
        self.statusCode = statusCode
        self.responseObject = responseObject
    }

}

// MARK: - Custom Error
extension JsonError {
    static func parseError(object responseObject: Any? = nil) -> JsonError {
        return JsonError(domain: "Cann't parse object.", statusCode: .parseError, responseObject: responseObject)
    }

    static func emptyError(object responseObject: Any? = nil) -> JsonError {
        return JsonError(domain: "Cann't find items.", statusCode: .parseError, responseObject: responseObject)
    }
}

enum StatusCode: Int {

    // MARK: - HTTP Status Code
    case ok         = 200,
        created     = 201,
        accepted    = 202,
        noContent   = 204

    case seeOther = 303

    case badRequest         = 400,
        unauthorized        = 401,
        forbidden           = 403,
        notFound            = 404,
        notAcceptable       = 406,
        requestTimeout      = 408,
        conflict            = 409,
        unprocessableEntity = 422,
        locked              = 423

    case internalServerError    = 500,
        badGateway              = 502,
        serviceUnavailable      = 503,
        gatewayTimeout          = 504

    case networkError   = 0,
        connectionError = -1009

    // MARK: - Pochi Status Code (40xxx)
    case parseError = 40400

    // MARK: - Common Error
    case unknownStatus  = -1

    // MARK: - Initialize
    init(code: Int?) {
        if let code = code {
            self = StatusCode(rawValue: code) ?? .unknownStatus
        } else {
            self = .networkError
        }
    }

}
