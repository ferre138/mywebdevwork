<%
Const EW_PAGE_ID = "list"
Const EW_TABLE_NAME = "Products"
%>
<!--#include file="ewcfg60.asp"-->
<!--#include file="Productsinfo.asp"-->
<!--#include file="Customersinfo.asp"-->
<!--#include file="aspfn60.asp"-->
<!--#include file="userfn60.asp"-->
<%
Response.Expires = 0
Response.ExpiresAbsolute = Now() - 1
Response.AddHeader "pragma", "no-cache"
Response.AddHeader "cache-control", "private, no-cache, no-store, must-revalidate"
%>
<%

' Open connection to the database
Dim conn
Set conn = Server.CreateObject("ADODB.Connection")
conn.Open EW_DB_CONNECTION_STRING
%>

<%

' Common page loading event (in userfn60.asp)
Call Page_Loading()
%>
<%

' Page load event, used in current page
Call Page_Load()
%>
<%
Products.Export = Request.QueryString("export") ' Get export parameter
sExport = Products.Export ' Get export parameter, used in header
sExportFile = Products.TableVar ' Get export file, used in header
%>
<%

' Paging variables
Dim Pager, PagerItem ' Pager
Dim nDisplayRecs ' Number of display records
Dim nRecRange ' Record display range
Dim nStartRec, nStopRec, nTotalRecs
nStartRec = 0 ' Start record index
nStopRec = 0 ' Stop record index
nTotalRecs = 0 ' Total number of records
nDisplayRecs = 20
nRecRange = 10
Dim i
Dim nRecCount
nRecCount = 0 ' Record count
Dim RowCnt, RowIndex, OptionCnt

' Sort
Dim sSortOrder

' Search filters
Dim sSrchAdvanced, sSrchBasic, sSrchWhere, sFilter
sSrchAdvanced = "" ' Advanced search filter
sSrchBasic = "" ' Basic search filter
sSrchWhere = "" ' Search where clause
sFilter = ""
Dim bEditRow, nEditRowCnt ' Edit row

' Master/Detail
Dim sDbMasterFilter, sDbDetailFilter
sDbMasterFilter = "" ' Master filter
sDbDetailFilter = "" ' Detail filter
Dim sSqlMaster
sSqlMaster = "" ' Sql for master record

' Handle reset command
ResetCmd()

' Get basic search criteria
sSrchBasic = BasicSearchWhere()

' Build search criteria
If sSrchAdvanced <> "" Then
	If sSrchWhere <> "" Then sSrchWhere = sSrchWhere & " AND "
	sSrchWhere = sSrchWhere & "(" & sSrchAdvanced & ")"
End If
If sSrchBasic <> "" Then
	If sSrchWhere <> "" Then sSrchWhere = sSrchWhere & " AND "
	sSrchWhere = sSrchWhere & "(" & sSrchBasic & ")"
End If

' Save search criteria
If sSrchWhere <> "" Then
	If sSrchBasic = "" Then Call ResetBasicSearchParms()
	Products.SearchWhere = sSrchWhere ' Save to Session
	nStartRec = 1 ' Reset start record counter
	Products.StartRecordNumber = nStartRec
Else
	Call RestoreSearchParms()
End If

' Build filter
sFilter = ""
If sDbDetailFilter <> "" Then
	If sFilter <> "" Then sFilter = sFilter & " AND "
	sFilter = sFilter & "(" & sDbDetailFilter & ")"
End If
If sSrchWhere <> "" Then
	If sFilter <> "" Then sFilter = sFilter & " AND "
	sFilter = sFilter & "(" & sSrchWhere & ")"
End If

' Set up filter in Session
Products.SessionWhere = sFilter
Products.CurrentFilter = ""

' Set Up Sorting Order
SetUpSortOrder()

' Set Return Url
Products.ReturnUrl = "Productslist.asp"
%>
<!--#include file="header.asp"-->

<script type="text/javascript">
<!--
var EW_PAGE_ID = "list"; // Page id
//-->
</script>
<script type="text/javascript">
<!--
var firstrowoffset = 1; // First data row start at
var lastrowoffset = 0; // Last data row end at
var EW_LIST_TABLE_NAME = 'ewlistmain'; // Table name for list page
var rowclass = 'ewTableRow'; // Row class
var rowaltclass = 'ewTableAltRow'; // Row alternate class
var rowmoverclass = 'ewTableHighlightRow'; // Row mouse over class
var rowselectedclass = 'ewTableSelectRow'; // Row selected class
var roweditclass = 'ewTableEditRow'; // Row edit class
//-->
</script>
<script type="text/javascript">
<!--
var ew_DHTMLEditors = [];
//-->
</script>


<%

' Load recordset
Dim rs
Set rs = LoadRecordset()
nTotalRecs = rs.RecordCount

nStartRec = 1
If nDisplayRecs <= 0 Then ' Display all records
	nDisplayRecs = nTotalRecs
End If
If Not (EW_EXPORT_ALL And Products.Export <> "") Then
	SetUpStartRec() ' Set up start record position
End If
%>


<%
If Session(EW_SESSION_MESSAGE) <> "" Then
%>
<p><span class="ewmsg"><%= Session(EW_SESSION_MESSAGE) %></span></p>
<%
	Session(EW_SESSION_MESSAGE) = "" ' Clear message
End If
%>


<% If nTotalRecs > 0 Then %>
<form action="vslCart.asp" method="post" name="fQProductslist" id="fQProductslist" >
<li class="t"> 
<table width="436" height="134" border="0" cellpadding="0" cellspacing="0" class="ewTableNoBorder" id="ewlistmain">

<%
If (EW_EXPORT_ALL And Products.Export <> "") Then
	nStopRec = nTotalRecs
Else
	nStopRec = nStartRec + nDisplayRecs - 1 ' Set the last record to display
End If

' Move to first record directly for performance reason
nRecCount = nStartRec - 1
If Not rs.Eof Then
	rs.MoveFirst
	rs.Move nStartRec - 1
End If
RowCnt = 0
Do While (Not rs.Eof) And (nRecCount < nStopRec)
	nRecCount = nRecCount + 1
	If CLng(nRecCount) >= CLng(nStartRec) Then
		RowCnt = RowCnt + 1

	' Init row class and style
	Products.CssClass = "ewTableRow"
	Products.CssStyle = ""

	' Init row event
	Products.RowClientEvents = "onmouseover='ew_MouseOver(this);' onmouseout='ew_MouseOut(this);' onclick='ew_Click(this);'"

	' Display alternate color for rows
	If RowCnt Mod 2 = 0 Then
		Products.CssClass = "ewTableAltRow"
	End If
	Call LoadRowValues(rs) ' Load row values
	Products.RowType = EW_ROWTYPE_VIEW ' Render view
	Call RenderRow()
%>

	<tr>


		<!-- Price -->
		<td width="320"<%= Products.Price.CellAttributes %>><b><%= Products.Description.ViewValue %></b><br> <% If Products.Image_Thumb.HrefValue <> "" Then %>
<% If Not IsNull(Products.Image_Thumb.Upload.DbValue) Then %>
<a href="<%= Products.Image_Thumb.HrefValue %>"><img src="products/thumbs/<%= Products.Image_Thumb.ViewValue %>" border="0"></a>
<% End If %>
<% Else %>
<% If Not IsNull(Products.Image_Thumb.Upload.DbValue) Then %>
<img src="products/thumbs/<%= Products.Image_Thumb.ViewValue %>" border="0">
<% End If %>
<% End If %><br>
<%= Products.Sizes.ViewValue %>
</td>
		<!-- Active -->
		<td width="104"<%= Products.Active.CellAttributes %>>
		  <p><strong>Price:</strong> $<%= Products.Price.ViewValue %>
              </p>
		  <p><br>
                <strong>Qty	:</strong>                
                <input name="<%=right("000" & RowCnt,3)%>_Qty" type="text" value="0" size="5">
                <input name="ItemId<%=right("000" & RowCnt,3)%>" type="hidden" value="<%=Products.ItemId.ViewValue%>">
                <input name="<%=right("000" & RowCnt,3)%>_Desc" type="hidden" value="<%=Products.Description.ViewValue%>">
    
                </p></td>
		<!-- Image -->
		<!-- Sizes -->
		<!-- Image_Thumb -->
		</tr>
	<tr>
	  <td height="5" colspan="2" bgcolor="#666666"></td>
  </tr>
<%
	End If
	rs.MoveNext
Loop
%>
</table>
<input name="Add to cart" type="image" class="InputNoBorder" value="Add to cart" src="images/addtocart.gif" align="right">
 </li>
	  </form>
<% End If %>

<%

' Close recordset and connection
rs.Close
Set rs = Nothing
%>


<!--#include file="footer.asp"-->

<%

' If control is passed here, simply terminate the page without redirect
Call Page_Terminate("")

' -----------------------------------------------------------------
'  Subroutine Page_Terminate
'  - called when exit page
'  - clean up ADO connection and objects
'  - if url specified, redirect to url, otherwise end response
'
Sub Page_Terminate(url)

	' Page unload event, used in current page
	Call Page_Unload()

	' Global page unloaded event (in userfn60.asp)
	Call Page_Unloaded()
	conn.Close ' Close Connection
	Set conn = Nothing
	Set Security = Nothing
	Set Products = Nothing

	' Go to url if specified
	If url <> "" Then
		Response.Clear
		Response.Redirect url
	End If

	' Terminate response
	Response.End
End Sub

'
'  Subroutine Page_Terminate (End)
' ----------------------------------------

%>
<%

' Return Basic Search sql
Function BasicSearchSQL(Keyword)
	Dim sKeyword
	sKeyword = ew_AdjustSql(Keyword)
	BasicSearchSQL = ""
	BasicSearchSQL = BasicSearchSQL & "[Description] LIKE '%" & sKeyword & "%' OR "
	BasicSearchSQL = BasicSearchSQL & "[Price] LIKE '%" & sKeyword & "%' OR "
	If Right(BasicSearchSQL, 4) = " OR " Then BasicSearchSQL = Left(BasicSearchSQL, Len(BasicSearchSQL)-4)
End Function

' Return Basic Search Where based on search keyword and type
Function BasicSearchWhere()
	Dim sSearchStr, sSearchKeyword, sSearchType
	Dim sSearch, arKeyword, sKeyword
	sSearchStr = ""
	sSearchKeyword = Request.QueryString(EW_TABLE_BASIC_SEARCH)
	sSearchType = Request.QueryString(EW_TABLE_BASIC_SEARCH_TYPE)
	If sSearchKeyword <> "" Then
		sSearch = Trim(sSearchKeyword)
		If sSearchType <> "" Then
			While InStr(sSearch, "  ") > 0
				sSearch = Replace(sSearch, "  ", " ")
			Wend
			arKeyword = Split(Trim(sSearch), " ")
			For Each sKeyword In arKeyword
				If sSearchStr <> "" Then sSearchStr = sSearchStr & " " & sSearchType & " "
				sSearchStr = sSearchStr & "(" & BasicSearchSQL(sKeyword) & ")"
			Next
		Else
			sSearchStr = BasicSearchSQL(sSearch)
		End If
	End If
	If sSearchKeyword <> "" then
		Products.BasicSearchKeyword = sSearchKeyword
		Products.BasicSearchType = sSearchType
	End If
	BasicSearchWhere = sSearchStr
End Function

' Clear all search parameters
Sub ResetSearchParms()

	' Clear search where
	sSrchWhere = ""
	Products.SearchWhere = sSrchWhere

	' Clear basic search parameters
	Call ResetBasicSearchParms()
End Sub

' Clear all basic search parameters
Sub ResetBasicSearchParms()

	' Clear basic search parameters
	Products.BasicSearchKeyword = ""
	Products.BasicSearchType = ""
End Sub

' Restore all search parameters
Sub RestoreSearchParms()
	sSrchWhere = Products.SearchWhere
End Sub

' Set up Sort parameters based on Sort Links clicked
Sub SetUpSortOrder()
	Dim sOrderBy
	Dim sSortField, sLastSort, sThisSort
	Dim bCtrl

	' Check for an Order parameter
	If Request.QueryString("order").Count > 0 Then
		Products.CurrentOrder = Request.QueryString("order")
		Products.CurrentOrderType = Request.QueryString("ordertype")

		' Field ItemId
		Call Products.UpdateSort(Products.ItemId)

		' Field Description
		Call Products.UpdateSort(Products.Description)

		' Field Price
		Call Products.UpdateSort(Products.Price)

		' Field Active
		Call Products.UpdateSort(Products.Active)
		Products.StartRecordNumber = 1 ' Reset start position
	End If
	sOrderBy = Products.SessionOrderBy ' Get order by from Session
	If sOrderBy = "" Then
		If Products.SqlOrderBy <> "" Then
			sOrderBy = Products.SqlOrderBy
			Products.SessionOrderBy = sOrderBy
		End If
	End If
End Sub

' Reset command based on querystring parameter cmd=
' - RESET: reset search parameters
' - RESETALL: reset search & master/detail parameters
' - RESETSORT: reset sort parameters
Sub ResetCmd()
	Dim sCmd

	' Get reset cmd
	If Request.QueryString("cmd").Count > 0 Then
		sCmd = Request.QueryString("cmd")

		' Reset search criteria
		If LCase(sCmd) = "reset" Or LCase(sCmd) = "resetall" Then
			Call ResetSearchParms()
		End If

		' Reset Sort Criteria
		If LCase(sCmd) = "resetsort" Then
			Dim sOrderBy
			sOrderBy = ""
			Products.SessionOrderBy = sOrderBy
			Products.ItemId.Sort = ""
			Products.Description.Sort = ""
			Products.Price.Sort = ""
			Products.Active.Sort = ""
		End If

		' Reset start position
		nStartRec = 1
		Products.StartRecordNumber = nStartRec
	End If
End Sub
%>
<%

' Set up Starting Record parameters based on Pager Navigation
Sub SetUpStartRec()
	Dim nPageNo

	' Exit if nDisplayRecs = 0
	If nDisplayRecs = 0 Then Exit Sub

	' Check for a START parameter
	If Request.QueryString(EW_TABLE_START_REC).Count > 0 Then
		nStartRec = Request.QueryString(EW_TABLE_START_REC)
		Products.StartRecordNumber = nStartRec
	ElseIf Request.QueryString(EW_TABLE_PAGE_NO).Count > 0 Then
		nPageNo = Request.QueryString(EW_TABLE_PAGE_NO)
		If IsNumeric(nPageNo) Then
			nStartRec = (nPageNo-1)*nDisplayRecs+1
			If nStartRec <= 0 Then
				nStartRec = 1
			ElseIf nStartRec >= ((nTotalRecs-1)\nDisplayRecs)*nDisplayRecs+1 Then
				nStartRec = ((nTotalRecs-1)\nDisplayRecs)*nDisplayRecs+1
			End If
			Products.StartRecordNumber = nStartRec
		Else
			nStartRec = Products.StartRecordNumber
		End If
	Else
		nStartRec = Products.StartRecordNumber
	End If

	' Check if correct start record counter
	If Not IsNumeric(nStartRec) Or nStartRec = "" Then ' Avoid invalid start record counter
		nStartRec = 1 ' Reset start record counter
		Products.StartRecordNumber = nStartRec
	ElseIf CLng(nStartRec) > CLng(nTotalRecs) Then ' Avoid starting record > total records
		nStartRec = ((nTotalRecs-1)\nDisplayRecs)*nDisplayRecs+1 ' Point to last page first record
		Products.StartRecordNumber = nStartRec
	ElseIf (nStartRec-1) Mod nDisplayRecs <> 0 Then
		nStartRec = ((nStartRec-1)\nDisplayRecs)*nDisplayRecs+1 ' Point to page boundary
		Products.StartRecordNumber = nStartRec
	End If
End Sub
%>
<%

' Load recordset
Function LoadRecordset()

	' Call Recordset Selecting event
	Call Products.Recordset_Selecting(Products.CurrentFilter)

	' Load list page sql
	Dim sSql
	sSql = Products.ListSQL

	' Response.Write sSql ' Uncomment to show SQL for debugging
	' Load recordset

	Dim rs
	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.CursorLocation = EW_CURSORLOCATION
	rs.Open sSql, conn, 1, 2

	' Call Recordset Selected event
	Call Products.Recordset_Selected(rs)
	Set LoadRecordset = rs
End Function
%>
<%

' Load row based on key values
Function LoadRow()
	Dim rs, sSql, sFilter
	sFilter = Products.SqlKeyFilter
	If Not IsNumeric(Products.ItemId.CurrentValue) Then
		LoadRow = False ' Invalid key, exit
		Exit Function
	End If
	sFilter = Replace(sFilter, "@ItemId@", ew_AdjustSql(Products.ItemId.CurrentValue)) ' Replace key value

	' Call Row Selecting event
	Call Products.Row_Selecting(sFilter)

	' Load sql based on filter
	Products.CurrentFilter = sFilter
	sSql = Products.SQL
	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.Open sSql, conn
	If rs.Eof Then
		LoadRow = False
	Else
		LoadRow = True
		rs.MoveFirst
		Call LoadRowValues(rs) ' Load row values

		' Call Row Selected event
		Call Products.Row_Selected(rs)
	End If
	rs.Close
	Set rs = Nothing
End Function

' Load row values from recordset
Sub LoadRowValues(rs)
	Products.ItemId.DbValue = rs("ItemId")
	Products.Description.DbValue = rs("Description")
	Products.Price.DbValue = rs("Price")
	Products.Active.DbValue = ew_IIf(rs("Active"), "1", "0")
	Products.Image.Upload.DbValue = rs("Image")
	Products.Sizes.DbValue = rs("Sizes")
	Products.Image_Thumb.Upload.DbValue = rs("Image_Thumb")
End Sub
%>
<%

' Render row values based on field settings
Sub RenderRow()

	' Call Row Rendering event
	Call Products.Row_Rendering()

	' Common render codes for all row types
	' ItemId

	Products.ItemId.CellCssStyle = ""
	Products.ItemId.CellCssClass = ""

	' Description
	Products.Description.CellCssStyle = ""
	Products.Description.CellCssClass = ""

	' Price
	Products.Price.CellCssStyle = ""
	Products.Price.CellCssClass = ""

	' Active
	Products.Active.CellCssStyle = ""
	Products.Active.CellCssClass = ""

	' Image
	Products.Image.CellCssStyle = ""
	Products.Image.CellCssClass = ""

	' Sizes
	Products.Sizes.CellCssStyle = ""
	Products.Sizes.CellCssClass = ""

	' Image_Thumb
	Products.Image_Thumb.CellCssStyle = ""
	Products.Image_Thumb.CellCssClass = ""
	If Products.RowType = EW_ROWTYPE_VIEW Then ' View row

		' ItemId
		Products.ItemId.ViewValue = Products.ItemId.CurrentValue
		Products.ItemId.CssStyle = ""
		Products.ItemId.CssClass = ""
		Products.ItemId.ViewCustomAttributes = ""

		' Description
		Products.Description.ViewValue = Products.Description.CurrentValue
		Products.Description.CssStyle = ""
		Products.Description.CssClass = ""
		Products.Description.ViewCustomAttributes = ""

		' Price
		Products.Price.ViewValue = Products.Price.CurrentValue
		Products.Price.CssStyle = ""
		Products.Price.CssClass = ""
		Products.Price.ViewCustomAttributes = ""

		' Active
		If Products.Active.CurrentValue = "1" Then
			Products.Active.ViewValue = "Yes"
		Else
			Products.Active.ViewValue = "No"
		End If
		Products.Active.CssStyle = ""
		Products.Active.CssClass = ""
		Products.Active.ViewCustomAttributes = ""

		' Image
		If Not IsNull(Products.Image.Upload.DbValue) Then
			Products.Image.ViewValue = Products.Image.Upload.DbValue
		Else
			Products.Image.ViewValue = ""
		End If
		Products.Image.CssStyle = ""
		Products.Image.CssClass = ""
		Products.Image.ViewCustomAttributes = ""

		' Sizes
		Products.Sizes.ViewValue = Products.Sizes.CurrentValue
		Products.Sizes.CssStyle = ""
		Products.Sizes.CssClass = ""
		Products.Sizes.ViewCustomAttributes = ""

		' Image_Thumb
		If Not IsNull(Products.Image_Thumb.Upload.DbValue) Then
			Products.Image_Thumb.ViewValue = Products.Image_Thumb.Upload.DbValue
		Else
			Products.Image_Thumb.ViewValue = ""
		End If
		Products.Image_Thumb.CssStyle = ""
		Products.Image_Thumb.CssClass = ""
		Products.Image_Thumb.ViewCustomAttributes = ""

		' ItemId
		Products.ItemId.HrefValue = ""

		' Description
		Products.Description.HrefValue = ""

		' Price
		Products.Price.HrefValue = ""

		' Active
		Products.Active.HrefValue = ""

		' Image
		If Not IsNull(Products.Image.Upload.DbValue) Then
			Products.Image.HrefValue = ew_UploadPathEx(False, "vsl/Products/") & ew_IIf(Products.Image.ViewValue<>"", Products.Image.ViewValue, Products.Image.CurrentValue)
			If Products.Export <> "" Then Products.Image.HrefValue = ew_ConvertFullUrl(Products.Image.HrefValue)
		Else
			Products.Image.HrefValue = ""
		End If

		' Sizes
		Products.Sizes.HrefValue = ""

		' Image_Thumb
		If Not IsNull(Products.Image_Thumb.Upload.DbValue) Then
			Products.Image_Thumb.HrefValue = ew_UploadPathEx(False, "vsl/Products/thumbs/") & ew_IIf(Products.Image_Thumb.ViewValue<>"", Products.Image_Thumb.ViewValue, Products.Image_Thumb.CurrentValue)
			If Products.Export <> "" Then Products.Image_Thumb.HrefValue = ew_ConvertFullUrl(Products.Image_Thumb.HrefValue)
		Else
			Products.Image_Thumb.HrefValue = ""
		End If
	ElseIf Products.RowType = EW_ROWTYPE_ADD Then ' Add row
	ElseIf Products.RowType = EW_ROWTYPE_EDIT Then ' Edit row
	ElseIf Products.RowType = EW_ROWTYPE_SEARCH Then ' Search row
	End If

	' Call Row Rendered event
	Call Products.Row_Rendered()
End Sub
%>
<%

' Page Load event
Sub Page_Load()

'***Response.Write "Page Load"
End Sub

' Page Unload event
Sub Page_Unload()

'***Response.Write "Page Unload"
End Sub
%>