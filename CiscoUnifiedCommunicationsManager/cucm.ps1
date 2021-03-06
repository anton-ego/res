
#Cisco unified communications manager SOAP integrations 
#Version=0.4 ; Author=Ilya Feoktistov ; TODO=add services, check errors


	
remove-item alias:curl -erroraction 'silentlycontinue'

class CallManager
{
        [string]$username
        [string]$password
        [string]$Server

        CallManager($username,$password,$server)
        {
            $this.username=$username
            $this.password=$password
            $this.server=$server
        }

 

        [hashtable]CreateUser([string]$FirstName,[string]$LastName,[string]$UserID,[string]$Password,[string]$pin,[string]$MailID,[string]$Department,[string]$Manager,[string]$Device,[string]$PrimaryExtensionPattern)
        {
            [hashtable]$output=@{Status="";Message="";UserID=""}
            [string]$cred='{0}:{1}' -f $this.username,$this.password

            $Body = [string]@"
                <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns=\"http://www.cisco.com/AXL/API/9.0\">     
	                <soapenv:Header/>     
		                <soapenv:Body>         
			                <ns:addUser sequence=\"?\">             
				                <user>                 
					                <firstName>$FirstName</firstName>                 
					                <lastName>$LastName</lastName>                 
					                <userid>$UserID</userid>                 
					                <password>$Password</password>                 
					                <pin>$pin</pin>                 
					                <mailid>$MailID</mailid>                 
					                <department>$Department</department>                 
					                <manager>$Manager</manager>                 
					                <associatedDevices>                     
					                <!--Zero or more repetitions:-->                     
					                <device>$Device</device>                 
					                </associatedDevices>                 
					                <primaryExtension>                     
					                <pattern>$PrimaryExtensionPattern</pattern>                 
					                </primaryExtension>             
				                </user>         
			                </ns:addUser>     
		                </soapenv:Body> 
                </soapenv:Envelope>
"@
            [xml]$result = curl  -k -u $cred -H 'Content-type: text/xml;' -H 'SOAPAction:CUCM:DB ver=9.0' -d $Body  $this.server

            if ($result.Envelope.Body.addUserResponse)
            {
                $output=@{
                    Status="Ok"
                    Message="User created"
                    UserID=$result.Envelope.Body.addUserResponse.return
                }   
            }
            elseif ($result.Envelope.Body.Fault.faultstring)
            {
                $output=@{
                    Status="Error"
                    Message=$result.Envelope.Body.Fault.faultstring
                    UserID="Error"
                }   
            }

        return $output

        }

        [hashtable]CreatePhone([string]$PhoneName,[string]$Description,[string]$Product,[string]$Protocol)
        {
            
            [Hashtable]$output=@{Status="";Message="";PhoneID=""}
            

            $Body = [string]@"
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/9.0">
                   <soapenv:Header/>
                   <soapenv:Body>
                 <ns:addPhone sequence="?">
                         <phone ctiid="?">
                            <name>$PhoneName</name>
                            <description>$Description</description>
                            <product></product>
                            <class>Phone</class>
                            <protocol>$Protocol</protocol>
                            <protocolSide>User</protocolSide>
                           <devicePoolName uuid="?">Default</devicePoolName>
                            <phoneTemplateName uuid="?">Standard 6961 SCCP</phoneTemplateName>
                            <softkeyTemplateName uuid="?">Standard User</softkeyTemplateName>
                         </phone>
                      </ns:addPhone>
                   </soapenv:Body>
                </soapenv:Envelope>
"@
            [xml]$result = curl  -k -u $this.cred -H 'Content-type: text/xml;' -H 'SOAPAction:CUCM:DB ver=9.0' -d $Body  $this.server

            if ($result.Envelope.Body.addUserResponse)
            {
                $output=@{
                    Status="Ok"
                    Message="User created"
                    UseID=$result.Envelope.Body.addUserResponse.return
                }   
            }
            elseif ($result.Envelope.Body.Fault.faultstring)
            {
                $output=@{
                    Status="Error"
                    Message=$result.Envelope.Body.Fault.faultstring
                    UseID="Error"
                }   
            }

        return $output

        }

}


$username="test"
$password="test"
$Server = "https://192.168.254.22:8443/axl/"
$FirstName = "Jo65srehhhyyygteph"
$LastName = "Stal6re54ghyhytin"
$UserID = "JStaln6re54ythyygtin"
$pin="126532146532176"
$MailID = "js654amp65hyle@company.com"
$Department = "M654654ar6565ketg5ting"
$Manager = "Ja635465ne gr6563Doe"
$Device = "SEP121212121220"
$PrimaryExtensionPattern="1011"




$Cisco=[CallManager]::new($username,$password,$server)


$Cisco.CreateUser($FirstName,$LastName,$UserID,$Password,$pin,$MailID,$Department,$Manager,$Device,$PrimaryExtensionPattern)





