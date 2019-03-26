Add-Type -AssemblyName System.Windows.Forms

#Initialize Filter Array
$FileTypeFilter = @()

#Uncomment Filetypes you want to allow in the File Browse Dialog
$FileTypeFilter += 'CSV (*.csv)|*.csv'
$FileTypeFilter += 'SpreadSheet (*.xlsx)|*.xlsx'
$FileTypeFilter += 'Text (*.txt)|*.txt'
$FileTypeFilter += 'Log (*.log)|*.log'
#$FileTypeFilter += 'Docx (*.docx)|*.docx'

#Sets the separator for the string to | 
$ofs = '|'


#Creates the file Browse window
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath('Desktop') 

    #Sets the filter.  Comment out if you do not want any filter at all
    Filter = [string]$FileTypeFilter
}

#Opens the File Browse window
$null = $FileBrowser.ShowDialog()
