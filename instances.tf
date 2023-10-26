resource "aws_key_pair" "keypair" {
	public_key = file("key/demo_key.pub")
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.instances.*.id[0]
  public_ip = "54.88.102.1"
}

resource "aws_instance" "instances" {
	count = 1

	ami = "ami-0323c3dd2da7fb37d"
	instance_type = "t2.xlarge"
	subnet_id = element(aws_subnet.public_subnet.*.id, count.index)
	key_name = aws_key_pair.keypair.key_name

	vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_outbound.id, aws_security_group.allow_application.id, aws_security_group.allow_kube.id]
	
	tags = {
    	Name = "test_instances"
  	}
}

data "template_file" "hosts" {
	template = file("./template/hosts.tpl")

	vars = {
		PUBLIC_IP_0 = aws_instance.instances.*.public_ip[0]
	}
}

resource "local_file" "hosts" {
  content = data.template_file.hosts.rendered
  filename = "./hosts"
}

output "public_ips" {
  value = join(", ", aws_instance.instances.*.public_ip)
}
