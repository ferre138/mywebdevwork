<%
Response.Buffer = EW_RESPONSE_BUFFER
%>
<!--#include file="ewcfg9.asp"-->
<!--#include file="Ordersinfo.asp"-->
<!--#include file="Loginsinfo.asp"-->
<!--#include file="aspfn9.asp"-->
<!--#include file="userfn9.asp"-->
<% Session.Timeout = 20 %>
<% Call ew_Header(False, EW_CHARSET) %>
<%

' Define page object
Dim Orders_delete
Set Orders_delete = New cOrders_delete
Set Page = Orders_delete

' Page init processing
Call Orders_delete.Page_Init()

' Page main processing
Call Orders_delete.Page_Main()
%>
<!--#include file="header.asp"-->
<script type="text/javascript">
<!--
// Create page object
var Orders_delete = new ew_Page("Orders_delete");
// page properties
Orders_delete.PageID = "delete"; // page ID
Orders_delete.FormID = "fOrdersdelete"; // form ID
var EW_PAGE_ID = Orders_delete.PageID; // for backward compatibility
// extend page with Form_CustomValidate function
Orders_delete.Form_CustomValidate =  
 function(fobj) { // DO NOT CHANGE THIS LINE!
 	// Your custom validation code here, return false if invalid. 
 	return true;
 }
Orders_delete.SelectAllKey = function(elem) {
	ew_SelectAll(elem);
}
<% If EW_CLIENT_VALIDATE Then %>
Orders_delete.ValidateRequired = true; // uses JavaScript validation
<% Else %>
Orders_delete.ValidateRequired = false; // no JavaScript validation
<% End If %>
//-->
</script>
<script language="JavaScript" type="text/javascript">
<!--
// Write your client script here, no need to add script tags.
//-->
</script>
<% Orders_delete.ShowPageHeader() %>
<%

' Load records for display
Set Orders_delete.Recordset = Orders_delete.LoadRecordset()
Orders_delete.TotalRecs = Orders_delete.Recordset.RecordCount ' Get record count
If Orders_delete.TotalRecs <= 0 Then ' No record found, exit
	Orders_delete.Recordset.Close
	Set Orders_delete.Recordset = Nothing
	Call Orders_delete.Page_Terminate("Orderslist.asp") ' Return to list
End If
%>
<p class="aspmaker ewTitle"><%= Language.Phrase("Delete") %>&nbsp;<%= Language.Phrase("TblTypeTABLE") %><%= Orders.TableCaption %></p>
<p class="aspmaker"><a href="<%= Orders.ReturnUrl %>"><%= Language.Phrase("GoBack") %></a></p>
<% Orders_delete.ShowMessage %>
<form action="<%= ew_CurrentPage %>" method="post">
<p>
<input type="hidden" name="t" id="t" value="Orders">
<input type="hidden" name="a_delete" id="a_delete" value="D">
<% For i = 0 to UBound(Orders_delete.RecKeys) %>
<input type="hidden" name="key_m" id="key_m" value="<%= ew_HtmlEncode(ew_GetKeyValue(Orders_delete.RecKeys(i))) %>">
<% Next %>
<table class="ewGrid"><tr><td class="ewGridContent">
<div class="ewGridMiddlePanel">
<table cellspacing="0" class="ewTable ewTableSeparate">
<%= Orders.TableCustomInnerHTML %>
	<thead>
	<tr class="ewTableHeader">
		<td valign="top"><%= Orders.CustomerId.FldCaption %></td>
		<td valign="top"><%= Orders.Amount.FldCaption %></td>
		<td valign="top"><%= Orders.Ship_FirstName.FldCaption %></td>
		<td valign="top"><%= Orders.Ship_LastName.FldCaption %></td>
		<td valign="top"><%= Orders.payment_status.FldCaption %></td>
		<td valign="top"><%= Orders.Ordered_Date.FldCaption %></td>
		<td valign="top"><%= Orders.payment_date.FldCaption %></td>
		<td valign="top"><%= Orders.pfirst_name.FldCaption %></td>
		<td valign="top"><%= Orders.plast_name.FldCaption %></td>
		<td valign="top"><%= Orders.payer_email.FldCaption %></td>
		<td valign="top"><%= Orders.txn_id.FldCaption %></td>
		<td valign="top"><%= Orders.payment_gross.FldCaption %></td>
		<td valign="top"><%= Orders.payment_fee.FldCaption %></td>
		<td valign="top"><%= Orders.payment_type.FldCaption %></td>
		<td valign="top"><%= Orders.txn_type.FldCaption %></td>
		<td valign="top"><%= Orders.Tax.FldCaption %></td>
		<td valign="top"><%= Orders.Shipping.FldCaption %></td>
		<td valign="top"><%= Orders.EmailSent.FldCaption %></td>
		<td valign="top"><%= Orders.EmailDate.FldCaption %></td>
	</tr>
	</thead>
	<tbody>
<%
Orders_delete.RecCnt = 0
i = 0
Do While (Not Orders_delete.Recordset.Eof)
	Orders_delete.RecCnt = Orders_delete.RecCnt + 1

	' Set row properties
	Call Orders.ResetAttrs()
	Orders.RowType = EW_ROWTYPE_VIEW ' view

	' Get the field contents
	Call Orders_delete.LoadRowValues(Orders_delete.Recordset)

	' Render row
	Call Orders_delete.RenderRow()
%>
	<tr<%= Orders.RowAttributes %>>
		<td<%= Orders.CustomerId.CellAttributes %>>
<div<%= Orders.CustomerId.ViewAttributes %>><%= Orders.CustomerId.ListViewValue %></div>
</td>
		<td<%= Orders.Amount.CellAttributes %>>
<div<%= Orders.Amount.ViewAttributes %>><%= Orders.Amount.ListViewValue %></div>
</td>
		<td<%= Orders.Ship_FirstName.CellAttributes %>>
<div<%= Orders.Ship_FirstName.ViewAttributes %>><%= Orders.Ship_FirstName.ListViewValue %></div>
</td>
		<td<%= Orders.Ship_LastName.CellAttributes %>>
<div<%= Orders.Ship_LastName.ViewAttributes %>><%= Orders.Ship_LastName.ListViewValue %></div>
</td>
		<td<%= Orders.payment_status.CellAttributes %>>
<div<%= Orders.payment_status.ViewAttributes %>><%= Orders.payment_status.ListViewValue %></div>
</td>
		<td<%= Orders.Ordered_Date.CellAttributes %>>
<div<%= Orders.Ordered_Date.ViewAttributes %>><%= Orders.Ordered_Date.ListViewValue %></div>
</td>
		<td<%= Orders.payment_date.CellAttributes %>>
<div<%= Orders.payment_date.ViewAttributes %>><%= Orders.payment_date.ListViewValue %></div>
</td>
		<td<%= Orders.pfirst_name.CellAttributes %>>
<div<%= Orders.pfirst_name.ViewAttributes %>><%= Orders.pfirst_name.ListViewValue %></div>
</td>
		<td<%= Orders.plast_name.CellAttributes %>>
<div<%= Orders.plast_name.ViewAttributes %>><%= Orders.plast_name.ListViewValue %></div>
</td>
		<td<%= Orders.payer_email.CellAttributes %>>
<div<%= Orders.payer_email.ViewAttributes %>><%= Orders.payer_email.ListViewValue %></div>
</td>
		<td<%= Orders.txn_id.CellAttributes %>>
<div<%= Orders.txn_id.ViewAttributes %>><%= Orders.txn_id.ListViewValue %></div>
</td>
		<td<%= Orders.payment_gross.CellAttributes %>>
<div<%= Orders.payment_gross.ViewAttributes %>><%= Orders.payment_gross.ListViewValue %></div>
</td>
		<td<%= Orders.payment_fee.CellAttributes %>>
<div<%= Orders.payment_fee.ViewAttributes %>><%= Orders.payment_fee.ListViewValue %></div>
</td>
		<td<%= Orders.payment_type.CellAttributes %>>
<div<%= Orders.payment_type.ViewAttributes %>><%= Orders.payment_type.ListViewValue %></div>
</td>
		<td<%= Orders.txn_type.CellAttributes %>>
<div<%= Orders.txn_type.ViewAttributes %>><%= Orders.txn_type.ListViewValue %></div>
</td>
		<td<%= Orders.Tax.CellAttributes %>>
<div<%= Orders.Tax.ViewAttributes %>><%= Orders.Tax.ListViewValue %></div>
</td>
		<td<%= Orders.Shipping.CellAttributes %>>
<div<%= Orders.Shipping.ViewAttributes %>><%= Orders.Shipping.ListViewValue %></div>
</td>
		<td<%= Orders.EmailSent.CellAttributes %>>
<div<%= Orders.EmailSent.ViewAttributes %>><%= Orders.EmailSent.ListViewValue %></div>
</td>
		<td<%= Orders.EmailDate.CellAttributes %>>
<div<%= Orders.EmailDate.ViewAttributes %>><%= Orders.EmailDate.ListViewValue %></div>
</td>
	</tr>
<%
	Orders_delete.Recordset.MoveNext
Loop
Orders_delete.Recordset.Close
Set Orders_delete.Recordset = Nothing
%>
	</tbody>
</table>
</div>
</td></tr></table>
<p>
<input type="submit" name="Action" id="Action" value="<%= ew_BtnCaption(Language.Phrase("DeleteBtn")) %>">
</form>
<%
Orders_delete.ShowPageFooter()
If EW_DEBUG_ENABLED Then Response.Write ew_DebugMsg()
%>
<script language="JavaScript" type="text/javascript">
<!--
// Write your table-specific startup script here
// document.write("page loaded");
//-->
</script>
<!--#include file="footer.asp"-->
<%

' Drop page object
Set Orders_delete = Nothing
%>
<%

' -----------------------------------------------------------------
' Page Class
'
Class cOrders_delete

	' Page ID
	Public Property Get PageID()
		PageID = "delete"
	End Property

	' Table Name
	Public Property Get TableName()
		TableName = "Orders"
	End Property

	' Page Object Name
	Public Property Get PageObjName()
		PageObjName = "Orders_delete"
	End Property

	' Page Name
	Public Property Get PageName()
		PageName = ew_CurrentPage()
	End Property

	' Page Url
	Public Property Get PageUrl()
		PageUrl = ew_CurrentPage() & "?"
		If Orders.UseTokenInUrl Then PageUrl = PageUrl & "t=" & Orders.TableVar & "&" ' add page token
	End Property

	' Message
	Public Property Get Message()
		Message = Session(EW_SESSION_MESSAGE)
	End Property

	Public Property Let Message(v)
		Dim msg
		msg = Session(EW_SESSION_MESSAGE)
		Call ew_AddMessage(msg, v)
		Session(EW_SESSION_MESSAGE) = msg
	End Property

	Public Property Get FailureMessage()
		FailureMessage = Session(EW_SESSION_FAILURE_MESSAGE)
	End Property

	Public Property Let FailureMessage(v)
		Dim msg
		msg = Session(EW_SESSION_FAILURE_MESSAGE)
		Call ew_AddMessage(msg, v)
		Session(EW_SESSION_FAILURE_MESSAGE) = msg
	End Property

	Public Property Get SuccessMessage()
		SuccessMessage = Session(EW_SESSION_SUCCESS_MESSAGE)
	End Property

	Public Property Let SuccessMessage(v)
		Dim msg
		msg = Session(EW_SESSION_SUCCESS_MESSAGE)
		Call ew_AddMessage(msg, v)
		Session(EW_SESSION_SUCCESS_MESSAGE) = msg
	End Property

	' Show Message
	Public Sub ShowMessage()
		Dim sMessage
		sMessage = Message
		Call Message_Showing(sMessage, "")
		If sMessage <> "" Then Response.Write "<p class=""ewMessage"">" & sMessage & "</p>"
		Session(EW_SESSION_MESSAGE) = "" ' Clear message in Session

		' Success message
		Dim sSuccessMessage
		sSuccessMessage = SuccessMessage
		Call Message_Showing(sSuccessMessage, "success")
		If sSuccessMessage <> "" Then Response.Write "<p class=""ewSuccessMessage"">" & sSuccessMessage & "</p>"
		Session(EW_SESSION_SUCCESS_MESSAGE) = "" ' Clear message in Session

		' Failure message
		Dim sErrorMessage
		sErrorMessage = FailureMessage
		Call Message_Showing(sErrorMessage, "failure")
		If sErrorMessage <> "" Then Response.Write "<p class=""ewErrorMessage"">" & sErrorMessage & "</p>"
		Session(EW_SESSION_FAILURE_MESSAGE) = "" ' Clear message in Session
	End Sub
	Dim PageHeader
	Dim PageFooter

	' Show Page Header
	Public Sub ShowPageHeader()
		Dim sHeader
		sHeader = PageHeader
		Call Page_DataRendering(sHeader)
		If sHeader <> "" Then ' Header exists, display
			Response.Write "<p class=""aspmaker"">" & sHeader & "</p>"
		End If
	End Sub

	' Show Page Footer
	Public Sub ShowPageFooter()
		Dim sFooter
		sFooter = PageFooter
		Call Page_DataRendered(sFooter)
		If sFooter <> "" Then ' Footer exists, display
			Response.Write "<p class=""aspmaker"">" & sFooter & "</p>"
		End If
	End Sub

	' -----------------------
	'  Validate Page request
	'
	Public Function IsPageRequest()
		If Orders.UseTokenInUrl Then
			IsPageRequest = False
			If Not (ObjForm Is Nothing) Then
				IsPageRequest = (Orders.TableVar = ObjForm.GetValue("t"))
			End If
			If Request.QueryString("t").Count > 0 Then
				IsPageRequest = (Orders.TableVar = Request.QueryString("t"))
			End If
		Else
			IsPageRequest = True
		End If
	End Function

	' -----------------------------------------------------------------
	'  Class initialize
	'  - init objects
	'  - open ADO connection
	'
	Private Sub Class_Initialize()
		If IsEmpty(StartTimer) Then StartTimer = Timer ' Init start time

		' Initialize language object
		If IsEmpty(Language) Then
			Set Language = New cLanguage
			Call Language.LoadPhrases()
		End If

		' Initialize table object
		If IsEmpty(Orders) Then Set Orders = New cOrders
		Set Table = Orders

		' Initialize urls
		' Initialize other table object

		If IsEmpty(Logins) Then Set Logins = New cLogins

		' Initialize form object
		Set ObjForm = Nothing

		' Intialize page id (for backward compatibility)
		EW_PAGE_ID = "delete"

		' Initialize table name (for backward compatibility)
		EW_TABLE_NAME = "Orders"

		' Open connection to the database
		If IsEmpty(Conn) Then Call ew_Connect()
	End Sub

	' -----------------------------------------------------------------
	'  Subroutine Page_Init
	'  - called before page main
	'  - check Security
	'  - set up response header
	'  - call page load events
	'
	Sub Page_Init()
		Set Security = New cAdvancedSecurity
		If Not Security.IsLoggedIn() Then Call Security.AutoLogin()
		If Not Security.IsLoggedIn() Then
			Call Security.SaveLastUrl()
			Call Page_Terminate("login.asp")
		End If

		' Global page loading event (in userfn7.asp)
		Call Page_Loading()

		' Page load event, used in current page
		Call Page_Load()
	End Sub

	' -----------------------------------------------------------------
	'  Class terminate
	'  - clean up page object
	'
	Private Sub Class_Terminate()
		Call Page_Terminate("")
	End Sub

	' -----------------------------------------------------------------
	'  Subroutine Page_Terminate
	'  - called when exit page
	'  - clean up ADO connection and objects
	'  - if url specified, redirect to url
	'
	Sub Page_Terminate(url)

		' Page unload event, used in current page
		Call Page_Unload()

		' Global page unloaded event (in userfn60.asp)
		Call Page_Unloaded()
		Dim sRedirectUrl
		sReDirectUrl = url
		Call Page_Redirecting(sReDirectUrl)
		If Not (Conn Is Nothing) Then Conn.Close ' Close Connection
		Set Conn = Nothing
		Set Security = Nothing
		Set Orders = Nothing
		Set ObjForm = Nothing

		' Go to url if specified
		If sReDirectUrl <> "" Then
			If Response.Buffer Then Response.Clear
			Response.Redirect sReDirectUrl
		End If
	End Sub

	'
	'  Subroutine Page_Terminate (End)
	' ----------------------------------------

	Dim TotalRecs
	Dim RecCnt
	Dim RecKeys
	Dim Recordset

	' Page main processing
	Sub Page_Main()
		Dim sFilter

		' Load Key Parameters
		RecKeys = Orders.GetRecordKeys() ' Load record keys
		sFilter = Orders.GetKeyFilter()
		If sFilter = "" Then
			Call Page_Terminate("Orderslist.asp") ' Prevent SQL injection, return to list
		End If

		' Set up filter (Sql Where Clause) and get Return Sql
		' Sql constructor in Orders class, Ordersinfo.asp

		Orders.CurrentFilter = sFilter

		' Get action
		If Request.Form("a_delete").Count > 0 Then
			Orders.CurrentAction = Request.Form("a_delete")
		Else
			Orders.CurrentAction = "I"	' Display record
		End If
		Select Case Orders.CurrentAction
			Case "D" ' Delete
				Orders.SendEmail = True ' Send email on delete success
				If DeleteRows() Then ' delete rows
					SuccessMessage = Language.Phrase("DeleteSuccess") ' Set up success message
					Call Page_Terminate(Orders.ReturnUrl) ' Return to caller
				End If
		End Select
	End Sub

	' -----------------------------------------------------------------
	' Load recordset
	'
	Function LoadRecordset()

		' Call Recordset Selecting event
		Dim sFilter
		sFilter = Orders.CurrentFilter
		Call Orders.Recordset_Selecting(sFilter)
		Orders.CurrentFilter = sFilter

		' Load list page sql
		Dim sSql
		sSql = Orders.ListSQL
		Call ew_SetDebugMsg("LoadRecordset: " & sSql) ' Show SQL for debugging

		' Load recordset
		Dim RsRecordset
		Set RsRecordset = ew_LoadRecordset(sSql)

		' Call Recordset Selected event
		Call Orders.Recordset_Selected(RsRecordset)
		Set LoadRecordset = RsRecordset
	End Function

	' -----------------------------------------------------------------
	' Load row based on key values
	'
	Function LoadRow()
		Dim RsRow, sSql, sFilter
		sFilter = Orders.KeyFilter

		' Call Row Selecting event
		Call Orders.Row_Selecting(sFilter)

		' Load sql based on filter
		Orders.CurrentFilter = sFilter
		sSql = Orders.SQL
		Call ew_SetDebugMsg("LoadRow: " & sSql) ' Show SQL for debugging
		Set RsRow = ew_LoadRow(sSql)
		If RsRow.Eof Then
			LoadRow = False
		Else
			LoadRow = True
			RsRow.MoveFirst
			Call LoadRowValues(RsRow) ' Load row values
		End If
		RsRow.Close
		Set RsRow = Nothing
	End Function

	' -----------------------------------------------------------------
	' Load row values from recordset
	'
	Sub LoadRowValues(RsRow)
		Dim sDetailFilter
		If RsRow.Eof Then Exit Sub

		' Call Row Selected event
		Call Orders.Row_Selected(RsRow)
		Orders.OrderId.DbValue = RsRow("OrderId")
		Orders.CustomerId.DbValue = RsRow("CustomerId")
		Orders.InvoiceId.DbValue = RsRow("InvoiceId")
		Orders.Amount.DbValue = RsRow("Amount")
		Orders.Ship_FirstName.DbValue = RsRow("Ship_FirstName")
		Orders.Ship_LastName.DbValue = RsRow("Ship_LastName")
		Orders.Ship_Address.DbValue = RsRow("Ship_Address")
		Orders.Ship_Address2.DbValue = RsRow("Ship_Address2")
		Orders.Ship_City.DbValue = RsRow("Ship_City")
		Orders.Ship_Province.DbValue = RsRow("Ship_Province")
		Orders.Ship_Postal.DbValue = RsRow("Ship_Postal")
		Orders.Ship_Country.DbValue = RsRow("Ship_Country")
		Orders.Ship_Phone.DbValue = RsRow("Ship_Phone")
		Orders.Ship_Email.DbValue = RsRow("Ship_Email")
		Orders.payment_status.DbValue = RsRow("payment_status")
		Orders.Ordered_Date.DbValue = RsRow("Ordered_Date")
		Orders.payment_date.DbValue = RsRow("payment_date")
		Orders.pfirst_name.DbValue = RsRow("pfirst_name")
		Orders.plast_name.DbValue = RsRow("plast_name")
		Orders.payer_email.DbValue = RsRow("payer_email")
		Orders.txn_id.DbValue = RsRow("txn_id")
		Orders.payment_gross.DbValue = RsRow("payment_gross")
		Orders.payment_fee.DbValue = RsRow("payment_fee")
		Orders.payment_type.DbValue = RsRow("payment_type")
		Orders.txn_type.DbValue = RsRow("txn_type")
		Orders.receiver_email.DbValue = RsRow("receiver_email")
		Orders.pShip_Name.DbValue = RsRow("pShip_Name")
		Orders.pShip_Address.DbValue = RsRow("pShip_Address")
		Orders.pShip_City.DbValue = RsRow("pShip_City")
		Orders.pShip_Province.DbValue = RsRow("pShip_Province")
		Orders.pShip_Postal.DbValue = RsRow("pShip_Postal")
		Orders.pShip_Country.DbValue = RsRow("pShip_Country")
		Orders.Tax.DbValue = RsRow("Tax")
		Orders.Shipping.DbValue = RsRow("Shipping")
		Orders.EmailSent.DbValue = RsRow("EmailSent")
		Orders.EmailDate.DbValue = RsRow("EmailDate")
	End Sub

	' -----------------------------------------------------------------
	' Render row values based on field settings
	'
	Sub RenderRow()

		' Initialize urls
		' Call Row Rendering event

		Call Orders.Row_Rendering()

		' ---------------------------------------
		'  Common render codes for all row types
		' ---------------------------------------
		' OrderId
		' CustomerId
		' InvoiceId
		' Amount
		' Ship_FirstName
		' Ship_LastName
		' Ship_Address
		' Ship_Address2
		' Ship_City
		' Ship_Province
		' Ship_Postal
		' Ship_Country
		' Ship_Phone
		' Ship_Email
		' payment_status
		' Ordered_Date
		' payment_date
		' pfirst_name
		' plast_name
		' payer_email
		' txn_id
		' payment_gross
		' payment_fee
		' payment_type
		' txn_type
		' receiver_email
		' pShip_Name
		' pShip_Address
		' pShip_City
		' pShip_Province
		' pShip_Postal
		' pShip_Country
		' Tax
		' Shipping
		' EmailSent
		' EmailDate
		' -----------
		'  View  Row
		' -----------

		If Orders.RowType = EW_ROWTYPE_VIEW Then ' View row

			' OrderId
			Orders.OrderId.ViewValue = Orders.OrderId.CurrentValue
			Orders.OrderId.ViewCustomAttributes = ""

			' CustomerId
			If Orders.CustomerId.CurrentValue & "" <> "" Then
				sFilterWrk = "[CustomerID] = " & ew_AdjustSql(Orders.CustomerId.CurrentValue) & ""
			sSqlWrk = "SELECT DISTINCT [Inv_FirstName], [Inv_LastName] FROM [Customers]"
			sWhereWrk = ""
			Call ew_AddFilter(sWhereWrk, sFilterWrk)
			If sWhereWrk <> "" Then sSqlWrk = sSqlWrk & " WHERE " & sWhereWrk
				Set RsWrk = Conn.Execute(sSqlWrk)
				If Not RsWrk.Eof Then
					Orders.CustomerId.ViewValue = RsWrk("Inv_FirstName")
					Orders.CustomerId.ViewValue = Orders.CustomerId.ViewValue & ew_ValueSeparator(0,1,Orders.CustomerId) & RsWrk("Inv_LastName")
				Else
					Orders.CustomerId.ViewValue = Orders.CustomerId.CurrentValue
				End If
				RsWrk.Close
				Set RsWrk = Nothing
			Else
				Orders.CustomerId.ViewValue = Null
			End If
			Orders.CustomerId.ViewCustomAttributes = ""

			' InvoiceId
			Orders.InvoiceId.ViewValue = Orders.InvoiceId.CurrentValue
			Orders.InvoiceId.ViewCustomAttributes = ""

			' Amount
			Orders.Amount.ViewValue = Orders.Amount.CurrentValue
			Orders.Amount.ViewCustomAttributes = ""

			' Ship_FirstName
			Orders.Ship_FirstName.ViewValue = Orders.Ship_FirstName.CurrentValue
			Orders.Ship_FirstName.ViewCustomAttributes = ""

			' Ship_LastName
			Orders.Ship_LastName.ViewValue = Orders.Ship_LastName.CurrentValue
			Orders.Ship_LastName.ViewCustomAttributes = ""

			' Ship_Address
			Orders.Ship_Address.ViewValue = Orders.Ship_Address.CurrentValue
			Orders.Ship_Address.ViewCustomAttributes = ""

			' Ship_Address2
			Orders.Ship_Address2.ViewValue = Orders.Ship_Address2.CurrentValue
			Orders.Ship_Address2.ViewCustomAttributes = ""

			' Ship_City
			Orders.Ship_City.ViewValue = Orders.Ship_City.CurrentValue
			Orders.Ship_City.ViewCustomAttributes = ""

			' Ship_Province
			Orders.Ship_Province.ViewValue = Orders.Ship_Province.CurrentValue
			Orders.Ship_Province.ViewCustomAttributes = ""

			' Ship_Postal
			Orders.Ship_Postal.ViewValue = Orders.Ship_Postal.CurrentValue
			Orders.Ship_Postal.ViewCustomAttributes = ""

			' Ship_Country
			Orders.Ship_Country.ViewValue = Orders.Ship_Country.CurrentValue
			Orders.Ship_Country.ViewCustomAttributes = ""

			' Ship_Phone
			Orders.Ship_Phone.ViewValue = Orders.Ship_Phone.CurrentValue
			Orders.Ship_Phone.ViewCustomAttributes = ""

			' Ship_Email
			Orders.Ship_Email.ViewValue = Orders.Ship_Email.CurrentValue
			Orders.Ship_Email.ViewCustomAttributes = ""

			' payment_status
			If Not IsNull(Orders.payment_status.CurrentValue) Then
				Select Case Orders.payment_status.CurrentValue
					Case "Completed"
						Orders.payment_status.ViewValue = ew_IIf(Orders.payment_status.FldTagCaption(1) <> "", Orders.payment_status.FldTagCaption(1), "Completed")
					Case "WIP"
						Orders.payment_status.ViewValue = ew_IIf(Orders.payment_status.FldTagCaption(2) <> "", Orders.payment_status.FldTagCaption(2), "WIP")
					Case "Pending"
						Orders.payment_status.ViewValue = ew_IIf(Orders.payment_status.FldTagCaption(3) <> "", Orders.payment_status.FldTagCaption(3), "Pending")
					Case "Failed"
						Orders.payment_status.ViewValue = ew_IIf(Orders.payment_status.FldTagCaption(4) <> "", Orders.payment_status.FldTagCaption(4), "Failed")
					Case Else
						Orders.payment_status.ViewValue = Orders.payment_status.CurrentValue
				End Select
			Else
				Orders.payment_status.ViewValue = Null
			End If
			Orders.payment_status.ViewCustomAttributes = ""

			' Ordered_Date
			Orders.Ordered_Date.ViewValue = Orders.Ordered_Date.CurrentValue
			Orders.Ordered_Date.ViewCustomAttributes = ""

			' payment_date
			Orders.payment_date.ViewValue = Orders.payment_date.CurrentValue
			Orders.payment_date.ViewCustomAttributes = ""

			' pfirst_name
			Orders.pfirst_name.ViewValue = Orders.pfirst_name.CurrentValue
			Orders.pfirst_name.ViewCustomAttributes = ""

			' plast_name
			Orders.plast_name.ViewValue = Orders.plast_name.CurrentValue
			Orders.plast_name.ViewCustomAttributes = ""

			' payer_email
			Orders.payer_email.ViewValue = Orders.payer_email.CurrentValue
			Orders.payer_email.ViewCustomAttributes = ""

			' txn_id
			Orders.txn_id.ViewValue = Orders.txn_id.CurrentValue
			Orders.txn_id.ViewCustomAttributes = ""

			' payment_gross
			Orders.payment_gross.ViewValue = Orders.payment_gross.CurrentValue
			Orders.payment_gross.ViewCustomAttributes = ""

			' payment_fee
			Orders.payment_fee.ViewValue = Orders.payment_fee.CurrentValue
			Orders.payment_fee.ViewCustomAttributes = ""

			' payment_type
			Orders.payment_type.ViewValue = Orders.payment_type.CurrentValue
			Orders.payment_type.ViewCustomAttributes = ""

			' txn_type
			Orders.txn_type.ViewValue = Orders.txn_type.CurrentValue
			Orders.txn_type.ViewCustomAttributes = ""

			' receiver_email
			Orders.receiver_email.ViewValue = Orders.receiver_email.CurrentValue
			Orders.receiver_email.ViewCustomAttributes = ""

			' pShip_Name
			Orders.pShip_Name.ViewValue = Orders.pShip_Name.CurrentValue
			Orders.pShip_Name.ViewCustomAttributes = ""

			' pShip_Address
			Orders.pShip_Address.ViewValue = Orders.pShip_Address.CurrentValue
			Orders.pShip_Address.ViewCustomAttributes = ""

			' pShip_City
			Orders.pShip_City.ViewValue = Orders.pShip_City.CurrentValue
			Orders.pShip_City.ViewCustomAttributes = ""

			' pShip_Province
			Orders.pShip_Province.ViewValue = Orders.pShip_Province.CurrentValue
			Orders.pShip_Province.ViewCustomAttributes = ""

			' pShip_Postal
			Orders.pShip_Postal.ViewValue = Orders.pShip_Postal.CurrentValue
			Orders.pShip_Postal.ViewCustomAttributes = ""

			' pShip_Country
			Orders.pShip_Country.ViewValue = Orders.pShip_Country.CurrentValue
			Orders.pShip_Country.ViewCustomAttributes = ""

			' Tax
			Orders.Tax.ViewValue = Orders.Tax.CurrentValue
			Orders.Tax.ViewCustomAttributes = ""

			' Shipping
			Orders.Shipping.ViewValue = Orders.Shipping.CurrentValue
			Orders.Shipping.ViewCustomAttributes = ""

			' EmailSent
			Orders.EmailSent.ViewValue = Orders.EmailSent.CurrentValue
			Orders.EmailSent.ViewCustomAttributes = ""

			' EmailDate
			Orders.EmailDate.ViewValue = Orders.EmailDate.CurrentValue
			Orders.EmailDate.ViewCustomAttributes = ""

			' View refer script
			' CustomerId

			Orders.CustomerId.LinkCustomAttributes = ""
			Orders.CustomerId.HrefValue = ""
			Orders.CustomerId.TooltipValue = ""

			' Amount
			Orders.Amount.LinkCustomAttributes = ""
			Orders.Amount.HrefValue = ""
			Orders.Amount.TooltipValue = ""

			' Ship_FirstName
			Orders.Ship_FirstName.LinkCustomAttributes = ""
			Orders.Ship_FirstName.HrefValue = ""
			Orders.Ship_FirstName.TooltipValue = ""

			' Ship_LastName
			Orders.Ship_LastName.LinkCustomAttributes = ""
			Orders.Ship_LastName.HrefValue = ""
			Orders.Ship_LastName.TooltipValue = ""

			' payment_status
			Orders.payment_status.LinkCustomAttributes = ""
			Orders.payment_status.HrefValue = ""
			Orders.payment_status.TooltipValue = ""

			' Ordered_Date
			Orders.Ordered_Date.LinkCustomAttributes = ""
			Orders.Ordered_Date.HrefValue = ""
			Orders.Ordered_Date.TooltipValue = ""

			' payment_date
			Orders.payment_date.LinkCustomAttributes = ""
			Orders.payment_date.HrefValue = ""
			Orders.payment_date.TooltipValue = ""

			' pfirst_name
			Orders.pfirst_name.LinkCustomAttributes = ""
			Orders.pfirst_name.HrefValue = ""
			Orders.pfirst_name.TooltipValue = ""

			' plast_name
			Orders.plast_name.LinkCustomAttributes = ""
			Orders.plast_name.HrefValue = ""
			Orders.plast_name.TooltipValue = ""

			' payer_email
			Orders.payer_email.LinkCustomAttributes = ""
			Orders.payer_email.HrefValue = ""
			Orders.payer_email.TooltipValue = ""

			' txn_id
			Orders.txn_id.LinkCustomAttributes = ""
			Orders.txn_id.HrefValue = ""
			Orders.txn_id.TooltipValue = ""

			' payment_gross
			Orders.payment_gross.LinkCustomAttributes = ""
			Orders.payment_gross.HrefValue = ""
			Orders.payment_gross.TooltipValue = ""

			' payment_fee
			Orders.payment_fee.LinkCustomAttributes = ""
			Orders.payment_fee.HrefValue = ""
			Orders.payment_fee.TooltipValue = ""

			' payment_type
			Orders.payment_type.LinkCustomAttributes = ""
			Orders.payment_type.HrefValue = ""
			Orders.payment_type.TooltipValue = ""

			' txn_type
			Orders.txn_type.LinkCustomAttributes = ""
			Orders.txn_type.HrefValue = ""
			Orders.txn_type.TooltipValue = ""

			' Tax
			Orders.Tax.LinkCustomAttributes = ""
			Orders.Tax.HrefValue = ""
			Orders.Tax.TooltipValue = ""

			' Shipping
			Orders.Shipping.LinkCustomAttributes = ""
			Orders.Shipping.HrefValue = ""
			Orders.Shipping.TooltipValue = ""

			' EmailSent
			Orders.EmailSent.LinkCustomAttributes = ""
			Orders.EmailSent.HrefValue = ""
			Orders.EmailSent.TooltipValue = ""

			' EmailDate
			Orders.EmailDate.LinkCustomAttributes = ""
			Orders.EmailDate.HrefValue = ""
			Orders.EmailDate.TooltipValue = ""
		End If

		' Call Row Rendered event
		If Orders.RowType <> EW_ROWTYPE_AGGREGATEINIT Then
			Call Orders.Row_Rendered()
		End If
	End Sub

	'
	' Delete records based on current filter
	'
	Function DeleteRows()
		If Not EW_DEBUG_ENABLED Then On Error Resume Next
		Dim sKey, sThisKey, sKeyFld, arKeyFlds
		Dim sSql, RsDelete
		Dim RsOld
		DeleteRows = True
		sSql = Orders.SQL
		Set RsDelete = Server.CreateObject("ADODB.Recordset")
		RsDelete.CursorLocation = EW_CURSORLOCATION
		RsDelete.Open sSql, Conn, 1, EW_RECORDSET_LOCKTYPE
		If Err.Number <> 0 Then
			FailureMessage = Err.Description
			RsDelete.Close
			Set RsDelete = Nothing
			DeleteRows = False
			Exit Function
		ElseIf RsDelete.Eof Then
			FailureMessage = Language.Phrase("NoRecord") ' No record found
			RsDelete.Close
			Set RsDelete = Nothing
			DeleteRows = False
			Exit Function
		End If
		Conn.BeginTrans

		' Clone old recordset object
		Set RsOld = ew_CloneRs(RsDelete)

		' Call row deleting event
		If DeleteRows Then
			RsDelete.MoveFirst
			Do While Not RsDelete.Eof
				DeleteRows = Orders.Row_Deleting(RsDelete)
				If Not DeleteRows Then Exit Do
				RsDelete.MoveNext
			Loop
			RsDelete.MoveFirst
		End If
		If DeleteRows Then
			sKey = ""
			RsDelete.MoveFirst
			Do While Not RsDelete.Eof
				sThisKey = ""
				If sThisKey <> "" Then sThisKey = sThisKey & EW_COMPOSITE_KEY_SEPARATOR
				sThisKey = sThisKey & RsDelete("OrderId")
				RsDelete.Delete
				If Err.Number <> 0 Then
					FailureMessage = Err.Description ' Set up error message
					DeleteRows = False
					Exit Do
				End If
				If sKey <> "" Then sKey = sKey & ", "
				sKey = sKey & sThisKey
				RsDelete.MoveNext
			Loop
		Else

			' Set up error message
			If Orders.CancelMessage <> "" Then
				FailureMessage = Orders.CancelMessage
				Orders.CancelMessage = ""
			Else
				FailureMessage = Language.Phrase("DeleteCancelled")
			End If
		End If
		If DeleteRows Then
			Conn.CommitTrans ' Commit the changes
			If Err.Number <> 0 Then
				FailureMessage = Err.Description
				DeleteRows = False ' Delete failed
			End If
		Else
			Conn.RollbackTrans ' Rollback changes
		End If
		RsDelete.Close
		Set RsDelete = Nothing

		' Call row deleting event
		If DeleteRows Then
			If Not RsOld.Eof Then RsOld.MoveFirst
			Do While Not RsOld.Eof
				Call Orders.Row_Deleted(RsOld)
				RsOld.MoveNext
			Loop
		End If
		RsOld.Close
		Set RsOld = Nothing
	End Function

	' Page Load event
	Sub Page_Load()

		'Response.Write "Page Load"
	End Sub

	' Page Unload event
	Sub Page_Unload()

		'Response.Write "Page Unload"
	End Sub

	' Page Redirecting event
	Sub Page_Redirecting(url)

		'url = newurl
	End Sub

	' Message Showing event
	' typ = ""|"success"|"failure"
	Sub Message_Showing(msg, typ)

		' Example:
		'If typ = "success" Then msg = "your success message"

	End Sub

	' Page Data Rendering event
	Sub Page_DataRendering(header)

		' Example:
		'header = "your header"

	End Sub

	' Page Data Rendered event
	Sub Page_DataRendered(footer)

		' Example:
		'footer = "your footer"

	End Sub
End Class
%>