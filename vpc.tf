provider "aws" {

    gerion          = "ap-south-1"
    access_key      = ""
    secret_key      = ""
}
resource "aws_vpc" "demo-vpc"{

    cidr_block        = "10.0.0.0/16"
    instance_tenancy  = "default"

    tags = {
          
           Name = "myfirst-vpc"
           
    }
}
resource "aws_subnet" "public" {

    vpc_id         = aws_vpc.demo-vpc.id
    cidr_block     = "10.0.1.0/24"

    tags = {

           Name = "public-subnet"
    }

}
resource "aws_subnet" "private" {

    vpc_id        = aws_vpc.demo-vpc.id
    cidr_block    = "10.0.2.0/24"

    tags = {

           Name = "private-subnet"
    }
}
resource "aws_internet_gateway" "gateway-01" {

    vpc_id       = aws_vpc.demo-vpc.id

    tags = {

           Name = "my-first-IGW"
    }
}
resource "aws_eip" "elastic" {

    vpc   = true

}
resource "aws_nat_gateway" "gateway-02" {

    allocation_id      = aws_eip.elastic.id
    subnet_id          = aws_subnet.private.id

    tags = {

           Name = "Myfirst-nat"
    }

}
resource "aws_route_table" "route-01" {

    vpc_id        = aws_vpc.demo-vpc.id

    route {

        cidr_block     = "0.0.0.0/0"
        gateway_id     = aws_internet_gateway.gateway-01.id
    }
        tags = {

            Name = "cutom-routes"
     }
 
 }  

 resource "aws_route_table" "route-02" {

    vpc_id        = aws_vpc.demo-vpc.id

    route {

        cidr_block     = "0.0.0.0/0"
        gateway_id     = aws_nat_gateway.gateway-02.id
    }
        tags = {

            Name = "main-route"
     }
 
 }  
 resource "aws_route_table_association" "example" {

    subnet_id       = aws_subnet.public.id
    rouet_table_id  = aws_route_table.route-01.id

 }
 
 resource "aws_route_table_association" "example-1" {

    subnet_id       = aws_subnet.private.id
    rouet_table_id  = aws_route_table.route-02.id

 }
 resource "aws_security_group" "my-sg" {

    name            = "first-security-group"
    description     = "Allow TLS inbound traffic"
    vpc_id          = aws_vpc.demo-vpc.id

    ingress {
      
        description    = "TLS from vpc"
        from_port      = 22
        to_port        = 22
        protocol       = "tcp"
        cidr_blocks    = [aws_vpc.demo-vpc.cidr_block]
    }

    egress {

        from_port     = 0
        to_port       = 0
        protocol      = "-1"
        cidr_blocks    = ["0.0.0.0/0"]
    }

    tags = {
          
         Name = "first-security-group"

    }

}
 
     
