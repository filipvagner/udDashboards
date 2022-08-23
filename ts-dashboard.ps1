# Importing data
$tsGlobalDataPath = "$env:ProgramData\udreports\tsreport\ts-global-data.csv"
$tsGlobalData = Import-Csv -Path $tsGlobalDataPath
$tsCountryDataPath = "$env:ProgramData\udreports\tsreport\ts-country-data.csv"
$tsCountryData = Import-Csv -Path $tsCountryDataPath 
$tsUsersData = "$env:ProgramData\udreports\tsreport\ts-users-data.csv"

# Variables
## Global data variables
$tsGlobalDataTable = [ordered]@{
    'Licenses server' = "<server name>"
    'Total number of installed licenses' = ($tsGlobalData | Measure-Object -Property TotalLicenses -Sum).Sum
    'Total number of used licenses' = ($tsGlobalData | Measure-Object -Property IssuedLicenses -Sum).Sum
    'Total number of available licenses' = ($tsGlobalData | Measure-Object -Property AvailableLicenses -Sum).Sum
    'Reported On' = ($tsGlobalData | Measure-Object -Property ReportedOn -Maximum).Maximum
}

$tsGlobalDataGrid = New-Object -TypeName "System.Collections.ArrayList"
$tsGlobalData | ForEach-Object {
    $tsGlobalDataObj = [PSCustomObject]@{
        TotalLicenses = $_.TotalLicenses
        IssuedLicenses = $_.IssuedLicenses
        AvailableLicenses = $_.AvailableLicenses       
        ProductVersion = $_.ProductVersion
        ReportedOn = $_.ReportedOn
    }
    $tsGlobalDataGrid.Add($tsGlobalDataObj)
}

## Country data variables
$tsCountryDataGrid = New-Object -TypeName "System.Collections.ArrayList"
$tsCountryData | ForEach-Object {
    $tsCountryDataObj = [PSCustomObject]@{
        Country = $_.Country
        IssuedLicensesNumber = $_.IssuedLicNum
        LicenseVersion2008 = $_.LicenseVersionWe
        LicenseVersion2012 = $_.LicenseVersionWt
        ReportedOn = $_.ReportedOn
    }
    $tsCountryDataGrid.Add($tsCountryDataObj)
}

# UD Theme
$Theme = New-UDTheme -Name "Basic" -Definition @{
    UDNavBar = @{
        BackgroundColor = "#263238"
        FontColor = "#EEEEEE"
    }

    UDDashboard = @{
        BackgroundColor = "#EEEEEE"
        FontColor = "#263238"
    }

    UDCard = @{
        BackgroundColor = "#FFFFFF"
        FontColor = "#263238"
    }

    UDChart = @{
        BackgroundColor = "#FAFAFA"
        FontColor = "#263238"
    }

    UDGrid = @{
        BackgroundColor = "#FFFFFF"
        FontColor = "#263238"
    }

    UDFooter = @{
        BackgroundColor = "#263238"
        FontColor = "#EEEEEE"
    }
}

# UD Dashboard
$Navigation = New-UDSideNav -Content {
    New-UDSideNavItem -Text "Home" -Url 'http://<server name>:1001/home' -Icon 'info_circle'
    New-UDSideNavItem -Text "Windows Image Maintenance Dashboard" -Url 'http://<server name>:1002/home' -Icon 'server'
    New-UDSideNavItem -Text "SQL Dashboard" -Url 'http://<server name>:1003/home' -Icon 'database'
    New-UDSideNavItem -Text "Terminal Licenses Dashboard" -Url 'http://<server name>:1004/home' -Icon 'id_badge'
    New-UDSideNavItem -Text "Country Dashboard" -Url 'http://<server name>:1092/home' -Icon 'stream'
}

$tsDashboard = New-UDDashboard -Title "Terminal Licenses Dashboard" -Navigation $Navigation -Theme $Theme -Content {
    # Terminal Licenses Overview begining 
    New-UDHeading -Text "Terminal Licenses Overview" -Size 3
    New-UDLayout -Columns 3 -Content {

        if (!(Test-Path -Path $tsGlobalDataPath)) {
            New-UDCard -Title "Licenses Statistics" -Size small -Content {
                New-UDParagraph -Text "Data file not found" -Color "#C62828"
            }            
        } elseif ((Get-Content -Path $tsGlobalDataPath).Length -eq 0) {
            New-UDCard -Title "Licenses Statistics" -Size small -Content {
                New-UDParagraph -Text "No info about licenses found" -Color "#C62828"
            }
        } else {
            New-UDTable -Title "Licenses Statistics" -Headers @(" ", " ") -Endpoint {
                $tsGlobalDataTable.GetEnumerator() | Out-UDTableData -Property @("Name", "Value")
            }
        }
        
        if (!(Test-Path -Path $tsGlobalDataPath)) {
            New-UDCard -Title "Licenses Statistics" -Size small -Content {
                New-UDParagraph -Text "Data file not found" -Color "#C62828"
            }            
        } elseif ((Get-Content -Path $tsGlobalDataPath).Length -eq 0) {
            New-UDCard -Title "Licenses Statistics" -Size small -Content {
                New-UDParagraph -Text "No info about licenses found" -Color "#C62828"
            }
        } else {
            New-UDChart -Title "Licenses Statistics" -Type Doughnut -Endpoint {  
                $tsCountryData | ForEach-Object {
                    [PSCustomObject]@{
                        Country = $_.Country;
                        IssuedLicensesNumber = $_.IssuedLicNum;
                    } 
                } |
                Out-UDChartData -DataProperty "IssuedLicensesNumber" -LabelProperty "Country" -BackgroundColor "#5D6D7E" -HoverBackgroundColor "#29B6F6" -BorderColor "#000000"
            } -Options @{
                legend = @{
                    display = $false
                }  
            }
        }

        if (!(Test-Path -Path $tsCountryDataPath)) {
            New-UDCard -Title "Overview of Installed Licenses" -Size small -Content {
                New-UDParagraph -Text "Data file not found" -Color "#C62828"
            }            
        } elseif ((Get-Content -Path $tsCountryDataPath).Length -eq 0) {
            New-UDCard -Title "Overview of Installed Licenses" -Size small -Content {
                New-UDParagraph -Text "No terminal licesnes issued"
            }
        } else {
            New-UdGrid -Title "Overview of Installed Licenses" -Endpoint {
                $tsGlobalDataGrid | Out-UDGridData
            }    
        }           
    }
    # Terminal Licesnes Overview end

    # Terminal Licesnes by Country begining
    New-UDHeading -Text "Terminal Licenses by Country" -Size 3
    New-UDLayout -Columns 1 -Content {

        if (!(Test-Path -Path $tsCountryDataPath)) {
            New-UDCard -Title "List of Issued Licenses" -Size small -Content {
                New-UDParagraph -Text "Data file not found" -Color "#C62828"
            }            
        } elseif ((Get-Content -Path $tsCountryDataPath).Length -eq 0) {
            New-UDCard -Title "List of Issued Licenses" -Size small -Content {
                New-UDParagraph -Text "No terminal licesnes issued"
            }
        } else {
            New-UdGrid -Title "List of Issued Licenses" -Endpoint {
                $tsCountryDataGrid | Out-UDGridData
            }    
        }
    }
    # Terminal Licesnes by Country end    

    # Terminal Licesnes Users begining
    New-UDHeading -Text "Terminal Licenses by Users" -Size 3
    New-UDLayout -Columns 1 -Content {

        if (!(Test-Path -Path $tsUsersData)) {
            New-UDCard -Title "List of Issued Licenses" -Size small -Content {
                New-UDParagraph -Text "Data file not found" -Color "#C62828"
            }            
        } elseif ((Get-Content -Path $tsUsersData).Length -eq 0) {
            New-UDCard -Title "List of Issued Licenses" -Size small -Content {
                New-UDParagraph -Text "No terminal licesnes issued"
            }
        } else {
            New-UdGrid -Title "List of Issued Licenses" -Endpoint {
                Import-Csv -Path $tsUsersData | Out-UDGridData
            }    
        }
    }
    # Terminal Licesnes Users begining
}

Start-UDDashboard -Dashboard $tsDashboard -Wait