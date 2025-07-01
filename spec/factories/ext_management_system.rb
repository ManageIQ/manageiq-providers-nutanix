FactoryBot.define do
  factory :ems_nutanix,
          :aliases => ["manageiq/providers/nutanix/infra_manager"],
          :class   => "ManageIQ::Providers::Nutanix::InfraManager",
          :parent  => :ems_infra

  factory :ems_nutanix_with_vcr_authentication, :parent => :ems_nutanix do
    zone       { EvmSpecHelper.local_miq_server.zone }
    hostname   { VcrSecrets.nutanix.hostname }
    port       { VcrSecrets.nutanix.port }
    verify_ssl { 0 }

    after(:create) do |ems|
      ems.authentications << FactoryBot.create(
        :authentication,
        :userid   => VcrSecrets.nutanix.username,
        :password => VcrSecrets.nutanix.password
      )
    end
  end
end
