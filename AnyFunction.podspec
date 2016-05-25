Pod::Spec.new do |s|
    s.name         = "AnyFunction"
    s.version      = "1.0.0"
    s.summary      = "Type tools for manipulating closures of distinct types"
    s.description  = <<-DESC
                        Type tools for manipulating closures of distinct types.
                        DESC
                        
    s.homepage     = "https://github.com/damouse/AnyFunction"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author       = { "Mickey Barboi" => "mickey.barboi@gmail.com" }
    s.source       = { :git => "https://github.com/damouse/AnyFunction.git", :tag => "1.0.0" }

    s.ios.deployment_target = "8.0"
    s.osx.deployment_target = "10.9"
    s.source_files  = "AnyFunction", "AnyFunction/**/*.{swift,h,m}"
    s.requires_arc = true

    s.dependency 'DSON', '~> 1.0.1'
end
