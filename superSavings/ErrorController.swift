//
//  ErrorController.swift
//  TeenCard
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 26/08/17.
//  Copyright © 2017 Gustavo De Mello Crivelli. All rights reserved.
//

import UIKit
import CloudKit

struct ErrorInfo {
    // if should retry the CKOperation
    var shouldRetry: Bool = false
    // error message to present to the user
    var message: String = ""
    // serverRecordChangedError
    var concurrentAccessError: Bool = false
}

class ErrorController {
    
    static var shared = ErrorController()
    
    private init() {}
    
    func handleCKError(error: CKError) -> ErrorInfo {
        var info = ErrorInfo()
        switch error.code {
        case .networkUnavailable, .networkFailure:
            // no internet connection
            print(error.localizedDescription)
            info.shouldRetry = false
            info.message = "Por favor, verifique sua conexão."
            info.concurrentAccessError = false
        case .internalError, .serverRejectedRequest, .invalidArguments, .permissionFailure:
            // internal error
            print(error.localizedDescription)
            info.shouldRetry = false
            info.message = "Problemas na conexão com o servidor. Tente novamente mais tarde."
            info.concurrentAccessError = false
        case .zoneBusy, .serviceUnavailable, .requestRateLimited:
            // overloaded server
            print(error.localizedDescription)
            info.shouldRetry = true
            info.message = "Servidor sobrecarregado."
            info.concurrentAccessError = false
            if let retryAfter = error.userInfo[CKErrorRetryAfterKey] as? Double {
                sleep(UInt32(retryAfter))
            }
        case .notAuthenticated:
            // user not authenticated
            print(error.localizedDescription)
            info.shouldRetry = false
            info.message = "Por favor, entre em sua conta do iCloud."
            info.concurrentAccessError = false
        case .serverRecordChanged:
            // concurrent access
            print(error.localizedDescription)
            info.shouldRetry = false
            info.message = "Acesso concorrente"
            info.concurrentAccessError = true
        default:
            // unknown error
            print(error.localizedDescription)
            info.shouldRetry = false
            info.message = "Problema inesperado. Tente novamente mais tarde."
            info.concurrentAccessError = false
        }
        return info
    }


}
