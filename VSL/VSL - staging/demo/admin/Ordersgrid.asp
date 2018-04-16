<% Session.Timeout = 20 %>
<%

' Define page object
Dim Orders_grid
Set Orders_grid = New cOrders_grid
Set MasterPage = Page
Set Page = Orders_grid

' Page init processing
Call Orders_grid.Page_Init()

' Page main processing
Call Orders_grid.Page_Main()
%>
<% If Orders.Export = "" Then %>
<script type="text/javascript">
<!--
// Create page object
var Orders_grid = new ew_Page("Orders_grid");
// page properties
Orders_grid.PageID = "grid"; // page ID
Orders_grid.FormID = "fOrdersgrid"; // form ID
var EW_PAGE_ID = Orders_grid.PageID; // for backward compatibility
// extend page with ValidateForm function
Orders_grid.ValidateForm = function(fobj) {
	ew_PostAutoSuggest(fobj);
	if (!this.ValidateRequired)
		return true; // ignore validation
	if (fobj.a_confirm && fobj.a_confirm.value == "F")
		return true;
	var i, elm, aelm, infix;
	var rowcnt = (fobj.key_count) ? Number(fobj.key_count.value) : 1;
	var addcnt = 0;
	for (i=0; i<rowcnt; i++) {
		infix = (fobj.key_count) ? String(i+1) : "";
		var chkthisrow = true;
		if (fobj.a_list && fobj.a_list.value == "gridinsert")
			chkthisrow = !(this.EmptyRow(fobj, infix));
		else
			chkthisrow = true;
		if (chkthisrow) {
			addcnt += 1;
		elm = fobj.elements["x" + infix + "_Amount"];
		if (elm && !ew_CheckNumber(elm.value))
			return ew_OnError(this, elm, "<%= ew_JsEncode2(Orders.Amount.FldErrMsg) %>");
		elm = fobj.elements["x" + infix + "_payment_gross"];
		if (elm && !ew_CheckNumber(elm.value))
			return ew_OnError(this, elm, "<%= ew_JsEncode2(Orders.payment_gross.FldErrMsg) %>");
		elm = fobj.elements["x" + infix + "_payment_fee"];
		if (elm && !ew_CheckNumber(elm.value))
			return ew_OnError(this, elm, "<%= ew_JsEncode2(Orders.payment_fee.FldErrMsg) %>");
		elm = fobj.elements["x" + infix + "_Tax"];
		if (elm && !ew_CheckNumber(elm.value))
			return ew_OnError(this, elm, "<%= ew_JsEncode2(Orders.Tax.FldErrMsg) %>");
		elm = fobj.elements["x" + infix + "_Shipping"];
		if (elm && !ew_CheckNumber(elm.value))
			return ew_OnError(this, elm, "<%= ew_JsEncode2(Orders.Shipping.FldErrMsg) %>");
		// Set up row object
		var row = {};
		row["index"] = infix;
		for (var j = 0; j < fobj.elements.length; j++) {
			var el = fobj.elements[j];
			var len = infix.length + 2;
			if (el.name.substr(0, len) == "x" + infix + "_") {
				var elname = "x_" + el.name.substr(len);
				if (ewLang.isObject(row[elname])) { // already exists
					if (ewLang.isArray(row[elname])) {
						row[elname][row[elname].length] = el; // add to array
					} else {
						row[elname] = [row[elname], el]; // convert to array
					}
				} else {
					row[elname] = el;
				}
			}
		}
		fobj.row = row;
		// Call Form Custom Validate event
		if (!this.Form_CustomValidate(fobj)) return false;
		} // End Grid Add checking
	}
	return true;
}
// Extend page with empty row check
Orders_grid.EmptyRow = function(fobj, infix) {
	if (ew_ValueChanged(fobj, infix, "CustomerId")) return false;
	if (ew_ValueChanged(fobj, infix, "Amount")) return false;
	if (ew_ValueChanged(fobj, infix, "Ship_FirstName")) return false;
	if (ew_ValueChanged(fobj, infix, "Ship_LastName")) return false;
	if (ew_ValueChanged(fobj, infix, "payment_status")) return false;
	if (ew_ValueChanged(fobj, infix, "Ordered_Date")) return false;
	if (ew_ValueChanged(fobj, infix, "payer_email")) return false;
	if (ew_ValueChanged(fobj, infix, "payment_gross")) return false;
	if (ew_ValueChanged(fobj, infix, "payment_fee")) return false;
	if (ew_ValueChanged(fobj, infix, "Tax")) return false;
	if (ew_ValueChanged(fobj, infix, "Shipping")) return false;
	if (ew_ValueChanged(fobj, infix, "EmailSent")) return false;
	if (ew_ValueChanged(fobj, infix, "EmailDate")) return false;
	if (ew_ValueChanged(fobj, infix, "PromoCodeUsed")) return false;
	return true;
}
// extend page with Form_CustomValidate function
Orders_grid.Form_CustomValidate =  
 function(fobj) { // DO NOT CHANGE THIS LINE!
 	// Your custom validation code here, return false if invalid. 
 	return true;
 }
Orders_grid.SelectAllKey = function(elem) {
	ew_SelectAll(elem);
}
<% If EW_CLIENT_VALIDATE Then %>
Orders_grid.ValidateRequired = true; // uses JavaScript validation
<% Else %>
Orders_grid.ValidateRequired = false; // no JavaScript validation
<% End If %>
//-->
</script>
<link rel="stylesheet" type="text/css" media="all" href="calendar/calendar-win2k-cold-1.css" title="win2k-1">
<script type="text/javascript" src="calendar/calendar.js"></script>
<script type="text/javascript" src="calendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="calendar/calendar-setup.js"></script>
<% End If %>
<% Orders_grid.ShowPageHeader() %>
<%
If Orders.CurrentAction = "gridadd" Then
	If Orders.CurrentMode <> "copy" Then Orders.CurrentFilter = "0=1"
End If

' Load recordset
Set Orders_grid.Recordset = Orders_grid.LoadRecordset()
If Orders.CurrentAction = "gridadd" Then
	If Orders.CurrentMode = "copy" Then
		Orders_grid.TotalRecs = Orders_grid.Recordset.RecordCount
		Orders_grid.StartRec = 1
		Orders_grid.DisplayRecs = Orders_grid.TotalRecs
	Else
		Orders_grid.StartRec = 1
		Orders_grid.DisplayRecs = Orders.GridAddRowCount
	End If
	Orders_grid.TotalRecs = Orders_grid.DisplayRecs
	Orders_grid.StopRec = Orders_grid.DisplayRecs
Else
	Orders_grid.TotalRecs = Orders_grid.Recordset.RecordCount
	Orders_grid.StartRec = 1
	Orders_grid.DisplayRecs = Orders_grid.TotalRecs ' Display all records
End If
%>
<p class="aspmaker ewTitle" style="white-space: nowrap;"><% If Orders.CurrentMode = "add" Or Orders.CurrentMode = "copy" Then %><%= Language.Phrase("Add") %><% ElseIf Orders.CurrentMode = "edit" Then %><%= Language.Phrase("Edit") %><% End If %>&nbsp;<%= Language.Phrase("TblTypeTABLE") %><%= Orders.TableCaption %></p>
</p>
<% Orders_grid.ShowMessage %>
<br>
<table cellspacing="0" class="ewGrid"><tr><td class="ewGridContent">
<% If (Orders.CurrentMode = "add" Or Orders.CurrentMode = "copy" Or Orders.CurrentMode = "edit") And Orders.CurrentAction <> "F" Then ' add/copy/edit mode %>
<div class="ewGridUpperPanel">
<% If Orders.AllowAddDeleteRow Then %>
<% If Security.IsLoggedIn() Then %>
<span class="aspmaker">
<a href="javascript:void(0);" onclick="ew_AddGridRow(this);"><img src='images/addblankrow.gif' alt='<%= ew_HtmlEncode(Language.Phrase("AddBlankRow")) %>' title='<%= ew_HtmlEncode(Language.Phrase("AddBlankRow")) %>' width='16' height='16' border='0'></a>&nbsp;&nbsp;
</span>
<% End If %>
<% End If %>
</div>
<% End If %>
<div id="gmp_Orders" class="ewGridMiddlePanel">
<table cellspacing="0" data-rowhighlightclass="ewTableHighlightRow" data-rowselectclass="ewTableSelectRow" data-roweditclass="ewTableEditRow" class="ewTable ewTableSeparate">
<%= Orders.TableCustomInnerHTML %>
<thead><!-- Table header -->
	<tr class="ewTableHeader">
<%
Call Orders_grid.RenderListOptions()

' Render list options (header, left)
Orders_grid.ListOptions.Render "header", "left"
%>
<% If Orders.OrderId.Visible Then ' OrderId %>
	<% If Orders.SortUrl(Orders.OrderId) = "" Then %>
		<td><%= Orders.OrderId.FldCaption %></td>
	<% Else %>
		<td><div>
			<table cellspacing="0" class="ewTableHeaderBtn"><thead><tr><td><%= Orders.OrderId.FldCaption %></td><td style="width: 10px;"><% If Orders.OrderId.Sort = "ASC" Then %><img src="images/sortup.gif" width="10" height="9" border="0"><% ElseIf Orders.OrderId.Sort = "DESC" Then %><img src="images/sortdown.gif" width="10" height="9" border="0"><% End If %></td></tr></thead></table>
		</div></td>
	<% End If %>
<% End If %>		
<% If Orders.CustomerId.Visible Then ' CustomerId %>
	<% If Orders.SortUrl(Orders.CustomerId) = "" Then %>
		<td><%= Orders.CustomerId.FldCaption %></td>
	<% Else %>
		<td><div>
			<table cellspacing="0" class="ewTableHeaderBtn"><thead><tr><td><%= Orders.CustomerId.FldCaption %></td><td style="width: 10px;"><% If Orders.CustomerId.Sort = "ASC" Then %><img src="images/sortup.gif" width="10" height="9" border="0"><% ElseIf Orders.CustomerId.Sort = "DESC" Then %><img src="images/sortdown.gif" width="10" height="9" border="0"><% End If %></td></tr></thead></table>
		</div></td>
	<% End If %>
<% End If %>		
<% If Orders.Amount.Visible Then ' Amount %>
	<% If Orders.SortUrl(Orders.Amount) = "" Then %>
		<td><%= Orders.Amount.FldCaption %></td>
	<% Else %>
		<td><div>
			<table cellspacing="0" class="ewTableHeaderBtn"><thead><tr><td><%= Orders.Amount.FldCaption %></td><td style="width: 10px;"><% If Orders.Amount.Sort = "ASC" Then %><img src="images/sortup.gif" width="10" height="9" border="0"><% ElseIf Orders.Amount.Sort = "DESC" Then %><img src="images/sortdown.gif" width="10" height="9" border="0"><% End If %></td></tr></thead></table>
		</div></td>
	<% End If %>
<% End If %>		
<% If Orders.Ship_FirstName.Visible Then ' Ship_FirstName %>
	<% If Orders.SortUrl(Orders.Ship_FirstName) = "" Then %>
		<td><%= Orders.Ship_FirstName.FldCaption %></td>
	<% Else %>
		<td><div>
			<table cellspacing="0" class="ewTableHeaderBtn"><thead><tr><td><%= Orders.Ship_FirstName.FldCaption %></td><td style="width: 10px;"><% If Orders.Ship_FirstName.Sort = "ASC" Then %><img src="images/sortup.gif" width="10" height="9" border="0"><% ElseIf Orders.Ship_FirstName.Sort = "DESC" Then %><img src="images/sortdown.gif" width="10" height="9" border="0"><% End If %></td></tr></thead></table>
		</div></td>
	<% End If %>
<% End If %>		
<% If Orders.Ship_LastName.Visible Then ' Ship_LastName %>
	<% If Orders.SortUrl(Orders.Ship_LastName) = "" Then %>
		<td><%= Orders.Ship_LastName.FldCaption %></td>
	<% Else %>
		<td><div>
			<table cellspacing="0" class="ewTableHeaderBtn"><thead><tr><td><%= Orders.Ship_LastName.FldCaption %></td><td style="width: 10px;"><% If Orders.Ship_LastName.Sort = "ASC" Then %><img src="images/sortup.gif" width="10" height="9" border="0"><% ElseIf Orders.Ship_LastName.Sort = "DESC" Then %><img src="images/sortdown.gif" width="10" height="9" border="0"><% End If %></td></tr></thead></table>
		</div></td>
	<% End If %>
<% End If %>		
<% If Orders.payment_status.Visible Then ' payment_status %>
	<% If Orders.SortUrl(Orders.payment_status) = "" Then %>
		<td><%= Orders.payment_status.FldCaption %></td>
	<% Else %>
		<td><div>
			<table cellspacing="0" class="ewTableHeaderBtn"><thead><tr><td><%= Orders.payment_status.FldCaption %></td><td style="width: 10px;"><% If Orders.payment_status.Sort = "ASC" Then %><img src="images/sortup.gif" width="10" height="9" border="0"><% ElseIf Orders.payment_status.Sort = "DESC" Then %><img src="images/sortdown.gif" width="10" height="9" border="0"><% End If %></td></tr></thead></table>
		</div></td>
	<% End If %>
<% End If %>		
<% If Orders.Ordered_Date.Visible Then ' Ordered_Date %>
	<% If Orders.SortUrl(Orders.Ordered_Date) = "" Then %>
		<td><%= Orders.Ordered_Date.FldCaption %></td>
	<% Else %>
		<td><div>
			<table cellspacing="0" class="ewTableHeaderBtn"><thead><tr><td><%= Orders.Ordered_Date.FldCaption %></td><td style="width: 10px;"><% If Orders.Ordered_Date.Sort = "ASC" Then %><img src="images/sortup.gif" width="10" height="9" border="0"><% ElseIf Orders.Ordered_Date.Sort = "DESC" Then %><img src="images/sortdown.gif" width="10" height="9" border="0"><% End If %></td></tr></thead></table>
		</div></td>
	<% End If %>
<% End If %>		
<% If Orders.payer_email.Visible Then ' payer_email %>
	<% If Orders.SortUrl(Orders.payer_email) = "" Then %>
		<td><%= Orders.payer_email.FldCaption %></td>
	<% Else %>
		<td><div>
			<table cellspacing="0" class="ewTableHeaderBtn"><thead><tr><td><%= Orders.payer_email.FldCaption %></td><td style="width: 10px;"><% If Orders.payer_email.Sort = "ASC" Then %><img src="images/sortup.gif" width="10" height="9" border="0"><% ElseIf Orders.payer_email.Sort = "DESC" Then %><img src="images/sortdown.gif" width="10" height="9" border="0"><% End If %></td></tr></thead></table>
		</div></td>
	<% End If %>
<% End If %>		
<% If Orders.payment_gross.Visible Then ' payment_gross %>
	<% If Orders.SortUrl(Orders.payment_gross) = "" Then %>
		<td><%= Orders.payment_gross.FldCaption %></td>
	<% Else %>
		<td><div>
			<table cellspacing="0" class="ewTableHeaderBtn"><thead><tr><td><%= Orders.payment_gross.FldCaption %></td><td style="width: 10px;"><% If Orders.payment_gross.Sort = "ASC" Then %><img src="images/sortup.gif" width="10" height="9" border="0"><% ElseIf Orders.payment_gross.Sort = "DESC" Then %><img src="images/sortdown.gif" width="10" height="9" border="0"><% End If %></td></tr></thead></table>
		</div></td>
	<% End If %>
<% End If %>		
<% If Orders.payment_fee.Visible Then ' payment_fee %>
	<% If Orders.SortUrl(Orders.payment_fee) = "" Then %>
		<td><%= Orders.payment_fee.FldCaption %></td>
	<% Else %>
		<td><div>
			<table cellspacing="0" class="ewTableHeaderBtn"><thead><tr><td><%= Orders.payment_fee.FldCaption %></td><td style="width: 10px;"><% If Orders.payment_fee.Sort = "ASC" Then %><img src="images/sortup.gif" width="10" height="9" border="0"><% ElseIf Orders.payment_fee.Sort = "DESC" Then %><img src="images/sortdown.gif" width="10" height="9" border="0"><% End If %></td></tr></thead></table>
		</div></td>
	<% End If %>
<% End If %>		
<% If Orders.Tax.Visible Then ' Tax %>
	<% If Orders.SortUrl(Orders.Tax) = "" Then %>
		<td><%= Orders.Tax.FldCaption %></td>
	<% Else %>
		<td><div>
			<table cellspacing="0" class="ewTableHeaderBtn"><thead><tr><td><%= Orders.Tax.FldCaption %></td><td style="width: 10px;"><% If Orders.Tax.Sort = "ASC" Then %><img src="images/sortup.gif" width="10" height="9" border="0"><% ElseIf Orders.Tax.Sort = "DESC" Then %><img src="images/sortdown.gif" width="10" height="9" border="0"><% End If %></td></tr></thead></table>
		</div></td>
	<% End If %>
<% End If %>		
<% If Orders.Shipping.Visible Then ' Shipping %>
	<% If Orders.SortUrl(Orders.Shipping) = "" Then %>
		<td><%= Orders.Shipping.FldCaption %></td>
	<% Else %>
		<td><div>
			<table cellspacing="0" class="ewTableHeaderBtn"><thead><tr><td><%= Orders.Shipping.FldCaption %></td><td style="width: 10px;"><% If Orders.Shipping.Sort = "ASC" Then %><img src="images/sortup.gif" width="10" height="9" border="0"><% ElseIf Orders.Shipping.Sort = "DESC" Then %><img src="images/sortdown.gif" width="10" height="9" border="0"><% End If %></td></tr></thead></table>
		</div></td>
	<% End If %>
<% End If %>		
<% If Orders.EmailSent.Visible Then ' EmailSent %>
	<% If Orders.SortUrl(Orders.EmailSent) = "" Then %>
		<td><%= Orders.EmailSent.FldCaption %></td>
	<% Else %>
		<td><div>
			<table cellspacing="0" class="ewTableHeaderBtn"><thead><tr><td><%= Orders.EmailSent.FldCaption %></td><td style="width: 10px;"><% If Orders.EmailSent.Sort = "ASC" Then %><img src="images/sortup.gif" width="10" height="9" border="0"><% ElseIf Orders.EmailSent.Sort = "DESC" Then %><img src="images/sortdown.gif" width="10" height="9" border="0"><% End If %></td></tr></thead></table>
		</div></td>
	<% End If %>
<% End If %>		
<% If Orders.EmailDate.Visible Then ' EmailDate %>
	<% If Orders.SortUrl(Orders.EmailDate) = "" Then %>
		<td><%= Orders.EmailDate.FldCaption %></td>
	<% Else %>
		<td><div>
			<table cellspacing="0" class="ewTableHeaderBtn"><thead><tr><td><%= Orders.EmailDate.FldCaption %></td><td style="width: 10px;"><% If Orders.EmailDate.Sort = "ASC" Then %><img src="images/sortup.gif" width="10" height="9" border="0"><% ElseIf Orders.EmailDate.Sort = "DESC" Then %><img src="images/sortdown.gif" width="10" height="9" border="0"><% End If %></td></tr></thead></table>
		</div></td>
	<% End If %>
<% End If %>		
<% If Orders.PromoCodeUsed.Visible Then ' PromoCodeUsed %>
	<% If Orders.SortUrl(Orders.PromoCodeUsed) = "" Then %>
		<td><%= Orders.PromoCodeUsed.FldCaption %></td>
	<% Else %>
		<td><div>
			<table cellspacing="0" class="ewTableHeaderBtn"><thead><tr><td><%= Orders.PromoCodeUsed.FldCaption %></td><td style="width: 10px;"><% If Orders.PromoCodeUsed.Sort = "ASC" Then %><img src="images/sortup.gif" width="10" height="9" border="0"><% ElseIf Orders.PromoCodeUsed.Sort = "DESC" Then %><img src="images/sortdown.gif" width="10" height="9" border="0"><% End If %></td></tr></thead></table>
		</div></td>
	<% End If %>
<% End If %>		
<%

' Render list options (header, right)
Orders_grid.ListOptions.Render "header", "right"
%>
	</tr>
</thead>
<tbody><!-- Table body -->
<%
Orders_grid.StartRec = 1
Orders_grid.StopRec = Orders_grid.TotalRecs ' Show all records

' Restore number of post back records
If IsObject(ObjForm) And Not (ObjForm Is Nothing) Then
	ObjForm.Index = 0
	If ObjForm.HasValue("key_count") And (Orders.CurrentAction = "gridadd" Or Orders.CurrentAction = "gridedit" Or Orders.CurrentAction = "F") Then
		Orders_grid.KeyCount = ObjForm.GetValue("key_count")
		Orders_grid.StopRec = Orders_grid.KeyCount
	End If
End If

' Move to first record
Orders_grid.RecCnt = Orders_grid.StartRec - 1
If Not Orders_grid.Recordset.Eof Then
	Orders_grid.Recordset.MoveFirst
	If Orders_grid.StartRec > 1 Then Orders_grid.Recordset.Move Orders_grid.StartRec - 1
ElseIf Not Orders.AllowAddDeleteRow And Orders_grid.StopRec = 0 Then
	Orders_grid.StopRec = Orders.GridAddRowCount
End If

' Initialize Aggregate
Orders.RowType = EW_ROWTYPE_AGGREGATEINIT
Call Orders.ResetAttrs()
Call Orders_grid.RenderRow()
Orders_grid.RowCnt = 0
If Orders.CurrentAction = "gridadd" Then Orders_grid.RowIndex = 0
If Orders.CurrentAction = "gridedit" Then Orders_grid.RowIndex = 0

' Output date rows
Do While CLng(Orders_grid.RecCnt) < CLng(Orders_grid.StopRec)
	Orders_grid.RecCnt = Orders_grid.RecCnt + 1
	If CLng(Orders_grid.RecCnt) >= CLng(Orders_grid.StartRec) Then
		Orders_grid.RowCnt = Orders_grid.RowCnt + 1
		If Orders.CurrentAction = "gridadd" Or Orders.CurrentAction = "gridedit" Or Orders.CurrentAction = "F" Then
			Orders_grid.RowIndex = Orders_grid.RowIndex + 1
			ObjForm.Index = Orders_grid.RowIndex
			If ObjForm.HasValue("k_action") Then
				Orders_grid.RowAction = ObjForm.GetValue("k_action") & ""
			ElseIf Orders.CurrentAction = "gridadd" Then
				Orders_grid.RowAction = "insert"
			Else
				Orders_grid.RowAction = ""
			End If
		End If

	' Set up key count
	Orders_grid.KeyCount = Orders_grid.RowIndex
	Call Orders.ResetAttrs()
	Orders.CssClass = ""
	If Orders.CurrentAction = "gridadd" Then
		If Orders.CurrentMode = "copy" Then
			Call Orders_grid.LoadRowValues(Orders_grid.Recordset) ' Load row values
			Orders_grid.RowOldKey = Orders_grid.SetRecordKey(Orders_grid.Recordset) ' Set old record key
		Else
			Call Orders_grid.LoadDefaultValues() ' Load default values
			Orders_grid.RowOldKey = "" ' Clear old key value
		End If
	Else
		Call Orders_grid.LoadRowValues(Orders_grid.Recordset) ' Load row values
	End If
	Orders.RowType = EW_ROWTYPE_VIEW ' Render view
	If Orders.CurrentAction = "gridadd" Then ' Grid add
		Orders.RowType = EW_ROWTYPE_ADD ' Render add
	End If
	If Orders.CurrentAction = "gridadd" And Orders.EventCancelled Then ' Insert failed
		Call Orders_grid.RestoreCurrentRowFormValues(Orders_grid.RowIndex) ' Restore form values
	End If
	If Orders.CurrentAction = "gridedit" Then ' Grid edit
		If Orders.EventCancelled Then ' Update failed
			Call Orders_grid.RestoreCurrentRowFormValues(Orders_grid.RowIndex) ' Restore form values
		End If
		If Orders_grid.RowAction = "insert" Then
			Orders.RowType = EW_ROWTYPE_ADD ' Render add
		Else
			Orders.RowType = EW_ROWTYPE_EDIT ' Render edit
		End If
	End If
	If Orders.RowType = EW_ROWTYPE_EDIT Then ' Edit row
		Orders_grid.EditRowCnt = Orders_grid.EditRowCnt + 1
	End If
	If Orders.CurrentAction = "F" Then ' Confirm row
		Call Orders_grid.RestoreCurrentRowFormValues(Orders_grid.RowIndex) ' Restore form values
	End If
	If Orders.RowType = EW_ROWTYPE_ADD Or Orders.RowType = EW_ROWTYPE_EDIT Then ' Add / Edit row
		If Orders.CurrentAction = "edit" Then
			Orders.RowAttrs.AddAttributes Array()
			Orders.CssClass = "ewTableEditRow"
		Else
			Orders.RowAttrs.AddAttributes Array()
		End If
		If Not IsEmpty(Orders_grid.RowIndex) Then
			Orders.RowAttrs.AddAttributes Array(Array("data-rowindex", Orders_grid.RowIndex), Array("id", "r" & Orders_grid.RowIndex & "_Orders"))
		End If
	Else
		Orders.RowAttrs.AddAttributes Array()
	End If

	' Render row
	Call Orders_grid.RenderRow()

	' Render list options
	Call Orders_grid.RenderListOptions()

	' Skip delete row / empty row for confirm page
	If Orders_grid.RowAction <> "delete" And Orders_grid.RowAction <> "insertdelete" And Not (Orders_grid.RowAction = "insert" And Orders.CurrentAction = "F" And Orders_grid.EmptyRow()) Then
%>
	<tr<%= Orders.RowAttributes %>>
<%

' Render list options (body, left)
Orders_grid.ListOptions.Render "body", "left"
%>
	<% If Orders.OrderId.Visible Then ' OrderId %>
		<td<%= Orders.OrderId.CellAttributes %>>
<% If Orders.RowType = EW_ROWTYPE_ADD Then ' Add Record %>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_OrderId" id="o<%= Orders_grid.RowIndex %>_OrderId" value="<%= Server.HTMLEncode(Orders.OrderId.OldValue&"") %>">
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_EDIT Then ' Edit Record %>
<div<%= Orders.OrderId.ViewAttributes %>><%= Orders.OrderId.EditValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_OrderId" id="x<%= Orders_grid.RowIndex %>_OrderId" value="<%= Server.HTMLEncode(Orders.OrderId.CurrentValue&"") %>">
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_VIEW Then ' View Record %>
<div<%= Orders.OrderId.ViewAttributes %>><%= Orders.OrderId.ListViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_OrderId" id="x<%= Orders_grid.RowIndex %>_OrderId" value="<%= Server.HTMLEncode(Orders.OrderId.CurrentValue&"") %>">
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_OrderId" id="o<%= Orders_grid.RowIndex %>_OrderId" value="<%= Server.HTMLEncode(Orders.OrderId.OldValue&"") %>">
<% End If %>
<a name="<%= Orders_grid.PageObjName & "_row_" & Orders_grid.RowCnt %>" id="<%= Orders_grid.PageObjName & "_row_" & Orders_grid.RowCnt %>"></a></td>
	<% End If %>
	<% If Orders.CustomerId.Visible Then ' CustomerId %>
		<td<%= Orders.CustomerId.CellAttributes %>>
<% If Orders.RowType = EW_ROWTYPE_ADD Then ' Add Record %>
<% If Orders.CustomerId.SessionValue <> "" Then %>
<div<%= Orders.CustomerId.ViewAttributes %>>
<% If Orders.CustomerId.LinkAttributes <> "" Then %>
<a<%= Orders.CustomerId.LinkAttributes %>><%= Orders.CustomerId.ListViewValue %></a>
<% Else %>
<%= Orders.CustomerId.ListViewValue %>
<% End If %>
</div>
<input type="hidden" id="x<%= Orders_grid.RowIndex %>_CustomerId" name="x<%= Orders_grid.RowIndex %>_CustomerId" value="<%= ew_HtmlEncode(Orders.CustomerId.CurrentValue) %>">
<% Else %>
<select id="x<%= Orders_grid.RowIndex %>_CustomerId" name="x<%= Orders_grid.RowIndex %>_CustomerId"<%= Orders.CustomerId.EditAttributes %>>
<%
emptywrk = True
If IsArray(Orders.CustomerId.EditValue) Then
	arwrk = Orders.CustomerId.EditValue
	For rowcntwrk = 0 To UBound(arwrk, 2)
		If arwrk(0, rowcntwrk)&"" = Orders.CustomerId.CurrentValue&"" Then
			selwrk = " selected=""selected"""
			emptywrk = False
		Else
			selwrk = ""
		End If
%>
<option value="<%= Server.HtmlEncode(arwrk(0, rowcntwrk)&"") %>"<%= selwrk %>>
<%= arwrk(1, rowcntwrk) %>
</option>
<%
	Next
End If
If emptywrk Then Orders.CustomerId.OldValue = ""
%>
</select>
<% End If %>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_CustomerId" id="o<%= Orders_grid.RowIndex %>_CustomerId" value="<%= Server.HTMLEncode(Orders.CustomerId.OldValue&"") %>">
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_EDIT Then ' Edit Record %>
<% If Orders.CustomerId.SessionValue <> "" Then %>
<div<%= Orders.CustomerId.ViewAttributes %>>
<% If Orders.CustomerId.LinkAttributes <> "" Then %>
<a<%= Orders.CustomerId.LinkAttributes %>><%= Orders.CustomerId.ListViewValue %></a>
<% Else %>
<%= Orders.CustomerId.ListViewValue %>
<% End If %>
</div>
<input type="hidden" id="x<%= Orders_grid.RowIndex %>_CustomerId" name="x<%= Orders_grid.RowIndex %>_CustomerId" value="<%= ew_HtmlEncode(Orders.CustomerId.CurrentValue) %>">
<% Else %>
<select id="x<%= Orders_grid.RowIndex %>_CustomerId" name="x<%= Orders_grid.RowIndex %>_CustomerId"<%= Orders.CustomerId.EditAttributes %>>
<%
emptywrk = True
If IsArray(Orders.CustomerId.EditValue) Then
	arwrk = Orders.CustomerId.EditValue
	For rowcntwrk = 0 To UBound(arwrk, 2)
		If arwrk(0, rowcntwrk)&"" = Orders.CustomerId.CurrentValue&"" Then
			selwrk = " selected=""selected"""
			emptywrk = False
		Else
			selwrk = ""
		End If
%>
<option value="<%= Server.HtmlEncode(arwrk(0, rowcntwrk)&"") %>"<%= selwrk %>>
<%= arwrk(1, rowcntwrk) %>
</option>
<%
	Next
End If
If emptywrk Then Orders.CustomerId.OldValue = ""
%>
</select>
<% End If %>
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_VIEW Then ' View Record %>
<div<%= Orders.CustomerId.ViewAttributes %>>
<% If Orders.CustomerId.LinkAttributes <> "" Then %>
<a<%= Orders.CustomerId.LinkAttributes %>><%= Orders.CustomerId.ListViewValue %></a>
<% Else %>
<%= Orders.CustomerId.ListViewValue %>
<% End If %>
</div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_CustomerId" id="x<%= Orders_grid.RowIndex %>_CustomerId" value="<%= Server.HTMLEncode(Orders.CustomerId.CurrentValue&"") %>">
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_CustomerId" id="o<%= Orders_grid.RowIndex %>_CustomerId" value="<%= Server.HTMLEncode(Orders.CustomerId.OldValue&"") %>">
<% End If %>
</td>
	<% End If %>
	<% If Orders.Amount.Visible Then ' Amount %>
		<td<%= Orders.Amount.CellAttributes %>>
<% If Orders.RowType = EW_ROWTYPE_ADD Then ' Add Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_Amount" id="x<%= Orders_grid.RowIndex %>_Amount" size="30" value="<%= Orders.Amount.EditValue %>"<%= Orders.Amount.EditAttributes %>>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_Amount" id="o<%= Orders_grid.RowIndex %>_Amount" value="<%= Server.HTMLEncode(Orders.Amount.OldValue&"") %>">
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_EDIT Then ' Edit Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_Amount" id="x<%= Orders_grid.RowIndex %>_Amount" size="30" value="<%= Orders.Amount.EditValue %>"<%= Orders.Amount.EditAttributes %>>
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_VIEW Then ' View Record %>
<div<%= Orders.Amount.ViewAttributes %>><%= Orders.Amount.ListViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_Amount" id="x<%= Orders_grid.RowIndex %>_Amount" value="<%= Server.HTMLEncode(Orders.Amount.CurrentValue&"") %>">
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_Amount" id="o<%= Orders_grid.RowIndex %>_Amount" value="<%= Server.HTMLEncode(Orders.Amount.OldValue&"") %>">
<% End If %>
</td>
	<% End If %>
	<% If Orders.Ship_FirstName.Visible Then ' Ship_FirstName %>
		<td<%= Orders.Ship_FirstName.CellAttributes %>>
<% If Orders.RowType = EW_ROWTYPE_ADD Then ' Add Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_Ship_FirstName" id="x<%= Orders_grid.RowIndex %>_Ship_FirstName" size="30" maxlength="255" value="<%= Orders.Ship_FirstName.EditValue %>"<%= Orders.Ship_FirstName.EditAttributes %>>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_Ship_FirstName" id="o<%= Orders_grid.RowIndex %>_Ship_FirstName" value="<%= Server.HTMLEncode(Orders.Ship_FirstName.OldValue&"") %>">
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_EDIT Then ' Edit Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_Ship_FirstName" id="x<%= Orders_grid.RowIndex %>_Ship_FirstName" size="30" maxlength="255" value="<%= Orders.Ship_FirstName.EditValue %>"<%= Orders.Ship_FirstName.EditAttributes %>>
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_VIEW Then ' View Record %>
<div<%= Orders.Ship_FirstName.ViewAttributes %>><%= Orders.Ship_FirstName.ListViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_Ship_FirstName" id="x<%= Orders_grid.RowIndex %>_Ship_FirstName" value="<%= Server.HTMLEncode(Orders.Ship_FirstName.CurrentValue&"") %>">
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_Ship_FirstName" id="o<%= Orders_grid.RowIndex %>_Ship_FirstName" value="<%= Server.HTMLEncode(Orders.Ship_FirstName.OldValue&"") %>">
<% End If %>
</td>
	<% End If %>
	<% If Orders.Ship_LastName.Visible Then ' Ship_LastName %>
		<td<%= Orders.Ship_LastName.CellAttributes %>>
<% If Orders.RowType = EW_ROWTYPE_ADD Then ' Add Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_Ship_LastName" id="x<%= Orders_grid.RowIndex %>_Ship_LastName" size="30" maxlength="255" value="<%= Orders.Ship_LastName.EditValue %>"<%= Orders.Ship_LastName.EditAttributes %>>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_Ship_LastName" id="o<%= Orders_grid.RowIndex %>_Ship_LastName" value="<%= Server.HTMLEncode(Orders.Ship_LastName.OldValue&"") %>">
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_EDIT Then ' Edit Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_Ship_LastName" id="x<%= Orders_grid.RowIndex %>_Ship_LastName" size="30" maxlength="255" value="<%= Orders.Ship_LastName.EditValue %>"<%= Orders.Ship_LastName.EditAttributes %>>
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_VIEW Then ' View Record %>
<div<%= Orders.Ship_LastName.ViewAttributes %>><%= Orders.Ship_LastName.ListViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_Ship_LastName" id="x<%= Orders_grid.RowIndex %>_Ship_LastName" value="<%= Server.HTMLEncode(Orders.Ship_LastName.CurrentValue&"") %>">
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_Ship_LastName" id="o<%= Orders_grid.RowIndex %>_Ship_LastName" value="<%= Server.HTMLEncode(Orders.Ship_LastName.OldValue&"") %>">
<% End If %>
</td>
	<% End If %>
	<% If Orders.payment_status.Visible Then ' payment_status %>
		<td<%= Orders.payment_status.CellAttributes %>>
<% If Orders.RowType = EW_ROWTYPE_ADD Then ' Add Record %>
<select id="x<%= Orders_grid.RowIndex %>_payment_status" name="x<%= Orders_grid.RowIndex %>_payment_status"<%= Orders.payment_status.EditAttributes %>>
<%
emptywrk = True
If IsArray(Orders.payment_status.EditValue) Then
	arwrk = Orders.payment_status.EditValue
	For rowcntwrk = 0 To UBound(arwrk, 2)
		If arwrk(0, rowcntwrk)&"" = Orders.payment_status.CurrentValue&"" Then
			selwrk = " selected=""selected"""
			emptywrk = False
		Else
			selwrk = ""
		End If
%>
<option value="<%= Server.HtmlEncode(arwrk(0, rowcntwrk)&"") %>"<%= selwrk %>>
<%= arwrk(1, rowcntwrk) %>
</option>
<%
	Next
End If
If emptywrk Then Orders.payment_status.OldValue = ""
%>
</select>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_payment_status" id="o<%= Orders_grid.RowIndex %>_payment_status" value="<%= Server.HTMLEncode(Orders.payment_status.OldValue&"") %>">
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_EDIT Then ' Edit Record %>
<select id="x<%= Orders_grid.RowIndex %>_payment_status" name="x<%= Orders_grid.RowIndex %>_payment_status"<%= Orders.payment_status.EditAttributes %>>
<%
emptywrk = True
If IsArray(Orders.payment_status.EditValue) Then
	arwrk = Orders.payment_status.EditValue
	For rowcntwrk = 0 To UBound(arwrk, 2)
		If arwrk(0, rowcntwrk)&"" = Orders.payment_status.CurrentValue&"" Then
			selwrk = " selected=""selected"""
			emptywrk = False
		Else
			selwrk = ""
		End If
%>
<option value="<%= Server.HtmlEncode(arwrk(0, rowcntwrk)&"") %>"<%= selwrk %>>
<%= arwrk(1, rowcntwrk) %>
</option>
<%
	Next
End If
If emptywrk Then Orders.payment_status.OldValue = ""
%>
</select>
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_VIEW Then ' View Record %>
<div<%= Orders.payment_status.ViewAttributes %>><%= Orders.payment_status.ListViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_payment_status" id="x<%= Orders_grid.RowIndex %>_payment_status" value="<%= Server.HTMLEncode(Orders.payment_status.CurrentValue&"") %>">
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_payment_status" id="o<%= Orders_grid.RowIndex %>_payment_status" value="<%= Server.HTMLEncode(Orders.payment_status.OldValue&"") %>">
<% End If %>
</td>
	<% End If %>
	<% If Orders.Ordered_Date.Visible Then ' Ordered_Date %>
		<td<%= Orders.Ordered_Date.CellAttributes %>>
<% If Orders.RowType = EW_ROWTYPE_ADD Then ' Add Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_Ordered_Date" id="x<%= Orders_grid.RowIndex %>_Ordered_Date" value="<%= Orders.Ordered_Date.EditValue %>"<%= Orders.Ordered_Date.EditAttributes %>>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_Ordered_Date" id="o<%= Orders_grid.RowIndex %>_Ordered_Date" value="<%= Server.HTMLEncode(Orders.Ordered_Date.OldValue&"") %>">
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_EDIT Then ' Edit Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_Ordered_Date" id="x<%= Orders_grid.RowIndex %>_Ordered_Date" value="<%= Orders.Ordered_Date.EditValue %>"<%= Orders.Ordered_Date.EditAttributes %>>
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_VIEW Then ' View Record %>
<div<%= Orders.Ordered_Date.ViewAttributes %>><%= Orders.Ordered_Date.ListViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_Ordered_Date" id="x<%= Orders_grid.RowIndex %>_Ordered_Date" value="<%= Server.HTMLEncode(Orders.Ordered_Date.CurrentValue&"") %>">
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_Ordered_Date" id="o<%= Orders_grid.RowIndex %>_Ordered_Date" value="<%= Server.HTMLEncode(Orders.Ordered_Date.OldValue&"") %>">
<% End If %>
</td>
	<% End If %>
	<% If Orders.payer_email.Visible Then ' payer_email %>
		<td<%= Orders.payer_email.CellAttributes %>>
<% If Orders.RowType = EW_ROWTYPE_ADD Then ' Add Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_payer_email" id="x<%= Orders_grid.RowIndex %>_payer_email" size="30" maxlength="255" value="<%= Orders.payer_email.EditValue %>"<%= Orders.payer_email.EditAttributes %>>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_payer_email" id="o<%= Orders_grid.RowIndex %>_payer_email" value="<%= Server.HTMLEncode(Orders.payer_email.OldValue&"") %>">
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_EDIT Then ' Edit Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_payer_email" id="x<%= Orders_grid.RowIndex %>_payer_email" size="30" maxlength="255" value="<%= Orders.payer_email.EditValue %>"<%= Orders.payer_email.EditAttributes %>>
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_VIEW Then ' View Record %>
<div<%= Orders.payer_email.ViewAttributes %>><%= Orders.payer_email.ListViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_payer_email" id="x<%= Orders_grid.RowIndex %>_payer_email" value="<%= Server.HTMLEncode(Orders.payer_email.CurrentValue&"") %>">
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_payer_email" id="o<%= Orders_grid.RowIndex %>_payer_email" value="<%= Server.HTMLEncode(Orders.payer_email.OldValue&"") %>">
<% End If %>
</td>
	<% End If %>
	<% If Orders.payment_gross.Visible Then ' payment_gross %>
		<td<%= Orders.payment_gross.CellAttributes %>>
<% If Orders.RowType = EW_ROWTYPE_ADD Then ' Add Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_payment_gross" id="x<%= Orders_grid.RowIndex %>_payment_gross" size="30" value="<%= Orders.payment_gross.EditValue %>"<%= Orders.payment_gross.EditAttributes %>>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_payment_gross" id="o<%= Orders_grid.RowIndex %>_payment_gross" value="<%= Server.HTMLEncode(Orders.payment_gross.OldValue&"") %>">
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_EDIT Then ' Edit Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_payment_gross" id="x<%= Orders_grid.RowIndex %>_payment_gross" size="30" value="<%= Orders.payment_gross.EditValue %>"<%= Orders.payment_gross.EditAttributes %>>
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_VIEW Then ' View Record %>
<div<%= Orders.payment_gross.ViewAttributes %>><%= Orders.payment_gross.ListViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_payment_gross" id="x<%= Orders_grid.RowIndex %>_payment_gross" value="<%= Server.HTMLEncode(Orders.payment_gross.CurrentValue&"") %>">
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_payment_gross" id="o<%= Orders_grid.RowIndex %>_payment_gross" value="<%= Server.HTMLEncode(Orders.payment_gross.OldValue&"") %>">
<% End If %>
</td>
	<% End If %>
	<% If Orders.payment_fee.Visible Then ' payment_fee %>
		<td<%= Orders.payment_fee.CellAttributes %>>
<% If Orders.RowType = EW_ROWTYPE_ADD Then ' Add Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_payment_fee" id="x<%= Orders_grid.RowIndex %>_payment_fee" size="30" value="<%= Orders.payment_fee.EditValue %>"<%= Orders.payment_fee.EditAttributes %>>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_payment_fee" id="o<%= Orders_grid.RowIndex %>_payment_fee" value="<%= Server.HTMLEncode(Orders.payment_fee.OldValue&"") %>">
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_EDIT Then ' Edit Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_payment_fee" id="x<%= Orders_grid.RowIndex %>_payment_fee" size="30" value="<%= Orders.payment_fee.EditValue %>"<%= Orders.payment_fee.EditAttributes %>>
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_VIEW Then ' View Record %>
<div<%= Orders.payment_fee.ViewAttributes %>><%= Orders.payment_fee.ListViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_payment_fee" id="x<%= Orders_grid.RowIndex %>_payment_fee" value="<%= Server.HTMLEncode(Orders.payment_fee.CurrentValue&"") %>">
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_payment_fee" id="o<%= Orders_grid.RowIndex %>_payment_fee" value="<%= Server.HTMLEncode(Orders.payment_fee.OldValue&"") %>">
<% End If %>
</td>
	<% End If %>
	<% If Orders.Tax.Visible Then ' Tax %>
		<td<%= Orders.Tax.CellAttributes %>>
<% If Orders.RowType = EW_ROWTYPE_ADD Then ' Add Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_Tax" id="x<%= Orders_grid.RowIndex %>_Tax" size="30" value="<%= Orders.Tax.EditValue %>"<%= Orders.Tax.EditAttributes %>>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_Tax" id="o<%= Orders_grid.RowIndex %>_Tax" value="<%= Server.HTMLEncode(Orders.Tax.OldValue&"") %>">
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_EDIT Then ' Edit Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_Tax" id="x<%= Orders_grid.RowIndex %>_Tax" size="30" value="<%= Orders.Tax.EditValue %>"<%= Orders.Tax.EditAttributes %>>
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_VIEW Then ' View Record %>
<div<%= Orders.Tax.ViewAttributes %>><%= Orders.Tax.ListViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_Tax" id="x<%= Orders_grid.RowIndex %>_Tax" value="<%= Server.HTMLEncode(Orders.Tax.CurrentValue&"") %>">
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_Tax" id="o<%= Orders_grid.RowIndex %>_Tax" value="<%= Server.HTMLEncode(Orders.Tax.OldValue&"") %>">
<% End If %>
</td>
	<% End If %>
	<% If Orders.Shipping.Visible Then ' Shipping %>
		<td<%= Orders.Shipping.CellAttributes %>>
<% If Orders.RowType = EW_ROWTYPE_ADD Then ' Add Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_Shipping" id="x<%= Orders_grid.RowIndex %>_Shipping" size="30" value="<%= Orders.Shipping.EditValue %>"<%= Orders.Shipping.EditAttributes %>>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_Shipping" id="o<%= Orders_grid.RowIndex %>_Shipping" value="<%= Server.HTMLEncode(Orders.Shipping.OldValue&"") %>">
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_EDIT Then ' Edit Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_Shipping" id="x<%= Orders_grid.RowIndex %>_Shipping" size="30" value="<%= Orders.Shipping.EditValue %>"<%= Orders.Shipping.EditAttributes %>>
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_VIEW Then ' View Record %>
<div<%= Orders.Shipping.ViewAttributes %>><%= Orders.Shipping.ListViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_Shipping" id="x<%= Orders_grid.RowIndex %>_Shipping" value="<%= Server.HTMLEncode(Orders.Shipping.CurrentValue&"") %>">
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_Shipping" id="o<%= Orders_grid.RowIndex %>_Shipping" value="<%= Server.HTMLEncode(Orders.Shipping.OldValue&"") %>">
<% End If %>
</td>
	<% End If %>
	<% If Orders.EmailSent.Visible Then ' EmailSent %>
		<td<%= Orders.EmailSent.CellAttributes %>>
<% If Orders.RowType = EW_ROWTYPE_ADD Then ' Add Record %>
<select id="x<%= Orders_grid.RowIndex %>_EmailSent" name="x<%= Orders_grid.RowIndex %>_EmailSent"<%= Orders.EmailSent.EditAttributes %>>
<%
emptywrk = True
If IsArray(Orders.EmailSent.EditValue) Then
	arwrk = Orders.EmailSent.EditValue
	For rowcntwrk = 0 To UBound(arwrk, 2)
		If arwrk(0, rowcntwrk)&"" = Orders.EmailSent.CurrentValue&"" Then
			selwrk = " selected=""selected"""
			emptywrk = False
		Else
			selwrk = ""
		End If
%>
<option value="<%= Server.HtmlEncode(arwrk(0, rowcntwrk)&"") %>"<%= selwrk %>>
<%= arwrk(1, rowcntwrk) %>
</option>
<%
	Next
End If
If emptywrk Then Orders.EmailSent.OldValue = ""
%>
</select>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_EmailSent" id="o<%= Orders_grid.RowIndex %>_EmailSent" value="<%= Server.HTMLEncode(Orders.EmailSent.OldValue&"") %>">
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_EDIT Then ' Edit Record %>
<select id="x<%= Orders_grid.RowIndex %>_EmailSent" name="x<%= Orders_grid.RowIndex %>_EmailSent"<%= Orders.EmailSent.EditAttributes %>>
<%
emptywrk = True
If IsArray(Orders.EmailSent.EditValue) Then
	arwrk = Orders.EmailSent.EditValue
	For rowcntwrk = 0 To UBound(arwrk, 2)
		If arwrk(0, rowcntwrk)&"" = Orders.EmailSent.CurrentValue&"" Then
			selwrk = " selected=""selected"""
			emptywrk = False
		Else
			selwrk = ""
		End If
%>
<option value="<%= Server.HtmlEncode(arwrk(0, rowcntwrk)&"") %>"<%= selwrk %>>
<%= arwrk(1, rowcntwrk) %>
</option>
<%
	Next
End If
If emptywrk Then Orders.EmailSent.OldValue = ""
%>
</select>
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_VIEW Then ' View Record %>
<div<%= Orders.EmailSent.ViewAttributes %>><%= Orders.EmailSent.ListViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_EmailSent" id="x<%= Orders_grid.RowIndex %>_EmailSent" value="<%= Server.HTMLEncode(Orders.EmailSent.CurrentValue&"") %>">
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_EmailSent" id="o<%= Orders_grid.RowIndex %>_EmailSent" value="<%= Server.HTMLEncode(Orders.EmailSent.OldValue&"") %>">
<% End If %>
</td>
	<% End If %>
	<% If Orders.EmailDate.Visible Then ' EmailDate %>
		<td<%= Orders.EmailDate.CellAttributes %>>
<% If Orders.RowType = EW_ROWTYPE_ADD Then ' Add Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_EmailDate" id="x<%= Orders_grid.RowIndex %>_EmailDate" value="<%= Orders.EmailDate.EditValue %>"<%= Orders.EmailDate.EditAttributes %>>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_EmailDate" id="o<%= Orders_grid.RowIndex %>_EmailDate" value="<%= Server.HTMLEncode(Orders.EmailDate.OldValue&"") %>">
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_EDIT Then ' Edit Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_EmailDate" id="x<%= Orders_grid.RowIndex %>_EmailDate" value="<%= Orders.EmailDate.EditValue %>"<%= Orders.EmailDate.EditAttributes %>>
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_VIEW Then ' View Record %>
<div<%= Orders.EmailDate.ViewAttributes %>><%= Orders.EmailDate.ListViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_EmailDate" id="x<%= Orders_grid.RowIndex %>_EmailDate" value="<%= Server.HTMLEncode(Orders.EmailDate.CurrentValue&"") %>">
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_EmailDate" id="o<%= Orders_grid.RowIndex %>_EmailDate" value="<%= Server.HTMLEncode(Orders.EmailDate.OldValue&"") %>">
<% End If %>
</td>
	<% End If %>
	<% If Orders.PromoCodeUsed.Visible Then ' PromoCodeUsed %>
		<td<%= Orders.PromoCodeUsed.CellAttributes %>>
<% If Orders.RowType = EW_ROWTYPE_ADD Then ' Add Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_PromoCodeUsed" id="x<%= Orders_grid.RowIndex %>_PromoCodeUsed" size="30" maxlength="6" value="<%= Orders.PromoCodeUsed.EditValue %>"<%= Orders.PromoCodeUsed.EditAttributes %>>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_PromoCodeUsed" id="o<%= Orders_grid.RowIndex %>_PromoCodeUsed" value="<%= Server.HTMLEncode(Orders.PromoCodeUsed.OldValue&"") %>">
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_EDIT Then ' Edit Record %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_PromoCodeUsed" id="x<%= Orders_grid.RowIndex %>_PromoCodeUsed" size="30" maxlength="6" value="<%= Orders.PromoCodeUsed.EditValue %>"<%= Orders.PromoCodeUsed.EditAttributes %>>
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_VIEW Then ' View Record %>
<div<%= Orders.PromoCodeUsed.ViewAttributes %>><%= Orders.PromoCodeUsed.ListViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_PromoCodeUsed" id="x<%= Orders_grid.RowIndex %>_PromoCodeUsed" value="<%= Server.HTMLEncode(Orders.PromoCodeUsed.CurrentValue&"") %>">
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_PromoCodeUsed" id="o<%= Orders_grid.RowIndex %>_PromoCodeUsed" value="<%= Server.HTMLEncode(Orders.PromoCodeUsed.OldValue&"") %>">
<% End If %>
</td>
	<% End If %>
<%

' Render list options (body, right)
Orders_grid.ListOptions.Render "body", "right"
%>
	</tr>
<% If Orders.RowType = EW_ROWTYPE_ADD Then %>
<% End If %>
<% If Orders.RowType = EW_ROWTYPE_EDIT Then %>
<% End If %>
<%
	End If
	End If ' End delete row checking
	If Orders.CurrentAction <> "gridadd" Or Orders.CurrentMode = "copy" Then
		If Not Orders_grid.Recordset.Eof Then Orders_grid.Recordset.MoveNext()
	End If
Loop
%>
<%
	If Orders.CurrentMode = "add" Or Orders.CurrentMode = "copy" Or Orders.CurrentMode = "edit" Then
		Orders_grid.RowIndex = "$rowindex$"
		Orders_grid.LoadDefaultValues()

		' Set row properties
		Call Orders.ResetAttrs()
		Orders.RowAttrs.AddAttributes Array()
		If Not IsEmpty(Orders_grid.RowIndex) Then
			Orders.RowAttrs.AddAttributes Array(Array("data-rowindex", Orders_grid.RowIndex), Array("id", "r" & Orders_grid.RowIndex & "_Orders"))
		End If
		Orders.RowType = EW_ROWTYPE_ADD

		' Render row
		Call Orders_grid.RenderRow()

		' Render list options
		Call Orders_grid.RenderListOptions()

		' Add id and class to the template row
		Orders.RowAttrs.UpdateAttribute "id", "r0_Orders"
		Orders.RowAttrs.AddAttribute "class", "ewTemplate", True
%>
	<tr<%= Orders.RowAttributes %>>
<%

' Render list options (body, left)
Orders_grid.ListOptions.Render "body", "left"
%>
	<% If Orders.OrderId.Visible Then ' OrderId %>
		<td<%= Orders.OrderId.CellAttributes %>>&nbsp;</td>
	<% End If %>
	<% If Orders.CustomerId.Visible Then ' CustomerId %>
		<td<%= Orders.CustomerId.CellAttributes %>>
<% If Orders.CurrentAction <> "F" Then %>
<% If Orders.CustomerId.SessionValue <> "" Then %>
<div<%= Orders.CustomerId.ViewAttributes %>>
<% If Orders.CustomerId.LinkAttributes <> "" Then %>
<a<%= Orders.CustomerId.LinkAttributes %>><%= Orders.CustomerId.ListViewValue %></a>
<% Else %>
<%= Orders.CustomerId.ListViewValue %>
<% End If %>
</div>
<input type="hidden" id="x<%= Orders_grid.RowIndex %>_CustomerId" name="x<%= Orders_grid.RowIndex %>_CustomerId" value="<%= ew_HtmlEncode(Orders.CustomerId.CurrentValue) %>">
<% Else %>
<select id="x<%= Orders_grid.RowIndex %>_CustomerId" name="x<%= Orders_grid.RowIndex %>_CustomerId"<%= Orders.CustomerId.EditAttributes %>>
<%
emptywrk = True
If IsArray(Orders.CustomerId.EditValue) Then
	arwrk = Orders.CustomerId.EditValue
	For rowcntwrk = 0 To UBound(arwrk, 2)
		If arwrk(0, rowcntwrk)&"" = Orders.CustomerId.CurrentValue&"" Then
			selwrk = " selected=""selected"""
			emptywrk = False
		Else
			selwrk = ""
		End If
%>
<option value="<%= Server.HtmlEncode(arwrk(0, rowcntwrk)&"") %>"<%= selwrk %>>
<%= arwrk(1, rowcntwrk) %>
</option>
<%
	Next
End If
If emptywrk Then Orders.CustomerId.OldValue = ""
%>
</select>
<% End If %>
<% Else %>
<div<%= Orders.CustomerId.ViewAttributes %>>
<% If Orders.CustomerId.LinkAttributes <> "" Then %>
<a<%= Orders.CustomerId.LinkAttributes %>><%= Orders.CustomerId.ViewValue %></a>
<% Else %>
<%= Orders.CustomerId.ViewValue %>
<% End If %>
</div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_CustomerId" id="x<%= Orders_grid.RowIndex %>_CustomerId" value="<%= Server.HTMLEncode(Orders.CustomerId.FormValue&"") %>">
<% End If %>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_CustomerId" id="o<%= Orders_grid.RowIndex %>_CustomerId" value="<%= Server.HTMLEncode(Orders.CustomerId.OldValue&"") %>">
</td>
	<% End If %>
	<% If Orders.Amount.Visible Then ' Amount %>
		<td<%= Orders.Amount.CellAttributes %>>
<% If Orders.CurrentAction <> "F" Then %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_Amount" id="x<%= Orders_grid.RowIndex %>_Amount" size="30" value="<%= Orders.Amount.EditValue %>"<%= Orders.Amount.EditAttributes %>>
<% Else %>
<div<%= Orders.Amount.ViewAttributes %>><%= Orders.Amount.ViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_Amount" id="x<%= Orders_grid.RowIndex %>_Amount" value="<%= Server.HTMLEncode(Orders.Amount.FormValue&"") %>">
<% End If %>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_Amount" id="o<%= Orders_grid.RowIndex %>_Amount" value="<%= Server.HTMLEncode(Orders.Amount.OldValue&"") %>">
</td>
	<% End If %>
	<% If Orders.Ship_FirstName.Visible Then ' Ship_FirstName %>
		<td<%= Orders.Ship_FirstName.CellAttributes %>>
<% If Orders.CurrentAction <> "F" Then %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_Ship_FirstName" id="x<%= Orders_grid.RowIndex %>_Ship_FirstName" size="30" maxlength="255" value="<%= Orders.Ship_FirstName.EditValue %>"<%= Orders.Ship_FirstName.EditAttributes %>>
<% Else %>
<div<%= Orders.Ship_FirstName.ViewAttributes %>><%= Orders.Ship_FirstName.ViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_Ship_FirstName" id="x<%= Orders_grid.RowIndex %>_Ship_FirstName" value="<%= Server.HTMLEncode(Orders.Ship_FirstName.FormValue&"") %>">
<% End If %>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_Ship_FirstName" id="o<%= Orders_grid.RowIndex %>_Ship_FirstName" value="<%= Server.HTMLEncode(Orders.Ship_FirstName.OldValue&"") %>">
</td>
	<% End If %>
	<% If Orders.Ship_LastName.Visible Then ' Ship_LastName %>
		<td<%= Orders.Ship_LastName.CellAttributes %>>
<% If Orders.CurrentAction <> "F" Then %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_Ship_LastName" id="x<%= Orders_grid.RowIndex %>_Ship_LastName" size="30" maxlength="255" value="<%= Orders.Ship_LastName.EditValue %>"<%= Orders.Ship_LastName.EditAttributes %>>
<% Else %>
<div<%= Orders.Ship_LastName.ViewAttributes %>><%= Orders.Ship_LastName.ViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_Ship_LastName" id="x<%= Orders_grid.RowIndex %>_Ship_LastName" value="<%= Server.HTMLEncode(Orders.Ship_LastName.FormValue&"") %>">
<% End If %>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_Ship_LastName" id="o<%= Orders_grid.RowIndex %>_Ship_LastName" value="<%= Server.HTMLEncode(Orders.Ship_LastName.OldValue&"") %>">
</td>
	<% End If %>
	<% If Orders.payment_status.Visible Then ' payment_status %>
		<td<%= Orders.payment_status.CellAttributes %>>
<% If Orders.CurrentAction <> "F" Then %>
<select id="x<%= Orders_grid.RowIndex %>_payment_status" name="x<%= Orders_grid.RowIndex %>_payment_status"<%= Orders.payment_status.EditAttributes %>>
<%
emptywrk = True
If IsArray(Orders.payment_status.EditValue) Then
	arwrk = Orders.payment_status.EditValue
	For rowcntwrk = 0 To UBound(arwrk, 2)
		If arwrk(0, rowcntwrk)&"" = Orders.payment_status.CurrentValue&"" Then
			selwrk = " selected=""selected"""
			emptywrk = False
		Else
			selwrk = ""
		End If
%>
<option value="<%= Server.HtmlEncode(arwrk(0, rowcntwrk)&"") %>"<%= selwrk %>>
<%= arwrk(1, rowcntwrk) %>
</option>
<%
	Next
End If
If emptywrk Then Orders.payment_status.OldValue = ""
%>
</select>
<% Else %>
<div<%= Orders.payment_status.ViewAttributes %>><%= Orders.payment_status.ViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_payment_status" id="x<%= Orders_grid.RowIndex %>_payment_status" value="<%= Server.HTMLEncode(Orders.payment_status.FormValue&"") %>">
<% End If %>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_payment_status" id="o<%= Orders_grid.RowIndex %>_payment_status" value="<%= Server.HTMLEncode(Orders.payment_status.OldValue&"") %>">
</td>
	<% End If %>
	<% If Orders.Ordered_Date.Visible Then ' Ordered_Date %>
		<td<%= Orders.Ordered_Date.CellAttributes %>>
<% If Orders.CurrentAction <> "F" Then %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_Ordered_Date" id="x<%= Orders_grid.RowIndex %>_Ordered_Date" value="<%= Orders.Ordered_Date.EditValue %>"<%= Orders.Ordered_Date.EditAttributes %>>
<% Else %>
<div<%= Orders.Ordered_Date.ViewAttributes %>><%= Orders.Ordered_Date.ViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_Ordered_Date" id="x<%= Orders_grid.RowIndex %>_Ordered_Date" value="<%= Server.HTMLEncode(Orders.Ordered_Date.FormValue&"") %>">
<% End If %>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_Ordered_Date" id="o<%= Orders_grid.RowIndex %>_Ordered_Date" value="<%= Server.HTMLEncode(Orders.Ordered_Date.OldValue&"") %>">
</td>
	<% End If %>
	<% If Orders.payer_email.Visible Then ' payer_email %>
		<td<%= Orders.payer_email.CellAttributes %>>
<% If Orders.CurrentAction <> "F" Then %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_payer_email" id="x<%= Orders_grid.RowIndex %>_payer_email" size="30" maxlength="255" value="<%= Orders.payer_email.EditValue %>"<%= Orders.payer_email.EditAttributes %>>
<% Else %>
<div<%= Orders.payer_email.ViewAttributes %>><%= Orders.payer_email.ViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_payer_email" id="x<%= Orders_grid.RowIndex %>_payer_email" value="<%= Server.HTMLEncode(Orders.payer_email.FormValue&"") %>">
<% End If %>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_payer_email" id="o<%= Orders_grid.RowIndex %>_payer_email" value="<%= Server.HTMLEncode(Orders.payer_email.OldValue&"") %>">
</td>
	<% End If %>
	<% If Orders.payment_gross.Visible Then ' payment_gross %>
		<td<%= Orders.payment_gross.CellAttributes %>>
<% If Orders.CurrentAction <> "F" Then %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_payment_gross" id="x<%= Orders_grid.RowIndex %>_payment_gross" size="30" value="<%= Orders.payment_gross.EditValue %>"<%= Orders.payment_gross.EditAttributes %>>
<% Else %>
<div<%= Orders.payment_gross.ViewAttributes %>><%= Orders.payment_gross.ViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_payment_gross" id="x<%= Orders_grid.RowIndex %>_payment_gross" value="<%= Server.HTMLEncode(Orders.payment_gross.FormValue&"") %>">
<% End If %>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_payment_gross" id="o<%= Orders_grid.RowIndex %>_payment_gross" value="<%= Server.HTMLEncode(Orders.payment_gross.OldValue&"") %>">
</td>
	<% End If %>
	<% If Orders.payment_fee.Visible Then ' payment_fee %>
		<td<%= Orders.payment_fee.CellAttributes %>>
<% If Orders.CurrentAction <> "F" Then %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_payment_fee" id="x<%= Orders_grid.RowIndex %>_payment_fee" size="30" value="<%= Orders.payment_fee.EditValue %>"<%= Orders.payment_fee.EditAttributes %>>
<% Else %>
<div<%= Orders.payment_fee.ViewAttributes %>><%= Orders.payment_fee.ViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_payment_fee" id="x<%= Orders_grid.RowIndex %>_payment_fee" value="<%= Server.HTMLEncode(Orders.payment_fee.FormValue&"") %>">
<% End If %>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_payment_fee" id="o<%= Orders_grid.RowIndex %>_payment_fee" value="<%= Server.HTMLEncode(Orders.payment_fee.OldValue&"") %>">
</td>
	<% End If %>
	<% If Orders.Tax.Visible Then ' Tax %>
		<td<%= Orders.Tax.CellAttributes %>>
<% If Orders.CurrentAction <> "F" Then %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_Tax" id="x<%= Orders_grid.RowIndex %>_Tax" size="30" value="<%= Orders.Tax.EditValue %>"<%= Orders.Tax.EditAttributes %>>
<% Else %>
<div<%= Orders.Tax.ViewAttributes %>><%= Orders.Tax.ViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_Tax" id="x<%= Orders_grid.RowIndex %>_Tax" value="<%= Server.HTMLEncode(Orders.Tax.FormValue&"") %>">
<% End If %>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_Tax" id="o<%= Orders_grid.RowIndex %>_Tax" value="<%= Server.HTMLEncode(Orders.Tax.OldValue&"") %>">
</td>
	<% End If %>
	<% If Orders.Shipping.Visible Then ' Shipping %>
		<td<%= Orders.Shipping.CellAttributes %>>
<% If Orders.CurrentAction <> "F" Then %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_Shipping" id="x<%= Orders_grid.RowIndex %>_Shipping" size="30" value="<%= Orders.Shipping.EditValue %>"<%= Orders.Shipping.EditAttributes %>>
<% Else %>
<div<%= Orders.Shipping.ViewAttributes %>><%= Orders.Shipping.ViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_Shipping" id="x<%= Orders_grid.RowIndex %>_Shipping" value="<%= Server.HTMLEncode(Orders.Shipping.FormValue&"") %>">
<% End If %>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_Shipping" id="o<%= Orders_grid.RowIndex %>_Shipping" value="<%= Server.HTMLEncode(Orders.Shipping.OldValue&"") %>">
</td>
	<% End If %>
	<% If Orders.EmailSent.Visible Then ' EmailSent %>
		<td<%= Orders.EmailSent.CellAttributes %>>
<% If Orders.CurrentAction <> "F" Then %>
<select id="x<%= Orders_grid.RowIndex %>_EmailSent" name="x<%= Orders_grid.RowIndex %>_EmailSent"<%= Orders.EmailSent.EditAttributes %>>
<%
emptywrk = True
If IsArray(Orders.EmailSent.EditValue) Then
	arwrk = Orders.EmailSent.EditValue
	For rowcntwrk = 0 To UBound(arwrk, 2)
		If arwrk(0, rowcntwrk)&"" = Orders.EmailSent.CurrentValue&"" Then
			selwrk = " selected=""selected"""
			emptywrk = False
		Else
			selwrk = ""
		End If
%>
<option value="<%= Server.HtmlEncode(arwrk(0, rowcntwrk)&"") %>"<%= selwrk %>>
<%= arwrk(1, rowcntwrk) %>
</option>
<%
	Next
End If
If emptywrk Then Orders.EmailSent.OldValue = ""
%>
</select>
<% Else %>
<div<%= Orders.EmailSent.ViewAttributes %>><%= Orders.EmailSent.ViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_EmailSent" id="x<%= Orders_grid.RowIndex %>_EmailSent" value="<%= Server.HTMLEncode(Orders.EmailSent.FormValue&"") %>">
<% End If %>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_EmailSent" id="o<%= Orders_grid.RowIndex %>_EmailSent" value="<%= Server.HTMLEncode(Orders.EmailSent.OldValue&"") %>">
</td>
	<% End If %>
	<% If Orders.EmailDate.Visible Then ' EmailDate %>
		<td<%= Orders.EmailDate.CellAttributes %>>
<% If Orders.CurrentAction <> "F" Then %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_EmailDate" id="x<%= Orders_grid.RowIndex %>_EmailDate" value="<%= Orders.EmailDate.EditValue %>"<%= Orders.EmailDate.EditAttributes %>>
<% Else %>
<div<%= Orders.EmailDate.ViewAttributes %>><%= Orders.EmailDate.ViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_EmailDate" id="x<%= Orders_grid.RowIndex %>_EmailDate" value="<%= Server.HTMLEncode(Orders.EmailDate.FormValue&"") %>">
<% End If %>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_EmailDate" id="o<%= Orders_grid.RowIndex %>_EmailDate" value="<%= Server.HTMLEncode(Orders.EmailDate.OldValue&"") %>">
</td>
	<% End If %>
	<% If Orders.PromoCodeUsed.Visible Then ' PromoCodeUsed %>
		<td<%= Orders.PromoCodeUsed.CellAttributes %>>
<% If Orders.CurrentAction <> "F" Then %>
<input type="text" name="x<%= Orders_grid.RowIndex %>_PromoCodeUsed" id="x<%= Orders_grid.RowIndex %>_PromoCodeUsed" size="30" maxlength="6" value="<%= Orders.PromoCodeUsed.EditValue %>"<%= Orders.PromoCodeUsed.EditAttributes %>>
<% Else %>
<div<%= Orders.PromoCodeUsed.ViewAttributes %>><%= Orders.PromoCodeUsed.ViewValue %></div>
<input type="hidden" name="x<%= Orders_grid.RowIndex %>_PromoCodeUsed" id="x<%= Orders_grid.RowIndex %>_PromoCodeUsed" value="<%= Server.HTMLEncode(Orders.PromoCodeUsed.FormValue&"") %>">
<% End If %>
<input type="hidden" name="o<%= Orders_grid.RowIndex %>_PromoCodeUsed" id="o<%= Orders_grid.RowIndex %>_PromoCodeUsed" value="<%= Server.HTMLEncode(Orders.PromoCodeUsed.OldValue&"") %>">
</td>
	<% End If %>
<%

' Render list options (body, right)
Orders_grid.ListOptions.Render "body", "right"
%>
	</tr>
<%
End If
%>
</tbody>
</table>
<% If Orders.CurrentMode = "add" Or Orders.CurrentMode = "copy" Then %>
<input type="hidden" name="a_list" id="a_list" value="gridinsert">
<input type="hidden" name="key_count" id="key_count" value="<%= Orders_grid.KeyCount %>">
<%= Orders_grid.MultiSelectKey %>
<% End If %>
<% If Orders.CurrentMode = "edit" Then %>
<input type="hidden" name="a_list" id="a_list" value="gridupdate">
<input type="hidden" name="key_count" id="key_count" value="<%= Orders_grid.KeyCount %>">
<%= Orders_grid.MultiSelectKey %>
<% End If %>
<input type="hidden" name="detailpage" id="detailpage" value="Orders_grid">
</div>
<%

' Close recordset and connection
Orders_grid.Recordset.Close
Set Orders_grid.Recordset = Nothing
%>
<% If (Orders.CurrentMode = "add" Or Orders.CurrentMode = "copy" Or Orders.CurrentMode = "edit") And Orders.CurrentAction <> "F" Then ' add/copy/edit mode %>
<div class="ewGridLowerPanel">
<% If Orders.AllowAddDeleteRow Then %>
<% If Security.IsLoggedIn() Then %>
<span class="aspmaker">
<a href="javascript:void(0);" onclick="ew_AddGridRow(this);"><img src='images/addblankrow.gif' alt='<%= ew_HtmlEncode(Language.Phrase("AddBlankRow")) %>' title='<%= ew_HtmlEncode(Language.Phrase("AddBlankRow")) %>' width='16' height='16' border='0'></a>&nbsp;&nbsp;
</span>
<% End If %>
<% End If %>
</div>
<% End If %>
</td></tr></table>
<% If Orders.Export = "" And Orders.CurrentAction = "" Then %>
<% End If %>
<%
Orders_grid.ShowPageFooter()
If EW_DEBUG_ENABLED Then Response.Write ew_DebugMsg()
%>
<%

' Drop page object
Set Orders_grid = Nothing
Set Page = MasterPage
%>
