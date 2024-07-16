# grabbing external ip of tfc

# Learn our public IP address
data "http" "icanhazip" {
   url = "http://icanhazip.com"
}

output "public_ip" {
  value = "${chomp(data.http.icanhazip.body)}"
}