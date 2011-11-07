Public Class Form1
    Dim WithEvents myComPort As New System.IO.Ports.SerialPort
    Dim data As String
    Private Sub Button2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button2.Click
        ComboBox1.Enabled = True
        Button2.Enabled = False
        Button1.Enabled = True
        RadioButton1.Enabled = False
        RadioButton2.Checked = True
        myComPort.Close()
    End Sub

    Private Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click
        If Not ComboBox1.SelectedItem Is Nothing Then
            If Not myComPort.IsOpen Then
                Try
                    myComPort.BaudRate = 2400
                    myComPort.PortName = ComboBox1.SelectedItem
                    myComPort.Parity = IO.Ports.Parity.None
                    myComPort.DataBits = 8
                    myComPort.StopBits = IO.Ports.StopBits.One
                    myComPort.Handshake = IO.Ports.Handshake.None
                    myComPort.ReadTimeout = 3000
                    myComPort.ReceivedBytesThreshold = 1
                    myComPort.DtrEnable = True

                    myComPort.Open()

                    ComboBox1.Enabled = False
                    Button1.Enabled = False
                    Button2.Enabled = True
                    RadioButton1.Enabled = True
                    RadioButton1.Checked = True

                Catch ex As Exception
                    MsgBox("Error Opening COM Port", MsgBoxStyle.Critical)
                End Try
            End If
        Else
            MsgBox("Select a valid COM Port", MsgBoxStyle.Information)
        End If
    End Sub

    Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        For Each portName As String In My.Computer.Ports.SerialPortNames
            ComboBox1.Items.Add(portName)
        Next
        CheckBox1.Checked = True
        If Not myComPort.IsOpen Then
            Button2.Enabled = False
            ComboBox1.Text = ComboBox1.Items(0)
            RadioButton1.Enabled = False
            RadioButton2.Checked = True
        Else
            Button1.Enabled = False
            ComboBox1.Text = myComPort.PortName
            RadioButton2.Checked = True
        End If
    End Sub

    Private Sub RadioButton1_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RadioButton1.CheckedChanged
        myComPort.DtrEnable = True
    End Sub

    Private Sub RadioButton2_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RadioButton2.CheckedChanged
        myComPort.DtrEnable = False
    End Sub
    Private Sub DataReceived(ByVal sender As Object, ByVal e As System.IO.Ports.SerialDataReceivedEventArgs) Handles myComPort.DataReceived
        TextBox1.Invoke(New myDelegate(AddressOf updateTextBox), New Object() {})
    End Sub
    Public Delegate Sub myDelegate()
    Public Sub updateTextBox()

        data = data + myComPort.ReadExisting()
        If Len(data) = 12 Then
            TextBox1.Text = TextBox1.Text + Microsoft.VisualBasic.Mid(data, 2, 11) & vbLf
            myComPort.DtrEnable = False
            RadioButton1.Enabled = False
            RadioButton2.Checked = True

            If CheckBox1.Checked = True Then
                Beep()
            End If

            Dim timeOut As DateTimeOffset = Now.AddMilliseconds(1500)
            Do
                Application.DoEvents()
            Loop Until Now > timeOut
            data = myComPort.ReadExisting()
            myComPort.DiscardInBuffer()
            data = ""
            myComPort.DtrEnable = True
            RadioButton1.Enabled = True
            RadioButton1.Checked = True

        End If
    End Sub

    Private Sub Button3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button3.Click
        TextBox1.Text = ""
    End Sub
End Class
