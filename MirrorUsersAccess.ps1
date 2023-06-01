cls
Write-Host "`n*******************************`n"
Write-Host "****  Mirror users access  ****`n"
Write-Host "*******************************`n"

$sourceUser = Read-Host "Enter user to mirror access of"
      try {
          $ADUser = Get-ADUser -Identity $sourceUser -ErrorAction Stop
      }
      catch {
          if ($_ -like "*Cannot find an object with identity: '$user'*") {
              Write-Warning -Message "User '$sourceUser' does not exist."
              break
          }
          else {
              "An error occurred: $_"
              break
          }
          continue
      }
      "User '$($ADUser.SamAccountName)' exists."

      $TargetSecurityGroups = Get-ADPrincipalGroupMembership $sourceUser
      
      $targetUser = Read-Host "What user to copy access to"
      
      foreach($securityGroup in $TargetSecurityGroups){
            $sgDN = $securityGroup.distinguishedName
            $sgName = $securityGroup.name
            Add-ADGroupMember -Identity $sgDN -Members $targetUser
            Write-Host "$targetUser has been added to the $sgName security group successfully"
      }
