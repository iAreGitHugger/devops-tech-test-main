#test

#File path of scrupts to execute  stepped variables to allow for other file types to be included
$script_path = '..\..\dbscripts\'
$sql_scrp_path = $script_path + '*.sql'


# get file names 
$file_names_w_num = (Get-ChildItem -Path $sql_scrp_path -Name -Include *[0-9]*)
#$f_n_wo_num = (Get-ChildItem -Path ..\..\dbscripts\*.sql -Name - Exclude *[0-9]*)
$file_names_w_num

# Separate initial integer from name string and removing unnumbered file names 
#This will allow to have same index for two arrays and in my view short the index matching and file execution
 
$f_ns_num_only = $file_names_w_num -replace '([0-9]*)\D.*','$1' 
$f_ns_num_only[-1]
$f_ns_num_only.IndexOf($f_ns_num_only[-1])



# Getting version from the reference file


$get_db_version = (Get-Content -Path ..\..\test\expecteddbstate\versionTable.json | ConvertFrom-Json ).version



# Comparing latest version with latest last file
if ($f_ns_xnum_x_[-1] -ne $get_db_version){
    
}

Set-Content -Path ..\..\test\expecteddbstate\versionTable.json -Value '{"version": $f_ns_xnum_x_[-1]}'



#((Get-ChildItem -Path ..\dbscripts\*sql -Name) -replace '([0-9]*)\D.*','$1') -notlike "" 


# Loop through the numbered files then compare their number to the database version
Foreach ($file in $file_names){

    $file_number = $file -replace '([0-9]*)\D.*','$1'
    if ($file_number-gt $get_db_version){
        $file_index = $f_ns_num_only.IndexOf($file_number)
       # Invoke-Sqlcmd -HostName $args[0] -Database $args[1] -Username $args[2] -Password[3] -InputFile $file_names_w_num[$file_index]

    } 
}
