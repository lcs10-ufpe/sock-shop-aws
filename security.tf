resource "aws_security_group" "allow_ssh"  {
    vpc_id = aws_vpc.main.id
    name = "test_allow_ssh"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_public_ip]
    }
}

resource "aws_security_group" "allow_outbound" {
    vpc_id = aws_vpc.main.id
    name = "test_allow_outbound"

    egress {
       from_port = 0
       to_port = 0
       protocol = "-1"
       cidr_blocks = ["0.0.0.0/0"] 
    }
}

resource "aws_security_group" "allow_kube" {
    vpc_id = aws_vpc.main.id
    name = "test_allow_kube"

    ingress {
       from_port = 6443
       to_port = 6443
       protocol = "tcp"
       cidr_blocks = ["0.0.0.0/0"] 
    }
}

resource "aws_security_group" "allow_application" {
    vpc_id = aws_vpc.main.id
    name = "test_allow_application"

    ingress {
       from_port = 8080
       to_port = 8080
       protocol = "tcp"
       cidr_blocks = [var.my_public_ip]  
    }

    ingress {
       from_port = 80
       to_port = 80
       protocol = "tcp"
       cidr_blocks = [var.my_public_ip]  
    }

    ingress {
       from_port = 30001
       to_port = 30001
       protocol = "tcp"
       cidr_blocks = [var.my_public_ip]  
    }

    ingress {
       from_port = 8079
       to_port = 8079
       protocol = "tcp"
       cidr_blocks = [var.my_public_ip]  
    }

}