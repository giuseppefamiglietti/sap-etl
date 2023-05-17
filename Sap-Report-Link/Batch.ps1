# start Excel 
$excel = New-Object -comobject Excel.Application  

#open file 
$FilePath = 'C:\Users\c.gambacorta\Desktop\Test_VB.xlsm' #<------- Change this!!! 
$workbook = $excel.Workbooks.Open($FilePath)  

#make it visible (just to check what is happening) 
$excel.Visible = $true  
timeout 1
$app = $excel.Application 
$app.Run("MM") #<------- Change this!!! 
$excel.Quit()     

#Popup box to show completion - you would remove this if using task scheduler 
#$wshell = New-Object -ComObject Wscript.Shell $wshell.Popup("Operation Completed",0,"Done",0x1)  

exit