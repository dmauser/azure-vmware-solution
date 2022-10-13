# Azure VMware Solution

Articles and labs

### LAB: AVS (ER) to On-prem (ER) transit using Secured-vhub+Routing Intent

Deployment script: 
```bash
wget -O svh-avs-er-deploy.sh https://raw.githubusercontent.com/dmauser/azure-vmware-solution/main/svh-er-transit/svh-avs-er-deploy.azcli
chmod +xr svh-avs-er-deploy.sh
./svh-avs-er-deploy.sh
```

#### Considerations:

- ExpressRoute Circuits are not created as part of this lab.
- After connecting the AVS ExpressRoute Circuit go to Firewall Manager - Security Configuration and enabled secure Internet Traffic to allow the default route (0.0.0.0./0) to get advertised to the AVS environment.
