# Output the public IP of the EC2 instance
output "instance_public_ip" {
  value = aws_instance.Web.public_ip
}