class Middlewares
  @name = "middlewares"
  @enabled = true
  @root_path = File.dirname(__FILE__).split(File::SEPARATOR)[-2..].join(File::SEPARATOR)

  def self.provision(config)
    # Provision middlewares using podman compose
    config.vm.provision "middlewares_up", type: "shell", 
      run: "never",
      privileged: false,
      keep_color: true,
      path: "#{@root_path}/provision.sh",
      args: "up"

    # Check if all middlewares are under normal status
    config.vm.provision "middlewares_ps", type: "shell", 
      run: "never",
      privileged: false,
      keep_color: true,
      path: "#{@root_path}/provision.sh",
      args: "ps"
  end
end
