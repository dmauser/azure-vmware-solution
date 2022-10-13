# Azure VMware Solution

Articles and labs

### LAB: AVS (ER) to On-prem (ER) transit using Secured-vhub+Routing Intent

Lab deployment script: 
```bash
wget -O svh-avs-er-deploy.sh https://raw.githubusercontent.com/dmauser/azure-vmware-solution/main/svh-er-transit/svh-avs-er-deploy.azcli
chmod +xr svh-avs-er-deploy.sh
./svh-avs-er-deploy.sh
```

#### Network diagram: (TBD)

#### Considerations

- ExpressRoute Circuits are not created as part of this lab.
- After connecting the AVS ExpressRoute Circuit go to Firewall Manager - Security Configuration and enabled secure Internet Traffic to allow the default route (0.0.0.0./0) to get advertised to the AVS environment.
- Add AVS /22 prefix inside the Private traffic prefixes.

#### Notes from the field

- Review carefully all the considerations when enabling Routing Policies/Intent by reviewing [Virtual WAN Hub routing intent and routing policies - Troubleshooting data path](https://learn.microsoft.com/en-us/azure/virtual-wan/how-to-routing-policies#troubleshooting). Especially RFC 1918 prefixes (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16) which are advertised by default from Secured-vHUB. Additionally, routing adjustment has to be done before enabling Routing-Intent in case the On-premises expressroute circuit already advertise those prefixes.
- Always onboard ExpressRoute circuits (including On-premises) after converting Secured-vHub and enabling Routing Policies/Intent. That will give you granular control on securing Internet traffic (the default route 0/0 advertisement). Otherwise, converting after it will have the default route (0.0.0.0/0) advertised to all connections.

