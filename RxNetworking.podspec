Pod::Spec.new do |s|
    s.platform = :ios, :macos
    s.ios.deployment_target = '14.0'
    s.macos.deployment_target = '11.0'
    s.name             = 'RxNetworking'  
    s.version          = '0.1.0'  
    s.summary          = 'a lightweight reactive networking framework.' 
    s.description      = 'a reactive networking framework built on top of URLSession and uses RxSwift and RxCocoa.'
    s.homepage         = 'https://github.com/loay-ashraf/RxNetworking'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'loay-ashraf' => 'loay.ashraf.96@gmail.com' }
    s.source           = { :git => 'https://github.com/loay-ashraf/RxNetworking.git', :tag => s.version.to_s }
    s.framework = "Foundation"
    s.dependency 'RxSwift', '~> 6.5.0'
    s.dependency 'RxCocoa', '~> 6.5.0'
    s.dependency 'RxSwiftExt', '~> 6.0.1'
    s.source_files = 'RxNetworking/**/*.{swift,m,h}'
    s.swift_version = '5.0'
    end