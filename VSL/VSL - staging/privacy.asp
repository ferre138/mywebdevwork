<%
Const EW_PAGE_ID = "register"
%>
<!--#include file="ewcfg60.asp"-->
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
Dim Security
Set Security = New cAdvancedSecurity
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
Dim bUserExists
Dim captcha
Response.Buffer = True

' Create form object
Dim objForm
Set objForm = New cFormObj
If objForm.GetValue("a_register")&"" <> "" Then

	' Get action
	Customers.CurrentAction = objForm.GetValue("a_register")
	Call LoadFormValues() ' Get form values
Else
	Customers.CurrentAction = "I" ' Display blank record
	Call LoadDefaultValues() ' Load default values
End If
If Customers.CurrentAction <> "I" And Customers.CurrentAction <> "C" Then

	' Get captcha value
	captcha = objForm.GetValue("captcha")

	' Check captcha value from form
	If captcha <> Session("CAPTCHA") Then ' Captcha matched
		Session(EW_SESSION_MESSAGE) = "Please enter the validation code shown" ' Set message
		Customers.CurrentAction = "I" ' Reset action, do not insert if captcha unmatched
	End If
End If

' Close form object
Set objForm = Nothing
Select Case Customers.CurrentAction
	Case "I" ' Blank record, no action required
	Case "A" ' Add

		' Check for Duplicate User ID
		Dim sFilter, sUserSql, rs
		sFilter = "([UserName] = '" & ew_AdjustSql(Customers.UserName.CurrentValue) & "')"

		' Set up filter (Sql Where Clause) and get Return Sql
		' Sql constructor in Customers class, Customersinfo.asp

		Customers.CurrentFilter = sFilter
		sUserSql = Customers.SQL
		Set rs = conn.Execute(sUserSql)
		If Not rs.Eof Then
			bUserExists = True
			Call RestoreFormValues() ' Restore form values
			Session(EW_SESSION_MESSAGE) = "User Already Exists!" ' Set user exist message
		End If
		rs.Close
		Set rs = Nothing
		If Not bUserExists Then
			Customers.SendEmail = True ' Send email on add success
			If AddRow() Then ' Add record
				Session(EW_SESSION_MESSAGE) = "Registration Successful" ' Register success
				Call Page_Terminate("login.asp") ' Go to login page
			Else
				Call RestoreFormValues() ' Restore form values
			End If
		End If
End Select

' Render row
Customers.RowType = EW_ROWTYPE_ADD ' Render add
Call RenderRow()
%>
<!--#include file="header.asp"-->
<script type="text/javascript">
<!--
var EW_PAGE_ID = "register"; // Page id
//-->
</script>
<script type="text/javascript">
<!--
function ew_ValidateForm(fobj) {
	if (fobj.a_confirm && fobj.a_confirm.value == "F")
		return true;
	var i, elm, aelm, infix;
	var rowcnt = (fobj.key_count) ? Number(fobj.key_count.value) : 1;
	for (i=0; i<rowcnt; i++) {
		infix = (fobj.key_count) ? String(i+1) : "";
		elm = fobj.elements["x" + infix + "_Inv_FirstName"];
		if (elm && !ew_HasValue(elm)) {
			if (!ew_OnError(elm, "Please enter required field - First Name"))
				return false;
		}
		elm = fobj.elements["x" + infix + "_Inv_LastName"];
		if (elm && !ew_HasValue(elm)) {
			if (!ew_OnError(elm, "Please enter required field - Last Name"))
				return false;
		}
		elm = fobj.elements["x" + infix + "_Inv_Address"];
		if (elm && !ew_HasValue(elm)) {
			if (!ew_OnError(elm, "Please enter required field - Billing Address"))
				return false;
		}
		elm = fobj.elements["x" + infix + "_inv_City"];
		if (elm && !ew_HasValue(elm)) {
			if (!ew_OnError(elm, "Please enter required field - City"))
				return false;
		}
		elm = fobj.elements["x" + infix + "_inv_Province"];
		if (elm && !ew_HasValue(elm)) {
			if (!ew_OnError(elm, "Please enter required field - Province"))
				return false;
		}
		elm = fobj.elements["x" + infix + "_inv_PostalCode"];
		if (elm && !ew_HasValue(elm)) {
			if (!ew_OnError(elm, "Please enter required field - Postal Code"))
				return false;
		}
		elm = fobj.elements["x" + infix + "_inv_PhoneNumber"];
		if (elm && !ew_CheckPhone(elm.value)) {
			if (!ew_OnError(elm, "Incorrect phone number - Phone Number"))
				return false;
		}
		elm = fobj.elements["x" + infix + "_inv_EmailAddress"];
		if (elm && !ew_HasValue(elm)) {
			if (!ew_OnError(elm, "Please enter required field - Email Address"))
				return false;
		}
		elm = fobj.elements["x" + infix + "_inv_EmailAddress"];
		if (elm && !ew_CheckEmail(elm.value)) {
			if (!ew_OnError(elm, "Please Enter a Valid Email"))
				return false;
		}
		elm = fobj.elements["x" + infix + "_inv_Fax"];
		if (elm && !ew_CheckPhone(elm.value)) {
			if (!ew_OnError(elm, "Incorrect phone number - Fax"))
				return false;
		}
		elm = fobj.elements["x" + infix + "_UserName"];
		if (elm && !ew_HasValue(elm)) {
			if (!ew_OnError(elm, "Please enter required field - User Name"))
				return false;
		}
		elm = fobj.elements["x" + infix + "_passwrd"];
		if (elm && !ew_HasValue(elm)) {
			if (!ew_OnError(elm, "Please enter required field - passwrd"))
				return false;
		}
		if (fobj.x_passwrd && !ew_HasValue(fobj.x_passwrd)) {
			if (!ew_OnError(fobj.x_passwrd, "Please enter password"))
				return false; 
		}
		if (fobj.c_passwrd.value != fobj.x_passwrd.value) {
			if (!ew_OnError(fobj.c_passwrd, "Mismatch Password"))
				return false; 
		}
	}
		if (fobj.captcha && !ew_HasValue(fobj.captcha)) {
			if (!ew_OnError(fobj.captcha, "Please enter the validation code shown"))
				return false;
		}
	return true;
}

//-->
</script>
<script type="text/javascript">
<!--
var ew_DHTMLEditors = [];
//-->
</script>
<script type="text/javascript">
<!--
var ew_MultiPagePage = "Page"; // multi-page Page Text
var ew_MultiPageOf = "of"; // multi-page Of Text
var ew_MultiPagePrev = "Prev"; // multi-page Prev Text
var ew_MultiPageNext = "Next"; // multi-page Next Text
//-->
</script>
<script language="JavaScript" type="text/javascript">
<!--
// Write your client script here, no need to add script tags.
// To include another .js script, use:
// ew_ClientScriptInclude("my_javascript.js"); 
//-->
</script>
<table  border="0" cellpadding="0" cellspacing="0" id="Table_01">
            <tr>
            <td  width="699" height="75" rowspan="2"><span class="Header">Ferring Privacy Policy</span></td>
              <td width="28" valign="top"><img src="images/fontsize.png" border="0" alt=""> </td>
              <td width="24" valign="top"> <a href="#"
				onmouseover="changeImages('login_13', 'images/login_13-over.jpg'); return true;"
				onmouseout="changeImages('login_13', 'images/font1.png'); return true;"
				onmousedown="changeImages('login_13', 'images/login_13-over.jpg'); return true;"
				onmouseup="changeImages('login_13', 'images/login_13-over.jpg'); return true;" onClick="javascript:setActiveStyleSheet('default'); 
return false;"> <img name="login_13" src="images/font1.png" width="24" height="27" border="0" alt=""></a></td>
              <td width="24"  valign="top"> <a href="#"
				onmouseover="changeImages('login_14', 'images/login_14-over.jpg'); return true;"
				onmouseout="changeImages('login_14', 'images/font2.png'); return true;"
				onmousedown="changeImages('login_14', 'images/login_14-over.jpg'); return true;"
				onmouseup="changeImages('login_14', 'images/login_14-over.jpg'); return true;" onClick="javascript:setActiveStyleSheet('Medium'); 
return false;"> <img name="login_14" src="images/font2.png" width="24" height="27" border="0" alt=""></a></td>
              <td width="26"  valign="top"> <a href="#"
				onmouseover="changeImages('login_15', 'images/login_15-over.jpg'); return true;"
				onmouseout="changeImages('login_15', 'images/font3.png'); return true;"
				onmousedown="changeImages('login_15', 'images/login_15-over.jpg'); return true;"
				onmouseup="changeImages('login_15', 'images/login_15-over.jpg'); return true;" onClick="javascript:setActiveStyleSheet('Large'); 
return false;"><img name="login_15" src="images/font3.png" width="24" height="27" border="0" alt=""></a></td>
            </tr>
            <tr>
              <td colspan="4" valign="top"><div align="right">
                <p><a href="french/privacy.asp" class="bodycopy_small">en fran&ccedil;ais &gt;</a></p>
              </div></td>
              </tr>
        </table>
<p align="justify" class="vslcss">Ferring thanks you for visiting its web site. Because we are committed to respecting the privacy of our web site visitors, this web site Privacy Policy describes the information we may collect from you during your visit to our site, how we may use it, and how we will protect the information which you may opt to provide. This policy explains the efforts to balance our business interests in collecting and using the information we receive from you with your need for appropriate protection and management of any personally identifiable information that you share with us. <br>
    <br>
    <span class="subheading">Personally Identifiable Information</span> <br>
    Personally identifiable information includes your name, address, phone number, e-mail address or any other information which might reasonably be used to identify you individually. Ferring collects personally identifiable information from web site visitors only when it is voluntarily provided. Ferring will not otherwise collect this information from you on our web site. When Ferring receives personally identifiable information, we reserve the right to use it for reasonable business purposes, just as non-Internet businesses do. By providing your personal identifiable information to Ferring via this web site you automatically consent to us using it for such purposes. For example, we may use this information to contact you, via e-mail or regular mail, to provide you with information we believe may be of interest. It might also be used for compiling data and analyses to understand and serve our customers' needs. Data are also compiled to evaluate the use and utility of the services we provide on-line. Your information may be transferred for processing and use to Ferring facilities in other countries and regions of the world. Personally identifiable information will not be sold, rented or exchanged outside of the Ferring Group unless the user is first notified and expressly consents to such transfer. <br><br>
    </p>
<p align="justify" class="vslcss"> <span class="subheading">Concerning Your Privacy</span> <br>
Access to this web site may be monitored by Ferring. If monitored, the requesting URLs, the machine originating the request, and the time of the request, are logged for access statistics and security purposes. Your use and access of this web site constitutes your consent to such general monitoring. Please see Ferring Privacy Policy for details on how information from the web site may be gathered and used. </p>
<p align="justify" class="vslcss"><br>
        <span class="subheading">Collective/Aggregate Data</span> <br>
        The Ferring web site may also collect information from you that is not personally identifiable. For example, we might track information about the date and time visitors access our site, the type of web browser they used, and the web site from which they connected to our site. Our web sites collect this information by depositing certain bits of information called "cookies" in a visitor's computer. This technology does not collect an individual visitor's personally identifiable information. Rather, this information is collected in an aggregate form. The cookies can tell us how and when pages in a web site were visited and by how many people. This aggregate information will enable us to improve our web sites to serve and inform you better. It may also allow you to shortcut access to points of interest on our web site when you re-enter our system. Attaching this device to your system has no effect on how it performs. <br>
        <br>
        Links To Other Sites As a resource to our visitors, Ferring may provide links to other web sites. We try to carefully choose web sites, which we believe are useful and meet our high standards for the accuracy and utility of information. However, because web site design and content can change so quickly, we cannot guarantee the standards of every web site to which we link. Likewise, we are not responsible for the content of any non-Ferring site. We also cannot guarantee the privacy policies of these other sites and suggest you check the privacy policies of those sites directly. <br><br>
</p>
<p align="justify" class="vslcss">          <span class="subheading">Submissions (Information To Ferring) </span><br>
  The submission of any unsolicited information, such as questions, comments, or suggestions, to Ferring, either through this web site or by any other means of communication, shall NOT be considered confidential. Ferring shall have no obligation to you of any kind with respect to such information. By submitting any information to Ferring, you understand that Ferring shall be free to reproduce, use, disclose, display, exhibit, transmit, perform, create derivative works, and distribute the information to others without limitation, and to authorise others to do the same. In addition, Ferring shall be free to use any ideas, concepts, know-how or techniques contained in such information for any purpose whatsoever, including but not limited to, developing, manufacturing and marketing products and other items incorporating such ideas, concepts, know-how or techniques.<br><br> </p><p align="justify" class="vslcss">        <span class="subheading">Choice</span> <br>
        If you wish to stop receiving any e-mails or other communications from Ferring which may be sent to you in the future based on your request for this information, or if you have submitted personally identifiable information through a Ferring web site and would like to have that information deleted from our records, please notify Ferring's Privacy Officer. Your wishes in these matters will be honoured. <br>
        <br>
        <span class="subheading">Accuracy</span> <br>
        Ferring will make every effort to maintain the accuracy and confidentiality of any personal information you supply to us. If you wish to make additions or other corrections to the information that you have sent in, please notify Ferring's Privacy Officer. <br>
        <br>
        <span class="subheading">Security</span> <br>
        All information transmitted to this Ferring web site is secure to the extent possible using existing technology. Unauthorised third parties should not be able to access it during transmission. We will store the information that you share with us securely and will take appropriate steps to protect it from unauthorised access or disclosure. While no security steps can offer 100 percent protection, we utilise state-of-the-art technology and systems to prevent unauthorised access to the information we hold. We will limit access to this information to those Ferring personnel with a need to know. We educate our staff about their duty to protect your privacy. <br>
        <br>
        <span class="subheading">Children</span> <br>
        Ferring does not intentionally collect or retain personally identifiable information about children who are younger than 18 years of age. If your child may have submitted information to us without indicating their actual age, and you would like it removed, please advise Ferring's Privacy Officer and we will delete it immediately. <br>
        <br>
        <span class="subheading">Changes</span> <br>
        Any changes to this privacy policy will be communicated promptly at this location. Please check the privacy page periodically to review any changes that may have been made. <br>
        <br>
        Thank you for visiting the Ferring web site. We value your interest and ideas. If you have any comments or concerns regarding the use of information provided to Ferring via an Internet site, please contact the Privacy Officer.<br><br></p>
<p><span class="subheading">Regular mail</span> <br>
  Privacy Officer <br>
  Ferring Inc. <br>
  200 Yorkland Blvd., Suite 500 <br>
  Toronto, Ontario <br>
  M2J 5C1 </p>
<p>Email <br>
    <a href="mailto:Privacy.officer@ferring.com">Privacy.officer@ferring.com </a></p>
	<%if(Month(now()) & year(now())="92009") then response.write "Date"%>
<!--#include file="footer.asp"-->
<script language="JavaScript" type="text/javascript">
<!--
// Write your startup script here
// document.write("page loaded");
//-->
</script>
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

' Load default values
Function LoadDefaultValues()
	Customers.inv_Country.CurrentValue = "Canada"
End Function
%>
<%

' Load form values
Function LoadFormValues()

	' Load from form
	Customers.Inv_FirstName.FormValue = objForm.GetValue("x_Inv_FirstName")
	Customers.Inv_LastName.FormValue = objForm.GetValue("x_Inv_LastName")
	Customers.Inv_Address.FormValue = objForm.GetValue("x_Inv_Address")
	Customers.Inv_Address2.FormValue = objForm.GetValue("x_Inv_Address2")
	Customers.inv_City.FormValue = objForm.GetValue("x_inv_City")
	Customers.inv_Province.FormValue = objForm.GetValue("x_inv_Province")
	Customers.inv_PostalCode.FormValue = objForm.GetValue("x_inv_PostalCode")
	Customers.inv_Country.FormValue = objForm.GetValue("x_inv_Country")
	Customers.inv_PhoneNumber.FormValue = objForm.GetValue("x_inv_PhoneNumber")
	Customers.inv_EmailAddress.FormValue = objForm.GetValue("x_inv_EmailAddress")
	Customers.inv_Fax.FormValue = objForm.GetValue("x_inv_Fax")
	Customers.UserName.FormValue = objForm.GetValue("x_UserName")
	Customers.passwrd.FormValue = objForm.GetValue("x_passwrd")
End Function

' Restore form values
Function RestoreFormValues()
	Customers.Inv_FirstName.CurrentValue = Customers.Inv_FirstName.FormValue
	Customers.Inv_LastName.CurrentValue = Customers.Inv_LastName.FormValue
	Customers.Inv_Address.CurrentValue = Customers.Inv_Address.FormValue
	Customers.Inv_Address2.CurrentValue = Customers.Inv_Address2.FormValue
	Customers.inv_City.CurrentValue = Customers.inv_City.FormValue
	Customers.inv_Province.CurrentValue = Customers.inv_Province.FormValue
	Customers.inv_PostalCode.CurrentValue = Customers.inv_PostalCode.FormValue
	Customers.inv_Country.CurrentValue = Customers.inv_Country.FormValue
	Customers.inv_PhoneNumber.CurrentValue = Customers.inv_PhoneNumber.FormValue
	Customers.inv_EmailAddress.CurrentValue = Customers.inv_EmailAddress.FormValue
	Customers.inv_Fax.CurrentValue = Customers.inv_Fax.FormValue
	Customers.UserName.CurrentValue = Customers.UserName.FormValue
	Customers.passwrd.CurrentValue = Customers.passwrd.FormValue
End Function
%>
<%

' Render row values based on field settings
Sub RenderRow()

	' Call Row Rendering event
	Call Customers.Row_Rendering()

	' Common render codes for all row types
	' Inv_FirstName

	Customers.Inv_FirstName.CellCssStyle = ""
	Customers.Inv_FirstName.CellCssClass = ""

	' Inv_LastName
	Customers.Inv_LastName.CellCssStyle = ""
	Customers.Inv_LastName.CellCssClass = ""

	' Inv_Address
	Customers.Inv_Address.CellCssStyle = ""
	Customers.Inv_Address.CellCssClass = ""

	' Inv_Address2
	Customers.Inv_Address2.CellCssStyle = ""
	Customers.Inv_Address2.CellCssClass = ""

	' inv_City
	Customers.inv_City.CellCssStyle = ""
	Customers.inv_City.CellCssClass = ""

	' inv_Province
	Customers.inv_Province.CellCssStyle = ""
	Customers.inv_Province.CellCssClass = ""

	' inv_PostalCode
	Customers.inv_PostalCode.CellCssStyle = ""
	Customers.inv_PostalCode.CellCssClass = ""

	' inv_Country
	Customers.inv_Country.CellCssStyle = ""
	Customers.inv_Country.CellCssClass = ""

	' inv_PhoneNumber
	Customers.inv_PhoneNumber.CellCssStyle = ""
	Customers.inv_PhoneNumber.CellCssClass = ""

	' inv_EmailAddress
	Customers.inv_EmailAddress.CellCssStyle = ""
	Customers.inv_EmailAddress.CellCssClass = ""

	' inv_Fax
	Customers.inv_Fax.CellCssStyle = ""
	Customers.inv_Fax.CellCssClass = ""

	' UserName
	Customers.UserName.CellCssStyle = ""
	Customers.UserName.CellCssClass = ""

	' passwrd
	Customers.passwrd.CellCssStyle = ""
	Customers.passwrd.CellCssClass = ""
	If Customers.RowType = EW_ROWTYPE_VIEW Then ' View row
	ElseIf Customers.RowType = EW_ROWTYPE_ADD Then ' Add row

		' Inv_FirstName
		Customers.Inv_FirstName.EditCustomAttributes = ""
		Customers.Inv_FirstName.EditValue = ew_HtmlEncode(Customers.Inv_FirstName.CurrentValue)

		' Inv_LastName
		Customers.Inv_LastName.EditCustomAttributes = ""
		Customers.Inv_LastName.EditValue = ew_HtmlEncode(Customers.Inv_LastName.CurrentValue)

		' Inv_Address
		Customers.Inv_Address.EditCustomAttributes = ""
		Customers.Inv_Address.EditValue = ew_HtmlEncode(Customers.Inv_Address.CurrentValue)

		' Inv_Address2
		Customers.Inv_Address2.EditCustomAttributes = ""
		Customers.Inv_Address2.EditValue = ew_HtmlEncode(Customers.Inv_Address2.CurrentValue)

		' inv_City
		Customers.inv_City.EditCustomAttributes = ""
		Customers.inv_City.EditValue = ew_HtmlEncode(Customers.inv_City.CurrentValue)

		' inv_Province
		Customers.inv_Province.EditCustomAttributes = ""
		sSqlWrk = "SELECT [Prov], [Province] FROM [Province]"
		sSqlWrk = sSqlWrk & " ORDER BY [Province] Asc"
		Set rswrk = Server.CreateObject("ADODB.Recordset")
		rswrk.Open sSqlWrk, conn
		If Not rswrk.Eof Then
			arwrk = rswrk.GetRows
		Else
			arwrk = ""
		End If
		rswrk.Close
		Set rswrk = Nothing
		arwrk = ew_AddItemToArray(arwrk, 0, Array("", "Please Select"))
		Customers.inv_Province.EditValue = arwrk

		' inv_PostalCode
		Customers.inv_PostalCode.EditCustomAttributes = ""
		Customers.inv_PostalCode.EditValue = ew_HtmlEncode(Customers.inv_PostalCode.CurrentValue)

		' inv_Country
		Customers.inv_Country.EditCustomAttributes = ""
		Customers.inv_Country.EditValue = ew_HtmlEncode(Customers.inv_Country.CurrentValue)

		' inv_PhoneNumber
		Customers.inv_PhoneNumber.EditCustomAttributes = ""
		Customers.inv_PhoneNumber.EditValue = ew_HtmlEncode(Customers.inv_PhoneNumber.CurrentValue)

		' inv_EmailAddress
		Customers.inv_EmailAddress.EditCustomAttributes = ""
		Customers.inv_EmailAddress.EditValue = ew_HtmlEncode(Customers.inv_EmailAddress.CurrentValue)

		' inv_Fax
		Customers.inv_Fax.EditCustomAttributes = ""
		Customers.inv_Fax.EditValue = ew_HtmlEncode(Customers.inv_Fax.CurrentValue)

		' UserName
		Customers.UserName.EditCustomAttributes = ""
		Customers.UserName.EditValue = ew_HtmlEncode(Customers.UserName.CurrentValue)

		' passwrd
		Customers.passwrd.EditCustomAttributes = ""
		Customers.passwrd.EditValue = Customers.passwrd.CurrentValue
	ElseIf Customers.RowType = EW_ROWTYPE_EDIT Then ' Edit row
	ElseIf Customers.RowType = EW_ROWTYPE_SEARCH Then ' Search row
	End If

	' Call Row Rendered event
	Call Customers.Row_Rendered()
End Sub
%>
<%

' Add record
Function AddRow()
	On Error Resume Next
	Dim rs, sSql, sFilter
	Dim rsnew
	Dim bCheckKey, sSqlChk, sWhereChk, rsChk
	Dim bInsertRow

	' Check if valid user id
	Dim bValidUser
	bValidUser = False
	If Security.CurrentUserID <> "" And Not Security.IsAdmin Then ' Non system admin
		bValidUser = Security.IsValidUserID(Customers.CustomerID.CurrentValue)
		If Not bValidUser Then
			Session(EW_SESSION_MESSAGE) = "Unauthorized"
			AddRow = False
			Exit Function
		End If
	End If

	' Check for duplicate key
	bCheckKey = True
	sFilter = Customers.SqlKeyFilter
	If Customers.CustomerID.CurrentValue = "" Or IsNull(Customers.CustomerID.CurrentValue) Then
		bCheckKey = False
	Else
		sFilter = Replace(sFilter, "@CustomerID@", ew_AdjustSql(Customers.CustomerID.CurrentValue)) ' Replace key value
	End If
	If Not IsNumeric(Customers.CustomerID.CurrentValue) Then
		bCheckKey = False
	End If
	If bCheckKey Then
		Set rsChk = Customers.LoadRs(sFilter)
		If Not (rsChk Is Nothing) Then
			Session(EW_SESSION_MESSAGE) = "Duplicate value for primary key"
			rsChk.Close
			Set rsChk = Nothing
			AddRow = False
			Exit Function
		End If
	End If

	' Add new record
	sFilter = "(0 = 1)"
	Customers.CurrentFilter = sFilter
	sSql = Customers.SQL
	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.CursorLocation = EW_CURSORLOCATION
	rs.Open sSql, conn, 1, 2
	rs.AddNew
	If Err.Number <> 0 Then
		Session(EW_SESSION_MESSAGE) = Err.Description
		rs.Close
		Set rs = Nothing
		AddRow = False
		Exit Function
	End If

	' Field Inv_FirstName
	Call Customers.Inv_FirstName.SetDbValue(Customers.Inv_FirstName.CurrentValue, Null)
	rs("Inv_FirstName") = Customers.Inv_FirstName.DbValue

	' Field Inv_LastName
	Call Customers.Inv_LastName.SetDbValue(Customers.Inv_LastName.CurrentValue, Null)
	rs("Inv_LastName") = Customers.Inv_LastName.DbValue

	' Field Inv_Address
	Call Customers.Inv_Address.SetDbValue(Customers.Inv_Address.CurrentValue, Null)
	rs("Inv_Address") = Customers.Inv_Address.DbValue

	' Field Inv_Address2
	Call Customers.Inv_Address2.SetDbValue(Customers.Inv_Address2.CurrentValue, Null)
	rs("Inv_Address2") = Customers.Inv_Address2.DbValue

	' Field inv_City
	Call Customers.inv_City.SetDbValue(Customers.inv_City.CurrentValue, Null)
	rs("inv_City") = Customers.inv_City.DbValue

	' Field inv_Province
	Call Customers.inv_Province.SetDbValue(Customers.inv_Province.CurrentValue, Null)
	rs("inv_Province") = Customers.inv_Province.DbValue

	' Field inv_PostalCode
	Call Customers.inv_PostalCode.SetDbValue(Customers.inv_PostalCode.CurrentValue, Null)
	rs("inv_PostalCode") = Customers.inv_PostalCode.DbValue

	' Field inv_Country
	Call Customers.inv_Country.SetDbValue(Customers.inv_Country.CurrentValue, Null)
	rs("inv_Country") = Customers.inv_Country.DbValue

	' Field inv_PhoneNumber
	Call Customers.inv_PhoneNumber.SetDbValue(Customers.inv_PhoneNumber.CurrentValue, Null)
	rs("inv_PhoneNumber") = Customers.inv_PhoneNumber.DbValue

	' Field inv_EmailAddress
	Call Customers.inv_EmailAddress.SetDbValue(Customers.inv_EmailAddress.CurrentValue, Null)
	rs("inv_EmailAddress") = Customers.inv_EmailAddress.DbValue

	' Field inv_Fax
	Call Customers.inv_Fax.SetDbValue(Customers.inv_Fax.CurrentValue, Null)
	rs("inv_Fax") = Customers.inv_Fax.DbValue

	' Field UserName
	Call Customers.UserName.SetDbValue(Customers.UserName.CurrentValue, Null)
	rs("UserName") = Customers.UserName.DbValue

	' Field passwrd
	Call Customers.passwrd.SetDbValue(Customers.passwrd.CurrentValue, Null)
	rs("passwrd") = Customers.passwrd.DbValue

	' Check recordset update error
	If Err.Number <> 0 Then
		Session(EW_SESSION_MESSAGE) = Err.Description
		rs.Close
		Set rs = Nothing
		AddRow = False
		Exit Function
	End If

	' Call Row Inserting event
	bInsertRow = Customers.Row_Inserting(rs)
	If bInsertRow Then

		' Clone new rs object
		Set rsnew = ew_CloneRs(rs)
		rs.Update
		If Err.Number <> 0 Then
			Session(EW_SESSION_MESSAGE) = Err.Description
			AddRow = False
		Else
			AddRow = True
		End If
	Else
		rs.CancelUpdate
		If Customers.CancelMessage <> "" Then
			Session(EW_SESSION_MESSAGE) = Customers.CancelMessage
			Customers.CancelMessage = ""
		Else
			Session(EW_SESSION_MESSAGE) = "Insert cancelled"
		End If
		AddRow = False
	End If
	rs.Close
	Set rs = Nothing
	If AddRow Then
		Customers.CustomerID.DbValue = rsnew("CustomerID")

		' Call Row Inserted event
		Call Customers.Row_Inserted(rsnew)
	End If
	If IsObject(rsnew) Then
		rsnew.Close
		Set rsnew = Nothing
	End If
End Function
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
