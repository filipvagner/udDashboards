# Importing data
$commonData = Import-Csv -Path "$env:ProgramData\udreports\cc\vmware-data\cc-common-data.csv"
$pdcData = Import-Csv -Path "$env:ProgramData\udreports\cc\vmware-data\cc-pdc-data.csv"
$pdcHostData = Import-Csv "$env:ProgramData\udreports\cc\vmware-data\cc-pdc-host-data.csv"
$pdcDatastoreData = Import-Csv "$env:ProgramData\udreports\cc\vmware-data\cc-pdc-datastore-data.csv"
$pdcSnapshotData = "$env:ProgramData\udreports\cc\vmware-data\cc-pdc-vm-snapshots.csv"
$drcData = Import-Csv -Path "$env:ProgramData\udreports\cc\vmware-data\cc-drc-data.csv"
$drcHostData = Import-Csv "$env:ProgramData\udreports\cc\vmware-data\cc-drc-host-data.csv"
$drcDatastoreData = Import-Csv "$env:ProgramData\udreports\cc\vmware-data\cc-drc-datastore-data.csv"
$drcSnapshotData = "$env:ProgramData\udreports\cc\vmware-data\cc-drc-vm-snapshots.csv"

# Variables
## Common variables
$countryName = $commonData.countryName
$dateReportCreated = $commonData.dateReportCreated
$timeReportCreated = $commonData.timeReportCreated

## PDC variables
$pdcVcenterServer = $pdcData.pdcVcenterServer
$pdcHostCluster = $pdcData.pdcHostCluster
$pdcHostClusterUsagePercent = $pdcData.pdcHostClusterUsagePercent
$pdcDsCluster = $pdcData.pdcDsCluster
$pdcDSClusterUsagePercent = $pdcData.pdcDSClusterUsagePercent

## DRC varibales
$drcVcenterServer = $drcData.drcVcenterServer
$drcHostCluster = $drcData.drcHostCluster
$drcHostClusterUsagePercent = $drcData.drcHostClusterUsagePercent
$drcDsCluster = $drcData.drcDsCluster
$drcDSClusterUsagePercent = $drcData.drcDSClusterUsagePercent

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

$chinaDashboard = New-UDDashboard -Title "$countryName Dashboard" -Navigation $Navigation -Theme $Theme -Content {    
    # vCenter general information overview begining
    New-UDLayout -Columns 2 -Content {
        # PDC vCenter information overview begining
        New-UDCard -Title "$countryName PDC vCenter infrastructure for Windows overview" -Content {
            New-UDParagraph -Text "vCenter: $pdcVcenterServer"
            if (($pdcHostClusterUsagePercent -gt 75) -and ($pdcHostClusterUsagePercent -lt 85)) {
                New-UDParagraph -Text "Host cluster $pdcHostCluster usage: $pdcHostClusterUsagePercent %" -Color "#F9A825"
            }
             elseif ($pdcHostClusterUsagePercent -gt 85) {
                New-UDParagraph -Text "Host cluster $pdcHostCluster usage: $pdcHostClusterUsagePercent %" -Color "#C62828"
            } else {
                New-UDParagraph -Text "Host cluster $pdcHostCluster usage: $pdcHostClusterUsagePercent %"
            }

            if (($pdcDSClusterUsagePercent -gt 75) -and ($pdcDSClusterUsagePercent -lt 85)) {
                New-UDParagraph -Text "Datastore cluster $pdcDsCluster usage: $pdcDSClusterUsagePercent %" -Color "#F9A825"
            }
            elseif ($pdcDSClusterUsagePercent -gt 85) {
                New-UDParagraph -Text "Datastore cluster $pdcDsCluster usage: $pdcDSClusterUsagePercent %" -Color "#C62828"
            } else {
                New-UDParagraph -Text "Datastore cluster $pdcDsCluster usage: $pdcDSClusterUsagePercent %"
            }
            
            New-UDParagraph -Text "Report generated on: $dateReportCreated at $timeReportCreated"
        }
        # PDC vCenter information overview end

        # DRC vCenter information overview begining
        New-UDCard -Title "$countryName DRC vCenter infrastructure for Windows overview" -Content {
            New-UDParagraph -Text "vCenter: $drcVcenterServer"
            if (($drcHostClusterUsagePercent -gt 75) -and ($drcHostClusterUsagePercent -lt 85)) {
                New-UDParagraph -Text "Host cluster $drcHostCluster usage: $drcHostClusterUsagePercent %" -Color "#F9A825"
            }
            elseif ($drcHostClusterUsagePercent -gt 85) {
                New-UDParagraph -Text "Host cluster $drcHostCluster usage: $drcHostClusterUsagePercent %" -Color "#C62828"
            } else {
                New-UDParagraph -Text "Host cluster $drcHostCluster usage: $drcHostClusterUsagePercent %"
            }

            if (($drcDSClusterUsagePercent -gt 75) -and ($drcDSClusterUsagePercent -lt 85)) {
                New-UDParagraph -Text "Datastore cluster $drcDsCluster usage: $drcDSClusterUsagePercent %" -Color "#F9A825"
            }
            elseif ($drcDSClusterUsagePercent -gt 85) {
                New-UDParagraph -Text "Datastore cluster $drcDsCluster usage: $drcDSClusterUsagePercent %" -Color "#C62828"
            } else {
                New-UDParagraph -Text "Datastore cluster $drcDsCluster usage: $drcDSClusterUsagePercent %"
            }
            New-UDParagraph -Text "Report generated on: $dateReportCreated at $timeReportCreated"
        }
        # DRC vCenter information overview end
    }
    # vCenter general information overview end

    # vCenter graphs information overview begining
    New-UDLayout -Columns 3 -Content {
        # PDC Cluster CPU usage report begining
        New-UDCard -Title "Host cluster usage" -Size large -Content {
            New-UDIcon -Icon microchip -Size 2x
            New-UDParagraph -Text "$countryName hosts CPU usage in cluster $pdcHostCluster"
            
            New-UdChart -Title "" -Type HorizontalBar -Endpoint {
                $pdcHostData | ForEach-Object {
                    [PSCustomObject]@{
                        VMHostName = $_.VMHostName;
                        VMHostCpuUsage = $_.VMHostCpuUsage;
                        VMHostCpuTotal = $_.VMHostCpuTotal;
                    } 
                } | 
                Out-UDChartData -LabelProperty "VMHostName" -Dataset @(
                    New-UDChartDataset -DataProperty "VMHostCpuUsage" -Label "CPU usage GHz" -BackgroundColor "#29B6F6" -HoverBackgroundColor "#29B6F6"
                    New-UDChartDataset -DataProperty "VMHostCpuTotal" -Label "CPU capacity GHz" -BackgroundColor "#5D6D7E" -HoverBackgroundColor "#5D6D7E"
                    )
            } -Labels @("NoLabel") -Options @{
                scales = @{
                    xAxes = @(
                        @{
                            stacked = $true
                        }
                    )
                    yAxes = @(
                        @{
                            stacked = $true
                        }
                    )
                }
            }
        }
        # PDC Cluster CPU usage report end
        
        # PDC Cluster Memory usage report begining
        New-UDCard -Title "Host cluster usage" -Size large -Content {
            New-UDIcon -Icon memory -Size 2x
            New-UDParagraph -Text "$countryName hosts memory usage in cluster $pdcHostCluster"
            
            New-UdChart -Title "" -Type HorizontalBar -Endpoint {
                $pdcHostData | ForEach-Object {
                    [PSCustomObject]@{
                        VMHostName = $_.VMHostName;
                        VMHostMemoryUsage = $_.VMHostMemoryUsage;
                        VMHostMemoryTotal = $_.VMHostMemoryTotal;
                    } 
                } | 
                Out-UDChartData -LabelProperty "VMHostName" -Dataset @(
                    New-UDChartDataset -DataProperty "VMHostMemoryUsage" -Label "Memory usage GB" -BackgroundColor "#29B6F6" -HoverBackgroundColor "#29B6F6"
                    New-UDChartDataset -DataProperty "VMHostMemoryTotal" -Label "Memory capacity GB" -BackgroundColor "#5D6D7E" -HoverBackgroundColor "#5D6D7E"
                    )
            } -Labels @("NoLabel") -Options @{
                scales = @{
                    xAxes = @(
                        @{
                            stacked = $true
                        }
                    )
                    yAxes = @(
                        @{
                            stacked = $true
                        }
                    )
                }
            }
        }
        # PDC Cluster Memory usage report end

        # PDC Datastore usage report begining
        New-UDCard -Title "Datastore cluster usage" -Size large -Content {
            New-UDIcon -Icon hdd -Size 2x
            New-UDParagraph -Text "$countryName datastore usage in cluster $pdcDsCluster"

            New-UdChart -Title "" -Type HorizontalBar -Endpoint {
                $pdcDatastoreData | ForEach-Object {
                    [PSCustomObject]@{
                        DSName = $_.DSName;
                        DSSpaceUsed = $_.DSSpaceUsed.Replace(",",".");
                        DSSpaceLeft = $_.DSSpaceLeft.Replace(",",".");
                    } 
                } | 
                Out-UDChartData -LabelProperty "DSName" -DatasetLabel "DSName" -DataProperty "DSName" -Dataset @(
                    New-UdChartDataset -DataProperty "DSSpaceUsed" -Label "Space Used TB" -BackgroundColor "#29B6F6" -HoverBackgroundColor "#29B6F6"
                    New-UDChartDataset -DataProperty "DSSpaceLeft" -Label "Space Left TB" -HoverBackgroundColor "#5D6D7E" -BackgroundColor "#5D6D7E"
                    )
            } -Labels @("NoLabel") -Options @{
                scales = @{
                    xAxes = @(
                        @{
                            stacked = $true
                        }
                    )
                    yAxes = @(
                        @{
                            stacked = $true
                        }
                    )
                }
            }
        }
        # PDC Datastore usage report end        
        
        # DRC Cluster CPU usage report begining
        New-UDCard -Title "Host cluster usage" -Size large -Content {
            New-UDIcon -Icon microchip -Size 2x
            New-UDParagraph -Text "$countryName hosts CPU usage in cluster $drcHostCluster"
            
            New-UdChart -Title "" -Type HorizontalBar -Endpoint {
                $drcHostData | ForEach-Object {
                    [PSCustomObject]@{
                        VMHostName = $_.VMHostName;
                        VMHostCpuUsage = $_.VMHostCpuUsage;
                        VMHostCpuTotal = $_.VMHostCpuTotal;
                    } 
                } | 
                Out-UDChartData -LabelProperty "VMHostName" -Dataset @(
                    New-UDChartDataset -DataProperty "VMHostCpuUsage" -Label "CPU usage GHz" -BackgroundColor "#29B6F6" -HoverBackgroundColor "#29B6F6"
                    New-UDChartDataset -DataProperty "VMHostCpuTotal" -Label "CPU capacity GHz" -BackgroundColor "#5D6D7E" -HoverBackgroundColor "#5D6D7E"
                    )
            } -Labels @("NoLabel") -Options @{
                scales = @{
                    xAxes = @(
                        @{
                            stacked = $true
                        }
                    )
                    yAxes = @(
                        @{
                            stacked = $true
                        }
                    )
                }
            }
        }
        # DRC Cluster CPU usage report end

        # DRC Cluster Memory usage report begining
        New-UDCard -Title "Host cluster usage" -Size large -Content {
            New-UDIcon -Icon memory -Size 2x
            New-UDParagraph -Text "$countryName hosts memory usage in cluster $drcHostCluster"
            
            New-UdChart -Title "" -Type HorizontalBar -Endpoint {
                $drcHostData | ForEach-Object {
                    [PSCustomObject]@{
                        VMHostName = $_.VMHostName;
                        VMHostMemoryUsage = $_.VMHostMemoryUsage;
                        VMHostMemoryTotal = $_.VMHostMemoryTotal;
                    } 
                } | 
                Out-UDChartData -LabelProperty "VMHostName" -Dataset @(
                    New-UDChartDataset -DataProperty "VMHostMemoryUsage" -Label "Memory usage GB" -BackgroundColor "#29B6F6" -HoverBackgroundColor "#29B6F6"
                    New-UDChartDataset -DataProperty "VMHostMemoryTotal" -Label "Memory capacity GB" -BackgroundColor "#5D6D7E" -HoverBackgroundColor "#5D6D7E"
                    )
            } -Labels @("NoLabel") -Options @{
                scales = @{
                    xAxes = @(
                        @{
                            stacked = $true
                        }
                    )
                    yAxes = @(
                        @{
                            stacked = $true
                        }
                    )
                }
            }
        }
        # DRC Cluster Memory usage report end

        # DRC Datastore usage report begining
        New-UDCard -Title "Datastore cluster usage" -Size large -Content {
            New-UDIcon -Icon hdd -Size 2x
            New-UDParagraph -Text "$countryName datastore usage in cluster $drcDsCluster"

            New-UdChart -Title "" -Type HorizontalBar -Endpoint {
                $drcDatastoreData | ForEach-Object {
                    [PSCustomObject]@{
                        DSName = $_.DSName;
                        DSSpaceUsed = $_.DSSpaceUsed.Replace(",",".");
                        DSSpaceLeft = $_.DSSpaceLeft.Replace(",",".");
                    } 
                } | 
                Out-UDChartData -LabelProperty "DSName" -DatasetLabel "DSName" -DataProperty "DSName" -Dataset @(
                    New-UdChartDataset -DataProperty "DSSpaceUsed" -Label "Space Used TB" -BackgroundColor "#29B6F6" -HoverBackgroundColor "#29B6F6"
                    New-UDChartDataset -DataProperty "DSSpaceLeft" -Label "Space Left TB" -HoverBackgroundColor "#5D6D7E" -BackgroundColor "#5D6D7E"
                    )
            } -Labels @("NoLabel") -Options @{
                scales = @{
                    xAxes = @(
                        @{
                            stacked = $true
                        }
                    )
                    yAxes = @(
                        @{
                            stacked = $true
                        }
                    )
                }
            }
        }
        # DRC Datastore usage report end
    }
    # vCenter graphs information overview end   
     
    # Virtual machines snapshot information overview begining
    New-UDLayout -Columns 2 -Content {
        # PDC Snapshots usage report begining
        if (!(Test-Path -Path $pdcSnapshotData)) {
            New-UDCard -Title "PDC Virtual Machines Snaphots" -Size small -Content {
                New-UDParagraph -Text "Data file not found" -Color "#C62828"
            }            
        } elseif ((Get-Content -Path $pdcSnapshotData).Length -eq 0) {
            New-UDCard -Title "PDC Virtual Machines Snaphots" -Size small -Content {
                New-UDParagraph -Text "No snapshots found"
            }
        } else {
            New-UdGrid -Title "PDC Virtual Machines Snaphots" -Endpoint {
                Import-Csv -Path $pdcSnapshotData | Out-UDGridData
            }    
        }
        # PDC Snapshots usage report end
 
         # DRC Snapshots usage report begining 
        if (!(Test-Path -Path $drcSnapshotData)) {
            New-UDCard -Title "DRC Virtual Machines Snaphots" -Size small -Content {
                New-UDParagraph -Text "Data file not found" -Color "#C62828"
            }            
        } elseif ((Get-Content -Path $drcSnapshotData).Length -eq 0) {
            New-UDCard -Title "DRC Virtual Machines Snaphots" -Size small -Content {
                 New-UDParagraph -Text "No snapshots found"
            }
        } else {
            New-UdGrid -Title "DRC Virtual Machines Snaphots" -Endpoint {
                Import-Csv -Path $drcSnapshotData | Out-UDGridData
            }    
        }
        # DRC Snapshots usage report end 
    }
    # Virtual machines snapshot information overview end
    
}
 
Start-UDDashboard -Dashboard $chinaDashboard -Wait