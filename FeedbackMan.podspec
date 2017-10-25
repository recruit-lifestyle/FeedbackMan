Pod::Spec.new do |s|
  s.name             = 'FeedbackMan'
  s.version          = '1.0.0'
  s.summary          = 'A useful and simple feedback tool for iOS developer.'
  s.description      = <<-DESC
                       FeedbackMan can send feedback to your Slack channel easily.
                       You can attach screenshot and edit it by various color lines.
                       Feedback data contains your app name, app version, device model name,
                       iOS version, and displaying ViewController automatically.
                       You can write detailed description, moreover,
                       like button make it possible for you to send these data with just one tap.
                       DESC
  s.homepage         = 'https://github.com/recruit-lifestyle/FeedbackMan'
  s.license          = 'Apache License, Version 2.0'
  s.author           = { 'Naomichi Okada' => 'b6u728@gmail.com',
                         'sshayashi' => 'sshayashi0208@gmail.com' }
  s.source           = { :git => 'https://github.com/recruit-lifestyle/FeedbackMan.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'FeedbackMan/Classes/**/*.swift'
  s.resource_bundles = {
  'FeedbackMan' => ['FeedbackMan/Resources/Storyboard/*.storyboard',
                    'FeedbackMan/Resources/Images/*.png']
  }
end
