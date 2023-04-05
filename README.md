# RxNetworking
![Swift](https://img.shields.io/badge/Swift-5.3~5.7-orange)
![Platforms](https://img.shields.io/badge/Platforms-iOS%20macOS-yellowgreen)
![iOS](https://img.shields.io/badge/iOS-14.0%2B-black)
![macOS](https://img.shields.io/badge/macOS-11.0%2B-black)
![Cocoapods](https://img.shields.io/badge/Cocoapods-compatible-red)
![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen)
[![Twitter](https://img.shields.io/badge/Twitter-%40lashraf96-blue)](https://twitter.com/lashraf96)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-loay--ashraf-blue)](https://linkedin.com/in/loay-ashraf)

RxNetworking is a lightweight FRP networking framework. 

Built on top of Apple's [URLSession](https://developer.apple.com/documentation/foundation/urlsession) and uses the infamous [RxSwift](https://github.com/ReactiveX/RxSwift) FRP library.

## Why RxNetworking?

RxNetworking fits nicely on your project if you use RxSwift and RxCocoa mainly in your project.

It makes use of RxSwift's traits at request level to acheive a high level of specialization for observed request sequence and expected output from it.

### Full of Goodies:

- includes download and upload capabillity with progress tracking all within the same observable sequence. cool, right?
- includes a request interceptor protocol that can be implemented for request adaptation and retry on failure.
- comes with a reachability class that you can observe from anywhere for reachability status.

## Installation
