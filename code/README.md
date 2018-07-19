.  
|-- ansible  
|   |-- bastion.yml  
|   |-- group_vars  
|   |   `-- webserver.yml  
|   |-- hostfile  
|   |-- roles  
|   |   |-- common  
|   |   |   |-- defaults  
|   |   |   |   `-- main.yml  
|   |   |   |-- files  
|   |   |   |-- handlers  
|   |   |   |   `-- main.yml  
|   |   |   |-- meta  
|   |   |   |   `-- main.yml  
|   |   |   |-- README.md  
|   |   |   |-- tasks  
|   |   |   |   |-- apt.yml  
|   |   |   |   |-- hostname.yml  
|   |   |   |   `-- main.yml  
|   |   |   |-- templates  
|   |   |   |-- tests  
|   |   |   |   |-- inventory  
|   |   |   |   `-- test.yml  
|   |   |   `-- vars  
|   |   |       `-- main.yml  
|   |   `-- nginx  
|   |       |-- defaults  
|   |       |   `-- main.yml  
|   |       |-- handlers  
|   |       |   `-- main.yml  
|   |       |-- meta  
|   |       |   `-- main.yml  
|   |       |-- README.md  
|   |       |-- tasks  
|   |       |   `-- main.yml  
|   |       `-- templates  
|   |           `-- etc  
|   |               `-- nginx  
|   |                   |-- nginx.conf.j2  
|   |                   `-- sites-available  
|   |                       `-- default.conf.j2  
|   `-- webserver.yml  
|-- README.md  
`-- terraform-vpc  
    |-- main.tf  
    |-- modules  
    |   |-- bastion  
    |   |   |-- aws-jumphost.tf  
    |   |   `-- userdata-jumphost.sh  
    |   |-- elb  
    |   |   `-- aws-elb.tf  
    |   |-- nat  
    |   |   `-- aws-nat.tf  
    |   |-- routes  
    |   |   |-- private  
    |   |   |   `-- aws-routing-tables.tf  
    |   |   `-- public  
    |   |       `-- aws-routing-tables.tf  
    |   |-- subnets  
    |   |   `-- aws-subnets.tf  
    |   |-- vpc  
    |   |   `-- aws-vpc.tf  
    |   `-- webserver  
    |       |-- aws-webserver.tf  
    |       `-- userdata.sh  
    |-- provider-credentials.tfvars  
    |-- README.md  
    |-- variables.tf  
    `-- variables.tfvars  
