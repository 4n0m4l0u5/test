# This will create and configure nginx web server in aws

Ec2_securitygroup {
  region => 'us-east-1',
}

Ec2_instance {
  region            => 'us-east-1',
  availability_zone => 'us-east-1a',
}

Ec2_vpc {
  region => 'us-east-1',
}

Ec2_vpc_subnet {
  region => 'us-east-1',
  availability_zone => 'us-east-1a',
}



ec2_vpc { 'cc-stelligent-mini-proj-vpc':
  ensure     => present,
  region     => 'us-east-1',
  cidr_block => '10.0.0.0/24',
  tags       => {
    created-by => 'puppet aws module',
  },
}

ec2_vpc_subnet { 'cc-stelligent-mini-proj-subnet':
  ensure                  => present,
  region                  => 'us-east-1',
  cidr_block              => '10.0.0.0/24',
  availability_zone       => 'us-east-1a',
  map_public_ip_on_launch => true,
  vpc                     => 'cc-stelligent-mini-proj-vpc,
  tags                    => {
    created-by => 'puppet aws module',
  },
}

ec2_securitygroup { 'cc-stelligent-mini-proj-sg':
  ensure      => present,
  region      => 'us-east-1',
  vpc         => 'cc-stelligent-mini-proj-vpc',
  description => 'cc-stelligent-mini-proj-sg',
  ingress     => [{
    protocol  => 'tcp',
    port      => 80,
    cidr      => '0.0.0.0/0',
  }],
  tags        => {
    created-by => 'puppet aws module',
  },
}

ec2_instance { 'cc-stelligent-mini-proj-inst':
  ensure          => present,
  region          => 'us-east-1',
  image_id        => 'ami-a4dc46db'
  subnet          => 'cc-stelligent-mini-proj-subnet'
  vpc             => 'cc-stelligent-mini-proj-vpc',
  security_groups => ['cc-stelligent-mini-proj-sg'],
  instance_type   => 't2.micro',
  monitoring      => true,
  tenancy         => 'default',
  user_data       => scripts('install-nginx.sh'),
  tags            => {
    created-by    => 'puppet aws module',
  },
  block_devices   => [
    {
    device_name           => '/dev/sda1',
    volume_size           => 8,
    delete_on_termination => 'true',
    volume_type          => 'gp2',
    }
  ]
}
