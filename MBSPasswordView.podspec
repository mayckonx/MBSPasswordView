Pod::Spec.new do |s|
  s.name                  = "MBSPasswordView"
  s.version               = '1.1.0'
  s.homepage              = "https://github.com/mayckonx/#{s.name}"
  s.license               = { type: 'MIT', file: 'LICENSE' }
  s.author                = 'Mayckon Barbosa da Silva'
  s.source                = { git: "#{s.homepage}.git", tag: "v#{s.version}" }
  s.source_files          = "MBSPasswordView/**/*"
  s.exclude_files          = "MBSPasswordView/*.plist"
  s.ios.deployment_target = '11.0'
  s.swift_version          = '4.2'
  s.summary               = 'Simple lock screen for iOS Application.'
  s.description  = <<-DESC
    # MBSPasswordView
   MBSPasswordView is a custom view that provides an easy way to use a block-screen password.
  DESC
end