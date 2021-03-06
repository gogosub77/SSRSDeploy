'============================================================================= 
' Simplified and adapted from the MS sample script that can be found at https://msftrsprodsamples.codeplex.com/SourceControl/changeset/view/76849#458460 
' 
' This version will dynamically upload from a folder, rather than hardcoded rdl files names. 
Dim definition As [Byte]() = Nothing
Dim warnings As Warning() = Nothing
Dim parentFolder As String = "exec_ssrs"
Dim parentPath As String = "/" '+ parentFolder 
Dim filePath As String = "C:\Users\Administrator\Desktop\SSRSDeploy\ssrs\" 
Dim fileName As String
Dim overwrite As Boolean = True		'true is overwrite report
 
Public Sub Main() 
	rs.Credentials = System.Net.CredentialCache.DefaultCredentials 
	 
	'Create the parent folder 
	Try 
		rs.CreateFolder(parentFolder, "/", Nothing) 
		Console.WriteLine("Parent folder {0} created successfully", parentFolder) 
	Catch e As Exception 
		Console.WriteLine(e.Message) 
	End Try
	 
	'Process the list of files found in the directory. 
	Console.WriteLine("Getting Paths") 
	 
	Dim fileEntries As String() = System.IO.Directory.GetFiles(filePath) 
	Dim fileName As String
	 
		For Each fileName In fileEntries
				fileName = filename.replace(".rdl", "") 
				FileName = filename.replace(filePath,"") 
					Console.WriteLine("Trying to deploy " & filename) 
				PublishReport(fileName) 
		Next fileName 
End Sub
 
Public Sub PublishReport(ByVal reportName As String) 
 
	Try
		Dim stream As FileStream = File.OpenRead(filePath + reportName + ".rdl") 
		definition = New [Byte](stream.Length - 1) {} 
		stream.Read(definition, 0, CInt(stream.Length)) 
		stream.Close() 
	 
	Catch e As IOException  
		Console.WriteLine(e.Message) 
	End Try
	 
	Try
		warnings = rs.CreateReport(reportName, parentPath, overwrite, definition, Nothing) 
		 
		If Not (warnings Is Nothing) Then
			Dim warning As Warning 
			For Each warning In warnings 
				Console.WriteLine(warning.Message) 
			Next warning 
		 
		Else 
			Console.WriteLine("Report: {0} published successfully with no warnings", reportName) 
		End If
	Catch e As Exception 
		Console.WriteLine(e.Message) 
	End Try
End Sub
'
'
''''''''''''''''''''''''''''''''''''''''''''''''