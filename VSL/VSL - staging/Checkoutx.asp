<%@ Language=VBScript %>
<!--#include file="vslConfig.asp"-->
<!--#include file="aspfn60.asp"-->
<!--#include file="ewcfg60.asp"-->
<!--#include file="Customersinfo.asp"-->
<!--#include file="cartinc.asp"-->
<!--#include file="header.asp"--> 
<!--#include file="userfn60.asp"-->
              <script language="JavaScript" type="text/JavaScript">
function copyAddress()
{
	//if(!formCheckout.CheckLocalPickup.checked)
	//{

        var unit = formCheckout.Inv_Address2.value;
        var arr = [' buzzer',' buzz',' Buzzer',' Buzz'];

        if(unit == ''){        
            //DO NOTHING  
        }else{
            for(i = 0; i < arr.length; i++) { 
                var found = unit.includes(arr[i]);
                console.log(found);
                if(found){            
                    //BUZZER FOUND
                    //console.log('Found');
                    var unit_array = unit.split(arr[i]);
                    formCheckout.ship_Address2.value=unit_array[0];
                    formCheckout.Buzzer.value=(unit_array[1]).replace(":","");  
                    break;                  
                }else{
                    //BUZZER NOT FOUND
                    //console.log('Not Found');
                    formCheckout.ship_Address2.value=formCheckout.Inv_Address2.value;
                }
            }
        }

		formCheckout.ship_FirstName.value=formCheckout.Inv_FirstName.value;
		formCheckout.ship_LastName.value=formCheckout.Inv_LastName.value;
		formCheckout.ship_Address.value=formCheckout.Inv_Address.value;		
		formCheckout.ship_City.value=formCheckout.inv_City.value;
		// formCheckout.ship_Province.value=formCheckout.inv_Province.value;
	 
		formCheckout.ship_Province.selectedIndex=formCheckout.inv_Province.selectedIndex;
		formCheckout.ship_PostalCode.value=formCheckout.inv_PostalCode.value;
	    formCheckout.ship_Country.value=formCheckout.inv_Country.value;
		
		formCheckout.HomePhone.value= formCheckout.inv_PhoneNumber.value;
	//}
}
function localAddress()
{
	/*if(formCheckout.CheckLocalPickup.checked)
	{
		formCheckout.ship_FirstName.value=formCheckout.Inv_FirstName.value;
		formCheckout.ship_FirstName.disabled=true ;
		formCheckout.ship_LastName.value=formCheckout.Inv_LastName.value;
		formCheckout.ship_LastName.disabled=true ;
		formCheckout.ship_Address.value="200 YorkLand";
		formCheckout.ship_Address.disabled=true ;
		formCheckout.ship_Address2.value="Suite:500";
		formCheckout.ship_Address2.disabled=true ;
		formCheckout.ship_City.value="Toronto";
		formCheckout.ship_City.disabled=true ;
	 // formCheckout.ship_Province.value=formCheckout.inv_Province.value;
	 
		formCheckout.ship_Province.selectedIndex=9;
		formCheckout.ship_Province.disabled=true ;
		formCheckout.ship_PostalCode.value="M2J5C1";
		formCheckout.ship_PostalCode.disabled=true ;
	    formCheckout.ship_Country.value="Canada";
		formCheckout.ship_Country.disabled=true ;
		
		formCheckout.HomePhone.value= "416 642-0075";
		formCheckout.HomePhone.disabled=true ;
		
		
	}
	else
	{
		formCheckout.ship_FirstName.disabled=false ;
		formCheckout.ship_LastName.disabled=false ;
		formCheckout.ship_Address.disabled=false ;
		formCheckout.ship_Address2.disabled=false ;
		formCheckout.ship_City.disabled=false ;
		formCheckout.ship_Province.disabled=false ;
		formCheckout.ship_PostalCode.disabled=false ;
		formCheckout.ship_Country.disabled=false ;
		formCheckout.HomePhone.disabled=false ;
	}
	*/
}

</script> 
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_validateForm() { //v4.0    
    var currentBuzzer = $('#Buzzer').val();
    // var add2 = $('#ship_Address2').val();
    // var newStr = add2 + ' Buzz:' + currentBuzzer;
    // $('#ship_Address2').val(newStr);

    
    var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;

    if(currentBuzzer === '' || currentBuzzer === null){
        errors += '- Buzzer is required.\n';
    }else{
        var add2 = $('#ship_Address2').val();
        var newStr = add2 + ' Buzz:' + currentBuzzer;
        $('#ship_Address2').val(newStr);
    }

    for (i=0; i<(args.length-2); i+=3) { test=args[i+2]; val=MM_findObj(args[i]);
    if (val) { nm=val.name; if ((val=val.value)!="") {
      if (test.indexOf('isEmail')!=-1) { p=val.indexOf('@');
        if (p<1 || p==(val.length-1)) errors+='- '+nm+' must contain an e-mail address.\n';
      } else if (test!='R') { num = parseFloat(val);
        if (isNaN(val)) errors+='- '+nm+' must contain a number.\n';
        if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
          min=test.substring(8,p); max=test.substring(p+1);
          if (num<min || max<num) errors+='- '+nm+' must contain a number between '+min+' and '+max+'.\n';
    } } } else if (test.charAt(0) == 'R') errors += '- '+nm+' is required.\n'; }
  } if (errors) alert('The following error(s) occurred:\n'+errors);
  document.MM_returnValue = (errors == '');
}
function PaypalSubmit(){
MM_validateForm('Inv_FirstName','','R','Inv_LastName','','R','Inv_Address','','R','inv_City','','R','inv_Province','','R','inv_PostalCode','','R','inv_Country','','R','inv_PhoneNumber','','R','inv_EmailAddress','','RisEmail','ship_FirstName','','R','ship_LastName','','R','ship_Address','','R','ship_City','','R','ship_Province','','R','ship_PostalCode','','R','ship_Country','','R');

if(document.MM_returnValue) {
document.formCheckout.action="paypalx.asp";
document.formCheckout.onSubmit="";
document.formCheckout.submit();
}
return false;
	}


function checkAddress(){
    var currentBuzzer = $('#Buzzer').val();
    if(needBuzzer() && currentBuzzer == ""){
       // $('#Buzzer').val('N/A');
        alert('It looks like you may need to include a buzzer number. If not, please input N/A.');
    }else{
        //Ignore
    }
}


function needBuzzer(){
    var str = $('#ship_Address').val();
    var str2 = $('#ship_Address2').val();
    var res = str.toLowerCase();
    var res2 = str2.toLowerCase();
    var arr = ['apartment','appartement','suite','bureau','unit','unite','unité','unitÃ©'];
    if(res2 == ''){        
        for(i = 0; i < arr.length; i++) { 
            var found = res.includes(arr[i]);
            if(found){
                return found;
            }
        }  
    }else{
        for(i = 0; i < arr.length; i++) { 
            var found = res2.includes(arr[i]);
            console.log(found);
            if(found){            
                return found;
            }
        }
    $('#ship_Address2').val('Unit '+ res2);
    return true;    
    }      
}



//-->
</script>
              <table  width="820" border="0" cellpadding="0" cellspacing="0" id="Table_01"> 
                <tr> 
                  <td width="680" rowspan="2"><img src="images/title_shipping.png" width="410" height="75"></td> 
               <!--   <td width="28" valign="top"><img src="images/fontsize.png" border="0" alt=""> </td> 
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
                    <p><a href="french/Checkout.asp" class="bodycopy_small">en fran&ccedil;ais &gt;</a></p>
                  </div></td>-->
                </tr> 
              </table> 
              <div align="right"><span class="vslcss"><a href="VSLOrderForm.asp">Back to Products</a> : <a href="vslCart.asp">View Cart</a> : <a href="Customersedit.asp">Edit account</a> : <a href="changepwd.asp">Change Password</a> : <a href="logout.asp">logout</a><img src="images/spacer.gif" width="65" height="10"> 
                <%

Dim promomsg			
dim conn
Set conn = Server.CreateObject("ADODB.Connection")
conn.Open EW_DB_CONNECTION_STRING


conn.execute " UPDATE Orders SET Orders.PromoCodeUsed = '' WHERE (((Orders.Ordered_Date)<DateAdd('h',-24,Now())) AND ((Orders.payment_status)='WIP')) ;"
'conn.execute " delete * from orderdetails where orderid in( select orderid FROM Orders WHERE (((Orders.Ordered_Date)<DateAdd('h',-168,Now())) AND ((Orders.payment_status)='WIP')) OR (((Orders.payment_status)='Cancelled')));"
'conn.execute "delete * FROM Orders WHERE (((Orders.Ordered_Date)<DateAdd('h',-168,Now())) AND ((Orders.payment_status)='WIP')) OR (((Orders.payment_status)='Cancelled')); "

conn.execute " delete * from orderdetails where orderid in( select orderid FROM Orders WHERE  (((Orders.payment_status)='Cancelled')));"
conn.execute "delete * FROM Orders WHERE  (((Orders.payment_status)='Cancelled')); "


Dim Security
Set Security = New cAdvancedSecurity

%> 
                <%
If Not Security.IsLoggedIn() Then Call Security.AutoLogin()
	If Not Security.IsLoggedIn() Then
		Call Security.SaveLastUrl()
		Call Page_Terminate("login.asp")
	End If

	shipvalues =request.form("shipvalues")
	if(shipvalues<>"") then
		shipvalue= split(shipvalues,"||")
		ship1=shipvalue(0)
		ship2=shipvalue(1)
		ship3=shipvalue(2)
		ship4=shipvalue(3)
		ship5=shipvalue(4)
		ship6=shipvalue(5)
		ship7=shipvalue(6)
		ship8=shipvalue(7)
		ship9=shipvalue(8)
	else
		ship1=""
		ship2=""
		ship3=""
		ship4=""
		ship5=""
		ship6=""
		ship7=""
		ship8=""
		ship9=""
		
	end if

	call getAddress (conn)

function getAddress(c)
	dim rs,strSql
	Set rs = Server.CreateObject("ADODB.Recordset")
	strSql= "SELECT QAddress.Inv_FirstName, QAddress.Inv_LastName, QAddress.Inv_Address, QAddress.Inv_Address2, "
	strSql= strSql & " QAddress.inv_City, QAddress.inv_Province, QAddress.inv_PostalCode, QAddress.inv_Country, "
	strSql= strSql & " QAddress.inv_PhoneNumber, QAddress.inv_EmailAddress, QAddress.inv_Fax, QAddress.ship_FirstName,"
	strSql= strSql & " 	QAddress.ship_LastName, QAddress.ship_Address, QAddress.ship_Address2, QAddress.ship_City, "
	strSql= strSql & " QAddress.ship_Province, QAddress.ship_PostalCode, QAddress.ship_Country, QAddress.HomePhone, "
	strSql= strSql & " QAddress.Customers.CustomerId FROM QAddress "
	strSql= strSql & " WHERE (((QAddress.Customers.CustomerId)=" & Security.CurrentUserID & "));"

	rs.Open strSql, c, 1, 2 
	if(not rs.eof) then %> 
    </span> </div> 
        <form  method="post" action="paypalx.asp" name="formCheckout" id="formCheckout" onSubmit="MM_validateForm('Inv_FirstName','','R','Inv_LastName','','R','Inv_Address','','R','inv_City','','R','inv_Province','','R','inv_PostalCode','','R','inv_Country','','R','inv_PhoneNumber','','R','inv_EmailAddress','','RisEmail','ship_FirstName','','R','ship_LastName','','R','ship_Address','','R','ship_City','','R','ship_Province','','R','ship_PostalCode','','R','ship_Country','','R');return document.MM_returnValue"> 
        <table width="720"  border="0" cellspacing="0" cellpadding="0"> 
            <tr> 
            <td valign="top"><li class="t"> 
            <table width="360"  border="0" cellpadding="0" cellspacing="0" class="ewTableNoBorder"> 
            <tr> 
            <td colspan="2"><strong><font size="+1">Billing Address </font></strong> <a href="Customersedit.asp">(edit)</a>
              <input type="hidden" name="SubmitSecure" id="SubmitSecure" value="Proceed to Secure Checkout">
           </td> 
            </tr> 
            <tr> 
            <td colspan="2" height="10px"></td> 
            </tr> 
            <tr> 
                <td width="116">First Name </td> 
                <td width="244"><input name="Inv_FirstName" type="text" id="Inv_FirstName" value="<%=rs("Inv_FirstName")%>" size="20" readonly></td> 
            </tr> 
            <tr> 
                <td width="116">Last Name </td> 
                <td width="244"><input name="Inv_LastName" type="text" id="Inv_LastName" value="<%=rs("Inv_LastName")%>" size="20" readonly></td> 
            </tr> 
            <tr> 
                <td width="116">Address</td> 
                <td width="244"><input name="Inv_Address" type="text" id="Inv_Address" value="<%=rs("Inv_Address")%>" size="20" disabled></td> 
            </tr> 
            <tr> 
                <td width="116">Unit/Suite</td> 
                <td width="244"><input name="Inv_Address2" type="text" id="Inv_Address2" value="<%=rs("Inv_Address2")%>" size="20" disabled></td> 
            </tr> 
            <tr> 
                <td width="116">City</td> 
                <td width="244"><input name="inv_City" type="text" id="inv_City" value="<%=rs("inv_City")%>" size="20" disabled></td> 
            </tr> 
            <tr> 
                <td width="116">Province</td> 
                <td width="244"> 
                <select id='inv_Province' name='inv_Province' disabled> 
                    <option value="" > Please Select </option> 
                    <option value="AB" <%if(rs("inv_Province")="AB") then response.Write "Selected"%>> Alberta </option> 
                    <option value="BC" <%if(rs("inv_Province")="BC") then response.Write "Selected"%>> British Columbia </option> 
                    <option value="MB" <%if(rs("inv_Province")="MB") then response.Write "Selected"%>> Manitoba </option> 
                    <option value="NB" <%if(rs("inv_Province")="NB") then response.Write "Selected"%>> New Brunswick </option> 
                    <option value="NL" <%if(rs("inv_Province")="NL") then response.Write "Selected"%>> Newfoundland and Labrador </option> 
                    <option value="NT" <%if(rs("inv_Province")="NT") then response.Write "Selected"%>> Northwest Territories </option> 
                    <option value="NS" <%if(rs("inv_Province")="NS") then response.Write "Selected"%>> Nova Scotia </option> 
                    <option value="NU" <%if(rs("inv_Province")="NU") then response.Write "Selected"%>> Nunavut </option> 
                    <option value="ON" <%if(rs("inv_Province")="ON") then response.Write "Selected"%>> Ontario </option> 
                    <option value="PE" <%if(rs("inv_Province")="PE") then response.Write "Selected"%>> Prince Edward Island </option> 
                    <option value="QC" <%if(rs("inv_Province")="QC") then response.Write "Selected"%>> Quebec </option> 
                    <option value="SK" <%if(rs("inv_Province")="SK") then response.Write "Selected"%>> Saskatchewan </option> 
                    <option value="YT" <%if(rs("inv_Province")="YT") then response.Write "Selected"%>> Yukon </option> 
                </select> </td> 
            </tr> 
            <tr> 
                <td width="116">Postal code </td> 
                <td width="244"><input name="inv_PostalCode" type="text" id="inv_PostalCode" value="<%=rs("inv_PostalCode")%>" size="20" disabled></td> 
            </tr> 
            <tr> 
                <td width="116">Country</td> 
                <td width="244"><input name="inv_Country" type="text" id="inv_Country" value="<%=rs("inv_Country")%>" size="20" disabled></td> 
            </tr> 
            <tr> 
                <td width="116">Phone</td> 
                <td width="244"><input name="inv_PhoneNumber" type="text" id="inv_PhoneNumber" value="<%=rs("inv_PhoneNumber")%>" size="20" disabled></td> 
            </tr> 
            <tr> 
                <td width="116">Email</td> 
                <td width="244"><input name="inv_EmailAddress" type="text" id="inv_EmailAddress" value="<%=rs("inv_EmailAddress")%>" size="20" disabled></td> 
            </tr> 
            </table> 
            </li></td> 
            <td valign="top"><li class="t">
            <table width="360"  border="0" cellpadding="0" cellspacing="0" class="ewTableNoBorder"> 
            <tr> 
                <td colspan="2"><strong><font size="+1">Shipping Address</font></strong></td> 
            </tr> 
            <tr> 
                <td colspan="2" height="10px"><table align="left" border="0" cellspacing="0" cellpadding="0" width="100%">

	<tr align="left" valign="top">
		<td width="50%"><input name="copyaddress" type="button" onClick="javascript:copyAddress();" value="Same as Billing"></td>
		<td width="50%"> <!--<input type="checkbox" name="CheckLocalPickup" id="CheckLocalPickup" onClick="javascript:localAddress();" value="on"><span class="aspmaker">Toronto local pickup only</span>--></td>
	</tr>
</table>
	</td> 
    </tr> 
    <tr> 
        <td width="123">First Name</td> 
        <td width="237"><input name="ship_FirstName" type="text" id="ship_FirstName" size="20" value="<%=ship1%>"></td> 
    </tr> 
    <tr> 
        <td width="123">Last Name</td> 
        <td width="237"><input name="ship_LastName" type="text" id="ship_LastName" size="20" value="<%=ship2%>"></td> 
    </tr> 
    <tr> 
        <td width="123">Address</td> 
        <td width="237"><input name="ship_Address" type="text" id="ship_Address" onblur="checkAddress()" size="20" value="<%=ship3%>"></td> 
    </tr> 
    <tr> 
        <td width="123">Unit/Suite</td> 
        <td width="237"><input name="ship_Address2" type="text" id="ship_Address2" onblur="checkAddress()" size="20" value="<%=ship4%>"></td> 
    </tr> 
    <tr> 
        <td width="116">Buzzer**</td> 
        <td width="244"><input name="Buzzer" type="text" id="Buzzer" value="" size="20"></td> 
    </tr>
    <tr> 
        <td width="123">City</td> 
        <td width="237"><input name="ship_City" type="text" id="ship_City" size="20" value="<%=ship5%>"></td> 
    </tr> 
    <tr> 
        <td width="123">Province</td> 
        <td width="237"><select id='ship_Province' name='ship_Province'> 
        <option value="" selected > Please Select </option> 
                                  <option value="AB" > Alberta </option> 
                                  <option value="BC" > British Columbia </option> 
                                  <option value="MB" > Manitoba </option> 
                                  <option value="NB" > New Brunswick </option> 
                                  <option value="NL" > Newfoundland and Labrador </option> 
                                  <option value="NT" > Northwest Territories </option> 
                                  <option value="NS" > Nova Scotia </option> 
                                  <option value="NU" > Nunavut </option> 
                                  <option value="ON" > Ontario </option> 
                                  <option value="PE" > Prince Edward Island </option> 
                                  <option value="QC" > Quebec </option> 
                                  <option value="SK" > Saskatchewan </option> 
                                  <option value="YT" > Yukon </option> 
                              </select></td></tr> 
                          <tr> 
                            <td width="123">Postal Code </td> 
                            <td width="237"><input name="ship_PostalCode" type="text" id="ship_PostalCode" size="20" value="<%=ship7%>"></td> 
                          </tr> 
                          <tr> 
                            <td width="123">Country</td> 
                            <td width="237"><input name="ship_Country" type="text" id="ship_Country"  size="20" value="<%=ship8%>">
                            </td> 
                          </tr> 
                          <tr> 
                            <td width="123">Phone</td> 
                            <td width="237"><input name="HomePhone" type="text" id="HomePhone" size="20" value="<%=ship9%>"></td> 
                          </tr> 
                          <tr> 
                            <td>&nbsp;</td> 
                            <td>&nbsp;</td> 
                          </tr> 
                        </table> 
                        <p style="font-size:12px;color:#333333;">**Must be set if the address contains a suite number<br>
                        Type N/A if there is no buzzer number</p>
                      </li></td> 
                  </tr>  </table></form><form name="promo" method="post" id="promoform" onSubmit="javascript:fillship();"><input type="hidden" name="shipvalues" id="shipvalues" value="" /><table>
                  <tr> 
                    <td colspan="2" class="vslcss"><div class="t">
					   <%if((Month(now())=12) and (day(now())<16) and (year(now())=2016)) then %>
						<p style="background-color: #FFFFCC;"><font color="#FF0000" size="+1" >Annual Sale </font></p>
						<p style="background-color: #FFFFCC;"><font color="#FF0000" size="+1" >Until December 15th, 2016 or while supplies last</font></p>
						<p style="background-color: #FFFFCC;"><font color="#FF0000" size="+1" >To our valued customers,  Ferring is  pleased to announce our Anniversary Sale on VSL#3.  </font></p>
						<p style="background-color: #FFFFCC;"><font color="#FF0000"  >Until December 15th, 2016, with every 3 cartons of VSL#3  you purchase, you will receive a 4th carton at no charge while supplies last.  

</font></p>
						
					<%end if%>
					<br>
         
                 <!--<span class="ewmsg"> ATTENTION! <br>The final day for ordering VSL#3 in 2016 for next-day delivery will be Wednesday December 21, 2016. All orders placed after this date will be delivered once next-day deliveries are resumed in January 3, 2017.

                 <br>
</span>-->
                 

                      <p><font size="2">You will receive confirmation of receipt of your order by Email.
                          </font></p>

                      <p><font size="2">Post office boxes will NOT be accepted as a delivery address
                          </font></p>

                      <font size="2">
                     <p><strong>Please be advised that you will need to have someone at the delivery address the day of the delivery to receive the package and ensure it is kept refrigerated.</strong> </p>
                      <p >The order will be packed in an insulated package with ice packs to maintain storage temperature requirements and will be delivered by courier. </p>
              
			  
                      </font></div></td> 
                  </tr> 
                  <tr> 
                    <td colspan="2" class="vslcss"><p>
                      <% call DisplayItems() %>
                    </p>
                    <!--
                  <div class="t">   
                      <label for="PromoCode">Promotion Code :</label>
                      <input name="PromoCode" type="text" id="PromoCode" value="%=session("promocode")%>">
                      <input type="submit" name="promosubmit" id="promosubmit" value="Apply">
                    <span id="promomsg" class="ewmsg"><br />%=promomsg%></span></div></td> 
                    -->
                  </tr> 
                  <tr> 
                    <td colspan="2" valign="bottom" style="padding-top:15px;"><p align="center"><a href="vslCart.asp"><img src="images/clicktoreturn.gif" width="177" height="32" border="0" style="vertical-align:top!important;"></a>&nbsp;&nbsp;
<input name="Submit2" type="image" class="InputNoBorder" style="border-style:none!important;border-color:transparent!important;boder-width:0px!important;" id="Submit2"  value="Proceed to Secure Checkout" src="images/checkout.gif" onclick="javascript:return PaypalSubmit();" >
                    &nbsp; <a href="logout.asp"><img src="images/logout.gif" width="75" height="32" border="0" style="vertical-align:top!important;"></a> </p></td>  
                  </tr> 
                </table> 
              </form> 
              <script type="text/javascript">
			  function fillship() {
			  document.getElementById("shipvalues").value = document.getElementById("ship_FirstName").value + '||' 
					+ document.getElementById("ship_LastName").value + '||'
					+ document.getElementById("ship_Address").value + '||'
					+ document.getElementById("ship_Address2").value + '||'
					+ document.getElementById("ship_City").value + '||'
					+ document.getElementById("ship_Province").value + '||'
					+ document.getElementById("ship_PostalCode").value + '||'
					+ document.getElementById("ship_Country").value + '||'
					+ document.getElementById("HomePhone").value ;
					
			  }
	document.getElementById("ship_Province").value="<%=ship6%>";
    var myMenu = new ImageMenu($$('#kwick .kwick'),{openWidth:261,start:4});
	
  </script> 
              <%
	else
		response.write "Error.."
	end if
rs.close
set rs=nothing

end function
%> 

<!--#include file="footer.asp"-->

<%Call Page_Terminate("")

Sub Page_Terminate(url)


	conn.Close ' Close Connection
	Set conn = Nothing
	Set Security = Nothing
	Set Customers = Nothing

	' Go to url if specified
	If url <> "" Then
		Response.Clear
		Response.Redirect url
	End If

	' Terminate response
	Response.End
End Sub


Sub DisplayItems()
	dim arr
	arr=GetCart()
	if( IsCartEmpty()) then  
	response.redirect "vslCart.asp?cmd=resetall"
	
		'message "emptycart"
		'response.redirect "vslCart.asp?cmd=resetall"
	else
dim applyDiscount
mcode= "" 'request.form("promocode")

If(mcode & "x"<>"x") then mcode=UCase(mcode)
if((mcode ="") and (session("promocode")<>"")) then mcode=session("promocode")
session("promocode")=mcode
applyDiscount= checkCustomer(conn,mcode)
		response.Write "<div class='t' width=720px><b>My cart:</b>"

%>
<table width="760px" >
  <tr>
    <td><table width="720px"  class="ewTable" cellspacing="5" cellpadding="5" border="1">
        <tr >
          <td width="50%" class="ewTableHeader"><b>Products</b></td>
          <td width="16%" class="ewTableHeader"><div align="right"><b>Unit Price</b></div></td>
          <td width="12%" class="ewTableHeader"><div align="center"><b>Quantity</b></div></td>
          <td width="10%" class="ewTableHeader"><div align="right"><b>Total</b></div></td>
        </tr>
        <%GT=0
		For i=0 To UBound(arr)
			p=arr(i,2)
			t=arr(i,2)
				if(applyDiscount) then
				
					if(session("specialxprice")<>""	) then 
						p= cdbl(session("specialxprice"))
						t= "<p>Regular pricing : <s>" & arr(i,2) & "<br>"&vbCrLf 
						t=t & "</s><font color=""#FF0000"" size=""-1"">Your special price for this order only</font>"
						t=t & ": <font color=""#FF0000""><strong>" & p  &"</strong></font> </p>"&vbCrLf
					end if
				end if
		
		%>
        <tr >
          <td width="50%"><b><%= "</b>" & arr(i,1) %></b></td>
          <td width="16%"><div align="right"><b><%=t%></b></div></td>
          <td width="12%" align="center"><div align="center">
              <%
			  dim tc
			  tc=arr(i,3) 
			  
			

			if(Session("FreexQty")<>"") then
				Response.write tc & ("( + " &  int(tc/cint(Session("FreexQty")) ) & " free)" )
			else
				Response.write tc
				'call extraUnits(tc,"<br />+2 free")
				'Response.write tc
				'if(tc>19) then  Response.write "<br />+2 free"
			end if
			
			  
			  %>
            </div></td>
          <td width="10%"><div align="right"><%=p *  arr(i,3)%></div></td>
        </tr>
        <%
		GT=GT+ p *  arr(i,3)
		Next%>
        <tr bordercolor="#FFCC66">
          <td width="50%" class="ewTablePager">
    <% if (isNewCustomer()) then%>
        <span class="ewmsg">Please note ,first box will be charged 99 instead of 110 when you go to the paypal payment.</span>
    <%end if %>
          </td>
          <td width="16%" class="ewTablePager">&nbsp;</td>
          <td width="12%" class="ewTablePager"><div align="right">Total:</div></td>
          <td width="10%" class="ewTablePager"><div align="right"><%=FormatNumber(GT,2)%></div></td>
        </tr>
      </table></td>
  </tr>
</table>
<%if(applyDiscount) then 
	if(Session("freexship")) then response.write " This order will be Shipped free of charge"
end if
%>
<%
response.write "</div>"
end if
End Sub





function checkCustomer(c,code)
if(session("invalidtry") & "x"="x") then
'nothing
else
if(cint(session("invalidtry"))>10) then 
		Session("freexship")=false
		Session("specialxprice")=""
		Session("FreexQty")=""
		checkCustomer=false
		session("promocode")=""
		promomsg="Invalid promo codes entered too many times..  "
		exit function
end if
end if

	if(code<>"") then
		code = UCase(code)
		dim rs,NewCustomer
		Set rs = Server.CreateObject("ADODB.Recordset")
		strSql ="SELECT Discountcodes.DiscountCode, DiscountTypes.DiscountTitle, DiscountTypes.DiscountType, DiscountTypes.freeShipping, DiscountTypes.FreePerQty, DiscountTypes.SpecialPrice, Orders.PromoCodeUsed "
		strSql = strSql & " FROM (Discountcodes INNER JOIN DiscountTypes ON Discountcodes.DiscountTypeId = DiscountTypes.DiscountTypeId) LEFT JOIN Orders ON Discountcodes.DiscountCode = Orders.PromoCodeUsed "
		strSql = strSql & " WHERE (((Discountcodes.DiscountCode)='"& mid(code,1,5) &"') AND ((Discountcodes.Active)=True)) AND ((DiscountTypes.StartDate)<Now()) AND ((DiscountTypes.EndDate)>Now()) "
		if(code<>"VSL14") then strSql = strSql & " AND((Discountcodes.used)=False) "
		
		'response.write strsql
		rs.Open strSql, c, 1, 2 

		if(not rs.eof) then 
			promoCodeused=rs.fields("PromoCodeUsed")
			if(promoCodeused & "x"<>"x") then promoCodeused=UCase(promoCodeused)
		
			if((promoCodeused & "x"="x") or (promoCodeused ="VSL14"))  then
			'if(true)  then
				Session("freexship")=rs.fields("freeShipping")
				Session("specialxprice")=rs.fields("SpecialPrice")
				Session("FreexQty")=rs.fields("FreePerQty")
				checkCustomer=true
				promomsg="Promo code Applied : " & rs.fields("DiscountTitle")
			else
				Session("freexship")=false
				Session("specialxprice")=""
				Session("FreexQty")=""
				checkCustomer=false
				promomsg="Promo Code is used and order is currently in process of being paid. If payment fails code will be unlocked within 24hrs."
				session("promocode")=""
			end if
			session("invalidtry")=0
		else
			Session("freexship")=false
			Session("specialxprice")=""
			Session("FreexQty")=""
			checkCustomer=false
			promomsg="Invalid promo Code"
			session("promocode")=""
			if(session("invalidtry") & "x"="x") then session("invalidtry")=0
			session("invalidtry") = cint(session("invalidtry"))+1
		end if
		rs.close
		set rs=nothing
	else
		checkCustomer=false
	end if
end function

function cleantxt(t)
	dim temp
	if(isnull(t)) then t=""
	if(t<>"") then
		t=LCase(t)
		t= replace (t,"-","")
		t= replace (t," ","")
		t= replace (t,"(","")
		t= replace (t,")","")
		t= replace (t,"'","")
		t= replace (t,".","")
	end if
	cleantxt=t
end function



%>