<%

' -----------------------------------------------------------------
' Page Class
'
Class cOrders_grid

	' Page ID
	Public Property Get PageID()
		PageID = "grid"
	End Property

	' Table Name
	Public Property Get TableName()
		TableName = "Orders"
	End Property

	' Page Object Name
	Public Property Get PageObjName()
		PageObjName = "Orders_grid"
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

'		Set MasterTable = Table
		Set Table = Orders

		' Initialize urls
		' Initialize other table object

		If IsEmpty(Logins) Then Set Logins = New cLogins

		' Intialize page id (for backward compatibility)
		EW_PAGE_ID = "grid"

		' Initialize table name (for backward compatibility)
		EW_TABLE_NAME = "Orders"

		' Open connection to the database
		If IsEmpty(Conn) Then Call ew_Connect()

		' Initialize list options
		Set ListOptions = New cListOptions
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

		' Get grid add count
		Dim gridaddcnt
		gridaddcnt = Request.QueryString(EW_TABLE_GRID_ADD_ROW_COUNT)
		If IsNumeric(gridaddcnt) Then
			If gridaddcnt > 0 Then
				Orders.GridAddRowCount = gridaddcnt
			End If
		End If

		' Set up list options
		SetupListOptions()

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

'		Set Table = MasterTable
		If url = "" Then
			Exit Sub
		End If

		' Global page unloaded event (in userfn60.asp)
		Call Page_Unloaded()
		Dim sRedirectUrl
		sReDirectUrl = url
		Call Page_Redirecting(sReDirectUrl)
		Set Security = Nothing
		Set Orders = Nothing

		' Go to url if specified
		If sReDirectUrl <> "" Then
			If Response.Buffer Then Response.Clear
			Response.Redirect sReDirectUrl
		End If
	End Sub

	'
	'  Subroutine Page_Terminate (End)
	' ----------------------------------------

	Dim DisplayRecs ' Number of display records
	Dim StartRec, StopRec, TotalRecs, RecRange
	Dim SearchWhere
	Dim RecCnt
	Dim EditRowCnt
	Dim RowCnt, RowIndex
	Dim RecPerRow, ColCnt
	Dim KeyCount
	Dim RowAction
	Dim RowOldKey ' Row old key (for copy)
	Dim DbMasterFilter, DbDetailFilter
	Dim MasterRecordExists
	Dim ListOptions
	Dim ExportOptions
	Dim MultiSelectKey
	Dim RestoreSearch
	Dim Recordset, OldRecordset

	' -----------------------------------------------------------------
	' Page main processing
	'
	Sub Page_Main()
		DisplayRecs = 20
		RecRange = 10
		RecCnt = 0 ' Record count
		KeyCount = 0 ' Key count

		' Search filters
		Dim sSrchAdvanced, sSrchBasic, sFilter
		sSrchAdvanced = "" ' Advanced search filter
		sSrchBasic = "" ' Basic search filter
		SearchWhere = "" ' Search where clause
		sFilter = ""

		' Master/Detail
		DbMasterFilter = "" ' Master filter
		DbDetailFilter = "" ' Detail filter
		If IsPageRequest Then ' Validate request

			' Handle reset command
			ResetCmd()

			' Set up master detail parameters
			SetUpMasterParms()

			' Hide all options
			If Orders.Export <> "" Or Orders.CurrentAction = "gridadd" Or Orders.CurrentAction = "gridedit" Then
				ListOptions.HideAllOptions()
			End If

			' Show grid delete link for grid add / grid edit
			If Orders.AllowAddDeleteRow Then
				If Orders.CurrentAction = "gridadd" Or Orders.CurrentAction = "gridedit" Then
					ListOptions.GetItem("griddelete").Visible = True
				End If
			End If

			' Set Up Sorting Order
			SetUpSortOrder()
		End If ' End Validate Request

		' Restore display records
		If Orders.RecordsPerPage <> "" Then
			DisplayRecs = Orders.RecordsPerPage ' Restore from Session
		Else
			DisplayRecs = 20 ' Load default
		End If

		' Load Sorting Order
		LoadSortOrder()
		sFilter = ""

		' Restore master/detail filter
		DbMasterFilter = Orders.MasterFilter ' Restore master filter
		DbDetailFilter = Orders.DetailFilter ' Restore detail filter
		Call ew_AddFilter(sFilter, DbDetailFilter)
		Call ew_AddFilter(sFilter, SearchWhere)
		Dim RsMaster

		' Load master record
		If Orders.MasterFilter <> "" And Orders.CurrentMasterTable = "Customers" Then
			Set RsMaster = Customers.LoadRs(DbMasterFilter)
			MasterRecordExists = Not (RsMaster Is Nothing)
			If Not MasterRecordExists Then
			Else
				Call Customers.LoadListRowValues(RsMaster)
				Customers.RowType = EW_ROWTYPE_MASTER ' Master row
				Call Customers.RenderListRow()
				RsMaster.Close
				Set RsMaster = Nothing
			End If
		End If

		' Set up filter in Session
		Orders.SessionWhere = sFilter
		Orders.CurrentFilter = ""
	End Sub

	' -----------------------------------------------------------------
	'  Exit out of inline mode
	'
	Sub ClearInlineMode()
		Orders.LastAction = Orders.CurrentAction ' Save last action
		Orders.CurrentAction = "" ' Clear action
		Session(EW_SESSION_INLINE_MODE) = "" ' Clear inline mode
	End Sub

	' -----------------------------------------------------------------
	' Switch to Grid Add Mode
	'
	Sub GridAddMode()
		Session(EW_SESSION_INLINE_MODE) = "gridadd" ' Enabled grid add
	End Sub

	' -----------------------------------------------------------------
	' Switch to Grid Edit Mode
	'
	Sub GridEditMode()
		Session(EW_SESSION_INLINE_MODE) = "gridedit" ' Enabled grid edit
	End Sub

	' -----------------------------------------------------------------
	' Peform update to grid
	'
	Function GridUpdate()
		Dim rowindex
		Dim bGridUpdate
		Dim sKey, sThisKey
		Dim Rs, RsOld, RsNew, sSql
		rowindex = 1
		bGridUpdate = True

		' Get old recordset
		Orders.CurrentFilter  = BuildKeyFilter()
		sSql = Orders.SQL
		Set Rs = Server.CreateObject("ADODB.Recordset")
		Rs.CursorLocation = EW_CURSORLOCATION
		Rs.Open sSql, Conn, 1, EW_RECORDSET_LOCKTYPE
		Set RsOld = ew_CloneRs(Rs)
		sKey = ""

		' Update row index and get row key
		Dim rowcnt
		ObjForm.Index = 0
		rowcnt = ObjForm.GetValue("key_count")
		If rowcnt = "" Or Not IsNumeric(rowcnt) Then
			rowcnt = 0
		End If

		' Update all rows based on key
		Dim rowkey, rowaction
		For rowindex = 1 to rowcnt
			ObjForm.Index = rowindex
			rowkey = ObjForm.GetValue("k_key") & ""
			rowaction = ObjForm.GetValue("k_action") & ""

			' Load all values & keys
			If rowaction <> "insertdelete" Then ' Skip insert then deleted rows
				Call LoadFormValues() ' Get form values
				If rowaction = "" Or rowaction = "edit" Or rowaction = "delete" Then
					bGridUpdate = SetupKeyValues(rowkey) ' Set up key values
				Else
					bGridUpdate = True
				End If

				' Skip empty row
				If rowaction = "insert" And EmptyRow() Then

					' No action required
				' Validate form and insert/update/delete record

				ElseIf bGridUpdate Then
					If rowaction = "delete" Then
						Orders.CurrentFilter = Orders.KeyFilter
						bGridUpdate = DeleteRows() ' Delete this row
					ElseIf Not ValidateForm() Then
						bGridUpdate = False ' Form error, reset action
						FailureMessage = gsFormError
					Else
						If rowaction = "insert" Then
							bGridUpdate = AddRow(Null) ' Insert this row
						Else
							If rowkey <> "" Then
								Orders.SendEmail = False ' Do not send email on update success

								' Set detail key fields disabled flag to skip update
								If Orders.CurrentMasterTable = "Customers" Then
									Orders.CustomerId.Disabled = True ' Set field disabled flag to skip update
								End If
								bGridUpdate = EditRow() ' Update this row

								' Reset detail key fields disabled flag
								If Orders.CurrentMasterTable = "Customers" Then
									Orders.CustomerId.Disabled = False ' Reset field disabled flag
								End If
							End If
						End If ' End update
					End If
				End If
				If bGridUpdate Then
					If sKey <> "" Then sKey = sKey & ", "
					sKey = sKey & rowkey
				Else
					Exit For
				End If
			End If
		Next
		If bGridUpdate Then

			' Get new recordset
			Set Rs = Conn.Execute(sSql)
			Set RsNew = ew_CloneRs(Rs)
			Call ClearInlineMode() ' Clear inline edit mode
		Else
			If FailureMessage = "" Then
				FailureMessage = Language.Phrase("UpdateFailed") ' Set update failed message
			End If
			Orders.EventCancelled = True ' Set event cancelled
			Orders.CurrentAction = "gridedit" ' Stay in gridedit mode
		End If
		Set Rs = Nothing
		Set RsOld = Nothing
		Set RsNew = Nothing
		GridUpdate = bGridUpdate
	End Function

	' -----------------------------------------------------------------
	'  Build filter for all keys
	'
	Function BuildKeyFilter()
		Dim rowindex, sThisKey
		Dim sKey
		Dim sWrkFilter, sFilter
		sWrkFilter = ""

		' Update row index and get row key
		rowindex = 1
		ObjForm.Index = rowindex
		sThisKey = ObjForm.GetValue("k_key") & ""
		Do While (sThisKey <> "")
			If SetupKeyValues(sThisKey) Then
				sFilter = Orders.KeyFilter
				If sWrkFilter <> "" Then sWrkFilter = sWrkFilter & " OR "
				sWrkFilter = sWrkFilter & sFilter
			Else
				sWrkFilter = "0=1"
				Exit Do
			End If

			' Update row index and get row key
			rowindex = rowindex + 1 ' next row
			ObjForm.Index = rowindex
			sThisKey = ObjForm.GetValue("k_key") & ""
		Loop
		BuildKeyFilter = sWrkFilter
	End Function

	' -----------------------------------------------------------------
	' Set up key values
	'
	Function SetupKeyValues(key)
		Dim arrKeyFlds
		arrKeyFlds = Split(key&"", EW_COMPOSITE_KEY_SEPARATOR)
		If UBound(arrKeyFlds) >= 0 Then
			Orders.OrderId.FormValue = arrKeyFlds(0)
			If Not IsNumeric(Orders.OrderId.FormValue) Then
				SetupKeyValues = False
				Exit Function
			End If
		End If
		SetupKeyValues = True
	End Function

	' Grid Insert
	' Peform insert to grid
	Function GridInsert()
		Dim addcnt
		Dim rowindex, rowcnt
		Dim bGridInsert
		Dim sSql, sWrkFilter, sFilter, sKey, sThisKey
		Dim Rs, RsNew
		rowindex = 1
		bGridInsert = False

		' Init key filter
		sWrkFilter = ""
		addcnt = 0
		sKey = ""

		' Get row count
		ObjForm.Index = 0
		rowcnt = ObjForm.GetValue("key_count") & ""
		If rowcnt = "" Or Not IsNumeric(rowcnt) Then rowcnt = 0

		' Insert all rows
		For rowindex = 1 to rowcnt

			' Load current row values
			ObjForm.Index = rowindex
			Dim rowaction
			rowaction = ObjForm.GetValue("k_action") & ""
			If rowaction = "" Or rowaction = "insert" Then
				If rowaction = "insert" Then
					RowOldKey = ObjForm.GetValue("k_oldkey") & ""
					LoadOldRecord() ' Load old recordset
				End If
				Call LoadFormValues() ' Get form values
				If Not EmptyRow() Then
					addcnt = addcnt + 1
					Orders.SendEmail = False ' Do not send email on insert success

					' Validate Form
					If Not ValidateForm() Then
						bGridInsert = False ' Form error, reset action
						FailureMessage = gsFormError
					Else
						bGridInsert = AddRow(OldRecordset) ' Insert this row
					End If
					If bGridInsert Then
						If sKey <> "" Then sKey = sKey & EW_COMPOSITE_KEY_SEPARATOR
						sKey = sKey & Orders.OrderId.CurrentValue

						' Add filter for this record
						sFilter = Orders.KeyFilter
						If sWrkFilter <> "" Then sWrkFilter = sWrkFilter & " OR "
						sWrkFilter = sWrkFilter & sFilter
					Else
						Exit For
					End If
				End If
			End If
		Next
		If addcnt = 0 Then ' No record inserted
			Call ClearInlineMode() ' Clear grid add mode and return
			GridInsert = True
			Exit Function
		End If
		If bGridInsert Then

			' Get new recordset
			Orders.CurrentFilter  = sWrkFilter
			sSql = Orders.SQL
			Set Rs = Conn.Execute(sSql)
			Set RsNew = ew_CloneRs(Rs)
			Call ClearInlineMode() ' Clear grid add mode
		Else
			If FailureMessage = "" Then
				FailureMessage = Language.Phrase("InsertFailed") ' Set insert failed message
			End If
			Orders.EventCancelled = True ' Set event cancelled
			Orders.CurrentAction = "gridadd" ' Stay in gridadd mode
		End If
		Set Rs = Nothing
		Set RsNew = Nothing
		GridInsert = bGridInsert
	End Function

	' Check if empty row
	Function EmptyRow()
		EmptyRow = True
		If EmptyRow And ObjForm.HasValue("x_CustomerId") And ObjForm.HasValue("o_CustomerId") Then EmptyRow = (Orders.CustomerId.CurrentValue&"" = Orders.CustomerId.OldValue&"")
		If EmptyRow And ObjForm.HasValue("x_Amount") And ObjForm.HasValue("o_Amount") Then EmptyRow = (Orders.Amount.CurrentValue&"" = Orders.Amount.OldValue&"")
		If EmptyRow And ObjForm.HasValue("x_Ship_FirstName") And ObjForm.HasValue("o_Ship_FirstName") Then EmptyRow = (Orders.Ship_FirstName.CurrentValue&"" = Orders.Ship_FirstName.OldValue&"")
		If EmptyRow And ObjForm.HasValue("x_Ship_LastName") And ObjForm.HasValue("o_Ship_LastName") Then EmptyRow = (Orders.Ship_LastName.CurrentValue&"" = Orders.Ship_LastName.OldValue&"")
		If EmptyRow And ObjForm.HasValue("x_payment_status") And ObjForm.HasValue("o_payment_status") Then EmptyRow = (Orders.payment_status.CurrentValue&"" = Orders.payment_status.OldValue&"")
		If EmptyRow And ObjForm.HasValue("x_Ordered_Date") And ObjForm.HasValue("o_Ordered_Date") Then EmptyRow = (Orders.Ordered_Date.CurrentValue&"" = Orders.Ordered_Date.OldValue&"")
		If EmptyRow And ObjForm.HasValue("x_payer_email") And ObjForm.HasValue("o_payer_email") Then EmptyRow = (Orders.payer_email.CurrentValue&"" = Orders.payer_email.OldValue&"")
		If EmptyRow And ObjForm.HasValue("x_payment_gross") And ObjForm.HasValue("o_payment_gross") Then EmptyRow = (Orders.payment_gross.CurrentValue&"" = Orders.payment_gross.OldValue&"")
		If EmptyRow And ObjForm.HasValue("x_payment_fee") And ObjForm.HasValue("o_payment_fee") Then EmptyRow = (Orders.payment_fee.CurrentValue&"" = Orders.payment_fee.OldValue&"")
		If EmptyRow And ObjForm.HasValue("x_Tax") And ObjForm.HasValue("o_Tax") Then EmptyRow = (Orders.Tax.CurrentValue&"" = Orders.Tax.OldValue&"")
		If EmptyRow And ObjForm.HasValue("x_Shipping") And ObjForm.HasValue("o_Shipping") Then EmptyRow = (Orders.Shipping.CurrentValue&"" = Orders.Shipping.OldValue&"")
		If EmptyRow And ObjForm.HasValue("x_EmailSent") And ObjForm.HasValue("o_EmailSent") Then EmptyRow = (Orders.EmailSent.CurrentValue&"" = Orders.EmailSent.OldValue&"")
		If EmptyRow And ObjForm.HasValue("x_EmailDate") And ObjForm.HasValue("o_EmailDate") Then EmptyRow = (Orders.EmailDate.CurrentValue&"" = Orders.EmailDate.OldValue&"")
		If EmptyRow And ObjForm.HasValue("x_PromoCodeUsed") And ObjForm.HasValue("o_PromoCodeUsed") Then EmptyRow = (Orders.PromoCodeUsed.CurrentValue&"" = Orders.PromoCodeUsed.OldValue&"")
	End Function

	' Validate grid form
	Function ValidateGridForm()
		Dim rowindex, rowcnt, rowaction

		' Get row count
		ObjForm.Index = 0
		rowcnt = ObjForm.GetValue("key_count")&""
		If rowcnt = "" Or Not IsNumeric(rowcnt) Then
			rowcnt = 0
		End If

		' Validate all records
		ValidateGridForm = True
		For rowindex = 1 to rowcnt

			' Load current row values
			ObjForm.Index = rowindex
			rowaction = ObjForm.GetValue("k_action") & ""
			If rowaction <> "delete" And rowaction <> "insertdelete" Then
				LoadFormValues() ' Get form values
				If rowaction = "insert" And EmptyRow() Then

					' Ignore
				ElseIf Not ValidateForm() Then
					ValidateGridForm = False
					Exit For
				End If
			End If
		Next
	End Function

	' -----------------------------------------------------------------
	' Restore form values for current row
	'
	Sub RestoreCurrentRowFormValues(idx)

		' Get row based on current index
		ObjForm.Index = idx
		Call LoadFormValues() ' Load form values
	End Sub

	' -----------------------------------------------------------------
	' Set up Sort parameters based on Sort Links clicked
	'
	Sub SetUpSortOrder()
		Dim sOrderBy
		Dim sSortField, sLastSort, sThisSort
		Dim bCtrl

		' Check for an Order parameter
		If Request.QueryString("order").Count > 0 Then
			Orders.CurrentOrder = Request.QueryString("order")
			Orders.CurrentOrderType = Request.QueryString("ordertype")
			Orders.StartRecordNumber = 1 ' Reset start position
		End If
	End Sub

	' -----------------------------------------------------------------
	' Load Sort Order parameters
	'
	Sub LoadSortOrder()
		Dim sOrderBy
		sOrderBy = Orders.SessionOrderBy ' Get order by from Session
		If sOrderBy = "" Then
			If Orders.SqlOrderBy <> "" Then
				sOrderBy = Orders.SqlOrderBy
				Orders.SessionOrderBy = sOrderBy
				Orders.OrderId.Sort = "DESC"
			End If
		End If
	End Sub

	' -----------------------------------------------------------------
	' Reset command based on querystring parameter cmd=
	' - RESET: reset search parameters
	' - RESETALL: reset search & master/detail parameters
	' - RESETSORT: reset sort parameters
	'
	Sub ResetCmd()
		Dim sCmd

		' Get reset cmd
		If Request.QueryString("cmd").Count > 0 Then
			sCmd = Request.QueryString("cmd")

			' Reset master/detail keys
			If LCase(sCmd) = "resetall" Then
				Orders.CurrentMasterTable = "" ' Clear master table
				DbMasterFilter = ""
				DbDetailFilter = ""
				Orders.CustomerId.SessionValue = ""
			End If

			' Reset Sort Criteria
			If LCase(sCmd) = "resetsort" Then
				Dim sOrderBy
				sOrderBy = ""
				Orders.SessionOrderBy = sOrderBy
			End If

			' Reset start position
			StartRec = 1
			Orders.StartRecordNumber = StartRec
		End If
	End Sub

	' Set up list options
	Sub SetupListOptions()
		Dim item

		' "griddelete"
		If Orders.AllowAddDeleteRow Then
			ListOptions.Add("griddelete")
			Set item = ListOptions.GetItem("griddelete")
			item.CssStyle = "white-space: nowrap;"
			item.OnLeft = True
			item.Visible = False ' Default hidden
		End If
		Call ListOptions_Load()
	End Sub

	' Render list options
	Sub RenderListOptions()
		Dim item, links
		ListOptions.LoadDefault()

		' Set up row action and key
		If IsNumeric(RowIndex) Then
			ObjForm.Index = RowIndex
			If RowAction <> "" Then
				MultiSelectKey = MultiSelectKey & "<input type=""hidden"" name=""k" & RowIndex & "_action"" id=""k" & RowIndex & "_action"" value=""" & RowAction & """>"
			End If
			If ObjForm.HasValue("k_oldkey") Then
				RowOldKey = ObjForm.GetValue("k_oldkey") & ""
			End If
			If RowOldKey <> "" Then
				MultiSelectKey = MultiSelectKey & "<input type=""hidden"" name=""k" & RowIndex & "_oldkey"" id=""k" & RowIndex & "_oldkey"" value = """ & ew_HtmlEncode(RowOldKey) & """>"
			End If
			If RowAction = "delete" Then
				Dim sKey
				sKey = ObjForm.GetValue("k_key") & ""
				Call SetupKeyValues(sKey)
			End If
		End If

		' "delete"
		If Orders.AllowAddDeleteRow Then
			If Orders.CurrentMode = "add" Or Orders.CurrentMode = "copy" Or Orders.CurrentMode = "edit" Then
				Set item = ListOptions.GetItem("griddelete")
				item.Body = "<a class=""ewGridLink"" href=""javascript:void(0);"" onclick=""ew_DeleteGridRow(this, Orders_grid, " & RowIndex & ");"">" & "<img src=""images/delete.gif"" alt=""" & ew_HtmlEncode(Language.Phrase("DeleteLink")) & """ title=""" & ew_HtmlEncode(Language.Phrase("DeleteLink")) & """ width=""16"" height=""16"" border=""0"">" & "</a>"
			End If
		End If
		If Orders.CurrentMode = "edit" And RowIndex <> "" And IsNumeric(RowIndex) Then
			MultiSelectKey = MultiSelectKey & "<input type=""hidden"" name=""k" & RowIndex & "_key"" id=""k" & RowIndex & "_key"" value=""" & Orders.OrderId.CurrentValue & """>"
		End If
		Call RenderListOptionsExt()
		Call ListOptions_Rendered()
	End Sub

	' Set record key
	Function SetRecordKey(rs)
		Dim key
		key = ""
		SetRecordKey = key
		If rs.Eof Then Exit Function
		If (key <> "") Then key = key & EW_COMPOSITE_KEY_SEPARATOR
		key = key & rs("OrderId")
		SetRecordKey = key
	End Function

	Function RenderListOptionsExt()
	End Function
	Dim Pager

	' -----------------------------------------------------------------
	' Set up Starting Record parameters based on Pager Navigation
	'
	Sub SetUpStartRec()
		Dim PageNo

		' Exit if DisplayRecs = 0
		If DisplayRecs = 0 Then Exit Sub
		If IsPageRequest Then ' Validate request

			' Check for a START parameter
			If Request.QueryString(EW_TABLE_START_REC).Count > 0 Then
				StartRec = Request.QueryString(EW_TABLE_START_REC)
				Orders.StartRecordNumber = StartRec
			ElseIf Request.QueryString(EW_TABLE_PAGE_NO).Count > 0 Then
				PageNo = Request.QueryString(EW_TABLE_PAGE_NO)
				If IsNumeric(PageNo) Then
					StartRec = (PageNo-1)*DisplayRecs+1
					If StartRec <= 0 Then
						StartRec = 1
					ElseIf StartRec >= ((TotalRecs-1)\DisplayRecs)*DisplayRecs+1 Then
						StartRec = ((TotalRecs-1)\DisplayRecs)*DisplayRecs+1
					End If
					Orders.StartRecordNumber = StartRec
				End If
			End If
		End If
		StartRec = Orders.StartRecordNumber

		' Check if correct start record counter
		If Not IsNumeric(StartRec) Or StartRec = "" Then ' Avoid invalid start record counter
			StartRec = 1 ' Reset start record counter
			Orders.StartRecordNumber = StartRec
		ElseIf CLng(StartRec) > CLng(TotalRecs) Then ' Avoid starting record > total records
			StartRec = ((TotalRecs-1)\DisplayRecs)*DisplayRecs+1 ' Point to last page first record
			Orders.StartRecordNumber = StartRec
		ElseIf (StartRec-1) Mod DisplayRecs <> 0 Then
			StartRec = ((StartRec-1)\DisplayRecs)*DisplayRecs+1 ' Point to page boundary
			Orders.StartRecordNumber = StartRec
		End If
	End Sub

	' -----------------------------------------------------------------
	' Function Get upload files
	'
	Function GetUploadFiles()

		' Get upload data
		Dim index, confirmPage
		index = ObjForm.Index ' Save form index
		ObjForm.Index = 0
		confirmPage = (ObjForm.GetValue("a_confirm") & "" <> "")
		ObjForm.Index = index ' Restore form index
	End Function

	' -----------------------------------------------------------------
	' Load default values
	'
	Function LoadDefaultValues()
		Orders.OrderId.CurrentValue = Null
		Orders.OrderId.OldValue = Orders.OrderId.CurrentValue
		Orders.CustomerId.CurrentValue = Null
		Orders.CustomerId.OldValue = Orders.CustomerId.CurrentValue
		Orders.Amount.CurrentValue = Null
		Orders.Amount.OldValue = Orders.Amount.CurrentValue
		Orders.Ship_FirstName.CurrentValue = Null
		Orders.Ship_FirstName.OldValue = Orders.Ship_FirstName.CurrentValue
		Orders.Ship_LastName.CurrentValue = Null
		Orders.Ship_LastName.OldValue = Orders.Ship_LastName.CurrentValue
		Orders.payment_status.CurrentValue = "WIP"
		Orders.payment_status.OldValue = Orders.payment_status.CurrentValue
		Orders.Ordered_Date.CurrentValue = Now()
		Orders.Ordered_Date.OldValue = Orders.Ordered_Date.CurrentValue
		Orders.payer_email.CurrentValue = Null
		Orders.payer_email.OldValue = Orders.payer_email.CurrentValue
		Orders.payment_gross.CurrentValue = Null
		Orders.payment_gross.OldValue = Orders.payment_gross.CurrentValue
		Orders.payment_fee.CurrentValue = Null
		Orders.payment_fee.OldValue = Orders.payment_fee.CurrentValue
		Orders.Tax.CurrentValue = Null
		Orders.Tax.OldValue = Orders.Tax.CurrentValue
		Orders.Shipping.CurrentValue = Null
		Orders.Shipping.OldValue = Orders.Shipping.CurrentValue
		Orders.EmailSent.CurrentValue = Null
		Orders.EmailSent.OldValue = Orders.EmailSent.CurrentValue
		Orders.EmailDate.CurrentValue = Null
		Orders.EmailDate.OldValue = Orders.EmailDate.CurrentValue
		Orders.PromoCodeUsed.CurrentValue = Null
		Orders.PromoCodeUsed.OldValue = Orders.PromoCodeUsed.CurrentValue
	End Function

	' -----------------------------------------------------------------
	' Load form values
	'
	Function LoadFormValues()

		' Load values from form
		If Not Orders.OrderId.FldIsDetailKey And Orders.CurrentAction <> "gridadd" And Orders.CurrentAction <> "add" Then Orders.OrderId.FormValue = ObjForm.GetValue("x_OrderId")
		If Not Orders.CustomerId.FldIsDetailKey Then Orders.CustomerId.FormValue = ObjForm.GetValue("x_CustomerId")
		Orders.CustomerId.OldValue = ObjForm.GetValue("o_CustomerId")
		If Not Orders.Amount.FldIsDetailKey Then Orders.Amount.FormValue = ObjForm.GetValue("x_Amount")
		Orders.Amount.OldValue = ObjForm.GetValue("o_Amount")
		If Not Orders.Ship_FirstName.FldIsDetailKey Then Orders.Ship_FirstName.FormValue = ObjForm.GetValue("x_Ship_FirstName")
		Orders.Ship_FirstName.OldValue = ObjForm.GetValue("o_Ship_FirstName")
		If Not Orders.Ship_LastName.FldIsDetailKey Then Orders.Ship_LastName.FormValue = ObjForm.GetValue("x_Ship_LastName")
		Orders.Ship_LastName.OldValue = ObjForm.GetValue("o_Ship_LastName")
		If Not Orders.payment_status.FldIsDetailKey Then Orders.payment_status.FormValue = ObjForm.GetValue("x_payment_status")
		Orders.payment_status.OldValue = ObjForm.GetValue("o_payment_status")
		If Not Orders.Ordered_Date.FldIsDetailKey Then Orders.Ordered_Date.FormValue = ObjForm.GetValue("x_Ordered_Date")
		If Not Orders.Ordered_Date.FldIsDetailKey Then Orders.Ordered_Date.CurrentValue = ew_UnFormatDateTime(Orders.Ordered_Date.CurrentValue, 8)
		Orders.Ordered_Date.OldValue = ObjForm.GetValue("o_Ordered_Date")
		If Not Orders.payer_email.FldIsDetailKey Then Orders.payer_email.FormValue = ObjForm.GetValue("x_payer_email")
		Orders.payer_email.OldValue = ObjForm.GetValue("o_payer_email")
		If Not Orders.payment_gross.FldIsDetailKey Then Orders.payment_gross.FormValue = ObjForm.GetValue("x_payment_gross")
		Orders.payment_gross.OldValue = ObjForm.GetValue("o_payment_gross")
		If Not Orders.payment_fee.FldIsDetailKey Then Orders.payment_fee.FormValue = ObjForm.GetValue("x_payment_fee")
		Orders.payment_fee.OldValue = ObjForm.GetValue("o_payment_fee")
		If Not Orders.Tax.FldIsDetailKey Then Orders.Tax.FormValue = ObjForm.GetValue("x_Tax")
		Orders.Tax.OldValue = ObjForm.GetValue("o_Tax")
		If Not Orders.Shipping.FldIsDetailKey Then Orders.Shipping.FormValue = ObjForm.GetValue("x_Shipping")
		Orders.Shipping.OldValue = ObjForm.GetValue("o_Shipping")
		If Not Orders.EmailSent.FldIsDetailKey Then Orders.EmailSent.FormValue = ObjForm.GetValue("x_EmailSent")
		Orders.EmailSent.OldValue = ObjForm.GetValue("o_EmailSent")
		If Not Orders.EmailDate.FldIsDetailKey Then Orders.EmailDate.FormValue = ObjForm.GetValue("x_EmailDate")
		If Not Orders.EmailDate.FldIsDetailKey Then Orders.EmailDate.CurrentValue = ew_UnFormatDateTime(Orders.EmailDate.CurrentValue, 8)
		Orders.EmailDate.OldValue = ObjForm.GetValue("o_EmailDate")
		If Not Orders.PromoCodeUsed.FldIsDetailKey Then Orders.PromoCodeUsed.FormValue = ObjForm.GetValue("x_PromoCodeUsed")
		Orders.PromoCodeUsed.OldValue = ObjForm.GetValue("o_PromoCodeUsed")
	End Function

	' -----------------------------------------------------------------
	' Restore form values
	'
	Function RestoreFormValues()
		If Orders.CurrentAction <> "gridadd" And Orders.CurrentAction <> "add" Then Orders.OrderId.CurrentValue = Orders.OrderId.FormValue
		Orders.CustomerId.CurrentValue = Orders.CustomerId.FormValue
		Orders.Amount.CurrentValue = Orders.Amount.FormValue
		Orders.Ship_FirstName.CurrentValue = Orders.Ship_FirstName.FormValue
		Orders.Ship_LastName.CurrentValue = Orders.Ship_LastName.FormValue
		Orders.payment_status.CurrentValue = Orders.payment_status.FormValue
		Orders.Ordered_Date.CurrentValue = Orders.Ordered_Date.FormValue
		Orders.Ordered_Date.CurrentValue = ew_UnFormatDateTime(Orders.Ordered_Date.CurrentValue, 8)
		Orders.payer_email.CurrentValue = Orders.payer_email.FormValue
		Orders.payment_gross.CurrentValue = Orders.payment_gross.FormValue
		Orders.payment_fee.CurrentValue = Orders.payment_fee.FormValue
		Orders.Tax.CurrentValue = Orders.Tax.FormValue
		Orders.Shipping.CurrentValue = Orders.Shipping.FormValue
		Orders.EmailSent.CurrentValue = Orders.EmailSent.FormValue
		Orders.EmailDate.CurrentValue = Orders.EmailDate.FormValue
		Orders.EmailDate.CurrentValue = ew_UnFormatDateTime(Orders.EmailDate.CurrentValue, 8)
		Orders.PromoCodeUsed.CurrentValue = Orders.PromoCodeUsed.FormValue
	End Function

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
		Orders.PromoCodeUsed.DbValue = RsRow("PromoCodeUsed")
	End Sub

	' Load old record
	Function LoadOldRecord()

		' Load key values from Session
		Dim bValidKey
		bValidKey = True
		Dim arKeys, cnt
		ReDim arKeys(0)
		arKeys(0) = RowOldKey
		cnt = UBound(arKeys)+1
		If cnt >= 1 Then
			If arKeys(0) & "" <> "" Then
				Orders.OrderId.CurrentValue = arKeys(0) & "" ' OrderId
			Else
				bValidKey = False
			End If
		Else
			bValidKey = False
		End If

		' Load old recordset
		If bValidKey Then
			Orders.CurrentFilter = Orders.KeyFilter
			Dim sSql
			sSql = Orders.SQL
			Set OldRecordset = ew_LoadRecordset(sSql)
			Call LoadRowValues(OldRecordset) ' Load row values
		Else
			OldRecordset = Null
		End If
		LoadOldRecord = bValidKey
	End Function

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
		' PromoCodeUsed
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
					Case "Cancelled"
						Orders.payment_status.ViewValue = ew_IIf(Orders.payment_status.FldTagCaption(5) <> "", Orders.payment_status.FldTagCaption(5), "Cancelled")
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
			If Not IsNull(Orders.EmailSent.CurrentValue) Then
				Select Case Orders.EmailSent.CurrentValue
					Case "confirm"
						Orders.EmailSent.ViewValue = ew_IIf(Orders.EmailSent.FldTagCaption(1) <> "", Orders.EmailSent.FldTagCaption(1), "Confirm")
					Case Else
						Orders.EmailSent.ViewValue = Orders.EmailSent.CurrentValue
				End Select
			Else
				Orders.EmailSent.ViewValue = Null
			End If
			Orders.EmailSent.ViewCustomAttributes = ""

			' EmailDate
			Orders.EmailDate.ViewValue = Orders.EmailDate.CurrentValue
			Orders.EmailDate.ViewCustomAttributes = ""

			' PromoCodeUsed
			Orders.PromoCodeUsed.ViewValue = Orders.PromoCodeUsed.CurrentValue
			Orders.PromoCodeUsed.ViewCustomAttributes = ""

			' View refer script
			' OrderId

			Orders.OrderId.LinkCustomAttributes = ""
			Orders.OrderId.HrefValue = ""
			Orders.OrderId.TooltipValue = ""

			' CustomerId
			Orders.CustomerId.LinkCustomAttributes = ""
			If Not ew_Empty(Orders.CustomerId.CurrentValue) Then
				Orders.CustomerId.HrefValue = "Customersedit.asp?CustomerID=" & Orders.CustomerId.CurrentValue
				Orders.CustomerId.LinkAttrs.AddAttribute "target", "", True ' Add target
				If Orders.Export <> "" Then Orders.CustomerId.HrefValue = ew_ConvertFullUrl(Orders.CustomerId.HrefValue)
			Else
				Orders.CustomerId.HrefValue = ""
			End If
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

			' payer_email
			Orders.payer_email.LinkCustomAttributes = ""
			Orders.payer_email.HrefValue = ""
			Orders.payer_email.TooltipValue = ""

			' payment_gross
			Orders.payment_gross.LinkCustomAttributes = ""
			Orders.payment_gross.HrefValue = ""
			Orders.payment_gross.TooltipValue = ""

			' payment_fee
			Orders.payment_fee.LinkCustomAttributes = ""
			Orders.payment_fee.HrefValue = ""
			Orders.payment_fee.TooltipValue = ""

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

			' PromoCodeUsed
			Orders.PromoCodeUsed.LinkCustomAttributes = ""
			Orders.PromoCodeUsed.HrefValue = ""
			Orders.PromoCodeUsed.TooltipValue = ""

		' ---------
		'  Add Row
		' ---------

		ElseIf Orders.RowType = EW_ROWTYPE_ADD Then ' Add row

			' OrderId
			' CustomerId

			Orders.CustomerId.EditCustomAttributes = ""
			If Orders.CustomerId.SessionValue <> "" Then
				Orders.CustomerId.CurrentValue = Orders.CustomerId.SessionValue
				Orders.CustomerId.OldValue = Orders.CustomerId.CurrentValue
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
			Else
			End If

			' Amount
			Orders.Amount.EditCustomAttributes = ""
			Orders.Amount.EditValue = ew_HtmlEncode(Orders.Amount.CurrentValue)

			' Ship_FirstName
			Orders.Ship_FirstName.EditCustomAttributes = ""
			Orders.Ship_FirstName.EditValue = ew_HtmlEncode(Orders.Ship_FirstName.CurrentValue)

			' Ship_LastName
			Orders.Ship_LastName.EditCustomAttributes = ""
			Orders.Ship_LastName.EditValue = ew_HtmlEncode(Orders.Ship_LastName.CurrentValue)

			' payment_status
			Orders.payment_status.EditCustomAttributes = ""
			Redim arwrk(1, 4)
			arwrk(0, 0) = "Completed"
			arwrk(1, 0) = ew_IIf(Orders.payment_status.FldTagCaption(1) <> "", Orders.payment_status.FldTagCaption(1), "Completed")
			arwrk(0, 1) = "WIP"
			arwrk(1, 1) = ew_IIf(Orders.payment_status.FldTagCaption(2) <> "", Orders.payment_status.FldTagCaption(2), "WIP")
			arwrk(0, 2) = "Pending"
			arwrk(1, 2) = ew_IIf(Orders.payment_status.FldTagCaption(3) <> "", Orders.payment_status.FldTagCaption(3), "Pending")
			arwrk(0, 3) = "Failed"
			arwrk(1, 3) = ew_IIf(Orders.payment_status.FldTagCaption(4) <> "", Orders.payment_status.FldTagCaption(4), "Failed")
			arwrk(0, 4) = "Cancelled"
			arwrk(1, 4) = ew_IIf(Orders.payment_status.FldTagCaption(5) <> "", Orders.payment_status.FldTagCaption(5), "Cancelled")
			arwrk = ew_AddItemToArray(arwrk, 0, Array("", Language.Phrase("PleaseSelect")))
			Orders.payment_status.EditValue = arwrk

			' Ordered_Date
			Orders.Ordered_Date.EditCustomAttributes = ""
			Orders.Ordered_Date.EditValue = Orders.Ordered_Date.CurrentValue

			' payer_email
			Orders.payer_email.EditCustomAttributes = ""
			Orders.payer_email.EditValue = ew_HtmlEncode(Orders.payer_email.CurrentValue)

			' payment_gross
			Orders.payment_gross.EditCustomAttributes = ""
			Orders.payment_gross.EditValue = ew_HtmlEncode(Orders.payment_gross.CurrentValue)

			' payment_fee
			Orders.payment_fee.EditCustomAttributes = ""
			Orders.payment_fee.EditValue = ew_HtmlEncode(Orders.payment_fee.CurrentValue)

			' Tax
			Orders.Tax.EditCustomAttributes = ""
			Orders.Tax.EditValue = ew_HtmlEncode(Orders.Tax.CurrentValue)

			' Shipping
			Orders.Shipping.EditCustomAttributes = ""
			Orders.Shipping.EditValue = ew_HtmlEncode(Orders.Shipping.CurrentValue)

			' EmailSent
			Orders.EmailSent.EditCustomAttributes = ""
			Redim arwrk(1, 0)
			arwrk(0, 0) = "confirm"
			arwrk(1, 0) = ew_IIf(Orders.EmailSent.FldTagCaption(1) <> "", Orders.EmailSent.FldTagCaption(1), "Confirm")
			arwrk = ew_AddItemToArray(arwrk, 0, Array("", Language.Phrase("PleaseSelect")))
			Orders.EmailSent.EditValue = arwrk

			' EmailDate
			Orders.EmailDate.EditCustomAttributes = ""
			Orders.EmailDate.EditValue = Orders.EmailDate.CurrentValue

			' PromoCodeUsed
			Orders.PromoCodeUsed.EditCustomAttributes = ""
			Orders.PromoCodeUsed.EditValue = ew_HtmlEncode(Orders.PromoCodeUsed.CurrentValue)

			' Edit refer script
			' OrderId

			Orders.OrderId.HrefValue = ""

			' CustomerId
			If Not ew_Empty(Orders.CustomerId.CurrentValue) Then
				Orders.CustomerId.HrefValue = "Customersedit.asp?CustomerID=" & Orders.CustomerId.CurrentValue
				Orders.CustomerId.LinkAttrs.AddAttribute "target", "", True ' Add target
				If Orders.Export <> "" Then Orders.CustomerId.HrefValue = ew_ConvertFullUrl(Orders.CustomerId.HrefValue)
			Else
				Orders.CustomerId.HrefValue = ""
			End If

			' Amount
			Orders.Amount.HrefValue = ""

			' Ship_FirstName
			Orders.Ship_FirstName.HrefValue = ""

			' Ship_LastName
			Orders.Ship_LastName.HrefValue = ""

			' payment_status
			Orders.payment_status.HrefValue = ""

			' Ordered_Date
			Orders.Ordered_Date.HrefValue = ""

			' payer_email
			Orders.payer_email.HrefValue = ""

			' payment_gross
			Orders.payment_gross.HrefValue = ""

			' payment_fee
			Orders.payment_fee.HrefValue = ""

			' Tax
			Orders.Tax.HrefValue = ""

			' Shipping
			Orders.Shipping.HrefValue = ""

			' EmailSent
			Orders.EmailSent.HrefValue = ""

			' EmailDate
			Orders.EmailDate.HrefValue = ""

			' PromoCodeUsed
			Orders.PromoCodeUsed.HrefValue = ""

		' ----------
		'  Edit Row
		' ----------

		ElseIf Orders.RowType = EW_ROWTYPE_EDIT Then ' Edit row

			' OrderId
			Orders.OrderId.EditCustomAttributes = ""
			Orders.OrderId.EditValue = Orders.OrderId.CurrentValue
			Orders.OrderId.ViewCustomAttributes = ""

			' CustomerId
			Orders.CustomerId.EditCustomAttributes = ""
			If Orders.CustomerId.SessionValue <> "" Then
				Orders.CustomerId.CurrentValue = Orders.CustomerId.SessionValue
				Orders.CustomerId.OldValue = Orders.CustomerId.CurrentValue
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
			Else
			End If

			' Amount
			Orders.Amount.EditCustomAttributes = ""
			Orders.Amount.EditValue = ew_HtmlEncode(Orders.Amount.CurrentValue)

			' Ship_FirstName
			Orders.Ship_FirstName.EditCustomAttributes = ""
			Orders.Ship_FirstName.EditValue = ew_HtmlEncode(Orders.Ship_FirstName.CurrentValue)

			' Ship_LastName
			Orders.Ship_LastName.EditCustomAttributes = ""
			Orders.Ship_LastName.EditValue = ew_HtmlEncode(Orders.Ship_LastName.CurrentValue)

			' payment_status
			Orders.payment_status.EditCustomAttributes = ""
			Redim arwrk(1, 4)
			arwrk(0, 0) = "Completed"
			arwrk(1, 0) = ew_IIf(Orders.payment_status.FldTagCaption(1) <> "", Orders.payment_status.FldTagCaption(1), "Completed")
			arwrk(0, 1) = "WIP"
			arwrk(1, 1) = ew_IIf(Orders.payment_status.FldTagCaption(2) <> "", Orders.payment_status.FldTagCaption(2), "WIP")
			arwrk(0, 2) = "Pending"
			arwrk(1, 2) = ew_IIf(Orders.payment_status.FldTagCaption(3) <> "", Orders.payment_status.FldTagCaption(3), "Pending")
			arwrk(0, 3) = "Failed"
			arwrk(1, 3) = ew_IIf(Orders.payment_status.FldTagCaption(4) <> "", Orders.payment_status.FldTagCaption(4), "Failed")
			arwrk(0, 4) = "Cancelled"
			arwrk(1, 4) = ew_IIf(Orders.payment_status.FldTagCaption(5) <> "", Orders.payment_status.FldTagCaption(5), "Cancelled")
			arwrk = ew_AddItemToArray(arwrk, 0, Array("", Language.Phrase("PleaseSelect")))
			Orders.payment_status.EditValue = arwrk

			' Ordered_Date
			Orders.Ordered_Date.EditCustomAttributes = ""
			Orders.Ordered_Date.EditValue = Orders.Ordered_Date.CurrentValue

			' payer_email
			Orders.payer_email.EditCustomAttributes = ""
			Orders.payer_email.EditValue = ew_HtmlEncode(Orders.payer_email.CurrentValue)

			' payment_gross
			Orders.payment_gross.EditCustomAttributes = ""
			Orders.payment_gross.EditValue = ew_HtmlEncode(Orders.payment_gross.CurrentValue)

			' payment_fee
			Orders.payment_fee.EditCustomAttributes = ""
			Orders.payment_fee.EditValue = ew_HtmlEncode(Orders.payment_fee.CurrentValue)

			' Tax
			Orders.Tax.EditCustomAttributes = ""
			Orders.Tax.EditValue = ew_HtmlEncode(Orders.Tax.CurrentValue)

			' Shipping
			Orders.Shipping.EditCustomAttributes = ""
			Orders.Shipping.EditValue = ew_HtmlEncode(Orders.Shipping.CurrentValue)

			' EmailSent
			Orders.EmailSent.EditCustomAttributes = ""
			Redim arwrk(1, 0)
			arwrk(0, 0) = "confirm"
			arwrk(1, 0) = ew_IIf(Orders.EmailSent.FldTagCaption(1) <> "", Orders.EmailSent.FldTagCaption(1), "Confirm")
			arwrk = ew_AddItemToArray(arwrk, 0, Array("", Language.Phrase("PleaseSelect")))
			Orders.EmailSent.EditValue = arwrk

			' EmailDate
			Orders.EmailDate.EditCustomAttributes = ""
			Orders.EmailDate.EditValue = Orders.EmailDate.CurrentValue

			' PromoCodeUsed
			Orders.PromoCodeUsed.EditCustomAttributes = ""
			Orders.PromoCodeUsed.EditValue = ew_HtmlEncode(Orders.PromoCodeUsed.CurrentValue)

			' Edit refer script
			' OrderId

			Orders.OrderId.HrefValue = ""

			' CustomerId
			If Not ew_Empty(Orders.CustomerId.CurrentValue) Then
				Orders.CustomerId.HrefValue = "Customersedit.asp?CustomerID=" & Orders.CustomerId.CurrentValue
				Orders.CustomerId.LinkAttrs.AddAttribute "target", "", True ' Add target
				If Orders.Export <> "" Then Orders.CustomerId.HrefValue = ew_ConvertFullUrl(Orders.CustomerId.HrefValue)
			Else
				Orders.CustomerId.HrefValue = ""
			End If

			' Amount
			Orders.Amount.HrefValue = ""

			' Ship_FirstName
			Orders.Ship_FirstName.HrefValue = ""

			' Ship_LastName
			Orders.Ship_LastName.HrefValue = ""

			' payment_status
			Orders.payment_status.HrefValue = ""

			' Ordered_Date
			Orders.Ordered_Date.HrefValue = ""

			' payer_email
			Orders.payer_email.HrefValue = ""

			' payment_gross
			Orders.payment_gross.HrefValue = ""

			' payment_fee
			Orders.payment_fee.HrefValue = ""

			' Tax
			Orders.Tax.HrefValue = ""

			' Shipping
			Orders.Shipping.HrefValue = ""

			' EmailSent
			Orders.EmailSent.HrefValue = ""

			' EmailDate
			Orders.EmailDate.HrefValue = ""

			' PromoCodeUsed
			Orders.PromoCodeUsed.HrefValue = ""
		End If
		If Orders.RowType = EW_ROWTYPE_ADD Or Orders.RowType = EW_ROWTYPE_EDIT Or Orders.RowType = EW_ROWTYPE_SEARCH Then ' Add / Edit / Search row
			Call Orders.SetupFieldTitles()
		End If

		' Call Row Rendered event
		If Orders.RowType <> EW_ROWTYPE_AGGREGATEINIT Then
			Call Orders.Row_Rendered()
		End If
	End Sub

	' -----------------------------------------------------------------
	' Validate form
	'
	Function ValidateForm()

		' Check if validation required
		If Not EW_SERVER_VALIDATE Then
			ValidateForm = (gsFormError = "")
			Exit Function
		End If
		If Not ew_CheckNumber(Orders.Amount.FormValue) Then
			Call ew_AddMessage(gsFormError, Orders.Amount.FldErrMsg)
		End If
		If Not ew_CheckNumber(Orders.payment_gross.FormValue) Then
			Call ew_AddMessage(gsFormError, Orders.payment_gross.FldErrMsg)
		End If
		If Not ew_CheckNumber(Orders.payment_fee.FormValue) Then
			Call ew_AddMessage(gsFormError, Orders.payment_fee.FldErrMsg)
		End If
		If Not ew_CheckNumber(Orders.Tax.FormValue) Then
			Call ew_AddMessage(gsFormError, Orders.Tax.FldErrMsg)
		End If
		If Not ew_CheckNumber(Orders.Shipping.FormValue) Then
			Call ew_AddMessage(gsFormError, Orders.Shipping.FldErrMsg)
		End If

		' Return validate result
		ValidateForm = (gsFormError = "")

		' Call Form Custom Validate event
		Dim sFormCustomError
		sFormCustomError = ""
		ValidateForm = ValidateForm And Form_CustomValidate(sFormCustomError)
		If sFormCustomError <> "" Then
			Call ew_AddMessage(gsFormError, sFormCustomError)
		End If
	End Function

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
		Else
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

	' -----------------------------------------------------------------
	' Update record based on key values
	'
	Function EditRow()
		If Not EW_DEBUG_ENABLED Then On Error Resume Next
		Dim Rs, sSql, sFilter
		Dim RsChk, sSqlChk, sFilterChk
		Dim bUpdateRow
		Dim RsOld, RsNew
		Dim sIdxErrMsg

		' Clear any previous errors
		Err.Clear
		sFilter = Orders.KeyFilter
		Orders.CurrentFilter  = sFilter
		sSql = Orders.SQL
		Set Rs = Server.CreateObject("ADODB.Recordset")
		Rs.CursorLocation = EW_CURSORLOCATION
		Rs.Open sSql, Conn, 1, EW_RECORDSET_LOCKTYPE
		If Err.Number <> 0 Then
			Message = Err.Description
			Rs.Close
			Set Rs = Nothing
			EditRow = False
			Exit Function
		End If

		' Clone old recordset object
		Set RsOld = ew_CloneRs(Rs)
		If Rs.Eof Then
			EditRow = False ' Update Failed
		Else

			' Field CustomerId
			Call Orders.CustomerId.SetDbValue(Rs, Orders.CustomerId.CurrentValue, Null, Orders.CustomerId.ReadOnly)

			' Field Amount
			Call Orders.Amount.SetDbValue(Rs, Orders.Amount.CurrentValue, Null, Orders.Amount.ReadOnly)

			' Field Ship_FirstName
			Call Orders.Ship_FirstName.SetDbValue(Rs, Orders.Ship_FirstName.CurrentValue, Null, Orders.Ship_FirstName.ReadOnly)

			' Field Ship_LastName
			Call Orders.Ship_LastName.SetDbValue(Rs, Orders.Ship_LastName.CurrentValue, Null, Orders.Ship_LastName.ReadOnly)

			' Field payment_status
			Call Orders.payment_status.SetDbValue(Rs, Orders.payment_status.CurrentValue, Null, Orders.payment_status.ReadOnly)

			' Field Ordered_Date
			Call Orders.Ordered_Date.SetDbValue(Rs, Orders.Ordered_Date.CurrentValue, Null, Orders.Ordered_Date.ReadOnly)

			' Field payer_email
			Call Orders.payer_email.SetDbValue(Rs, Orders.payer_email.CurrentValue, Null, Orders.payer_email.ReadOnly)

			' Field payment_gross
			Call Orders.payment_gross.SetDbValue(Rs, Orders.payment_gross.CurrentValue, Null, Orders.payment_gross.ReadOnly)

			' Field payment_fee
			Call Orders.payment_fee.SetDbValue(Rs, Orders.payment_fee.CurrentValue, Null, Orders.payment_fee.ReadOnly)

			' Field Tax
			Call Orders.Tax.SetDbValue(Rs, Orders.Tax.CurrentValue, Null, Orders.Tax.ReadOnly)

			' Field Shipping
			Call Orders.Shipping.SetDbValue(Rs, Orders.Shipping.CurrentValue, Null, Orders.Shipping.ReadOnly)

			' Field EmailSent
			Call Orders.EmailSent.SetDbValue(Rs, Orders.EmailSent.CurrentValue, Null, Orders.EmailSent.ReadOnly)

			' Field EmailDate
			Call Orders.EmailDate.SetDbValue(Rs, Orders.EmailDate.CurrentValue, Null, Orders.EmailDate.ReadOnly)

			' Field PromoCodeUsed
			Call Orders.PromoCodeUsed.SetDbValue(Rs, Orders.PromoCodeUsed.CurrentValue, Null, Orders.PromoCodeUsed.ReadOnly)

			' Check recordset update error
			If Err.Number <> 0 Then
				FailureMessage = Err.Description
				Rs.Close
				Set Rs = Nothing
				EditRow = False
				Exit Function
			End If

			' Call Row Updating event
			bUpdateRow = Orders.Row_Updating(RsOld, Rs)
			If bUpdateRow Then

				' Clone new recordset object
				Set RsNew = ew_CloneRs(Rs)
				Rs.Update
				If Err.Number <> 0 Then
					FailureMessage = Err.Description
					EditRow = False
				Else
					EditRow = True
				End If
			Else
				Rs.CancelUpdate
				If Orders.CancelMessage <> "" Then
					FailureMessage = Orders.CancelMessage
					Orders.CancelMessage = ""
				Else
					FailureMessage = Language.Phrase("UpdateCancelled")
				End If
				EditRow = False
			End If
		End If

		' Call Row Updated event
		If EditRow Then
			Call Orders.Row_Updated(RsOld, RsNew)
		End If
		Rs.Close
		Set Rs = Nothing
		If IsObject(RsOld) Then
			RsOld.Close
			Set RsOld = Nothing
		End If
		If IsObject(RsNew) Then
			RsNew.Close
			Set RsNew = Nothing
		End If
	End Function

	' -----------------------------------------------------------------
	' Add record
	'
	Function AddRow(RsOld)
		If Not EW_DEBUG_ENABLED Then On Error Resume Next
		Dim Rs, sSql, sFilter
		Dim RsNew
		Dim bInsertRow
		Dim RsChk
		Dim sIdxErrMsg

		' Clear any previous errors
		Err.Clear

		' Set up foreign key field value from Session
		If Orders.CurrentMasterTable = "Customers" Then
			Orders.CustomerId.CurrentValue = Orders.CustomerId.SessionValue
		End If

		' Add new record
		sFilter = "(0 = 1)"
		Orders.CurrentFilter = sFilter
		sSql = Orders.SQL
		Set Rs = Server.CreateObject("ADODB.Recordset")
		Rs.CursorLocation = EW_CURSORLOCATION
		Rs.Open sSql, Conn, 1, EW_RECORDSET_LOCKTYPE
		Rs.AddNew
		If Err.Number <> 0 Then
			Message = Err.Description
			Rs.Close
			Set Rs = Nothing
			AddRow = False
			Exit Function
		End If

		' Field CustomerId
		Call Orders.CustomerId.SetDbValue(Rs, Orders.CustomerId.CurrentValue, Null, False)

		' Field Amount
		Call Orders.Amount.SetDbValue(Rs, Orders.Amount.CurrentValue, Null, False)

		' Field Ship_FirstName
		Call Orders.Ship_FirstName.SetDbValue(Rs, Orders.Ship_FirstName.CurrentValue, Null, False)

		' Field Ship_LastName
		Call Orders.Ship_LastName.SetDbValue(Rs, Orders.Ship_LastName.CurrentValue, Null, False)

		' Field payment_status
		Call Orders.payment_status.SetDbValue(Rs, Orders.payment_status.CurrentValue, Null, (Orders.payment_status.CurrentValue&"" = ""))

		' Field Ordered_Date
		Call Orders.Ordered_Date.SetDbValue(Rs, Orders.Ordered_Date.CurrentValue, Null, (Orders.Ordered_Date.CurrentValue&"" = ""))

		' Field payer_email
		Call Orders.payer_email.SetDbValue(Rs, Orders.payer_email.CurrentValue, Null, False)

		' Field payment_gross
		Call Orders.payment_gross.SetDbValue(Rs, Orders.payment_gross.CurrentValue, Null, False)

		' Field payment_fee
		Call Orders.payment_fee.SetDbValue(Rs, Orders.payment_fee.CurrentValue, Null, False)

		' Field Tax
		Call Orders.Tax.SetDbValue(Rs, Orders.Tax.CurrentValue, Null, False)

		' Field Shipping
		Call Orders.Shipping.SetDbValue(Rs, Orders.Shipping.CurrentValue, Null, False)

		' Field EmailSent
		Call Orders.EmailSent.SetDbValue(Rs, Orders.EmailSent.CurrentValue, Null, False)

		' Field EmailDate
		Call Orders.EmailDate.SetDbValue(Rs, Orders.EmailDate.CurrentValue, Null, False)

		' Field PromoCodeUsed
		Call Orders.PromoCodeUsed.SetDbValue(Rs, Orders.PromoCodeUsed.CurrentValue, Null, False)

		' Check recordset update error
		If Err.Number <> 0 Then
			FailureMessage = Err.Description
			Rs.Close
			Set Rs = Nothing
			AddRow = False
			Exit Function
		End If

		' Call Row Inserting event
		bInsertRow = Orders.Row_Inserting(RsOld, Rs)
		If bInsertRow Then

			' Clone new recordset object
			Set RsNew = ew_CloneRs(Rs)
			Rs.Update
			If Err.Number <> 0 Then
				FailureMessage = Err.Description
				AddRow = False
			Else
				AddRow = True
			End If
		Else
			Rs.CancelUpdate
			If Orders.CancelMessage <> "" Then
				FailureMessage = Orders.CancelMessage
				Orders.CancelMessage = ""
			Else
				FailureMessage = Language.Phrase("InsertCancelled")
			End If
			AddRow = False
		End If
		Rs.Close
		Set Rs = Nothing
		If AddRow Then
			Orders.OrderId.DbValue = RsNew("OrderId")
		End If
		If AddRow Then

			' Call Row Inserted event
			Call Orders.Row_Inserted(RsOld, RsNew)
		End If
		If IsObject(RsNew) Then
			RsNew.Close
			Set RsNew = Nothing
		End If
	End Function

	' -----------------------------------------------------------------
	' Set up Master Detail based on querystring parameter
	'
	Sub SetUpMasterParms()
		Dim bValidMaster, sMasterTblVar

		' Hide foreign keys
		sMasterTblVar = Orders.CurrentMasterTable
		If sMasterTblVar = "Customers" Then
			Orders.CustomerId.Visible = False
			If Customers.EventCancelled Then Orders.EventCancelled = True
		End If
		DbMasterFilter = Orders.MasterFilter '  Get master filter
		DbDetailFilter = Orders.DetailFilter ' Get detail filter
	End Sub

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

	' Form Custom Validate event
	Function Form_CustomValidate(CustomError)

		'Return error message in CustomError
		Form_CustomValidate = True
	End Function

		' ListOptions Load event
Sub ListOptions_Load()
	'Example: 
	 Dim opt
	 Set opt = ListOptions.Add("Report")
	 opt.OnLeft = True ' Link on left
	' opt.MoveTo 0 ' Move to first column
End Sub                                

		' ListOptions Rendered event
Sub ListOptions_Rendered()
'Example: 
		if((Orders.payment_status.CurrentValue <> "WIP") AND  (Orders.payment_status.CurrentValue<>"Cancelled")) then    
			ListOptions.GetItem("Report").Body = "<a href=""sendemail.asp?orderid=" & Orders.OrderId.CurrentValue &""">Notify</a>"
		else 
			ListOptions.GetItem("Report").Body = ""
		end if
End Sub                                                                                   


End Class
%>