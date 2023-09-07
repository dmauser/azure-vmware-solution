# Parameters (make changes based on your requirements)
rg=lab-svh-avsdr
vwanname=svh-avsdr #set vWAN name
hub1name=sechub1 #set Hub1 name
hub2name=sechub2 #set Hub2 name
region1=$(az network vhub show -n $hub1name -g $rg --query location -o tsv)
region2=$(az network vhub show -n $hub2name -g $rg --query location -o tsv)

#ExpressRoute specific variables
ername1="er-ckt-$hub1name"
ername2="er-avs-$hub1name" 
ername3="er-ckt-$hub2name"
ername4="er-avs-$hub2name" 

# Dump ExpressRoute Circuit routes
echo "***** On-prem ER Circuit Routes *****" && \
az network express-route list-route-tables --path primary -n $ername1 -g $rg  --peering-name AzurePrivatePeering --query value -o table --only-show-errors && \
echo "***** AVS Prod ER Circuit Routes *****" && \
az network express-route list-route-tables --path primary -n $ername2 -g $rg  --peering-name AzurePrivatePeering --query value -o table --only-show-errors && \
echo "***** AVS DR ER Circuit Routes *****" && \
az network express-route list-route-tables --path primary -n $ername4 -g $rg  --peering-name AzurePrivatePeering --query value -o table --only-show-errors


# SSH Spoke1vm to Spoke2vm
ssh azureuser@20.127.9.198