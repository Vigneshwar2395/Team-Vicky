#Make sure that I run this command against the VMs in the right Subscription
$SubscriptionID= "a8108c2b-496c-424d-8347-ecc8afb6384c"
		
Set-AzContext -Subscription $SubscriptionID
	
$ResourceGroupName= "ShiraStorageAccount-rg"
$srcStorageAccountName = "shirastorageaccount0a"
$destStorageAccountName = "shirastorageaccount0b"
$srcStorageAccountContext = (Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $srcStorageAccountName).Context
$destStorageAccountContext = (Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $destStorageAccountName).Context
$srcContainer = "sourcecontainer"
$destContainer = "destcontainer"
#Create source and destination container
#New-AzStorageContainer -Name $srcContainer -Context $srcStorageAccountContext -Permission blob
#New-AzStorageContainer -Name $destContainer -Context $destStorageAccountContext -Permission blob
        
$srcStorageKey = Get-AzStorageAccountKey -Name $srcStorageAccountName `
                 -ResourceGroupName $ResourceGroupName 
$srcContext = New-AzStorageContext -StorageAccountName $srcStorageAccountName `
              -StorageAccountKey $srcStorageKey.Value[0] 
#Upload 100 blobs
Get-ChildItem -Path C:\Users\shira.zadok\Desktop\100Blobs | Set-AzStorageBlobContent -Container $srcContainer `
-Context $srcContext -Force

#Copy 100 blob
azcopy copy "https://shirastorageaccount0a.blob.core.windows.net/sourcecontainer?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacuptfx&se=2021-10-31T10:03:46Z&st=2021-08-29T01:03:46Z&spr=https&sig=dAXc8MNHpgNnrAbiqtGM7GGMdLpoixmUKfyKSBatWZc%3D" "https://shirastorageaccount0b.blob.core.windows.net/destcontainer?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacuptfx&se=2021-10-31T10:02:16Z&st=2021-08-29T01:02:16Z&spr=https&sig=ik5acirjGtqsFl%2Fn566Nx5ntLh3BTMY8VCi60j6iqFA%3D" --recursive
