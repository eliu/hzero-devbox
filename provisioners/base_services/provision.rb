class BaseServices
  @name = "base_services"
  @enabled = true
  @root_path = File.dirname(__FILE__).split(File::SEPARATOR)[-2..].join(File::SEPARATOR)

  def self.provision(config)
    # Provision base services using podman compose
    config.vm.provision "base_services_up", type: "shell", 
      run: "never",
      privileged: false,
      keep_color: true,
      path: "#{@root_path}/provision.sh",
      args: "up"

    # Check if all base services are under normal status
    config.vm.provision "base_services_ps", type: "shell", 
      run: "never",
      privileged: false,
      keep_color: true,
      path: "#{@root_path}/provision.sh",
      args: "ps"
  end
end
