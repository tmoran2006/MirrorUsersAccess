cls
Write-Host "`n*******************************`n"
Write-Host "****  Mirror users access  ****`n"
Write-Host "*******************************`n"

$user = Read-Host "Enter user to mirror access of"
      try {
          $ADUser = Get-ADUser -Identity $user -ErrorAction Stop
      }
      catch {
          if ($_ -like "*Cannot find an object with identity: '$user'*") {
              Write-Warning -Message "User '$user' does not exist."
              break
          }
          else {
              "An error occurred: $_"
              break
          }
          continue
      }
      "User '$($ADUser.SamAccountName)' exists."

      $TargetSecurityGroups = Get-ADPrincipalGroupMembership $user

      foreach($securityGroup in $TargetSecurityGroups){
            $sgDN = $securityGroup.distinguishedName
            $sgName = $securityGroup.name
            Add-ADGroupMember -Identity $sgDN -Members $userName
            Write-Host "$userName has been added to the $sgName security group successfully"
      }
