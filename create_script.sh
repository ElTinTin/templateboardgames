#!/usr/bin/env ruby

require 'rubygems'
require 'xcodeproj'
require 'json'
require 'plist_lite'

puts "New target name:"
name = gets
puts "New target bundle identifier"
bundleIdentifier = gets

name = name.chomp
bundleIdentifier = bundleIdentifier.chomp
srcTargetName = "templateboardgames"
configJSON = '{"appName": "MonApp", "primaryColor": "#FF0000", "favoriteFeature": true}'

# Convert the JSON string to a Ruby hash
config_hash = JSON.parse(configJSON)

# Function to create new template.plist
def create_template_plist(client_name, config_hash)
  # Load the default template.plist
  template_path = "/Users/quentindeschamps/Documents/Work/templateboardgames/templateboardgames/Configuration/template.plist"
  template_content = File.read(template_path)

  # Parse the template_content into a PlistLite::Plist object
  template_plist = PlistLite.load(template_content)

  # Replace the values in the template with the values from the config_hash
  config_hash.each do |key, value|
    template_plist[key] = value
  end

  # Serialize the updated plist back to a string
  updated_template_content = PlistLite.dump(template_plist)

  # Create the new template.plist file for the client
  client_template_path = "/Users/quentindeschamps/Documents/Work/templateboardgames/templateboardgames/Configuration/#{client_name}.plist"
  File.open(client_template_path, "w") { |file| file.puts updated_template_content }

  puts "Created template.plist for #{client_name} with the following values:"
  puts config_hash
  
  return client_template_path
end

# Path to your Xcode project file
project_file = "templateboardgames.xcodeproj"

# Add a new target to the Xcode project
def add_new_target(project_file, name, bundleIdentifier, srcTargetName)
  proj = Xcodeproj::Project.open(project_file)
  src_target = proj.targets.find { |item| item.to_s == srcTargetName }

  target = proj.new_target(src_target.symbol_type, name, src_target.platform_name, src_target.deployment_target)
  target.product_name = name

  target.build_configurations.map do |item|
    item.build_settings.update(src_target.build_settings(item.name))
  end

  target.build_configurations.each do |config|
    config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = bundleIdentifier
    config.build_settings['PRODUCT_NAME'] = "$(TARGET_NAME)"
  end

  # copy build_phases and files (excluding .plist)
  phases = src_target.build_phases.reject { |x| x.instance_of?(Xcodeproj::Project::Object::PBXShellScriptBuildPhase) || x.isa == "PBXResourcesBuildPhase" }.collect(&:class)

  phases.each do |klass|
    src = src_target.build_phases.find { |x| x.instance_of? klass }
    dst = target.build_phases.find { |x| x.instance_of? klass }
    unless dst
      dst ||= proj.new(klass)
      target.build_phases << dst
    end
    dst.files.map { |x| x.remove_from_project }

    src.files.each do |f|
      next if f.file_ref.nil?
      file_ref = proj.new(Xcodeproj::Project::Object::PBXFileReference)
      file_ref.name = f.file_ref.name
      file_ref.path = f.file_ref.path
      file_ref.source_tree = f.file_ref.source_tree
      file_ref.last_known_file_type = f.file_ref.last_known_file_type

      begin
        file_ref.move(f.file_ref.parent)
      rescue
      end

      build_file = proj.new(Xcodeproj::Project::Object::PBXBuildFile)
      build_file.file_ref = f.file_ref
      dst.files << build_file
    end
  end

  proj.save
end

# Call the functions for the new client target
new_target = add_new_target(project_file, name, bundleIdentifier, srcTargetName)
template_plist_path = create_template_plist(name, config_hash)

# Add the new template.plist to the Xcode project
proj = Xcodeproj::Project.open(project_file)
group = proj.main_group["templateboardgames"]["Configuration"]

unless group
  # If the "Configuration" group doesn't exist, create it
  group = proj.main_group.new_group("Configuration", "Configuration") # Use the same name for path and group
end

file_reference = group.new_file(template_plist_path)

# Find the new target in the project
new_target = proj.targets.find { |item| item.to_s == name }

# Add the file reference to the Resources build phase of the new target
new_target.build_phases.each do |build_phase|
  if build_phase.isa == 'PBXResourcesBuildPhase'
    build_phase.add_file_reference(file_reference)
  end
end

# Update the Display Name of the new target
new_target.build_configurations.each do |config|
  build_settings = config.build_settings
  build_settings['TARGETED_DEVICE_FAMILY'] = '1,2' # 1 for iPhone, 2 for iPad
  build_settings['DEVELOPMENT_TEAM'] = bundleIdentifier
  build_settings['PROVISIONING_PROFILE_SPECIFIER'] = 'Automatic'
  build_settings['CODE_SIGN_STYLE'] = 'Automatic'
  build_settings['CODE_SIGN_ENTITLEMENTS'] = ''
  build_settings['CODE_SIGN_IDENTITY'] = 'iPhone Developer'
  build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = bundleIdentifier
  build_settings['CFBundleDisplayName'] = name
end

proj.save
