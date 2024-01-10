# ``RxNetworkKit``

a lightweight networking framework based on URLSession and RxSwift.

## Overview

RxNetworkKit fits nicely in your project if you use RxSwift and RxCocoa mainly in your project.

It makes use of RxSwift's traits at request level to acheive a high level of specialization for observed request sequence and expected output from it.

### Full of Goodies:
- includes download and upload capabillity with progress tracking all within the same observable sequence.
- includes websocket capabillity for observing remote data updates.
- includes a request interceptor protocol that can be implemented for request adaptation and retry on failure.
- comes with a reachability class that you can observe from anywhere for reachability status.

## Topics

### Foundation

- ``Session``
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

### Event Monitor

- ``HTTPRequestEventMonitor``

### Network Reachability

- ``NetworkReachability``
- ``NetworkReachabilityStatus``
- ``NetworkInterfaceType``
