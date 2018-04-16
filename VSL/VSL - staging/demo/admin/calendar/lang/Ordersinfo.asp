<%

' ASPMaker configuration for Table Orders
Dim Orders

' Define table class
Class cOrders

	' Class Initialize
	Private Sub Class_Initialize()
		UseTokenInUrl = EW_USE_TOKEN_IN_URL
		ExportOriginalValue = EW_EXPORT_ORIGINAL_VALUE
		ExportAll = True
		Set RowAttrs = New cAttributes ' Row attributes
		AllowAddDeleteRow = ew_AllowAddDeleteRow() ' Allow add/delete row
		DetailAdd = False ' Allow detail add
		DetailEdit = False ' Allow detail edit
		GridAddRowCount = 5 ' Grid add row count
		Call ew_SetArObj(Fields, "OrderId", OrderId)
		Call ew_SetArObj(Fields, "CustomerId", CustomerId)
		Call ew_SetArObj(Fields, "InvoiceId", InvoiceId)
		Call ew_SetArObj(Fields, "Amount", Amount)
		Call ew_SetArObj(Fields, "Ship_FirstName", Ship_FirstName)
		Call ew_SetArObj(Fields, "Ship_LastName", Ship_LastName)
		Call ew_SetArObj(Fields, "Ship_Address", Ship_Address)
		Call ew_SetArObj(Fields, "Ship_Address2", Ship_Address2)
		Call ew_SetArObj(Fields, "Ship_City", Ship_City)
		Call ew_SetArObj(Fields, "Ship_Province", Ship_Province)
		Call ew_SetArObj(Fields, "Ship_Postal", Ship_Postal)
		Call ew_SetArObj(Fields, "Ship_Country", Ship_Country)
		Call ew_SetArObj(Fields, "Ship_Phone", Ship_Phone)
		Call ew_SetArObj(Fields, "Ship_Email", Ship_Email)
		Call ew_SetArObj(Fields, "payment_status", payment_status)
		Call ew_SetArObj(Fields, "Ordered_Date", Ordered_Date)
		Call ew_SetArObj(Fields, "payment_date", payment_date)
		Call ew_SetArObj(Fields, "pfirst_name", pfirst_name)
		Call ew_SetArObj(Fields, "plast_name", plast_name)
		Call ew_SetArObj(Fields, "payer_email", payer_email)
		Call ew_SetArObj(Fields, "txn_id", txn_id)
		Call ew_SetArObj(Fields, "payment_gross", payment_gross)
		Call ew_SetArObj(Fields, "payment_fee", payment_fee)
		Call ew_SetArObj(Fields, "payment_type", payment_type)
		Call ew_SetArObj(Fields, "txn_type", txn_type)
		Call ew_SetArObj(Fields, "receiver_email", receiver_email)
		Call ew_SetArObj(Fields, "pShip_Name", pShip_Name)
		Call ew_SetArObj(Fields, "pShip_Address", pShip_Address)
		Call ew_SetArObj(Fields, "pShip_City", pShip_City)
		Call ew_SetArObj(Fields, "pShip_Province", pShip_Province)
		Call ew_SetArObj(Fields, "pShip_Postal", pShip_Postal)
		Call ew_SetArObj(Fields, "pShip_Country", pShip_Country)
		Call ew_SetArObj(Fields, "Tax", Tax)
		Call ew_SetArObj(Fields, "Shipping", Shipping)
		Call ew_SetArObj(Fields, "EmailSent", EmailSent)
		Call ew_SetArObj(Fields, "EmailDate", EmailDate)
	End Sub

	' Reset attributes for table object
	Public Sub ResetAttrs()
		CssClass = ""
		CssStyle = ""
		RowAttrs.Clear()
		Dim i, fld
		If IsArray(Fields) Then
			For i = 0 to UBound(Fields,2)
				Set fld = Fields(1,i)
				Call fld.ResetAttrs()
			Next
		End If
	End Sub

	' Setup field titles
	Public Sub SetupFieldTitles()
		Dim i, fld
		If IsArray(Fields) Then
			For i = 0 to UBound(Fields,2)
				Set fld = Fields(1,i)
				If fld.FldTitle <> "" Then
					fld.EditAttrs.AddAttribute "onmouseover", "ew_ShowTitle(this, '" & ew_JsEncode3(fld.FldTitle) & "');", True
					fld.EditAttrs.AddAttribute "onmouseout", "ew_HideTooltip();", True
				End If
			Next
		End If
	End Sub

	' Define table level constants
	' Use table token in Url

	Dim UseTokenInUrl

	' Table variable
	Public Property Get TableVar()
		TableVar = "Orders"
	End Property

	' Table name
	Public Property Get TableName()
		TableName = "Orders"
	End Property

	' Table type
	Public Property Get TableType()
		TableType = "TABLE"
	End Property

	' Table caption
	Public Property Get TableCaption()
		TableCaption = Language.TablePhrase(TableVar, "TblCaption")
	End Property

	' Page caption
	Public Property Get PageCaption(Page)
		PageCaption = Language.TablePhrase(TableVar, "TblPageCaption" & Page)
		If PageCaption = "" Then PageCaption = "Page " & Page
	End Property

	' Export Return Page
	Public Property Get ExportReturnUrl()
		If Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_EXPORT_RETURN_URL) <> "" Then
			ExportReturnUrl = Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_EXPORT_RETURN_URL)
		Else
			ExportReturnUrl = ew_CurrentPage
		End If
	End Property

	Public Property Let ExportReturnUrl(v)
		Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_EXPORT_RETURN_URL) = v
	End Property

	' Records per page
	Public Property Get RecordsPerPage()
		RecordsPerPage = Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_REC_PER_PAGE)
	End Property

	Public Property Let RecordsPerPage(v)
		Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_REC_PER_PAGE) = v
	End Property

	' Start record number
	Public Property Get StartRecordNumber()
		StartRecordNumber = Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_START_REC)
	End Property

	Public Property Let StartRecordNumber(v)
		Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_START_REC) = v
	End Property

	' Search Highlight Name
	Public Property Get HighlightName()
		HighlightName = "Orders_Highlight"
	End Property

	' Advanced search
	Public Function GetAdvancedSearch(fld)
		GetAdvancedSearch = Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_ADVANCED_SEARCH & "_" & fld)
	End Function

	Public Function SetAdvancedSearch(fld, v)
		If Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_ADVANCED_SEARCH & "_" & fld) <> v Then
			Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_ADVANCED_SEARCH & "_" & fld) = v
		End If
	End Function
	Dim BasicSearchKeyword
	Dim BasicSearchType

	' Basic search Keyword
	Public Property Get SessionBasicSearchKeyword()
		SessionBasicSearchKeyword = Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_BASIC_SEARCH)
	End Property

	Public Property Let SessionBasicSearchKeyword(v)
		Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_BASIC_SEARCH) = v
	End Property

	' Basic Search Type
	Public Property Get SessionBasicSearchType()
		SessionBasicSearchType = Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_BASIC_SEARCH_TYPE)
	End Property

	Public Property Let SessionBasicSearchType(v)
		Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_BASIC_SEARCH_TYPE) = v
	End Property

	' Search where clause
	Public Property Get SearchWhere()
		SearchWhere = Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_SEARCH_WHERE)
	End Property

	Public Property Let SearchWhere(v)
		Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_SEARCH_WHERE) = v
	End Property

	' Single column sort
	Public Sub UpdateSort(ofld)
		Dim sSortField, sLastSort, sThisSort
		If CurrentOrder = ofld.FldName Then
			sSortField = ofld.FldExpression
			sLastSort = ofld.Sort
			If CurrentOrderType = "ASC" Or CurrentOrderType = "DESC" Then
				sThisSort = CurrentOrderType
			Else
				If sLastSort = "ASC" Then sThisSort = "DESC" Else sThisSort = "ASC"
			End If
			ofld.Sort = sThisSort
			SessionOrderBy = sSortField & " " & sThisSort ' Save to Session
		Else
			ofld.Sort = ""
		End If
	End Sub

	' Session WHERE Clause
	Public Property Get SessionWhere()
		SessionWhere = Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_WHERE)
	End Property

	Public Property Let SessionWhere(v)
		Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_WHERE) = v
	End Property

	' Session ORDER BY
	Public Property Get SessionOrderBy()
		SessionOrderBy = Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_ORDER_BY)
	End Property

	Public Property Let SessionOrderBy(v)
		Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_ORDER_BY) = v
	End Property

	' Session Key
	Public Function GetKey(fld)
		GetKey = Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_KEY & "_" & fld)
	End Function

	Public Function SetKey(fld, v)
		Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_KEY & "_" & fld) = v
	End Function

	' Current detail table name
	Public Property Get CurrentDetailTable()
		CurrentDetailTable = Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_DETAIL_TABLE)
	End Property

	Public Property Let CurrentDetailTable(v)
		Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_DETAIL_TABLE) = v
	End Property

	' Get detail url
	Public Property Get DetailUrl()

		' Detail url
		Dim sDetailUrl
		sDetailUrl = ""
		If CurrentDetailTable = "OrderDetails" Then
			sDetailUrl = OrderDetails.ListUrl & "?showmaster=" & TableVar
			sDetailUrl = sDetailUrl & "&OrderId=" & OrderId.CurrentValue
		End If
		DetailUrl = sDetailUrl
	End Property

	' Table level SQL
	Public Property Get SqlSelect() ' Select
		SqlSelect = "SELECT * FROM [Orders]"
	End Property

	Private Property Get TableFilter()
		TableFilter = ""
	End Property

	Public Property Get SqlWhere() ' Where
		Dim sWhere
		sWhere = ""
		Call ew_AddFilter(sWhere, TableFilter)
		SqlWhere = sWhere
	End Property

	Public Property Get SqlGroupBy() ' Group By
		SqlGroupBy = ""
	End Property

	Public Property Get SqlHaving() ' Having
		SqlHaving = ""
	End Property

	Public Property Get SqlOrderBy() ' Order By
		SqlOrderBy = "[OrderId] DESC"
	End Property

	' SQL variables
	Dim CurrentFilter ' Current filter
	Dim CurrentOrder ' Current order
	Dim CurrentOrderType ' Current order type

	' Get sql
	Public Function GetSQL(where, orderby)
		GetSQL = ew_BuildSelectSql(SqlSelect, SqlWhere, SqlGroupBy, SqlHaving, SqlOrderBy, where, orderby)
	End Function

	' Table sql
	Public Property Get SQL()
		Dim sFilter, sSort
		sFilter = CurrentFilter
		sSort = SessionOrderBy
		SQL = ew_BuildSelectSql(SqlSelect, SqlWhere, SqlGroupBy, SqlHaving, SqlOrderBy, sFilter, sSort)
	End Property

	' Return table sql with list page filter
	Public Property Get ListSQL()
		Dim sFilter, sSort
		sFilter = SessionWhere
		Call ew_AddFilter(sFilter, CurrentFilter)
		sSort = SessionOrderBy
		ListSQL = ew_BuildSelectSql(SqlSelect, SqlWhere, SqlGroupBy, SqlHaving, SqlOrderBy, sFilter, sSort)
	End Property

	' Key filter for table
	Private Property Get SqlKeyFilter()
		SqlKeyFilter = "[OrderId] = @OrderId@"
	End Property

	' Return Key filter for table
	Public Property Get KeyFilter()
		Dim sKeyFilter
		sKeyFilter = SqlKeyFilter
		If Not IsNumeric(OrderId.CurrentValue) Then
			sKeyFilter = "0=1" ' Invalid key
		End If
		sKeyFilter = Replace(sKeyFilter, "@OrderId@", ew_AdjustSql(OrderId.CurrentValue)) ' Replace key value
		KeyFilter = sKeyFilter
	End Property

	' Return url
	Public Property Get ReturnUrl()

		' Get referer url automatically
		If Request.ServerVariables("HTTP_REFERER") <> "" Then
			If ew_ReferPage <> ew_CurrentPage And ew_ReferPage <> "login.asp" Then ' Referer not same page or login page
				Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_RETURN_URL) = Request.ServerVariables("HTTP_REFERER") ' Save to Session
			End If
		End If
		If Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_RETURN_URL) <> "" Then
			ReturnUrl = Session(EW_PROJECT_NAME & "_" & TableVar & "_" & EW_TABLE_RETURN_URL)
		Else
			ReturnUrl = "Orderslist.asp"
		End If
	End Property

	' List url
	Public Function ListUrl()
		ListUrl = "Orderslist.asp"
	End Function

	' View url
	Public Function ViewUrl()
		ViewUrl = KeyUrl("Ordersview.asp", UrlParm(""))
	End Function

	' Add url
	Public Function AddUrl()
		AddUrl = "Ordersadd.asp"

'		Dim sUrlParm
'		sUrlParm = UrlParm("")
'		If sUrlParm <> "" Then AddUrl = AddUrl & "?" & sUrlParm

	End Function

	' Edit url
	Public Function EditUrl(parm)
		If parm <> "" Then
			EditUrl = KeyUrl("Ordersedit.asp", UrlParm(parm))
		Else
			EditUrl = KeyUrl("Ordersedit.asp", UrlParm(EW_TABLE_SHOW_DETAIL & "="))
		End If
	End Function

	' Inline edit url
	Public Function InlineEditUrl()
		InlineEditUrl = KeyUrl(ew_CurrentPage, UrlParm("a=edit"))
	End Function

	' Copy url
	Public Function CopyUrl(parm)
		If parm <> "" Then
			CopyUrl = KeyUrl("Ordersadd.asp", UrlParm(parm))
		Else
			CopyUrl = KeyUrl("Ordersadd.asp", UrlParm(EW_TABLE_SHOW_DETAIL & "="))
		End If
	End Function

	' Inline copy url
	Public Function InlineCopyUrl()
		InlineCopyUrl = KeyUrl(ew_CurrentPage, UrlParm("a=copy"))
	End Function

	' Delete url
	Public Function DeleteUrl()
		DeleteUrl = KeyUrl("Ordersdelete.asp", UrlParm(""))
	End Function

	' Key url
	Public Function KeyUrl(url, parm)
		Dim sUrl: sUrl = url & "?"
		If parm <> "" Then sUrl = sUrl & parm & "&"
		If Not IsNull(OrderId.CurrentValue) Then
			sUrl = sUrl & "OrderId=" & OrderId.CurrentValue
		Else
			KeyUrl = "javascript:alert(ewLanguage.Phrase('InvalidRecord'));"
			Exit Function
		End If
		KeyUrl = sUrl
	End Function

	' Sort Url
	Public Property Get SortUrl(fld)
		If CurrentAction <> "" Or Export <> "" Or (fld.FldType = 201 Or fld.FldType = 203 Or fld.FldType = 205 Or fld.FldType = 141) Then
			SortUrl = ""
		ElseIf fld.Sortable Then
			SortUrl = ew_CurrentPage
			Dim sUrlParm
			sUrlParm = UrlParm("order=" & Server.URLEncode(fld.FldName) & "&amp;ordertype=" & fld.ReverseSort)
			SortUrl = SortUrl & "?" & sUrlParm
		Else
			SortUrl = ""
		End If
	End Property

	' Url parm
	Function UrlParm(parm)
		If UseTokenInUrl Then
			UrlParm = "t=Orders"
		Else
			UrlParm = ""
		End If
		If parm <> "" Then
			If UrlParm <> "" Then UrlParm = UrlParm & "&"
			UrlParm = UrlParm & parm
		End If
	End Function

	' Get record keys from Form/QueryString/Session
	Public Function GetRecordKeys()
		Dim arKeys, arKey, cnt, i, bHasKey
		bHasKey = False

		' Check ObjForm first
		If IsObject(ObjForm) And Not (ObjForm Is Nothing) Then
			ObjForm.Index = 0
			If ObjForm.HasValue("key_m") Then
				arKeys = ObjForm.GetValue("key_m")
				If Not IsArray(arKeys) Then
					arKeys = Array(arKeys)
				End If
				bHasKey = True
			End If
		End If

		' Check Form/QueryString
		If Not bHasKey Then
			If Request.Form("key_m").Count > 0 Then
				cnt = Request.Form("key_m").Count
				ReDim arKeys(cnt-1)
				For i = 1 to cnt ' Set up keys
					arKeys(i-1) = Request.Form("key_m")(i)
				Next
			ElseIf Request.QueryString("key_m").Count > 0 Then
				cnt = Request.QueryString("key_m").Count
				ReDim arKeys(cnt-1)
				For i = 1 to cnt ' Set up keys
					arKeys(i-1) = Request.QueryString("key_m")(i)
				Next
			ElseIf Request.QueryString <> "" Then
				ReDim arKeys(0)
				arKeys(0) = Request.QueryString("OrderId") ' OrderId

				'GetRecordKeys = arKeys ' do not return yet, so the values will also be checked by the following code
			End If
		End If

		' Check keys
		Dim ar, key
		If IsArray(arKeys) Then
			For i = 0 to UBound(arKeys)
				key = arKeys(i)
						Dim skip
						skip = False
						If Not IsNumeric(key) Then skip = True
						If Not skip Then
							If IsArray(ar) Then
								ReDim Preserve ar(UBound(ar)+1)
							Else
								ReDim ar(0)
							End If
							ar(UBound(ar)) = key
						End If
			Next
		End If
		GetRecordKeys = ar
	End Function

	' Get key filter
	Public Function GetKeyFilter()
		Dim arKeys, sKeyFilter, i, key
		arKeys = GetRecordKeys()
		sKeyFilter = ""
		If IsArray(arKeys) Then
			For i = 0 to UBound(arKeys)
				key = arKeys(i)
				If sKeyFilter <> "" Then sKeyFilter = sKeyFilter & " OR "
				OrderId.CurrentValue = key
				sKeyFilter = sKeyFilter & "(" & KeyFilter & ")"
			Next
		End If
		GetKeyFilter = sKeyFilter
	End Function

	' Function LoadRecordCount
	' - Load record count based on filter
	Public Function LoadRecordCount(sFilter)
		Dim wrkrs
		Set wrkrs = LoadRs(sFilter)
		If Not wrkrs Is Nothing Then
			LoadRecordCount = wrkrs.RecordCount
		Else
			LoadRecordCount = 0
		End If
		Set wrkrs = Nothing
	End Function

	' Function LoadRs
	' - Load Rows based on filter
	Public Function LoadRs(sFilter)
		If Not EW_DEBUG_ENABLED Then On Error Resume Next
		Dim RsRows, sSql

		' Set up filter (Sql Where Clause) and get Return Sql
		CurrentFilter = sFilter
		sSql = SQL
		Err.Clear
		Set RsRows = Server.CreateObject("ADODB.Recordset")
		RsRows.CursorLocation = EW_CURSORLOCATION
		RsRows.Open sSql, Conn, 3, 1, 1 ' adOpenStatic, adLockReadOnly, adCmdText
		If Err.Number <> 0 Then
			Err.Clear
			Set LoadRs = Nothing
			RsRows.Close
			Set RsRows = Nothing
		ElseIf RsRows.Eof Then
			Set LoadRs = Nothing
			RsRows.Close
			Set RsRows = Nothing
		Else
			Set LoadRs = RsRows
		End If
	End Function

	' Load row values from recordset
	Public Sub LoadListRowValues(RsRow)
		OrderId.DbValue = RsRow("OrderId")
		CustomerId.DbValue = RsRow("CustomerId")
		InvoiceId.DbValue = RsRow("InvoiceId")
		Amount.DbValue = RsRow("Amount")
		Ship_FirstName.DbValue = RsRow("Ship_FirstName")
		Ship_LastName.DbValue = RsRow("Ship_LastName")
		Ship_Address.DbValue = RsRow("Ship_Address")
		Ship_Address2.DbValue = RsRow("Ship_Address2")
		Ship_City.DbValue = RsRow("Ship_City")
		Ship_Province.DbValue = RsRow("Ship_Province")
		Ship_Postal.DbValue = RsRow("Ship_Postal")
		Ship_Country.DbValue = RsRow("Ship_Country")
		Ship_Phone.DbValue = RsRow("Ship_Phone")
		Ship_Email.DbValue = RsRow("Ship_Email")
		payment_status.DbValue = RsRow("payment_status")
		Ordered_Date.DbValue = RsRow("Ordered_Date")
		payment_date.DbValue = RsRow("payment_date")
		pfirst_name.DbValue = RsRow("pfirst_name")
		plast_name.DbValue = RsRow("plast_name")
		payer_email.DbValue = RsRow("payer_email")
		txn_id.DbValue = RsRow("txn_id")
		payment_gross.DbValue = RsRow("payment_gross")
		payment_fee.DbValue = RsRow("payment_fee")
		payment_type.DbValue = RsRow("payment_type")
		txn_type.DbValue = RsRow("txn_type")
		receiver_email.DbValue = RsRow("receiver_email")
		pShip_Name.DbValue = RsRow("pShip_Name")
		pShip_Address.DbValue = RsRow("pShip_Address")
		pShip_City.DbValue = RsRow("pShip_City")
		pShip_Province.DbValue = RsRow("pShip_Province")
		pShip_Postal.DbValue = RsRow("pShip_Postal")
		pShip_Country.DbValue = RsRow("pShip_Country")
		Tax.DbValue = RsRow("Tax")
		Shipping.DbValue = RsRow("Shipping")
		EmailSent.DbValue = RsRow("EmailSent")
		EmailDate.DbValue = RsRow("EmailDate")
	End Sub

	' Render list row values
	Sub RenderListRow()

		'
		'  Common render codes
		'
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
		' Call Row Rendering event

		Call Row_Rendering()

		'
		'  Render for View
		'
		' OrderId

		OrderId.ViewValue = OrderId.CurrentValue
		OrderId.ViewCustomAttributes = ""

		' CustomerId
		If CustomerId.CurrentValue & "" <> "" Then
			sFilterWrk = "[CustomerID] = " & ew_AdjustSql(CustomerId.CurrentValue) & ""
		sSqlWrk = "SELECT DISTINCT [Inv_FirstName], [Inv_LastName] FROM [Customers]"
		sWhereWrk = ""
		Call ew_AddFilter(sWhereWrk, sFilterWrk)
		If sWhereWrk <> "" Then sSqlWrk = sSqlWrk & " WHERE " & sWhereWrk
			Set RsWrk = Conn.Execute(sSqlWrk)
			If Not RsWrk.Eof Then
				CustomerId.ViewValue = RsWrk("Inv_FirstName")
				CustomerId.ViewValue = CustomerId.ViewValue & ew_ValueSeparator(0,1,CustomerId) & RsWrk("Inv_LastName")
			Else
				CustomerId.ViewValue = CustomerId.CurrentValue
			End If
			RsWrk.Close
			Set RsWrk = Nothing
		Else
			CustomerId.ViewValue = Null
		End If
		CustomerId.ViewCustomAttributes = ""

		' InvoiceId
		InvoiceId.ViewValue = InvoiceId.CurrentValue
		InvoiceId.ViewCustomAttributes = ""

		' Amount
		Amount.ViewValue = Amount.CurrentValue
		Amount.ViewCustomAttributes = ""

		' Ship_FirstName
		Ship_FirstName.ViewValue = Ship_FirstName.CurrentValue
		Ship_FirstName.ViewCustomAttributes = ""

		' Ship_LastName
		Ship_LastName.ViewValue = Ship_LastName.CurrentValue
		Ship_LastName.ViewCustomAttributes = ""

		' Ship_Address
		Ship_Address.ViewValue = Ship_Address.CurrentValue
		Ship_Address.ViewCustomAttributes = ""

		' Ship_Address2
		Ship_Address2.ViewValue = Ship_Address2.CurrentValue
		Ship_Address2.ViewCustomAttributes = ""

		' Ship_City
		Ship_City.ViewValue = Ship_City.CurrentValue
		Ship_City.ViewCustomAttributes = ""

		' Ship_Province
		Ship_Province.ViewValue = Ship_Province.CurrentValue
		Ship_Province.ViewCustomAttributes = ""

		' Ship_Postal
		Ship_Postal.ViewValue = Ship_Postal.CurrentValue
		Ship_Postal.ViewCustomAttributes = ""

		' Ship_Country
		Ship_Country.ViewValue = Ship_Country.CurrentValue
		Ship_Country.ViewCustomAttributes = ""

		' Ship_Phone
		Ship_Phone.ViewValue = Ship_Phone.CurrentValue
		Ship_Phone.ViewCustomAttributes = ""

		' Ship_Email
		Ship_Email.ViewValue = Ship_Email.CurrentValue
		Ship_Email.ViewCustomAttributes = ""

		' payment_status
		If Not IsNull(payment_status.CurrentValue) Then
			Select Case payment_status.CurrentValue
				Case "Completed"
					payment_status.ViewValue = ew_IIf(payment_status.FldTagCaption(1) <> "", payment_status.FldTagCaption(1), "Completed")
				Case "WIP"
					payment_status.ViewValue = ew_IIf(payment_status.FldTagCaption(2) <> "", payment_status.FldTagCaption(2), "WIP")
				Case "Pending"
					payment_status.ViewValue = ew_IIf(payment_status.FldTagCaption(3) <> "", payment_status.FldTagCaption(3), "Pending")
				Case "Failed"
					payment_status.ViewValue = ew_IIf(payment_status.FldTagCaption(4) <> "", payment_status.FldTagCaption(4), "Failed")
				Case Else
					payment_status.ViewValue = payment_status.CurrentValue
			End Select
		Else
			payment_status.ViewValue = Null
		End If
		payment_status.ViewCustomAttributes = ""

		' Ordered_Date
		Ordered_Date.ViewValue = Ordered_Date.CurrentValue
		Ordered_Date.ViewCustomAttributes = ""

		' payment_date
		payment_date.ViewValue = payment_date.CurrentValue
		payment_date.ViewCustomAttributes = ""

		' pfirst_name
		pfirst_name.ViewValue = pfirst_name.CurrentValue
		pfirst_name.ViewCustomAttributes = ""

		' plast_name
		plast_name.ViewValue = plast_name.CurrentValue
		plast_name.ViewCustomAttributes = ""

		' payer_email
		payer_email.ViewValue = payer_email.CurrentValue
		payer_email.ViewCustomAttributes = ""

		' txn_id
		txn_id.ViewValue = txn_id.CurrentValue
		txn_id.ViewCustomAttributes = ""

		' payment_gross
		payment_gross.ViewValue = payment_gross.CurrentValue
		payment_gross.ViewCustomAttributes = ""

		' payment_fee
		payment_fee.ViewValue = payment_fee.CurrentValue
		payment_fee.ViewCustomAttributes = ""

		' payment_type
		payment_type.ViewValue = payment_type.CurrentValue
		payment_type.ViewCustomAttributes = ""

		' txn_type
		txn_type.ViewValue = txn_type.CurrentValue
		txn_type.ViewCustomAttributes = ""

		' receiver_email
		receiver_email.ViewValue = receiver_email.CurrentValue
		receiver_email.ViewCustomAttributes = ""

		' pShip_Name
		pShip_Name.ViewValue = pShip_Name.CurrentValue
		pShip_Name.ViewCustomAttributes = ""

		' pShip_Address
		pShip_Address.ViewValue = pShip_Address.CurrentValue
		pShip_Address.ViewCustomAttributes = ""

		' pShip_City
		pShip_City.ViewValue = pShip_City.CurrentValue
		pShip_City.ViewCustomAttributes = ""

		' pShip_Province
		pShip_Province.ViewValue = pShip_Province.CurrentValue
		pShip_Province.ViewCustomAttributes = ""

		' pShip_Postal
		pShip_Postal.ViewValue = pShip_Postal.CurrentValue
		pShip_Postal.ViewCustomAttributes = ""

		' pShip_Country
		pShip_Country.ViewValue = pShip_Country.CurrentValue
		pShip_Country.ViewCustomAttributes = ""

		' Tax
		Tax.ViewValue = Tax.CurrentValue
		Tax.ViewCustomAttributes = ""

		' Shipping
		Shipping.ViewValue = Shipping.CurrentValue
		Shipping.ViewCustomAttributes = ""

		' EmailSent
		EmailSent.ViewValue = EmailSent.CurrentValue
		EmailSent.ViewCustomAttributes = ""

		' EmailDate
		EmailDate.ViewValue = EmailDate.CurrentValue
		EmailDate.ViewCustomAttributes = ""

		' OrderId
		OrderId.LinkCustomAttributes = ""
		OrderId.HrefValue = ""
		OrderId.TooltipValue = ""

		' CustomerId
		CustomerId.LinkCustomAttributes = ""
		CustomerId.HrefValue = ""
		CustomerId.TooltipValue = ""

		' InvoiceId
		InvoiceId.LinkCustomAttributes = ""
		InvoiceId.HrefValue = ""
		InvoiceId.TooltipValue = ""

		' Amount
		Amount.LinkCustomAttributes = ""
		Amount.HrefValue = ""
		Amount.TooltipValue = ""

		' Ship_FirstName
		Ship_FirstName.LinkCustomAttributes = ""
		Ship_FirstName.HrefValue = ""
		Ship_FirstName.TooltipValue = ""

		' Ship_LastName
		Ship_LastName.LinkCustomAttributes = ""
		Ship_LastName.HrefValue = ""
		Ship_LastName.TooltipValue = ""

		' Ship_Address
		Ship_Address.LinkCustomAttributes = ""
		Ship_Address.HrefValue = ""
		Ship_Address.TooltipValue = ""

		' Ship_Address2
		Ship_Address2.LinkCustomAttributes = ""
		Ship_Address2.HrefValue = ""
		Ship_Address2.TooltipValue = ""

		' Ship_City
		Ship_City.LinkCustomAttributes = ""
		Ship_City.HrefValue = ""
		Ship_City.TooltipValue = ""

		' Ship_Province
		Ship_Province.LinkCustomAttributes = ""
		Ship_Province.HrefValue = ""
		Ship_Province.TooltipValue = ""

		' Ship_Postal
		Ship_Postal.LinkCustomAttributes = ""
		Ship_Postal.HrefValue = ""
		Ship_Postal.TooltipValue = ""

		' Ship_Country
		Ship_Country.LinkCustomAttributes = ""
		Ship_Country.HrefValue = ""
		Ship_Country.TooltipValue = ""

		' Ship_Phone
		Ship_Phone.LinkCustomAttributes = ""
		Ship_Phone.HrefValue = ""
		Ship_Phone.TooltipValue = ""

		' Ship_Email
		Ship_Email.LinkCustomAttributes = ""
		Ship_Email.HrefValue = ""
		Ship_Email.TooltipValue = ""

		' payment_status
		payment_status.LinkCustomAttributes = ""
		payment_status.HrefValue = ""
		payment_status.TooltipValue = ""

		' Ordered_Date
		Ordered_Date.LinkCustomAttributes = ""
		Ordered_Date.HrefValue = ""
		Ordered_Date.TooltipValue = ""

		' payment_date
		payment_date.LinkCustomAttributes = ""
		payment_date.HrefValue = ""
		payment_date.TooltipValue = ""

		' pfirst_name
		pfirst_name.LinkCustomAttributes = ""
		pfirst_name.HrefValue = ""
		pfirst_name.TooltipValue = ""

		' plast_name
		plast_name.LinkCustomAttributes = ""
		plast_name.HrefValue = ""
		plast_name.TooltipValue = ""

		' payer_email
		payer_email.LinkCustomAttributes = ""
		payer_email.HrefValue = ""
		payer_email.TooltipValue = ""

		' txn_id
		txn_id.LinkCustomAttributes = ""
		txn_id.HrefValue = ""
		txn_id.TooltipValue = ""

		' payment_gross
		payment_gross.LinkCustomAttributes = ""
		payment_gross.HrefValue = ""
		payment_gross.TooltipValue = ""

		' payment_fee
		payment_fee.LinkCustomAttributes = ""
		payment_fee.HrefValue = ""
		payment_fee.TooltipValue = ""

		' payment_type
		payment_type.LinkCustomAttributes = ""
		payment_type.HrefValue = ""
		payment_type.TooltipValue = ""

		' txn_type
		txn_type.LinkCustomAttributes = ""
		txn_type.HrefValue = ""
		txn_type.TooltipValue = ""

		' receiver_email
		receiver_email.LinkCustomAttributes = ""
		receiver_email.HrefValue = ""
		receiver_email.TooltipValue = ""

		' pShip_Name
		pShip_Name.LinkCustomAttributes = ""
		pShip_Name.HrefValue = ""
		pShip_Name.TooltipValue = ""

		' pShip_Address
		pShip_Address.LinkCustomAttributes = ""
		pShip_Address.HrefValue = ""
		pShip_Address.TooltipValue = ""

		' pShip_City
		pShip_City.LinkCustomAttributes = ""
		pShip_City.HrefValue = ""
		pShip_City.TooltipValue = ""

		' pShip_Province
		pShip_Province.LinkCustomAttributes = ""
		pShip_Province.HrefValue = ""
		pShip_Province.TooltipValue = ""

		' pShip_Postal
		pShip_Postal.LinkCustomAttributes = ""
		pShip_Postal.HrefValue = ""
		pShip_Postal.TooltipValue = ""

		' pShip_Country
		pShip_Country.LinkCustomAttributes = ""
		pShip_Country.HrefValue = ""
		pShip_Country.TooltipValue = ""

		' Tax
		Tax.LinkCustomAttributes = ""
		Tax.HrefValue = ""
		Tax.TooltipValue = ""

		' Shipping
		Shipping.LinkCustomAttributes = ""
		Shipping.HrefValue = ""
		Shipping.TooltipValue = ""

		' EmailSent
		EmailSent.LinkCustomAttributes = ""
		EmailSent.HrefValue = ""
		EmailSent.TooltipValue = ""

		' EmailDate
		EmailDate.LinkCustomAttributes = ""
		EmailDate.HrefValue = ""
		EmailDate.TooltipValue = ""

		' Call Row Rendered event
		If RowType <> EW_ROWTYPE_AGGREGATEINIT Then
			Call Row_Rendered()
		End If
	End Sub

	' Aggregate list row values
	Public Sub AggregateListRowValues()
	End Sub

	' Aggregate list row (for rendering)
	Sub AggregateListRow()
	End Sub

	' Export data in Xml Format
	Public Sub ExportXmlDocument(XmlDoc, HasParent, Recordset, StartRec, StopRec, ExportPageType)
		If Not IsObject(Recordset) Or Not IsObject(XmlDoc) Then
			Exit Sub
		End If
		If Not HasParent Then
			Call XmlDoc.AddRoot(TableVar)
		End If

		' Move to first record
		Dim RecCnt, RowCnt
		RecCnt = StartRec - 1
		If Not Recordset.Eof Then
			Recordset.MoveFirst()
			If StartRec > 1 Then Recordset.Move(StartRec - 1)
		End If
		Do While Not Recordset.Eof And RecCnt < StopRec
			RecCnt = RecCnt + 1
			If CLng(RecCnt) >= CLng(StartRec) Then
				RowCnt = CLng(RecCnt) - CLng(StartRec) + 1
				Call LoadListRowValues(Recordset)

				' Render row
				RowType = EW_ROWTYPE_VIEW ' Render view
				Call ResetAttrs()
				Call RenderListRow()
				If HasParent Then
					Call XmlDoc.AddRow(TableVar, "")
				Else
					Call XmlDoc.AddRow("", "")
				End If
				If ExportPageType = "view" Then
					Call XmlDoc.AddField("OrderId", OrderId.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("CustomerId", CustomerId.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("InvoiceId", InvoiceId.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Amount", Amount.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ship_FirstName", Ship_FirstName.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ship_LastName", Ship_LastName.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ship_Address", Ship_Address.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ship_Address2", Ship_Address2.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ship_City", Ship_City.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ship_Province", Ship_Province.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ship_Postal", Ship_Postal.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ship_Country", Ship_Country.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ship_Phone", Ship_Phone.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ship_Email", Ship_Email.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("payment_status", payment_status.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ordered_Date", Ordered_Date.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("payment_date", payment_date.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("pfirst_name", pfirst_name.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("plast_name", plast_name.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("payer_email", payer_email.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("txn_id", txn_id.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("payment_gross", payment_gross.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("payment_fee", payment_fee.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("payment_type", payment_type.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("txn_type", txn_type.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("receiver_email", receiver_email.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("pShip_Name", pShip_Name.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("pShip_Address", pShip_Address.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("pShip_City", pShip_City.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("pShip_Province", pShip_Province.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("pShip_Postal", pShip_Postal.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("pShip_Country", pShip_Country.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Tax", Tax.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Shipping", Shipping.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("EmailSent", EmailSent.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("EmailDate", EmailDate.ExportValue(Export, ExportOriginalValue))
				Else
					Call XmlDoc.AddField("OrderId", OrderId.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("CustomerId", CustomerId.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("InvoiceId", InvoiceId.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Amount", Amount.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ship_FirstName", Ship_FirstName.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ship_LastName", Ship_LastName.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ship_Address", Ship_Address.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ship_Address2", Ship_Address2.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ship_City", Ship_City.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ship_Province", Ship_Province.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ship_Postal", Ship_Postal.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ship_Country", Ship_Country.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ship_Phone", Ship_Phone.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ship_Email", Ship_Email.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("payment_status", payment_status.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Ordered_Date", Ordered_Date.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("payment_date", payment_date.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("pfirst_name", pfirst_name.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("plast_name", plast_name.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("payer_email", payer_email.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("txn_id", txn_id.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("payment_gross", payment_gross.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("payment_fee", payment_fee.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("payment_type", payment_type.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("txn_type", txn_type.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("receiver_email", receiver_email.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("pShip_Name", pShip_Name.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("pShip_Address", pShip_Address.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("pShip_City", pShip_City.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("pShip_Province", pShip_Province.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("pShip_Postal", pShip_Postal.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("pShip_Country", pShip_Country.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Tax", Tax.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("Shipping", Shipping.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("EmailSent", EmailSent.ExportValue(Export, ExportOriginalValue))
					Call XmlDoc.AddField("EmailDate", EmailDate.ExportValue(Export, ExportOriginalValue))
				End If
			End If
			Recordset.MoveNext()
		Loop
	End Sub

	' Export data in HTML/CSV/Word/Excel/Email format
	Public Sub ExportDocument(Doc, Recordset, StartRec, StopRec, ExportPageType)
		If Not IsObject(Recordset) Or Not IsObject(Doc) Then
			Exit Sub
		End If

		' Write header
		Call Doc.ExportTableHeader()
		If Doc.Horizontal Then ' Horizontal format, write header
			Call Doc.BeginExportRow(0)
			If ExportPageType = "view" Then
				Call Doc.ExportCaption(OrderId)
				Call Doc.ExportCaption(CustomerId)
				Call Doc.ExportCaption(InvoiceId)
				Call Doc.ExportCaption(Amount)
				Call Doc.ExportCaption(Ship_FirstName)
				Call Doc.ExportCaption(Ship_LastName)
				Call Doc.ExportCaption(Ship_Address)
				Call Doc.ExportCaption(Ship_Address2)
				Call Doc.ExportCaption(Ship_City)
				Call Doc.ExportCaption(Ship_Province)
				Call Doc.ExportCaption(Ship_Postal)
				Call Doc.ExportCaption(Ship_Country)
				Call Doc.ExportCaption(Ship_Phone)
				Call Doc.ExportCaption(Ship_Email)
				Call Doc.ExportCaption(payment_status)
				Call Doc.ExportCaption(Ordered_Date)
				Call Doc.ExportCaption(payment_date)
				Call Doc.ExportCaption(pfirst_name)
				Call Doc.ExportCaption(plast_name)
				Call Doc.ExportCaption(payer_email)
				Call Doc.ExportCaption(txn_id)
				Call Doc.ExportCaption(payment_gross)
				Call Doc.ExportCaption(payment_fee)
				Call Doc.ExportCaption(payment_type)
				Call Doc.ExportCaption(txn_type)
				Call Doc.ExportCaption(receiver_email)
				Call Doc.ExportCaption(pShip_Name)
				Call Doc.ExportCaption(pShip_Address)
				Call Doc.ExportCaption(pShip_City)
				Call Doc.ExportCaption(pShip_Province)
				Call Doc.ExportCaption(pShip_Postal)
				Call Doc.ExportCaption(pShip_Country)
				Call Doc.ExportCaption(Tax)
				Call Doc.ExportCaption(Shipping)
				Call Doc.ExportCaption(EmailSent)
				Call Doc.ExportCaption(EmailDate)
			Else
				Call Doc.ExportCaption(OrderId)
				Call Doc.ExportCaption(CustomerId)
				Call Doc.ExportCaption(InvoiceId)
				Call Doc.ExportCaption(Amount)
				Call Doc.ExportCaption(Ship_FirstName)
				Call Doc.ExportCaption(Ship_LastName)
				Call Doc.ExportCaption(Ship_Address)
				Call Doc.ExportCaption(Ship_Address2)
				Call Doc.ExportCaption(Ship_City)
				Call Doc.ExportCaption(Ship_Province)
				Call Doc.ExportCaption(Ship_Postal)
				Call Doc.ExportCaption(Ship_Country)
				Call Doc.ExportCaption(Ship_Phone)
				Call Doc.ExportCaption(Ship_Email)
				Call Doc.ExportCaption(payment_status)
				Call Doc.ExportCaption(Ordered_Date)
				Call Doc.ExportCaption(payment_date)
				Call Doc.ExportCaption(pfirst_name)
				Call Doc.ExportCaption(plast_name)
				Call Doc.ExportCaption(payer_email)
				Call Doc.ExportCaption(txn_id)
				Call Doc.ExportCaption(payment_gross)
				Call Doc.ExportCaption(payment_fee)
				Call Doc.ExportCaption(payment_type)
				Call Doc.ExportCaption(txn_type)
				Call Doc.ExportCaption(receiver_email)
				Call Doc.ExportCaption(pShip_Name)
				Call Doc.ExportCaption(pShip_Address)
				Call Doc.ExportCaption(pShip_City)
				Call Doc.ExportCaption(pShip_Province)
				Call Doc.ExportCaption(pShip_Postal)
				Call Doc.ExportCaption(pShip_Country)
				Call Doc.ExportCaption(Tax)
				Call Doc.ExportCaption(Shipping)
				Call Doc.ExportCaption(EmailSent)
				Call Doc.ExportCaption(EmailDate)
			End If
			Call Doc.EndExportRow()
		End If

		' Move to first record
		Dim RecCnt, RowCnt
		RecCnt = StartRec - 1
		If Not Recordset.Eof Then
			Recordset.MoveFirst()
			If StartRec > 1 Then Recordset.Move(StartRec - 1)
		End If
		Do While Not Recordset.Eof And CLng(RecCnt) < CLng(StopRec)
			RecCnt = RecCnt + 1
			If CLng(RecCnt) >= CLng(StartRec) Then
				RowCnt = CLng(RecCnt) - CLng(StartRec) + 1
				Call LoadListRowValues(Recordset)

				' Render row
				RowType = EW_ROWTYPE_VIEW ' Render view
				Call ResetAttrs()
				Call RenderListRow()
				Call Doc.BeginExportRow(RowCnt)
				If ExportPageType = "view" Then
					Call Doc.ExportField(OrderId)
					Call Doc.ExportField(CustomerId)
					Call Doc.ExportField(InvoiceId)
					Call Doc.ExportField(Amount)
					Call Doc.ExportField(Ship_FirstName)
					Call Doc.ExportField(Ship_LastName)
					Call Doc.ExportField(Ship_Address)
					Call Doc.ExportField(Ship_Address2)
					Call Doc.ExportField(Ship_City)
					Call Doc.ExportField(Ship_Province)
					Call Doc.ExportField(Ship_Postal)
					Call Doc.ExportField(Ship_Country)
					Call Doc.ExportField(Ship_Phone)
					Call Doc.ExportField(Ship_Email)
					Call Doc.ExportField(payment_status)
					Call Doc.ExportField(Ordered_Date)
					Call Doc.ExportField(payment_date)
					Call Doc.ExportField(pfirst_name)
					Call Doc.ExportField(plast_name)
					Call Doc.ExportField(payer_email)
					Call Doc.ExportField(txn_id)
					Call Doc.ExportField(payment_gross)
					Call Doc.ExportField(payment_fee)
					Call Doc.ExportField(payment_type)
					Call Doc.ExportField(txn_type)
					Call Doc.ExportField(receiver_email)
					Call Doc.ExportField(pShip_Name)
					Call Doc.ExportField(pShip_Address)
					Call Doc.ExportField(pShip_City)
					Call Doc.ExportField(pShip_Province)
					Call Doc.ExportField(pShip_Postal)
					Call Doc.ExportField(pShip_Country)
					Call Doc.ExportField(Tax)
					Call Doc.ExportField(Shipping)
					Call Doc.ExportField(EmailSent)
					Call Doc.ExportField(EmailDate)
				Else
					Call Doc.ExportField(OrderId)
					Call Doc.ExportField(CustomerId)
					Call Doc.ExportField(InvoiceId)
					Call Doc.ExportField(Amount)
					Call Doc.ExportField(Ship_FirstName)
					Call Doc.ExportField(Ship_LastName)
					Call Doc.ExportField(Ship_Address)
					Call Doc.ExportField(Ship_Address2)
					Call Doc.ExportField(Ship_City)
					Call Doc.ExportField(Ship_Province)
					Call Doc.ExportField(Ship_Postal)
					Call Doc.ExportField(Ship_Country)
					Call Doc.ExportField(Ship_Phone)
					Call Doc.ExportField(Ship_Email)
					Call Doc.ExportField(payment_status)
					Call Doc.ExportField(Ordered_Date)
					Call Doc.ExportField(payment_date)
					Call Doc.ExportField(pfirst_name)
					Call Doc.ExportField(plast_name)
					Call Doc.ExportField(payer_email)
					Call Doc.ExportField(txn_id)
					Call Doc.ExportField(payment_gross)
					Call Doc.ExportField(payment_fee)
					Call Doc.ExportField(payment_type)
					Call Doc.ExportField(txn_type)
					Call Doc.ExportField(receiver_email)
					Call Doc.ExportField(pShip_Name)
					Call Doc.ExportField(pShip_Address)
					Call Doc.ExportField(pShip_City)
					Call Doc.ExportField(pShip_Province)
					Call Doc.ExportField(pShip_Postal)
					Call Doc.ExportField(pShip_Country)
					Call Doc.ExportField(Tax)
					Call Doc.ExportField(Shipping)
					Call Doc.ExportField(EmailSent)
					Call Doc.ExportField(EmailDate)
				End If
				Call Doc.EndExportRow()
			End If
			Recordset.MoveNext()
		Loop
		Call Doc.ExportTableFooter()
	End Sub
	Dim CurrentAction ' Current action
	Dim LastAction ' Last action
	Dim CurrentMode ' Current mode
	Dim UpdateConflict ' Update conflict
	Dim EventName ' Event name
	Dim EventCancelled ' Event cancelled
	Dim CancelMessage ' Cancel message
	Dim AllowAddDeleteRow ' Allow add/delete row
	Dim DetailAdd ' Allow detail add
	Dim DetailEdit ' Allow detail edit
	Dim GridAddRowCount ' Grid add row count

	' Check current action
	' - Add
	Public Function IsAdd()
		IsAdd = (CurrentAction = "add")
	End Function

	' - Copy
	Public Function IsCopy()
		IsCopy = (CurrentAction = "copy" Or CurrentAction = "C")
	End Function

	' - Edit
	Public Function IsEdit()
		IsEdit = (CurrentAction = "edit")
	End Function

	' - Delete
	Public Function IsDelete()
		IsDelete = (CurrentAction = "D")
	End Function

	' - Confirm
	Public Function IsConfirm()
		IsConfirm = (CurrentAction = "F")
	End Function

	' - Overwrite
	Public Function IsOverwrite()
		IsOverwrite = (CurrentAction = "overwrite")
	End Function

	' - Cancel
	Public Function IsCancel()
		IsCancel = (CurrentAction = "cancel")
	End Function

	' - Grid add
	Public Function IsGridAdd()
		IsGridAdd = (CurrentAction = "gridadd")
	End Function

	' - Grid edit
	Public Function IsGridEdit()
		IsGridEdit = (CurrentAction = "gridedit")
	End Function

	' - Insert
	Public Function IsInsert()
		IsInsert = (CurrentAction = "insert" Or CurrentAction = "A")
	End Function

	' - Update
	Public Function IsUpdate()
		IsUpdate = (CurrentAction = "update" Or CurrentAction = "U")
	End Function

	' - Grid update
	Public Function IsGridUpdate()
		IsGridUpdate = (CurrentAction = "gridupdate")
	End Function

	' - Grid insert
	Public Function IsGridInsert()
		IsGridInsert = (CurrentAction = "gridinsert")
	End Function

	' - Grid overwrite
	Public Function IsGridOverwrite()
		IsGridOverwrite = (CurrentAction = "gridoverwrite")
	End Function

	' Check last action
	' - Cancelled
	Public Function IsCancelled()
		IsCancelled = (LastAction = "cancel" And CurrentAction = "")
	End Function

	' - Inline inserted
	Public Function IsInlineInserted()
		IsInlineInserted = (LastAction = "insert" And CurrentAction = "")
	End Function

	' - Inline updated
	Public Function IsInlineUpdated()
		IsInlineUpdated = (LastAction = "update" And CurrentAction = "")
	End Function

	' - Grid updated
	Public Function IsGridUpdated()
		IsGridUpdated = (LastAction = "gridupdate" And CurrentAction = "")
	End Function

	' - Grid inserted
	Public Function IsGridInserted()
		IsGridInserted = (LastAction = "gridinsert" And CurrentAction = "")
	End Function

	' Row Type
	Private m_RowType

	Public Property Get RowType()
		RowType = m_RowType
	End Property

	Public Property Let RowType(v)
		m_RowType = v
	End Property
	Dim CssClass ' Css class
	Dim CssStyle' Css style

'	Dim RowClientEvents ' Row client events
	Dim RowAttrs ' Row attributes

	' Row Styles
	Public Property Get RowStyles()
		Dim sAtt, Value
		Dim sStyle, sClass
		sAtt = ""
		sStyle = CssStyle
		If RowAttrs.Exists("style") Then
			Value = RowAttrs.Item("style")
			If Trim(Value) <> "" Then
				sStyle = sStyle & " " & Value
			End If
		End If
		sClass = CssClass
		If RowAttrs.Exists("class") Then
			Value = RowAttrs.Item("class")
			If Trim(Value) <> "" Then
				sClass = sClass & " " & Value
			End If
		End If
		If Trim(sStyle) <> "" Then
			sAtt = sAtt & " style=""" & Trim(sStyle) & """" 
		End If
		If Trim(sClass) <> "" Then
			sAtt = sAtt & " class=""" & Trim(sClass) & """" 
		End If
		RowStyles = sAtt
	End Property

	' Row Attribute
	Public Property Get RowAttributes()
		Dim sAtt, Attr, Value, i
		sAtt = RowStyles
		If m_Export = "" Then

'			If Trim(RowClientEvents) <> "" Then
'				sAtt = sAtt & " " & Trim(RowClientEvents)
'			End If

			For i = 0 to UBound(RowAttrs.Attributes)
				Attr = RowAttrs.Attributes(i)(0)
				Value = RowAttrs.Attributes(i)(1)
				If Attr <> "style" And Attr <> "class" And Attr <> "" And Value <> "" Then
					sAtt = sAtt & " " & Attr & "=""" & Value & """"
				End If
			Next
		End If
		RowAttributes = sAtt
	End Property

	' Export
	Private m_Export

	Public Property Get Export()
		Export = m_Export
	End Property

	Public Property Let Export(v)
		m_Export = v
	End Property

	' Export Original Value
	Dim ExportOriginalValue

	' Export All
	Dim ExportAll

	' Send Email
	Dim SendEmail

	' Custom Inner Html
	Dim TableCustomInnerHtml

	' ----------------
	'  Field objects
	' ----------------
	' Field OrderId
	Private m_OrderId

	Public Property Get OrderId()
		If Not IsObject(m_OrderId) Then
			Set m_OrderId = NewFldObj("Orders", "Orders", "x_OrderId", "OrderId", "[OrderId]", 3, 8, "", False, False, "FORMATTED TEXT")
			m_OrderId.FldDefaultErrMsg = Language.Phrase("IncorrectInteger")
		End If
		Set OrderId = m_OrderId
	End Property

	' Field CustomerId
	Private m_CustomerId

	Public Property Get CustomerId()
		If Not IsObject(m_CustomerId) Then
			Set m_CustomerId = NewFldObj("Orders", "Orders", "x_CustomerId", "CustomerId", "[CustomerId]", 3, 8, "", False, False, "FORMATTED TEXT")
			m_CustomerId.FldDefaultErrMsg = Language.Phrase("IncorrectInteger")
		End If
		Set CustomerId = m_CustomerId
	End Property

	' Field InvoiceId
	Private m_InvoiceId

	Public Property Get InvoiceId()
		If Not IsObject(m_InvoiceId) Then
			Set m_InvoiceId = NewFldObj("Orders", "Orders", "x_InvoiceId", "InvoiceId", "[InvoiceId]", 3, 8, "", False, False, "FORMATTED TEXT")
			m_InvoiceId.FldDefaultErrMsg = Language.Phrase("IncorrectInteger")
		End If
		Set InvoiceId = m_InvoiceId
	End Property

	' Field Amount
	Private m_Amount

	Public Property Get Amount()
		If Not IsObject(m_Amount) Then
			Set m_Amount = NewFldObj("Orders", "Orders", "x_Amount", "Amount", "[Amount]", 5, 8, "", False, False, "FORMATTED TEXT")
			m_Amount.FldDefaultErrMsg = Language.Phrase("IncorrectFloat")
		End If
		Set Amount = m_Amount
	End Property

	' Field Ship_FirstName
	Private m_Ship_FirstName

	Public Property Get Ship_FirstName()
		If Not IsObject(m_Ship_FirstName) Then
			Set m_Ship_FirstName = NewFldObj("Orders", "Orders", "x_Ship_FirstName", "Ship_FirstName", "[Ship_FirstName]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set Ship_FirstName = m_Ship_FirstName
	End Property

	' Field Ship_LastName
	Private m_Ship_LastName

	Public Property Get Ship_LastName()
		If Not IsObject(m_Ship_LastName) Then
			Set m_Ship_LastName = NewFldObj("Orders", "Orders", "x_Ship_LastName", "Ship_LastName", "[Ship_LastName]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set Ship_LastName = m_Ship_LastName
	End Property

	' Field Ship_Address
	Private m_Ship_Address

	Public Property Get Ship_Address()
		If Not IsObject(m_Ship_Address) Then
			Set m_Ship_Address = NewFldObj("Orders", "Orders", "x_Ship_Address", "Ship_Address", "[Ship_Address]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set Ship_Address = m_Ship_Address
	End Property

	' Field Ship_Address2
	Private m_Ship_Address2

	Public Property Get Ship_Address2()
		If Not IsObject(m_Ship_Address2) Then
			Set m_Ship_Address2 = NewFldObj("Orders", "Orders", "x_Ship_Address2", "Ship_Address2", "[Ship_Address2]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set Ship_Address2 = m_Ship_Address2
	End Property

	' Field Ship_City
	Private m_Ship_City

	Public Property Get Ship_City()
		If Not IsObject(m_Ship_City) Then
			Set m_Ship_City = NewFldObj("Orders", "Orders", "x_Ship_City", "Ship_City", "[Ship_City]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set Ship_City = m_Ship_City
	End Property

	' Field Ship_Province
	Private m_Ship_Province

	Public Property Get Ship_Province()
		If Not IsObject(m_Ship_Province) Then
			Set m_Ship_Province = NewFldObj("Orders", "Orders", "x_Ship_Province", "Ship_Province", "[Ship_Province]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set Ship_Province = m_Ship_Province
	End Property

	' Field Ship_Postal
	Private m_Ship_Postal

	Public Property Get Ship_Postal()
		If Not IsObject(m_Ship_Postal) Then
			Set m_Ship_Postal = NewFldObj("Orders", "Orders", "x_Ship_Postal", "Ship_Postal", "[Ship_Postal]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set Ship_Postal = m_Ship_Postal
	End Property

	' Field Ship_Country
	Private m_Ship_Country

	Public Property Get Ship_Country()
		If Not IsObject(m_Ship_Country) Then
			Set m_Ship_Country = NewFldObj("Orders", "Orders", "x_Ship_Country", "Ship_Country", "[Ship_Country]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set Ship_Country = m_Ship_Country
	End Property

	' Field Ship_Phone
	Private m_Ship_Phone

	Public Property Get Ship_Phone()
		If Not IsObject(m_Ship_Phone) Then
			Set m_Ship_Phone = NewFldObj("Orders", "Orders", "x_Ship_Phone", "Ship_Phone", "[Ship_Phone]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set Ship_Phone = m_Ship_Phone
	End Property

	' Field Ship_Email
	Private m_Ship_Email

	Public Property Get Ship_Email()
		If Not IsObject(m_Ship_Email) Then
			Set m_Ship_Email = NewFldObj("Orders", "Orders", "x_Ship_Email", "Ship_Email", "[Ship_Email]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set Ship_Email = m_Ship_Email
	End Property

	' Field payment_status
	Private m_payment_status

	Public Property Get payment_status()
		If Not IsObject(m_payment_status) Then
			Set m_payment_status = NewFldObj("Orders", "Orders", "x_payment_status", "payment_status", "[payment_status]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set payment_status = m_payment_status
	End Property

	' Field Ordered_Date
	Private m_Ordered_Date

	Public Property Get Ordered_Date()
		If Not IsObject(m_Ordered_Date) Then
			Set m_Ordered_Date = NewFldObj("Orders", "Orders", "x_Ordered_Date", "Ordered_Date", "[Ordered_Date]", 135, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set Ordered_Date = m_Ordered_Date
	End Property

	' Field payment_date
	Private m_payment_date

	Public Property Get payment_date()
		If Not IsObject(m_payment_date) Then
			Set m_payment_date = NewFldObj("Orders", "Orders", "x_payment_date", "payment_date", "[payment_date]", 135, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set payment_date = m_payment_date
	End Property

	' Field pfirst_name
	Private m_pfirst_name

	Public Property Get pfirst_name()
		If Not IsObject(m_pfirst_name) Then
			Set m_pfirst_name = NewFldObj("Orders", "Orders", "x_pfirst_name", "pfirst_name", "[pfirst_name]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set pfirst_name = m_pfirst_name
	End Property

	' Field plast_name
	Private m_plast_name

	Public Property Get plast_name()
		If Not IsObject(m_plast_name) Then
			Set m_plast_name = NewFldObj("Orders", "Orders", "x_plast_name", "plast_name", "[plast_name]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set plast_name = m_plast_name
	End Property

	' Field payer_email
	Private m_payer_email

	Public Property Get payer_email()
		If Not IsObject(m_payer_email) Then
			Set m_payer_email = NewFldObj("Orders", "Orders", "x_payer_email", "payer_email", "[payer_email]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set payer_email = m_payer_email
	End Property

	' Field txn_id
	Private m_txn_id

	Public Property Get txn_id()
		If Not IsObject(m_txn_id) Then
			Set m_txn_id = NewFldObj("Orders", "Orders", "x_txn_id", "txn_id", "[txn_id]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set txn_id = m_txn_id
	End Property

	' Field payment_gross
	Private m_payment_gross

	Public Property Get payment_gross()
		If Not IsObject(m_payment_gross) Then
			Set m_payment_gross = NewFldObj("Orders", "Orders", "x_payment_gross", "payment_gross", "[payment_gross]", 5, 8, "", False, False, "FORMATTED TEXT")
			m_payment_gross.FldDefaultErrMsg = Language.Phrase("IncorrectFloat")
		End If
		Set payment_gross = m_payment_gross
	End Property

	' Field payment_fee
	Private m_payment_fee

	Public Property Get payment_fee()
		If Not IsObject(m_payment_fee) Then
			Set m_payment_fee = NewFldObj("Orders", "Orders", "x_payment_fee", "payment_fee", "[payment_fee]", 5, 8, "", False, False, "FORMATTED TEXT")
			m_payment_fee.FldDefaultErrMsg = Language.Phrase("IncorrectFloat")
		End If
		Set payment_fee = m_payment_fee
	End Property

	' Field payment_type
	Private m_payment_type

	Public Property Get payment_type()
		If Not IsObject(m_payment_type) Then
			Set m_payment_type = NewFldObj("Orders", "Orders", "x_payment_type", "payment_type", "[payment_type]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set payment_type = m_payment_type
	End Property

	' Field txn_type
	Private m_txn_type

	Public Property Get txn_type()
		If Not IsObject(m_txn_type) Then
			Set m_txn_type = NewFldObj("Orders", "Orders", "x_txn_type", "txn_type", "[txn_type]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set txn_type = m_txn_type
	End Property

	' Field receiver_email
	Private m_receiver_email

	Public Property Get receiver_email()
		If Not IsObject(m_receiver_email) Then
			Set m_receiver_email = NewFldObj("Orders", "Orders", "x_receiver_email", "receiver_email", "[receiver_email]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set receiver_email = m_receiver_email
	End Property

	' Field pShip_Name
	Private m_pShip_Name

	Public Property Get pShip_Name()
		If Not IsObject(m_pShip_Name) Then
			Set m_pShip_Name = NewFldObj("Orders", "Orders", "x_pShip_Name", "pShip_Name", "[pShip_Name]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set pShip_Name = m_pShip_Name
	End Property

	' Field pShip_Address
	Private m_pShip_Address

	Public Property Get pShip_Address()
		If Not IsObject(m_pShip_Address) Then
			Set m_pShip_Address = NewFldObj("Orders", "Orders", "x_pShip_Address", "pShip_Address", "[pShip_Address]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set pShip_Address = m_pShip_Address
	End Property

	' Field pShip_City
	Private m_pShip_City

	Public Property Get pShip_City()
		If Not IsObject(m_pShip_City) Then
			Set m_pShip_City = NewFldObj("Orders", "Orders", "x_pShip_City", "pShip_City", "[pShip_City]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set pShip_City = m_pShip_City
	End Property

	' Field pShip_Province
	Private m_pShip_Province

	Public Property Get pShip_Province()
		If Not IsObject(m_pShip_Province) Then
			Set m_pShip_Province = NewFldObj("Orders", "Orders", "x_pShip_Province", "pShip_Province", "[pShip_Province]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set pShip_Province = m_pShip_Province
	End Property

	' Field pShip_Postal
	Private m_pShip_Postal

	Public Property Get pShip_Postal()
		If Not IsObject(m_pShip_Postal) Then
			Set m_pShip_Postal = NewFldObj("Orders", "Orders", "x_pShip_Postal", "pShip_Postal", "[pShip_Postal]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set pShip_Postal = m_pShip_Postal
	End Property

	' Field pShip_Country
	Private m_pShip_Country

	Public Property Get pShip_Country()
		If Not IsObject(m_pShip_Country) Then
			Set m_pShip_Country = NewFldObj("Orders", "Orders", "x_pShip_Country", "pShip_Country", "[pShip_Country]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set pShip_Country = m_pShip_Country
	End Property

	' Field Tax
	Private m_Tax

	Public Property Get Tax()
		If Not IsObject(m_Tax) Then
			Set m_Tax = NewFldObj("Orders", "Orders", "x_Tax", "Tax", "[Tax]", 5, 8, "", False, False, "FORMATTED TEXT")
			m_Tax.FldDefaultErrMsg = Language.Phrase("IncorrectFloat")
		End If
		Set Tax = m_Tax
	End Property

	' Field Shipping
	Private m_Shipping

	Public Property Get Shipping()
		If Not IsObject(m_Shipping) Then
			Set m_Shipping = NewFldObj("Orders", "Orders", "x_Shipping", "Shipping", "[Shipping]", 5, 8, "", False, False, "FORMATTED TEXT")
			m_Shipping.FldDefaultErrMsg = Language.Phrase("IncorrectFloat")
		End If
		Set Shipping = m_Shipping
	End Property

	' Field EmailSent
	Private m_EmailSent

	Public Property Get EmailSent()
		If Not IsObject(m_EmailSent) Then
			Set m_EmailSent = NewFldObj("Orders", "Orders", "x_EmailSent", "EmailSent", "[EmailSent]", 202, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set EmailSent = m_EmailSent
	End Property

	' Field EmailDate
	Private m_EmailDate

	Public Property Get EmailDate()
		If Not IsObject(m_EmailDate) Then
			Set m_EmailDate = NewFldObj("Orders", "Orders", "x_EmailDate", "EmailDate", "[EmailDate]", 135, 8, "", False, False, "FORMATTED TEXT")
		End If
		Set EmailDate = m_EmailDate
	End Property
	Dim Fields ' Fields

	' Create new field object
	Private Function NewFldObj(TblVar, TblName, FldVar, FldName, FldExpression, FldType, FldDtFormat, FldVirtualExp, FldVirtual, FldForceSelect, FldViewTag)
		Dim fld
		Set fld = New cField
		fld.TblVar = TblVar
		fld.TblName = TblName
		fld.FldVar = FldVar
		fld.FldName = FldName
		fld.FldExpression = FldExpression
		fld.FldType = FldType
		fld.FldDataType = ew_FieldDataType(FldType)
		fld.FldDateTimeFormat = FldDtFormat
		fld.FldVirtualExpression = FldVirtualExp
		fld.FldIsVirtual = FldVirtual
		fld.FldForceSelection = FldForceSelect
		fld.FldViewTag = FldViewTag
		Set NewFldObj = fld
	End Function

	' Table level events
	' Recordset Selecting event
	Sub Recordset_Selecting(filter)
		If Not EW_DEBUG_ENABLED Then On Error Resume Next

		' Enter your code here	
	End Sub

	' Recordset Selected event
	Sub Recordset_Selected(rs)

		'Response.Write "Recordset Selected"
	End Sub

	' Recordset Search Validated event
	Sub Recordset_SearchValidated()
		If Not EW_DEBUG_ENABLED Then On Error Resume Next

		' Enter your code here
	End Sub

	' Recordset Searching event
	Sub Recordset_Searching(filter)
		If Not EW_DEBUG_ENABLED Then On Error Resume Next

		' Enter your code here	
	End Sub

	' Row_Selecting event
	Sub Row_Selecting(filter)
		If Not EW_DEBUG_ENABLED Then On Error Resume Next

		' Enter your code here	
	End Sub

	' Row Selected event
	Sub Row_Selected(rs)

		'Response.Write "Row Selected"
	End Sub

	' Row Inserting event
	Function Row_Inserting(rsold, rsnew)
		If Not EW_DEBUG_ENABLED Then On Error Resume Next

		' Enter your code here
		' To cancel, set return value to False

		Row_Inserting = True
	End Function

	' Row Inserted event
	Sub Row_Inserted(rsold, rsnew)

		' Response.Write "Row Inserted"
	End Sub

	' Row Updating event
	Function Row_Updating(rsold, rsnew)
		If Not EW_DEBUG_ENABLED Then On Error Resume Next

		' Enter your code here
		' To cancel, set return value to False

		Row_Updating = True
	End Function

	' Row Updated event
	Sub Row_Updated(rsold, rsnew)

		' Response.Write "Row Updated"
	End Sub

	' Row Update Conflict event
	Function Row_UpdateConflict(rsold, rsnew)
		If Not EW_DEBUG_ENABLED Then On Error Resume Next

		' Enter your code here
		' To ignore conflict, set return value to False

		Row_UpdateConflict = True
	End Function

	' Row Deleting event
	Function Row_Deleting(rs)
		If Not EW_DEBUG_ENABLED Then On Error Resume Next

		' Enter your code here
		' To cancel, set return value to False

		Row_Deleting = True
	End Function

	' Row Deleted event
	Sub Row_Deleted(rs)

		' Response.Write "Row Deleted"
	End Sub

	' Email Sending event
	Function Email_Sending(Email, Args)

		'Response.Write Email.AsString
		'Response.Write "Keys of Args: " & Join(Args.Keys, ", ")
		'Response.End

		Email_Sending = True
	End Function

	' Row Rendering event
	Sub Row_Rendering()
		If Not EW_DEBUG_ENABLED Then On Error Resume Next

		' Enter your code here	
	End Sub

	' Row Rendered event
	Sub Row_Rendered()

		' To view properties of field class, use:
		' Response.Write <FieldName>.AsString() 

	End Sub

	' Class terminate
	Private Sub Class_Terminate
		If IsObject(m_OrderId) Then Set m_OrderId = Nothing
		If IsObject(m_CustomerId) Then Set m_CustomerId = Nothing
		If IsObject(m_InvoiceId) Then Set m_InvoiceId = Nothing
		If IsObject(m_Amount) Then Set m_Amount = Nothing
		If IsObject(m_Ship_FirstName) Then Set m_Ship_FirstName = Nothing
		If IsObject(m_Ship_LastName) Then Set m_Ship_LastName = Nothing
		If IsObject(m_Ship_Address) Then Set m_Ship_Address = Nothing
		If IsObject(m_Ship_Address2) Then Set m_Ship_Address2 = Nothing
		If IsObject(m_Ship_City) Then Set m_Ship_City = Nothing
		If IsObject(m_Ship_Province) Then Set m_Ship_Province = Nothing
		If IsObject(m_Ship_Postal) Then Set m_Ship_Postal = Nothing
		If IsObject(m_Ship_Country) Then Set m_Ship_Country = Nothing
		If IsObject(m_Ship_Phone) Then Set m_Ship_Phone = Nothing
		If IsObject(m_Ship_Email) Then Set m_Ship_Email = Nothing
		If IsObject(m_payment_status) Then Set m_payment_status = Nothing
		If IsObject(m_Ordered_Date) Then Set m_Ordered_Date = Nothing
		If IsObject(m_payment_date) Then Set m_payment_date = Nothing
		If IsObject(m_pfirst_name) Then Set m_pfirst_name = Nothing
		If IsObject(m_plast_name) Then Set m_plast_name = Nothing
		If IsObject(m_payer_email) Then Set m_payer_email = Nothing
		If IsObject(m_txn_id) Then Set m_txn_id = Nothing
		If IsObject(m_payment_gross) Then Set m_payment_gross = Nothing
		If IsObject(m_payment_fee) Then Set m_payment_fee = Nothing
		If IsObject(m_payment_type) Then Set m_payment_type = Nothing
		If IsObject(m_txn_type) Then Set m_txn_type = Nothing
		If IsObject(m_receiver_email) Then Set m_receiver_email = Nothing
		If IsObject(m_pShip_Name) Then Set m_pShip_Name = Nothing
		If IsObject(m_pShip_Address) Then Set m_pShip_Address = Nothing
		If IsObject(m_pShip_City) Then Set m_pShip_City = Nothing
		If IsObject(m_pShip_Province) Then Set m_pShip_Province = Nothing
		If IsObject(m_pShip_Postal) Then Set m_pShip_Postal = Nothing
		If IsObject(m_pShip_Country) Then Set m_pShip_Country = Nothing
		If IsObject(m_Tax) Then Set m_Tax = Nothing
		If IsObject(m_Shipping) Then Set m_Shipping = Nothing
		If IsObject(m_EmailSent) Then Set m_EmailSent = Nothing
		If IsObject(m_EmailDate) Then Set m_EmailDate = Nothing
		Set RowAttrs = Nothing
	End Sub
End Class
%>
