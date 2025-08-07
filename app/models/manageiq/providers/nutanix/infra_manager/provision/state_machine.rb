module ManageIQ::Providers::Nutanix::InfraManager::Provision::StateMachine
  def create_destination
    signal :determine_placement
  end

  def determine_placement
    host, cluster, datastore = placement

    options[:dest_host]    = [host.id, host.name]       if host
    options[:dest_cluster] = [cluster.id, cluster.name] if cluster
    options[:dest_storage] = [datastore.id, datastore.name]

    signal :start_clone_task
  end

  def start_clone_task
    source.with_provider_connection do |vmm_api_client|
      templates_api = NutanixVmm::TemplatesApi.new(vmm_api_client)

      request_id = SecureRandom.uuid

      override_vm_config = {
        :name => dest_name
      }

      content_template_deployment = {
        :numberOfVms         => 1,
        :overrideVmConfigMap => override_vm_config,
        :clusterReference    => cluster.ems_ref # TODO cluster from options
      }

      response = templates_api.deploy_template(
        ems_ref,
        request_id,
        content_template_deployment
      )

      # TODO verify this response payload
      phase_context[:deploy_task_ref] = response.data.ext_id
    end

    signal :poll_clone_complete
  end

  def poll_clone_complete
    # TODO check if the clone is complete
    task_ext_id = phase_context[:deploy_task_ref]

    task = source.with_provider_connection do |api_client|
      NutanixPrism::TasksApi.new(api_client).get_task_by_id(task_ext_id)
    end

    # TODO update task message with percent complete
    task.progress_percentage

    case task.status
    when "SUCCEEDED"
      new_vm_ems_ref = task.something
      phase_context[:new_vm_ems_ref] = new_vm_ems_ref

      target = InventoryRefresh::Target.new(
        :association => :vms,
        :manager_ref => new_vm_ems_ref,
        :manager     => source.ext_management_system
      )

      EmsRefresh.queue_refresh(target)

      signal :poll_destination_in_vmdb
    when "CANCELED", "FAILED"
      signal_abort
    else
      requeue_phase
    end
  end

  def find_destination_in_vmdb(new_vm_ems_ref)
    source.ext_management_system&.vms_and_templates&.find_by(:ems_ref => new_vm_ems_ref)
  end
end
