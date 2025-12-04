module ManageIQ::Providers::Nutanix::InfraManager::Provision::Placement
  extend ActiveSupport::Concern

  protected

  def placement
    host, cluster, datastore = get_option(:placement_auto) ? automatic_placement : manual_placement

    raise MiqException::MiqProvisionError, "Destination placement_ds_name not provided" if datastore.nil?
    raise MiqException::MiqProvisionError, "Destination placement_host_name" if host.nil? && cluster.nil?

    return host, cluster, datastore
  end

  private

  def manual_placement
    _log.info("Manual placement...")

    host      = selected_placement_obj(:placement_host_name, Host)
    cluster   = selected_placement_obj(:placement_cluster_name, EmsCluster)
    datastore = selected_placement_obj(:placement_ds_name, Storage)

    if host && cluster.nil?
      cluster = host.ems_cluster
    end

    return host, cluster, datastore
  end

  def automatic_placement
    raise "Automatic Placement not supported yet"
  end

  def selected_placement_obj(key, klass)
    klass.find_by(:id => get_option(key)).tap do |obj|
      _log.info("Using selected #{key} : [#{obj.name}] id : [#{obj.id}]") if obj
    end
  end
end
