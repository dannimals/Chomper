# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!

def production_pods
    pod 'BNRCoreDataStack'
    pod 'GoogleMaps', '~> 1.13.2'
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

  target 'WebServicesTests' do
    inherit! :search_paths
  end

end
