        Clear-AzContext
	Connect-AzAccount
	
	#Make sure that I run this command against the VMs in the right Subscription
	$SubscriptionID= "a8108c2b-496c-424d-8347-ecc8afb6384c"
		
	Set-AzContext -Subscription $SubscriptionID
	
	
	$ConnectionAssetName = "AzureRunAsConnection"
	$ConnectionFieldValues = @{"ApplicationId" = $Application.ApplicationId; "TenantId" = $TenantID.TenantId; "CertificateThumbprint" = $Cert.Thumbprint; "SubscriptionId" = $SubscriptionId}
	New-AzureRmAutomationConnection -ResourceGroupName "ShiraStorageAccount-rg" -AutomationAccountName "shiraAutomationAccount" -Name $ConnectionAssetName -ConnectionTypeName AzureServicePrincipal -ConnectionFieldValues $ConnectionFieldValues 
		
	$ResourceGroupName= "ShiraStorageAccount-rg"
        $srcStorageAccountName = "shirastorageaccount0a"
	$destStorageAccountName = "shirastorageaccount0b"
        $srcStorageAccountContext = (Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $srcStorageAccountName).Context
        $destStorageAccountContext = (Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $destStorageAccountName).Context
        $srcContainer = "sourcecontainer"
        $destContainer = "destcontainer"

        #Create source and destination container
        New-AzStorageContainer -Name $srcContainer -Context $srcStorageAccountContext -Permission blob
        New-AzStorageContainer -Name $destContainer -Context $destStorageAccountContext -Permission blob
        
        $srcStorageKey = Get-AzStorageAccountKey -Name $srcStorageAccountName `
                                          -ResourceGroupName $ResourceGroupName 
        $srcContext = New-AzStorageContext -StorageAccountName $srcStorageAccountName `
                                    -StorageAccountKey $srcStorageKey.Value[0] 
      #Upload 100 blobs
      Get-ChildItem -Path C:\Users\shira.zadok\Desktop\100Blobs | Set-AzStorageBlobContent -Container $srcContainer `
      -Context $srcContext -Force
