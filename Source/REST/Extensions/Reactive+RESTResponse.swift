//
//  Reactive+RESTResponse.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/01/2024.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: URLSession {
    /**
     Observable sequence of responses for URL request.
     
     Performing of request starts after observer is subscribed and not after invoking this method.
     
     **URL requests will be performed per subscribed observer.**
     
     Any error during fetching of the response will cause observed sequence to terminate with error.
     
     - parameter request: URL request.
     - returns: Observable sequence of URL responses.
     */
    func restResponse(request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)> {
        return Observable.create { observer in
            
#if DEBUG
            if URLSession.logRequests {
                let outgoingRequest = base.outgoingRequest(for: request)
                HTTPRequestLogger.shared.log(request: outgoingRequest)
            }
#endif
            
            let task = self.base.dataTask(with: request) { data, response, error in
#if DEBUG
                if URLSession.logRequests {
                    HTTPRequestLogger.shared.log(response: (request.url, response, data, error))
                }
#endif
                
                guard let response = response, let data = data else {
                    observer.on(.error(error ?? RxCocoaURLError.unknown))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.on(.error(RxCocoaURLError.nonHTTPResponse(response: response)))
                    return
                }
                
                observer.on(.next((httpResponse, data)))
                observer.on(.completed)
            }
            
            task.resume()
            
            return Disposables.create(with: task.cancel)
        }
    }
    
}
