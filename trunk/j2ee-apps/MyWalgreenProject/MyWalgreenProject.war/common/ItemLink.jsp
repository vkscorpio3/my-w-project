<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<%@ taglib uri="core" prefix="core"%>
<dsp:page>

	<%         
/* -------------------------------------------------------
 * Display a link to the Item (Product or Category).
 * The link will take you to the jsp page which displays
 * this Item.  The jsp page is fetched from the   
 * "template.url" attribute on the Item.
 * If an Image is passed in, both the Image, and a text
 * link is displayed - clicking either the Image or the
 * text link brings the user to the above described jsp page.
 * ------------------------------------------------------- */
%>

	<dsp:importbean bean="/atg/dynamo/droplet/IsNull" />


	<DECLAREPARAM NAME="Item" CLASS="java.lang.Object"
		DESCRIPTION="A Repository Item to display a link to - typically 
                           a Product or Category">
	<DECLAREPARAM NAME="Image" CLASS="java.lang.String"
		DESCRIPTION="The optional param is used to display an image along with the link."
		OPTIONAL>
	<DECLAREPARAM NAME="navAction" CLASS="java.lang.String"
		DESCRIPTION="How to change the navigation history. Choices are
                           push, pop and jump.  Blank is treated as push."
		OPTIONAL>
	<DECLAREPARAM NAME="DisplayText" CLASS="java.lang.String"
		DESCRIPTION="This optional string can be passed in to display 
                           different text (than what is default).  The default 
                           text to display is the Item's DisplayName"
		OPTIONAL>

	<% /* Display link in bold: */ %>
	<b> <%         
/* -------------------------------------------------------
 * Display a clickable link to the Item (Product or Category).
 * The link will take you to the jsp page which displays
 * this Item.  The jsp page to go to for this Item is 
 * specified in the "template.url" attribute on the Item.            
 * ------------------------------------------------------- */
%> <dsp:getvalueof id="templateUrl" idtype="String"
		param="Item.template.url">

		<%-- The link to the item is shown only if the template.url property is defined for the item. --%>
		<core:ifNotNull value="<%=templateUrl%>">

			<dsp:a page="<%=templateUrl%>">
				<dsp:param name="id" param="Item.repositoryId" />
				<dsp:param name="navCount"
					bean="/atg/commerce/catalog/CatalogNavHistory.navCount" />

				<%-- These set for breadcrumb navigation: --%>
				<dsp:param name="navAction" param="navAction" />

				<dsp:getvalueof id="imageInp" param="Image">
					<core:ifNotNull value="<%=imageInp%>">
						<font color=000000> <dsp:getvalueof id="imageURL"
							param="Image.url" idtype="java.lang.String">
							<core:ifNotNull value="<%=imageURL%>">
								<img border="1" src="<%=imageURL%>">
							</core:ifNotNull>
						</dsp:getvalueof> </font>
						<br>
					</core:ifNotNull>
				</dsp:getvalueof>

				<%-- Show DisplayText if set, otherwise show item's display name --%>
				<dsp:valueof param="DisplayText">
					<dsp:valueof param="Item.displayName" />
				</dsp:valueof>

			</dsp:a>
		</core:ifNotNull>

	</dsp:getvalueof> <% /* end link in bold: */ %> </b>


</dsp:page>
<%-- @version $Id: //product/DCS/version/9.0/release/PioneerCyclingJSP/j2ee-apps/pioneer/web-app/en/common/ItemLink.jsp#1 $$Change: 508164 $--%>
