if respond_to?(:brew)
  current_brewfile = File.join(__dir__, "brewfiles/current.rb")

  abort("Run `make device` or `make sync` to prepare #{current_brewfile}") unless File.exist?(current_brewfile)

  instance_eval(File.read(current_brewfile), current_brewfile)
end
