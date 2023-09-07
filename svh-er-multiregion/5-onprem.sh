# AVS Hub1
# Define your variables
project=angular-expanse-327722 #Set your project Name. Get your PROJECT_ID use command: gcloud projects list 
region=us-central1 #Set your region. Get Regions/Zones Use command: gcloud compute zones list
zone=us-central1-b # Set availability zone: a, b or c.
vpcrange=10.10.0.0/24
envname=avs-hub1-lab
vmname=vm1
mypip=$(curl -4 ifconfig.io -s) #Gets your Home Public IP or replace with that information. It will add it to the Firewall Rule.

#Create VPC + Subnet
gcloud config set project $project
gcloud compute networks create $envname-vpc --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional
gcloud compute networks subnets create $envname-subnet --range=$vpcrange --network=$envname-vpc --region=$region

#Create Firewall Rule
gcloud compute firewall-rules create $envname-allow-traffic-from-azure --network $envname-vpc --allow tcp,udp,icmp --source-ranges 192.168.0.0/16,10.0.0.0/8,172.16.0.0/16,35.235.240.0/20,$mypip/32

#Create Unbutu VM:
gcloud compute instances create $envname-vm1 --zone=$zone --machine-type=f1-micro --network-interface=subnet=$envname-subnet,network-tier=PREMIUM --image=ubuntu-1804-bionic-v20220126 --image-project=ubuntu-os-cloud --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=$envname-vm1 
#gcloud compute instances create $envname-vm1 --zone=$zone --machine-type=f1-micro --network-interface=subnet=$envname-subnet,network-tier=PREMIUM --image-family=ubuntu-1804-lts-arm64 --image-project=ubuntu-os-cloud --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=$envname-vm1 

#Cloud Router: #***********Validate************
gcloud compute routers create $envname-router --region=$region --network=$envname-vpc --asn=16550

#DirectConnect via MegaPort:
gcloud compute interconnects attachments partner create $envname-vlan --region $region --edge-availability-domain availability-domain-1 --router $envname-router --admin-enabled


#Route propagation
bgpsession=$(gcloud compute routers describe $envname-router --region=$region --format='value(bgpPeers.name)')
gcloud compute routers update-bgp-peer $envname-router \
 --peer-name $bgpsession \
 --advertisement-mode custom \
 --set-advertisement-ranges 10.10.0.0/25,10.10.128.0/25 \
 --set-advertisement-groups=ALL_SUBNETS \
 --region=$region


# AVS Hub2
# Define your variables
project=angular-expanse-327722 #Set your project Name. Get your PROJECT_ID use command: gcloud projects list 
region=us-central1 #Set your region. Get Regions/Zones Use command: gcloud compute zones list
zone=us-central1-b # Set availability zone: a, b or c.
vpcrange=10.20.0.0/24
envname=avs-hub2-lab
vmname=vm1
mypip=$(curl -4 ifconfig.io -s) #Gets your Home Public IP or replace with that information. It will add it to the Firewall Rule.

#Create VPC + Subnet
gcloud config set project $project
gcloud compute networks create $envname-vpc --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional
gcloud compute networks subnets create $envname-subnet --range=$vpcrange --network=$envname-vpc --region=$region

#Create Firewall Rule
gcloud compute firewall-rules create $envname-allow-traffic-from-azure --network $envname-vpc --allow tcp,udp,icmp --source-ranges 192.168.0.0/16,10.0.0.0/8,172.16.0.0/16,35.235.240.0/20,$mypip/32

#Create Unbutu VM:
gcloud compute instances create $envname-vm1 --zone=$zone --machine-type=f1-micro --network-interface=subnet=$envname-subnet,network-tier=PREMIUM --image=ubuntu-1804-bionic-v20220126 --image-project=ubuntu-os-cloud --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=$envname-vm1 
#gcloud compute instances create $envname-vm1 --zone=$zone --machine-type=f1-micro --network-interface=subnet=$envname-subnet,network-tier=PREMIUM --image-family=ubuntu-1804-lts-arm64 --image-project=ubuntu-os-cloud --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=$envname-vm1 

#Cloud Router: #***********Validate************
gcloud compute routers create $envname-router --region=$region --network=$envname-vpc --asn=16550

#DirectConnect via MegaPort:
gcloud compute interconnects attachments partner create $envname-vlan --region $region --edge-availability-domain availability-domain-1 --router $envname-router --admin-enabled

#Route propagation
bgpsession=$(gcloud compute routers describe $envname-router --region=$region --format='value(bgpPeers.name)')
gcloud compute routers update-bgp-peer $envname-router \
 --peer-name $bgpsession \
 --advertisement-mode custom \
 --set-advertisement-ranges 10.20.0.0/25,10.20.128.0/25 \
 --region=$region

# On-prem DAL
project=angular-expanse-327722 #Set your project Name. Get your PROJECT_ID use command: gcloud projects list 
region=us-central1 #Set your region. Get Regions/Zones Use command: gcloud compute zones list
zone=us-central1-b # Set availability zone: a, b or c.
vpcrange=10.154.0.0/24
envname=onprem-dal
vmname=vm1
mypip=$(curl -4 ifconfig.io -s) #Gets your Home Public IP or replace with that information. It will add it to the Firewall Rule.

#Create VPC + Subnet
gcloud config set project $project
gcloud compute networks create $envname-vpc --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional
gcloud compute networks subnets create $envname-subnet --range=$vpcrange --network=$envname-vpc --region=$region

#Create Firewall Rule
gcloud compute firewall-rules create $envname-allow-traffic-from-azure --network $envname-vpc --allow tcp,udp,icmp --source-ranges 192.168.0.0/16,10.0.0.0/8,172.16.0.0/16,35.235.240.0/20,$mypip/32

#Create Unbutu VM:
gcloud compute instances create $envname-vm1 --zone=$zone --machine-type=f1-micro --network-interface=subnet=$envname-subnet,network-tier=PREMIUM --image=ubuntu-1804-bionic-v20220126 --image-project=ubuntu-os-cloud --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=$envname-vm1 
#gcloud compute instances create $envname-vm1 --zone=$zone --machine-type=f1-micro --network-interface=subnet=$envname-subnet,network-tier=PREMIUM --image-family=ubuntu-1804-lts-arm64 --image-project=ubuntu-os-cloud --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=$envname-vm1 

#Cloud Router: #***********Validate************
gcloud compute routers create $envname-router --region=$region --network=$envname-vpc --asn=16550

#DirectConnect via MegaPort:
gcloud compute interconnects attachments partner create $envname-vlan --region $region --edge-availability-domain availability-domain-1 --router $envname-router --admin-enabled


# Access VMs
gcloud compute ssh $envname-vm1 --zone=$zone


# Cleanup
gcloud compute interconnects attachments delete $envname-vlan --region $region --quiet 
gcloud compute routers delete $envname-router --region=$region --quiet
gcloud compute instances delete $envname-vm1 --zone=$zone --quiet
gcloud compute firewall-rules delete $envname-allow-traffic-from-azure --quiet
gcloud compute networks subnets delete $envname-subnet --region=$region --quiet
gcloud compute networks delete $envname-vpc --quiet

