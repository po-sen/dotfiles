require "digest"
require "fileutils"
require "pathname"

def load_brewfile(path)
  instance_eval(File.read(path), path.to_s)
end

def device_id
  ioreg = `ioreg -rd1 -c IOPlatformExpertDevice 2>/dev/null`
  uuid = ioreg[/\"IOPlatformUUID\" = \"([^\"]+)\"/, 1]
  return "device-#{Digest::SHA256.hexdigest(uuid)[0, 12]}" if uuid && !uuid.empty?

  name = `scutil --get LocalHostName 2>/dev/null`.strip
  name = `hostname -s 2>/dev/null`.strip if name.empty?
  slug = name.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-+|-+\z/, "")
  return "device-#{slug}" unless slug.empty?

  "device-local"
end

def repo_root
  Pathname.new(__dir__)
end

def brewfiles_dir
  repo_root.join("brewfiles")
end

def default_brewfile_path
  brewfiles_dir.join("default.rb")
end

def device_brewfile_path
  brewfiles_dir.join("#{device_id}.rb")
end

def ensure_device_brewfile!
  FileUtils.mkdir_p(brewfiles_dir)
  device_file = device_brewfile_path
  FileUtils.cp(default_brewfile_path, device_file) unless device_file.exist?
  device_file
end

load_brewfile(ensure_device_brewfile!) if respond_to?(:brew)
