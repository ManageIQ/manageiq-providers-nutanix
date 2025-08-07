class ManageIQ::Providers::Nutanix::InfraManager::Template < ManageIQ::Providers::InfraManager::Template
  def parent_datacenter
    with_relationship_type('ems_metadata') do
      detect_ancestor(:of_type => 'EmsFolder') { |a| a.kind_of?(Datacenter) }
    end
  end
end
