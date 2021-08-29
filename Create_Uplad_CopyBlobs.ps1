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

#Create source and destination containers
Try
{
   $containerSrcCheck = Get-AzStorageContainer -Context $srcStorageAccountContext
   $containerDestCheck = Get-AzStorageContainer -Context $destStorageAccountContext
}
Catch
{
    # Catch any error
    #The containers are exist
}
Finally
{
    if(($containerSrcCheck -eq $null) -and ($containerDestCheck -eq $null)){
        New-AzStorageContainer -Name $srcContainer -Context $srcStorageAccountContext -Permission blob
        New-AzStorageContainer -Name $destContainer -Context $destStorageAccountContext -Permission blob
    }
}
        
$srcStorageKey = Get-AzStorageAccountKey -Name $srcStorageAccountName `
-ResourceGroupName $ResourceGroupName 
$srcContext = New-AzStorageContext -StorageAccountName $srcStorageAccountName `
-StorageAccountKey $srcStorageKey.Value[0] 
#Upload 100 blobs
Get-ChildItem -Path C:\Users\shira.zadok\Desktop\100Blobs | Set-AzStorageBlobContent -Container $srcContainer `
-Context $srcContext -Force
#$sourcecontainerContext = New-AzStorageContainerSASToken -Context $srcStorageAccountContext -Name sourcecontainer -Permission racwdl -FullUri
#$destcontainerContext = New-AzStorageContainerSASToken -Context $destStorageAccountContext -Name destcontainer -Permission racwdl -FullUri
#Copy 100 blob
#azcopy copy $sourcecontainerContext $destcontainerContext --recursive
azcopy copy "https://shirastorageaccount0a.blob.core.windows.net/sourcecontainer?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacuptfx&se=2021-08-29T20:27:37Z&st=2021-08-29T12:27:37Z&spr=https&sig=iA%2FgcL8U55D2J%2FFGyichLvNX572KfvlKktizV6rZl4I%3D" "https://shirastorageaccount0b.blob.core.windows.net/destcontainer?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacuptfx&se=2021-10-31T21:25:13Z&st=2021-08-29T12:25:13Z&spr=https&sig=G1iul%2Btlgy78yboQlfBMd7XyLJZTqsLA5DVHr8BnXF0%3D" --recursive
