# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!

def production_pods
    pod 'GoogleMaps', '~> 1.13.2'
    pod 'SwiftyJSON'
    pod 'FLEX', '~> 2.3.0', :configurations => ['Debug']
    pod 'RxSwift', '3.1.0'
end

target 'Chomper' do
  production_pods
  target 'ChomperTests' do
    inherit! :search_paths
  end

end

target 'Common' do

  # Pods for Common

  target 'CommonTests' do
    inherit! :search_paths
  end

end

target 'Models' do

  target 'ModelsTests' do
    inherit! :search_paths
  end

end

target 'ModelSync' do

  target 'ModelSyncTests' do
    inherit! :search_paths
  end

end

target 'WebServices' do
  pod 'SwiftyJSON'
  pod 'Moya-ObjectMapper/RxSwift', '2.3'
  pod 'Moya/RxSwift', '8.0.0'

  target 'WebServicesTests' do
    inherit! :search_paths
  end

end
