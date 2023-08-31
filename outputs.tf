output "security_group_id" {
  value       = aws_security_group.cluster.id
}

output "eip_id" {
  value       = aws_eip.cluster_eip.id
}

output "eip_public_ip" {
  description = "Contains the public IP address"
  value       = aws_eip.cluster_eip.public_ip
}