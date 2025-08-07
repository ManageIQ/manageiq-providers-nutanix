class ManageIQ::Providers::Nutanix::InfraManager::Template < ManageIQ::Providers::InfraManager::Template
  supports :provisioning do
    if ext_management_system
      ext_management_system.unsupported_reason(:provisioning)
    else
      _('not connected to ems')
    end
  end

  def parent_datacenter
    with_relationship_type('ems_metadata') do
      detect_ancestor(:of_type => 'EmsFolder') { |a| a.kind_of?(Datacenter) }
    end
  end
end
