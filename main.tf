#Module      : LABELS
#Description : This terraform module is designed to generate consistent label names and tags
#              for resources. You can use terraform-labels to implement a strict naming
#              convention.
module "labels" {
  source = "git::https://github.com/aashishgoyal246/terraform-labels.git?ref=tags/0.13.0"

  name        = var.name
  application = var.application
  environment = var.environment
  enabled     = var.enabled
  label_order = var.label_order
  tags        = var.tags
}

#Module      : CLOUDWATCH METRIC ALARM 
#Description : Terraform module to create cloudwatch metric alarm resource on AWS.
resource "aws_cloudwatch_metric_alarm" "default" {
  for_each = var.metric_alarms

  alarm_name          = format("%s-%s", module.labels.id, each.key)
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = each.value.metric_name
  namespace           = each.value.namespace
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  alarm_actions       = each.value.alarm_actions
  
  dimensions          = each.value.dimensions

}