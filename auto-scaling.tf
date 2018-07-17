resource "aws_autoscaling_group" "JobAssistASG" {
  name     = "JobAssistASG"
  max_size = 2
  min_size = 1

  # desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  load_balancers            = ["${aws_elb.my_vpc_elb.name}"]
  force_delete              = true
  vpc_zone_identifier       = ["${aws_subnet.webservers.*.id}"]
  launch_configuration      = "${aws_launch_configuration.JobAssistLC-1.name}"
}

# resource "aws_launch_configuration" "JobAssistLC" {
#   name            = "JobAssistLC"
#   image_id        = "${var.web_ami}"
#   instance_type   = "${var.ec2_instance_type}"
#   key_name        = "${var.ec2_keyname}"
#   user_data       = "${file("./scripts/setup_apache.sh")}"
#   security_groups = ["${aws_security_group.web_sg.id}"]
#
#   # iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"
# }

resource "aws_launch_configuration" "JobAssistLC-1" {
  name                 = "JobAssistLC-1"
  image_id             = "${var.web_ami}"
  instance_type        = "${var.ec2_instance_type}"
  key_name             = "${var.ec2_keyname}"
  user_data            = "${file("./scripts/setup_apache.sh")}"
  security_groups      = ["${aws_security_group.web_sg.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"
}

resource "aws_autoscaling_policy" "AddInstancesPolicy" {
  name                   = "AddInstancesPolicy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.JobAssistASG.name}"
}

resource "aws_autoscaling_policy" "RemoveInstancesPolicy" {
  name                   = "RemoveInstancesPolicy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.JobAssistASG.name}"
}

resource "aws_cloudwatch_metric_alarm" "avg_cpu_ge_80" {
  alarm_name          = "avg_cpu_ge_80"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.JobAssistASG.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.AddInstancesPolicy.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "avg_cpu_le_30" {
  alarm_name          = "avg_cpu_le_30"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.JobAssistASG.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.RemoveInstancesPolicy.arn}"]
}
