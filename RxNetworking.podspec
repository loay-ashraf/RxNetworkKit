Pod::Spec.new do |s|
    s.name             = 'RxNetworking'  
    s.version          = '0.0.1'  
    s.summary          = 'a lightweight reactive networking framework.' 
    s.description      = 'a reactive networking framework built on top of URLSession and uses RxSwift and RxCocoa.'
    s.homepage         = 'https://github.com/loay-ashraf/RxNetworking'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'loay-ashraf' => 'loay.ashraf.96@gmail.com' }
    s.source           = { :git => 'https://github.com/loay-ashraf/RxNetworking.git', :tag => s.version.to_s }
    s.ios.deployment_target = '14.0'
    s.source_files = 'RxNetworking/*'
    end