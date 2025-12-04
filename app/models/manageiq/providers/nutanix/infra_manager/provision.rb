class ManageIQ::Providers::Nutanix::InfraManager::Provision < ::MiqProvision
  include Placement
  include StateMachine

  VALID_REQUEST_TYPES = %w[template]
  validates_inclusion_of :request_type, :in => VALID_REQUEST_TYPES, :message => "should be one of: #{VALID_REQUEST_TYPES.join(', ')}"
end
