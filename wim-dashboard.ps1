# Common variables
# WSUS Report variables
$wsusReportError = "$env:ProgramData\udreports\wsusreport\wsusreport-error.csv"
$wsusReportData = "$env:ProgramData\udreports\wsusreport\wsusreport-data.csv"
# Windows Image Maintenance Logs variables
$pdcWIMLogsData = "$env:ProgramData\udreports\wimreport\pdc-wim-data.csv"
$drcWIMLogsData = "$env:ProgramData\udreports\wimreport\drc-wim-data.csv"

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

$wimDashboard = New-UDDashboard -Title "ITIS OS Windows Dashboard" -Navigation $Navigation -Theme $Theme -Content {
    # WSUS info begining
    New-UDHeading -Text "WSUS Report" -Size 3
    New-UDLayout -Columns 2 -Content {

        if (!(Test-Path -Path $wsusReportData)) {
            New-UDCard -Title "WSUS Windows Image Report" -Size small -Content {
                New-UDParagraph -Text "Data file not found" -Color "#C62828"
            }            
        } elseif ((Get-Content -Path $wsusReportData).Length -eq 0) {
            New-UDCard -Title "WSUS Windows Image Report" -Size small -Content {
                New-UDParagraph -Text "No errors found"
            }
        } else {
            New-UdGrid -Title "WSUS Windows Image Report" -Endpoint {
                Import-Csv -Path $wsusReportData | Out-UDGridData
            }    
        }
        
        if (!(Test-Path -Path $wsusReportError)) {
            New-UDCard -Title "WSUS Connection Errors" -Size small -Content {
                New-UDParagraph -Text "Data file not found" -Color "#C62828"
            }            
        } elseif ((Get-Content -Path $wsusReportError).Length -eq 0) {
            New-UDCard -Title "WSUS Connection Errors" -Size small -Content {
                New-UDParagraph -Text "No errors found"
            }
        } else {
            New-UdGrid -Title "WSUS Connection Errors" -Endpoint {
                Import-Csv -Path $wsusReportError | Out-UDGridData
            }    
        }
    }
    # WSUS info end

    # PDC Windows image maintenance info begining
    New-UDHeading -Text "Windows Image Maintenance Logs" -Size 3
    New-UDLayout -Columns 1 -Content {

        if (!(Test-Path -Path $pdcWIMLogsData)) {
            New-UDCard -Title "PDC Windows Image Maintenance Logs" -Size small -Content {
                New-UDParagraph -Text "Data file not found" -Color "#C62828"
            }            
        } elseif ((Get-Content -Path $pdcWIMLogsData).Length -eq 0) {
            New-UDCard -Title "PDC Windows Image Maintenance Logs" -Size small -Content {
                New-UDParagraph -Text "No errors found"
            }
        } else {
            New-UdGrid -Title "PDC Windows Image Maintenance Logs" -Endpoint {
                Import-Csv -Path $pdcWIMLogsData | Out-UDGridData
            }    
        }
    }
    # PDC Windows image maintenance end

    # DRC Windows image maintenance info begining
    New-UDLayout -Columns 1 -Content {

        if (!(Test-Path -Path $drcWIMLogsData)) {
            New-UDCard -Title "DRC Windows Image Maintenance Logs" -Size small -Content {
                New-UDParagraph -Text "Data file not found" -Color "#C62828"
            }            
        } elseif ((Get-Content -Path $drcWIMLogsData).Length -eq 0) {
            New-UDCard -Title "DRC Windows Image Maintenance Logs" -Size small -Content {
                New-UDParagraph -Text "No errors found"
            }
        } else {
            New-UdGrid -Title "DRC Windows Image Maintenance Logs" -Endpoint {
                Import-Csv -Path $drcWIMLogsData | Out-UDGridData
            }    
        }
    }
    # DRC Windows image maintenance end
}

Start-UDDashboard -Dashboard $wimDashboard -Wait