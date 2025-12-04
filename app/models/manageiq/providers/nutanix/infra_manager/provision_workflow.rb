class ManageIQ::Providers::Nutanix::InfraManager::ProvisionWorkflow < ManageIQ::Providers::InfraManager::ProvisionWorkflow
  def self.default_dialog_file
    'miq_provision_dialogs'
  end

  def self.default_pre_dialog_file
    'miq_provision_dialogs_pre'
  end

  def self.provider_model
    ManageIQ::Providers::Nutanix::InfraManager
  end

  def dialog_name_from_automate(message = 'get_dialog_name', extra_attrs = {'platform' => 'nutanix'})
    super(message, extra_attrs)
  end

  def allowed_provision_types(_options = {})
    {
      "native_clone" => "Native Clone"
    }
  end
end
