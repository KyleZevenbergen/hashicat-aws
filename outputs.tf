# Outputs file
output "hashidog_url" {
  value = "http://${aws_eip.hashidog.public_dns}"
}

output "hashidog_ip" {
  value = "http://${aws_eip.hashidog.public_ip}"
}
