# ``RxNetworkKit``

a reactive networking framework based on URLSession and RxSwift.

@Metadata {
    @Available(iOS, introduced: "14.0")
    @Available(macOS, introduced: "11.0")
    @Available(tvOS, introduced: "14.0")
    @Available(watchOS, introduced: "7.0")
    @PageColor(purple)
}

## Overview

RxNetworkKit is a generic reactive networking framework that leverages the stability and reliability of both URLSession and RxSwift.

### RxNetworkKit can be used to:

- Make simple REST API calls.
- Make download and upload requests while also tracking the progress.
- Connect to websocket and listen to remote data changes.
- Intercept requests for adaptation or retry on failure.
- Observe network reachability status.

## Featured

@Links(visualStyle: list) {
    - <doc:GettingStarted>
    - <doc:MakingFirstRequest>
    - <doc:MonitoringNetworkReachability>
}

## Topics

### Foundation

- ``Session``
- ``SessionConfiguration``
- ``TLSTrustEvaluatorConfiguration``
- ``TLSTrustEvaluationPolicy``
- ``RESTClient``
- ``HTTPClient``

### HTTP

- ``HTTPScheme``
- ``HTTPMethod``
- ``HTTPStatusCode``

### Error

- ``HTTPError``
- ``HTTPAPIError``
- ``DefaultHTTPAPIError``
- ``HTTPBodyError``
- ``DefaultHTTPBodyError``
- ``HTTPClientError``
- ``HTTPServerError``

### Request Interceptor

- ``HTTPRequestInterceptor``
- ``HTTPRequestAdapter``
- ``HTTPRequestRetrier``
- ``HTTPRequestRetryPolicy``

### Network Reachability

- ``NetworkReachability``
- ``NetworkReachabilityStatus``
- ``NetworkInterfaceType``

### Articles

- <doc:GettingStarted>
- <doc:MakingFirstRequest>
- <doc:MakingDownloadRequest>
- <doc:MakingUploadRequest>
- <doc:MakingMultipartFormUploadRequest>
- <doc:ConnectingToWebSocket>
- <doc:MonitoringNetworkReachability>
