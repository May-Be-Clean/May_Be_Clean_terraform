resource "aws_elastic_beanstalk_environment" "api" {
  application         = var.application_name
  name                = local.name_prefix
  solution_stack_name = "64bit Amazon Linux 2 v3.4.7 running Corretto 17"
  tier                = "WebServer"

  // Setup networks
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
    resource  = ""
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value = join(",", sort([
      aws_subnet.private-a.id,
      aws_subnet.private-c.id,
    ]))
    resource = ""
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", sort(var.public-subnet-ids))
    resource  = ""
  }

  // Setup deployment policy
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = var.deployment_policy
    resource  = ""
  }

  // Configure rolling deploy and update type if deployment policy is rolling
  dynamic "setting" {
    for_each = var.deployment_policy == "RollingWithAdditionalBatch" || var.deployment_policy == "Rolling" ? [
      {
        namespace = "aws:elasticbeanstalk:command"
        name      = "BatchSizeType"
        value     = "Percentage"
      },
      {
        namespace = "aws:elasticbeanstalk:command"
        name      = "BatchSize"
        value     = "50"
      },
      {
        namespace = "aws:autoscaling:updatepolicy:rollingupdate"
        name      = "RollingUpdateType"
        value     = "Health"
      },
      {
        namespace = "aws:autoscaling:updatepolicy:rollingupdate"
        name      = "RollingUpdateEnabled"
        value     = "true"
      },
    ] : []

    content {
      namespace = setting.value["namespace"]
      name      = setting.value["name"]
      value     = setting.value["value"]
    }
  }

  // Setup Elastic Load Balancer Autoscaling
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = var.load_balancer_auto_scaling_min_size
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = var.load_balancer_auto_scaling_max_size
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MeasureName"
    value     = "CPUUtilization"
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Unit"
    value     = "Percent"
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerThreshold"
    value     = "20"
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperThreshold"
    value     = "50"
    resource  = ""
  }

  // Setup security group
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.instances.id
    resource  = ""
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups"
    value     = aws_security_group.load_balancer.id
    resource  = ""
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "ManagedSecurityGroup"
    value     = aws_security_group.load_balancer.id
    resource  = ""
  }

  // HTTPS
  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "Protocol"
    value     = "HTTPS"
    resource  = ""
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "SSLCertificateArns"
    value     = var.certificate_arn
    resource  = ""
  }

  // Load balancer health check
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    resource  = ""
    value     = var.load_balancer_health_check_path
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    resource  = ""
    value     = "200"
  }

  // Disable HTTP
  setting {
    namespace = "aws:elbv2:listener:default"
    name      = "ListenerEnabled"
    value     = "false"
    resource  = ""
  }

  // Log
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "true"
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "RetentionInDays"
    value     = "30"
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:hostmanager"
    name      = "LogPublicationControl"
    value     = "true"
    resource  = ""
  }

  // Role
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.web_instance_profile
    resource  = ""
  }

  // Environment variables for spring
  dynamic "setting" {
    for_each = [
      {
        name  = "DEV"
        value = local.is_main ? "0" : "1"
      },
      {
        name  = "spring_profiles_active"
        value = var.environment
      },
      { // Enable TLS 1.0 and 1.1 for legacy hospital databases
        name  = "JAVA_TOOL_OPTIONS"
        value = "-Djava.security.properties=\"java/security/enableLegacyTLS.security\""
      },
      {
        name = "DATASOURCE_URL",
        value = "jdbc:mariadb://may-be-clean-develop-database-primary.cluster-cuhxyhjtupdm.ap-northeast-2.rds.amazonaws.com:3306/may_be_clean"
      },
      {
        name = "DATASOURCE_USERNAME",
        value = "root"
      },
      {
        name = "DATASOURCE_PASSWORD",
        value = "z3xgGfViVcqWxmzXFpDe40H9ajUAQRBA"
      }
    ]

    content {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = setting.value["name"]
      value     = setting.value["value"]
    }
  }

  // Instances
  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = var.backend_instance
    resource  = ""
  }

  // Root storage
  dynamic "setting" {
    for_each = local.is_main ? [
      {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "RootVolumeType"
        value     = "gp2"
      },
      {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "RootVolumeSize"
        value     = "50"
      },
    ] : []

    content {
      namespace = setting.value["namespace"]
      name      = setting.value["name"]
      value     = setting.value["value"]
    }
  }
}
