#test module is installed and if not run install
$module_missing= 'SqlServer'

if (Get-Module -ListAvailable -Name $module_missing) {
    Write-Host "Module exists"
} 
else {
    Write-Host "Module does not exist\nInstalling"
    pwsh -Command {Install-Module -Name $module_missing -force}
}




# File path of scrupts to execute  stepped variables to allow for other file types to be included

$db_version_path = '..\..\dbscripts\expecteddbstate\versionTable.json'
$script_path = 'C:\Users\ProfirMihai\OneDrive - RPC Consulting\Documents\personal\devops-tech-test-main\devops-tech-test-main\dbscripts'
$sql_scrp_path = $script_path + '*.sql'


# get file names 
$file_names_w_num = (Get-ChildItem -Path $script_path -Name -Include *[0-9]*)
#$f_n_wo_num = (Get-ChildItem -Path ..\..\dbscripts\*.sql -Name - Exclude *[0-9]*)
$file_names_w_num.Length
write-Host $file_names_w_num.GetType()


# Separate initial integer from name string and removing unnumbered file names 
#This will allow to have same index for two arrays and in my view short the index matching and file execution
 
$f_ns_num_only = $file_names_w_num -replace '([0-9]*)\D.*','$1' 
$f_ns_num_only
write-Host $f_ns_num_only.GetType()
$f_ns_num_only[-1]
Write-Host 'Last index is' $f_ns_num_only.IndexOf($f_ns_num_only[-1])

# Getting version from the reference file


$get_db_version = (Get-Content -Path $db_version_path  | ConvertFrom-Json).version


#
# Comparing latest version with latest last file
# if ($file_names_w_num[-1] -ne $get_db_version){ }
# Setting the db version
# Set-Content -Path ..\..\test\expecteddbstate\versionTable.json -Value '{"version": $file_names_w_num[-1]}' | ConvertTo-Json 
#((Get-ChildItem -Path ..\dbscripts\*sql -Name) -replace '([0-9]*)\D.*','$1') -notlike "" 
#
# Loop through the numbered files then compare their number to the database version
cd $script_path
    Foreach ($file_number in $f_ns_num_only)
    {
        Write-host 'Current Database version is' $get_db_version
        if ($file_number -gt $get_db_version){
            $file_index = $f_ns_num_only.IndexOf($file_number)
            Write-Host 'Looking at script' $file_names_w_num[$file_index]
            Write-Host 'Now running script ' $file_names_w_num[$file_index]
            Invoke-Sqlcmd -HostName $args[0] -Database $args[1] -Username $args[2] -Password $args[3] -InputFile $file_names_w_num[$file_index]
            Set-Content -Path $db_version_path -Value "{\"version\": $f_ns_num_only[$file_index]'}" | ConvertTo-Json
            Write-Host 'New deb version is' $get_db_version
        }
    }