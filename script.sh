    #!/bin/bash

    read -p "Nom du Resource Group : " resourceGroup
    read -p "Nom de l'utilisateur pour !!TOUTES!! les machines" username
    read -p "Combien de VMs créer" vmNumber
    read -p "Voulez vous nommez vos VMs? y/n" vmBool 


    echo $resourceGroup

    i=1
    vmNAME="placeholder"

    while [ $i -le $vmNumber ]; do
        if [[ $vmBool == "n" || $vmBool == "N" ]]; then
            vmNAME="VM-$RANDOM-$RANDOM"
        else
            read -p "Veuillez choisir le nom de votre VM" vmNAME
        fi
        
        if [ $i -eq 1 ]; then
            ip_param="--public-ip-sku Standard"
        else
            ip_param="--public-ip-address """
        fi

        az vm create --resource-group $resourceGroup --name $vmNAME --admin-username $username --size Standard_B1s --image Ubuntu2404 --ssh-key-value ~/.ssh/cloud_tp.pub $ip_param

        ((i++))
    done