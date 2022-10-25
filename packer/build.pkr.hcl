build {
  sources = [
    "source.amazon-ebs.builder",
  ]

  provisioner "ansible" {
    groups = [ "${var.configuration_group}" ]
    playbook_file = "${var.playbook_file_path}"
    extra_arguments  = [
      "-e", "aws_region=${var.aws_region}",
      "-e", "resource_bucket_name=${var.resource_bucket_name}",
      "-e", "resource_bucket_prefix=${var.resource_bucket_prefix}",
      "-e", "force_delete_snapshot=${var.force_delete_snapshot}",
      "-e", "force_deregister=${var.force_deregister}"
    ]
  }
}
