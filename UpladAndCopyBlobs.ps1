      $ResourceGroupName= "ShiraStorageAccount-rg"
      $srcStorageAccountName = "mysorage11"
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

      Get-ChildItem -Path C:\Users\ShiraZadok\Microsoft\100Blobs | Set-AzStorageBlobContent -Container $srcContainer `
      -Context $srcContext -Force

      azcopy copy "https://mysorage11.blob.core.windows.net/sourcecontainer?sv=2020-08-04&ss=bfqt&srt=co&sp=rwdlacuptfx&se=2021-09-10T04:03:56Z&st=2021-08-26T20:03:56Z&spr=https&sig=f4o4yp8lW8nTmwk9rI6hH6aJpp81DkW%2FoyEC1x7i8mU%3D" "https://mysorage22.blob.core.windows.net/destcontainer?sv=2020-08-04&ss=bfqt&srt=co&sp=rwdlacuptfx&se=2021-09-10T04:05:44Z&st=2021-08-26T20:05:44Z&spr=https&sig=lRf8nc%2FJnoX%2BAzGQBzVIXsmcRZggPWO2RCoSzYIVOjE%3D" --recursive
