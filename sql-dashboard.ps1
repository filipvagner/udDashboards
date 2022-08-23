# Common variables
# SQL Report variables
$ccSqlReportData =  Import-Csv -Path "$env:ProgramData\udreports\cc\sql-data\sqlreport-data.csv"

# Tables with data
$ccTable = [ordered]@{
    'DBserver' = $ccSqlReportData.DBserver
    'Version' = $ccSqlReportData.Version
    'InstanceStatus' = $ccSqlReportData.InstanceStatus
    'DBname' = $ccSqlReportData.DBname
    'DBstatus' = $ccSqlReportData.DBstatus
    'DBaccess' = $ccSqlReportData.Access
    'DBreadOnly' = $ccSqlReportData.DBreadOnly
    'DBowner' = $ccSqlReportData.DBowner
    'DatabaseLocation' = $ccSqlReportData.DatabaseLocation
    'ServiceAccount' = $ccSqlReportData.ServiceAccount
    'TCPenabled' = $ccSqlReportData.TCPenabled
    'SAaccount' = $ccSqlReportData.SAaccount
    'ReportedOn' = $ccSqlReportData.TimeStamp
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

$sqlDashboard = New-UDDashboard -Title "ITIS OS Windows Dashboard" -Navigation $Navigation -Theme $Theme -Content {
    
    New-UDHeading -Text "SQL Report" -Size 3
    
    New-UDLayout -Columns 4 -Content {
        New-UDTable -Title "Country Database Overview" -Headers @(" ", " ") -Endpoint {
            $ccTable.GetEnumerator() | Out-UDTableData -Property @("Name", "Value")
        }

    }
}

Start-UDDashboard -Dashboard $sqlDashboard -Wait