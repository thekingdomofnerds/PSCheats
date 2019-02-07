function PC_OSDrive {
    param (
        [string]$FIND   
    )
    
    switch($FIND){
        "Letter"{
            #Returns the letter of the drive that Windows is installed on
            #Usage:     PC_OSDrive -FIND Letter     (In many cases this would return "C")

            #Queries WMI to get the Logical Disk (Such as C:) and RegEX it to 1 character long (C)
            $result = (Get-WmiObject -Class Win32_logicaldisk | Select-Object -expand DeviceID).SubString(0,1)

            return $result
        }
    }
}
