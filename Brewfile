require "digest"
require "fileutils"

AUTOMATIC_DEVICE_PREFIX = "mac"

def load_brewfile(path)
  instance_eval(File.read(path), path.to_s)
end

def normalized_device_id(value)
  slug = value.to_s.strip.downcase.gsub(/[^a-z0-9._-]+/, "-").gsub(/\A-+|-+\z/, "")
  slug.empty? ? nil : slug
end

def device_id
  override = normalized_device_id(ENV["DOTFILES_DEVICE_ID"])
  return override if override

  ioreg = `ioreg -rd1 -c IOPlatformExpertDevice 2>/dev/null`
  uuid = ioreg[/\"IOPlatformUUID\" = \"([^\"]+)\"/, 1]
  return "#{AUTOMATIC_DEVICE_PREFIX}-#{Digest::SHA256.hexdigest(uuid)[0, 12]}" if uuid && !uuid.empty?

  name = `scutil --get LocalHostName 2>/dev/null`.strip
  name = `hostname -s 2>/dev/null`.strip if name.empty?
  slug = normalized_device_id(name)
  return "#{AUTOMATIC_DEVICE_PREFIX}-#{slug}" if slug

  "#{AUTOMATIC_DEVICE_PREFIX}-local"
end

def brewfiles_dir
  File.join(__dir__, "brewfiles")
end

def tool_versions_dir
  File.join(__dir__, "tool-versions")
end

def default_brewfile_path
  File.join(brewfiles_dir, "default.rb")
end

def device_brewfile_path
  File.join(brewfiles_dir, "#{device_id}.rb")
end

def current_brewfile_path
  File.join(brewfiles_dir, "current.rb")
end

def default_tool_versions_path
  File.join(tool_versions_dir, "default")
end

def device_tool_versions_path
  File.join(tool_versions_dir, device_id)
end

def ensure_device_copy!(default_path, device_path)
  FileUtils.mkdir_p(File.dirname(device_path))
  FileUtils.cp(default_path, device_path) unless File.exist?(device_path)
  device_path
end

def ensure_device_brewfile!
  ensure_device_copy!(default_brewfile_path, device_brewfile_path)
end

def ensure_device_tool_versions!
  ensure_device_copy!(default_tool_versions_path, device_tool_versions_path)
end

if respond_to?(:brew)
  current_brewfile = current_brewfile_path

  abort("Run `make device` or `make sync` to prepare #{current_brewfile}") unless File.exist?(current_brewfile)

  load_brewfile(current_brewfile)
end
