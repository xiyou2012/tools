Public Const HTML_FILENAME As String = "HealthChecks.htm"

Sub Auto_Open()

    Sheets("Health Check Report").Activate

End Sub

Sub SendEmail()
    ' Temporary Folder Path
    Dim oFS As FileSystemObject
    Dim sTempFolder As String
    Set oFS = New FileSystemObject
    sTempFolder = oFS.GetSpecialFolder(TemporaryFolder)


    ' Create HTML file with contents required in body of email
    Call PrintToFile
     
     
    ' Set email body - need to have it as HTML, so read it in from file
    Dim strHTMLbody As String
    
    Dim createfile As Object
    Dim getfile As Object
    Dim bodyfile As Object
    Set createfile = CreateObject("Scripting.FileSystemObject")
    Set getfile = createfile.getfile(sTempFolder & "\" & HTML_FILENAME)
    Set bodyfile = getfile.OpenAsTextStream()
    
    strHTMLbody = bodyfile.ReadAll
    
    bodyfile.Close
    
    
    ' Declare variables to create email and email parts i.e. To:, Cc:, Subject:
    Dim strEmail As String
    Dim strSubject As String
    Dim strFrom As String
    Dim strCC As String
    
    Dim objOutlook As Outlook.Application
    Dim objEmail As Outlook.MailItem
    
    ' Creates an instance of Outlook
    Set objOutlook = CreateObject("Outlook.application")
    Set objEmail = objOutlook.CreateItem(olMailItem)
    
    ' *****************************************
    
    ' Set To: list
    strEmail = Trim(Range("EmailTo").Value)
    
    ' Set Cc: list
    strCC = Trim(Range("EmailCc").Value)
    
    ' Set email Subject:
    strSubject = Trim(Range("EmailSubject").Value)
    
    ' Creates and previews email
    With objEmail
        .To = strEmail
        .CC = strCC
        .Subject = strSubject
        .BodyFormat = olFormatHTML
        .HTMLBody = strHTMLbody
        .Display
        .ReadReceiptRequested = False
    End With
    
    Set objEmail = Nothing
    Exit Sub
    

End Sub

Sub PrintToFile()
    ' Temporary Folder Path
    Dim oFS As FileSystemObject
    Dim sTempFolder As String
    Set oFS = New FileSystemObject

    sTempFolder = oFS.GetSpecialFolder(TemporaryFolder)
    
    Range("EmailBody").Select
    With ActiveWorkbook.PublishObjects.Add(xlSourceRange, sTempFolder & "\" & HTML_FILENAME, _
        "HealthCheckReport", "EmailBody", xlHtmlStatic, "MorningHealthChecksReport", "")
        .Publish (True)
        .AutoRepublish = False
    End With
    ChDir "C:\"
    
End Sub

Sub FormatStatusLine()

    Dim rngStatusMessage As Range

    Set rngStatusMessage = Range("StatusMessageEmail")
    ActiveSheet.Unprotect
    If InStr(1, rngStatusMessage.Value, "problems", vbBinaryCompare) Then
        rngStatusMessage.Font.ColorIndex = 3
    Else
        rngStatusMessage.Font.ColorIndex = 11
    End If
    ActiveSheet.Protect DrawingObjects:=True, Contents:=True, Scenarios:=True

End Sub


