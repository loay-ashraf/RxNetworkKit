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

### Why RxNetworkKit?

- can be used to make simple REST API calls.
- can be used to make download and upload requests while also tracking the progress.
- can be used to connect to websocket and listen to remote data changes.
- can intercept requests for adaptation or retry on failure.
- can observe and provide network reachability status.

## Featured

@Links(visualStyle: detailedGrid) {
    - <doc:GettingStarted>
}

## Topics

### Essentials

- <doc:GettingStarted>

### Foundation

- ``Session``
- ``SessionConfiguration``
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
