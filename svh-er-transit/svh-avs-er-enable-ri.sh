#Parameters
region=eastus
rg=lab-svh-avs # set your Resource Group
vwanname=svh-avs # vWAN name
hubname=svhub # vHub name
riconfig=PrivateOnly #Routing Intenet configuration, valid parametersare: privateonly, internetonly or both.

if [ "$riconfig" = "both" ]; then
 config=Private-and-Internet
elif [ "$riconfig" = "InternetOnly" ]; then
 config=InternetOnly
elif [ "$riconfig" = "PrivateOnly" ]; then
 config=PrivateOnly
fi

echo $config
#Enabling Secured-vHUB + Routing intent
echo "Enabling Secured-vHUB + Routing Intent" $config
nexthophub1=$(az network vhub show -g $rg -n $hubname --query azureFirewall.id -o tsv)
az deployment group create --name $hubname-ri \
--resource-group $rg \
--template-uri https://raw.githubusercontent.com/dmauser/azure-virtualwan/main/svh-ri-intra-region/bicep/main.json \
--parameters scenarioOption=$config hubname=$hubname nexthop=$nexthophub1 \
--no-wait

sleep 10
subid=$(az account list --query "[?isDefault == \`true\`].id" --all -o tsv)
prState=''
while [[ $prState != 'Succeeded' ]];
do
    prState=$(az rest --method get --uri /subscriptions/$subid/resourceGroups/$rg/providers/Microsoft.Network/virtualHubs/$hubname/routingIntent/$hubname_RoutingIntent?api-version=2022-01-01 --query 'value[].properties.provisioningState' -o tsv)
    echo "$hubname routing intent provisioningState="$prState
    sleep 5
done



