# fleet


resource "aws_appstream_fleet" "main" {
  name = var.app_name

  compute_capacity {
    desired_instances = 1
  }

  description                        = "test fleet"
  idle_disconnect_timeout_in_seconds = 60 * 15
  disconnect_timeout_in_seconds      = 60 * 15
  display_name                       = "test-fleet"
  enable_default_internet_access     = false
  fleet_type                         = "ON_DEMAND"
  image_name                         = "Amazon-AppStream2-Sample-Image-03-11-2023"
  instance_type                      = "stream.standard.small"
  max_user_duration_in_seconds       = 60 * 30

  vpc_config {
    subnet_ids = module.vpc.private_subnets
  }

}

resource "aws_appstream_fleet_stack_association" "main" {
  fleet_name = aws_appstream_fleet.main.name
  stack_name = aws_appstream_stack.main.name
}

# stack

resource "aws_appstream_stack" "main" {
  name         = var.app_name
  description  = var.app_name
  display_name = var.app_name
  #   feedback_url = "http://your-domain/feedback"
  #   redirect_url = "http://your-domain/redirect"

  storage_connectors {
    connector_type = "HOMEFOLDERS"
  }

  application_settings {
    enabled        = true
    settings_group = "SettingsGroup"
  }
  user_settings {
    action     = "CLIPBOARD_COPY_FROM_LOCAL_DEVICE"
    permission = "ENABLED"
  }
  user_settings {
    action     = "CLIPBOARD_COPY_TO_LOCAL_DEVICE"
    permission = "DISABLED"
  }
  #   user_settings {
  #     action     = "DOMAIN_PASSWORD_SIGNIN"
  #     permission = "DISABLED"
  #   }
  #   user_settings {
  #     action     = "DOMAIN_SMART_CARD_SIGNIN"
  #     permission = "DISABLED"
  #   }
  user_settings {
    action     = "FILE_DOWNLOAD"
    permission = "DISABLED"
  }
  user_settings {
    action     = "FILE_UPLOAD"
    permission = "DISABLED"
  }
  user_settings {
    action     = "PRINTING_TO_LOCAL_DEVICE"
    permission = "DISABLED"
  }

  #   tags = {
  #     TagName = "TagValue"
  #   }
}


# enable usage reports
