class ManageIQ::Providers::Nutanix::Inventory::Persister < ManageIQ::Providers::Inventory::Persister
  def initialize_inventory_collections
    super

    # Core collections
    add_collection(infra, :vms)
    add_collection(infra, :hosts)
    add_collection(infra, :host_storages)
    add_collection(infra, :clusters)
    add_collection(infra, :ems_folders)
    # Hardware and devices
    add_collection(infra, :hardwares)
    add_collection(infra, :host_hardwares)
    add_collection(infra, :storages)
    add_collection(infra, :disks)
    add_collection(infra, :guest_devices)
    add_collection(infra, :networks)
    add_collection(infra, :operating_systems)
    add_collection(infra, :miq_templates)
    # Relationships
    add_collection(infra, :parent_blue_folders)
    add_collection(infra, :vm_parent_blue_folders)
    add_collection(infra, :vm_resource_pools)
    add_collection(infra, :root_folder_relationship)
  end
end
