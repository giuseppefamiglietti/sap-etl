Attribute VB_Name = "Scrittura"

Sub Scrittura()
Dim http As New MSXML2.ServerXMLHTTP60
Set http = CreateObject("MSXML2.ServerXMLHTTP")
Dim url As String
Dim token As String
Dim json1 As String
Dim json2 As String
Dim json3 As String
Dim json4 As String
Dim json5 As String
Dim json6 As String
Dim json7 As String
Dim json8 As String
Dim Arti As String
Dim responseText As String
Dim Parsed As Dictionary
Dim i As Long
Dim js As Object
Dim NumDoc As String

'Test
Call MioTK

Arti = ""
    
    http.setOption 2, http.getOption(2)
    
    url = "https://sb1.magistergroup.net:50000/b1s/v2/Orders"
    
    token = Cells(1, 1)
    
    ' Impostare la richiesta HTTP per la chiamata al servizio web
    http.Open "POST", url, False
    http.setRequestHeader "Content-Type", "application/json"
    
    http.setRequestHeader "Cookie", "B1SESSION=" & token
    
''''' I json1 - json2 - json3, sono dell'intestazione dell'ordine, incluso il commento e la destinazione
    json1 = ("{" & "CardCode:" & Chr(34) & Cells(4, 7) & Chr(34) & "," & "NumAtCard:" & Chr(34) & Cells(5, 7) & Chr(34) & "," & "DocDate:" & Chr(34) & Cells(6, 7) & Chr(34) & ",")
    json2 = ("TaxDate:" & Chr(34) & Cells(7, 7) & Chr(34) & "," & "DocDueDate:" & Chr(34) & Cells(8, 7) & Chr(34) & "," & "U_AD2106_Delivery:" & Chr(34) & Cells(9, 7) & Chr(34) & ",")
    json3 = ("ShipToCode:" & Chr(34) & Cells(10, 7) & Chr(34) & "," & "U_Filler:" & Cells(11, 7) & "," & "U_ToWhsCode:" & Cells(12, 7) & "," & "U_CausLog:" & "62" & "," & "Comments:" & Chr(34) & Cells(13, 7) & Chr(34) & "," & "DocumentLines:" & "[")
    ' in json3 inserito "U_CausLog che sarebbe la causale logistica che l'operatore dovrà scegliere
    
For x = 10 To 20 Step 10
'x = 10
''''' I json 4 - 5 - 6 fanno parde dell'articolo, attenzione che al nuovo rigo bisogna incrementare il numero del rigo che parte da 0
    json4 = ("{" & "LineNum:" & Cells(4 + x, 5) - 1 & "," & "ItemCode:" & Chr(34) & Cells(4 + x, 7) & Chr(34) & "," & "ShipDate:" & Chr(34) & Cells(5 + x, 7) & Chr(34) & ",")

'Riga inclusa della Valuta "EUR" e del codice iva "V1" nel nostro esempio
'    json5 = ("Price:" & Cells(6 + x, 7) & "," & "WarehouseCode:" & Chr(34) & Cells(7 + x, 7) & Chr(34) & "," & "Currency:" & Chr(34) & Cells(8 + x, 7) & Chr(34) & "," & "VatGroup:" & Chr(34) & Cells(9 + x, 7) & Chr(34) & ",")
    
    json5 = ("Price:" & Cells(6 + x, 7) & "," & "WarehouseCode:" & Chr(34) & Cells(7 + x, 7) & Chr(34) & ",")
    json6 = ("Quantity:" & Cells(10 + x, 7) & "," & "U_AD2106_Colli:" & Cells(11 + x, 7) & ",")
    
''''' Il json7 specifica il lotto e le quantità dell'articolo e chiude il pacchetto dell'articolo per rigo
    json7 = ("BatchNumbers:" & "[" & "{" & "BatchNumber:" & Chr(34) & Cells(12 + x, 7) & Chr(34) & "," & "Quantity:" & Cells(13 + x, 7) & "}" & "]" & "," & "}" & ",")
    Arti = Arti & json4 & json5 & json6 & json7
Next x
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''' Inserire il ciclo per ogni singolo rigo con l'aggiunta del lotto (da json4 a json 7)
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

    json8 = ("]" & "}")
    
    json1 = json1 & json2 & json3 & Arti & json8
    'json1 = json1 & json2 & json3 & json4 & json5 & json6 & json7 & json8
    
    Cells(2, 8) = json1
   
    ' Inviare la richiesta al servizio web
    http.send json1
    
    ' Recuperare la risposta del servizio web
    http.waitForResponse
    responseText = http.responseText
    
    Cells(1, 8) = responseText
   
    If http.Status >= 200 And http.Status <= 299 Then
        
        Set js = JsonConverter.ParseJson(responseText)
        'NumDoc = js("DocNum")
    ' or
        NumDoc = js.Item("DocNum")
    
        MsgBox "Ordine caricato correttamente con numero: " & NumDoc
        
        Cells(2, 7) = NumDoc
        
    ElseIf http.Status = 400 Then
        
        MsgBox "Errore 400 / 258 - Insufficienti diritti di privilegi"
    
    End If

'Next k

End Sub
