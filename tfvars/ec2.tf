
resource "aws_instance" "roboshop" {
  count = length(var.instances)
  ami           = var.ami_id  
  instance_type = "t3.micro"
  vpc_security_group_ids = [  aws_security_group.allow_all.id  ]
  
  tags = merge(
    var.common_tags,
    {
      Name = "${var.instances[count.index]}-${var.environment}",
      Component = var.instances[count.index]
      Environment = var.environment
    }
  )    

}

resource "aws_security_group" "allow_all" {
  name        = "${var.sg_name}-${var.environment}"  # allow-all-dev
  description = var.sg_description

  ingress {
    from_port        = var.from_port
    to_port          = var.to_port
    protocol         = "-1"     
    cidr_blocks      = var.cidr_blocks
    ipv6_cidr_blocks = ["::/0"]
  }

   egress {
    from_port        = var.from_port
    to_port          = var.to_port
    protocol         = "-1"     
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.sg_name}-${var.environment}"
    }
  )
}


#  self mean roboshop only, >private_ip means dani private-ip only, dhanini tisukoni velli inventory ane file create chesi dhanilo save chey ani meaning. 

# so IP-address vachhimdhi, ee ip address tho yemi chesukuntam, you can run ansible play books automatic gha. so terraform ni ansible ni integrate chesukoni..
# Terraform responsible vachhesi server ni create cheyatam varaske, an then once server create chesina taruwata miku ip address vachhimdhi ante,then you can handover this ip-address to Ansible. Appudu ansible aa server ki connect ayye a provisioning chestumdhi. public or private Ip whatever we want, we can give. 

# not only Ip address, manaki nachhina di run chesukovachhu. like Alarts pampimchatamu or yevariki ina info cheyatamu ala... 

# yenni local-exec aaina e vachhu, oka dhani taruwata okati execute avutumdhi.  

# ala ney failure behaviour kuda pettukovachhu, indhak amanam yemi chesamu, adi fail indhi kabatti malli adi first numdhi execute indhi... naku ala vaddu fail ite parledu anukunte on failure = continue ani pedate ipotumdhi. appudu malli recreate avvaadu


