#check if the script is running in its own folder
$path = get-location
$scriptloc = split-path $myinvocation.mycommand.path -parent

if ([string]$path -eq [string]$scriptloc) {

	write-host "Please use the terminal to run this script in a folder where the script itself is not located"
	start-sleep -seconds 3
	exit

}

#get user inputs
$find = read-host -prompt "Enter what you will replace"

while ($find -eq "") {
	write-host "You can't replace nothing"
	$find = read-host -prompt "Enter what you will replace"
}

$replace = read-host -prompt ("Enter what you will replace `"$find`" with")

#loop through and get new names
foreach ($file in get-childitem -filter "*$find*") {

	$newname = $file.basename.replace($find, $replace)
	if ($newname -ne $file.basename) {
		write-host ($file.basename,"will be renamed to",$newname)
		$anythingreplaced = "true"
	}
}

#exit if the specified criteria rename nothing
if ($anythingreplaced -ne "true") {

	write-host "Under the specified criteria, nothing will be renamed. If this was an error try again, check spelling and remember it's case sensitive"
	exit

}

#get user confirmation to rename
$confirmation = read-host -prompt "Does this look good? [`"y`", or (blank) to rename, `"n`" to cancel]"
while (-not (($confirmation -eq "y") -or ($confirmation -eq "")))
{
	if ($confirmation -eq 'n') {
		write-host All changes have been cancelled
		exit
	}

	$confirmation = read-Host "Please input strictly `"y`", or (blank) to rename, or `"n`" to cancel"
}

#rename if user said yes
foreach ($file in get-childitem -filter "*$find*") {

	rename-item -path $file -newname ($file.basename.replace($find, $replace)+$file.extension)

}

write-host The files have been renamed accordingly