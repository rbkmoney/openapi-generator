#
# OpenAPI Petstore
# This is a sample server Petstore server. For this sample, you can use the api key `special-key` to test the authorization filters.
# Version: 1.0.0
# Generated by OpenAPI Generator: https://openapi-generator.tech
#

Describe -tag 'PSOpenAPITools' -name 'Integration Tests' {
    Context 'Pet' {
        It 'CRUD tests' {
            $Id = 38369

            # Add pet
            $Pet = Initialize-PSPet -Id $Id -Name 'PowerShell' -Category (
                Initialize-PSCategory -Id $Id -Name 'PSCategory'
            ) -PhotoUrls @(
                'http://example.com/foo',
                'http://example.com/bar'
            ) -Tags (
                Initialize-PSTag -Id $Id -Name 'PSTag'
            ) -Status Available
            $Result = Add-PSPet -Pet $Pet
            
            # Get 
            $Result = Get-PSPetById -petId $Id
            $Result."id" | Should Be 38369
            $Result."name" | Should Be "PowerShell"
            $Result."status" | Should Be "Available"
            $Result."category"."id" | Should Be $Id
            $Result."category"."name" | Should Be 'PSCategory'

            $Result.GetType().fullname | Should Be "System.Management.Automation.PSCustomObject"

            # Update (form)
            $Result = Update-PSPetWithForm -petId $Id -Name "PowerShell Update" -Status "Pending"

            $Result = Get-PSPetById -petId $Id
            $Result."id" | Should Be 38369
            $Result."name" | Should Be "PowerShell Update"
            $Result."status" | Should Be "Pending"

            # Update (put)
            $NewPet = Initialize-PSPet -Id $Id -Name 'PowerShell2' -Category (
                Initialize-PSCategory -Id $Id -Name 'PSCategory2'
            ) -PhotoUrls @(
                'http://example.com/foo2',
                'http://example.com/bar2'
            ) -Tags (
                Initialize-PSTag -Id $Id -Name 'PSTag2'
            ) -Status Sold

            $Result = Update-PSPet -Pet $NewPet
            $Result = Get-PSPetById -petId $Id -WithHttpInfo
            $Result.GetType().fullname | Should Be "System.Collections.Hashtable"
            #$Result["Response"].GetType().fullanme | Should Be "System.Management.Automation.PSCustomObject"
            $Result["Response"]."id" | Should Be 38369
            $Result["Response"]."name" | Should Be "PowerShell2"
            $Result["Response"]."status" | Should Be "Sold"
            $Result["StatusCode"] | Should Be 200
            $Result["Headers"]["Content-Type"] | Should Be "application/json"

            # upload file
            $file = Get-Item "./plus.gif"
            #$Result = Invoke-PSUploadFile -petId $Id -additionalMetadata "Additional data" -File $file

            # modify and update
            #
            $NewPet = $Result["response"]

            $NewPet."id" = $NewPet."id" + 1
            $NewPet."name" = $NewPet."name" + "PowerShell Modify"

            $Result = Update-PSPet -Pet $NewPet
            $Result = Get-PSPetById -petId $NewPet."id" -WithHttpInfo
            $Result["Response"]."id" | Should Be $NewPet."id"
            $Result["Response"]."name" | Should Be $NewPet."name"

            # Delete
            $Result = Remove-Pet -petId $Id
            $Result = Remove-Pet -petId $NewPet."id"

        }

        It 'Find pets test' {

            # add 1st pet
            $pet = Initialize-PSPet -Id 10129 -Name 'foo' -Category (
                   Initialize-PSCategory -Id 20129 -Name 'bar'
               ) -PhotoUrls @(
                   'http://example.com/foo',
                   'http://example.com/bar'
               ) -Tags (
                   Initialize-PSTag -Id 10129 -Name 'bazbaz'
               ) -Status Available
               
             $Result = Add-PSPet -Pet $pet
             
             # add 2nd pet
             $pet2 = Initialize-PSPet -Id 20129 -Name '2foo' -Category (
                     Initialize-PSCategory -Id 20129 -Name '2bar'
                 ) -PhotoUrls @(
                     'http://example.com/2foo',
                     'http://example.com/2bar'
                 ) -Tags (
                     Initialize-PSTag -Id 10129 -Name 'bazbaz'
                 ) -Status Available
                 
             $Result = Add-PSPet $pet2
            
             # test find pets by tags 
             $Results = Find-PSPetsByTags 'bazbaz'
             $Results.GetType().FullName| Should Be "System.Object[]"
             $Results.Count | Should Be 2

             if ($Results[0]."id" -gt 10129) {
                 $Results[0]."id" | Should Be 20129
             } else {
                 $Results[0]."id" | Should Be 10129
             }

             if ($Results[1]."id" -gt 10129) {
                 $Results[1]."id" | Should Be 20129
             } else {
                 $Results[1]."id" | Should Be 10129
             }

        }
    }

    Context 'Configuration' {
        It 'Get-PSHostSetting tests' {

            $HS = Get-PSHostSetting

            $HS[0]["Url"] | Should Be "http://{server}.swagger.io:{port}/v2"
            $HS[0]["Description"] | Should Be "petstore server"
            $HS[0]["Variables"]["server"]["Description"] | Should Be "No description provided"
            $HS[0]["Variables"]["server"]["DefaultValue"] | Should Be "petstore"
            $HS[0]["Variables"]["server"]["EnumValues"] | Should Be @("petstore",
                    "qa-petstore",
                    "dev-petstore")

        }

        It "Get-PSUrlFromHostSetting tests" {
            Get-PSUrlFromHostSetting -Index 0 | Should Be "http://petstore.swagger.io:80/v2"
            Get-PSUrlFromHostSetting -Index 0 -Variables @{ "port" = "8080" } | Should Be "http://petstore.swagger.io:8080/v2" 
            #Get-PSUrlFromHostSetting -Index 2 | Should -Throw -ExceptionType ([RuntimeException]) 
            #Get-PSUrlFromHostSetting -Index 2 -ErrorAction Stop | Should -Throw "RuntimeException: Invalid index 2 when selecting the host. Must be less than 2"
            #Get-PSUrlFromHostSetting -Index 0 -Variables @{ "port" = "1234" } -ErrorAction Stop | Should -Throw "RuntimeException: The variable 'port' in the host URL has invalid value 1234. Must be 80,8080"

        }

        It "Default header tests" {

            Set-PSConfigurationDefaultHeader -Key "TestKey" -Value "TestValue"

            $Configuration = Get-PSConfiguration
            $Configuration["DefaultHeaders"].Count | Should Be 1
            $Configuration["DefaultHeaders"]["TestKey"] | Should Be "TestValue"

        }

        It "Configuration tests" {
            $Conf = Get-PSConfiguration
            $Conf["SkipCertificateCheck"] | Should Be $false
            $Conf = Set-PSConfiguration -PassThru -SkipCertificateCheck
            $Conf["SkipCertificateCheck"] | Should Be $true
            $Conf = Set-PSConfiguration -PassThru # reset SkipCertificateCheck
        }

        It "Base URL tests" {
            $Conf = Set-PSConfiguration -BaseURL "http://localhost"
            $Conf = Set-PSConfiguration -BaseURL "https://localhost:8080/api"
        }
    }
}
