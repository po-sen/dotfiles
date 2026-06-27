require "digest"
require "fileutils"
require "pathname"

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

def repo_root
  Pathname.new(__dir__)
end

def brewfiles_dir
  repo_root.join("brewfiles")
end

def tool_versions_dir
  repo_root.join("tool-versions")
end

def default_brewfile_path
  brewfiles_dir.join("default.rb")
end

def device_brewfile_path
  brewfiles_dir.join("#{device_id}.rb")
end

def current_brewfile_link_path
  brewfiles_dir.join("current.rb")
end

def default_tool_versions_path
  tool_versions_dir.join("default")
end

def device_tool_versions_path
  tool_versions_dir.join(device_id)
end

def current_tool_versions_link_path
  tool_versions_dir.join("current")
end

def ensure_device_copy!(default_path, device_path)
  FileUtils.mkdir_p(device_path.dirname)
  FileUtils.cp(default_path, device_path) unless device_path.exist?
  device_path
end

def ensure_device_brewfile!
  ensure_device_copy!(default_brewfile_path, device_brewfile_path)
end

def ensure_device_tool_versions!
  ensure_device_copy!(default_tool_versions_path, device_tool_versions_path)
end

def update_current_link!(target_path, link_path)
  FileUtils.mkdir_p(link_path.dirname)
  relative_target = target_path.relative_path_from(link_path.dirname)
  FileUtils.ln_sf(relative_target.to_s, link_path)
  link_path
end

def ensure_current_profile_links!
  ensure_device_brewfile!
  ensure_device_tool_versions!
  update_current_link!(device_brewfile_path, current_brewfile_link_path)
  update_current_link!(device_tool_versions_path, current_tool_versions_link_path)
end

if respond_to?(:brew)
  ensure_current_profile_links!
  load_brewfile(device_brewfile_path)
end
