<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<dsp:page>

	<dsp:importbean bean="/atg/dynamo/service/EmailFormHandler" />
	<dsp:importbean bean="/atg/userprofiling/Profile" />
	<dsp:importbean bean="/atg/userprofiling/ProfileErrorMessageForEach" />
	<dsp:importbean bean="/atg/dynamo/droplet/Switch" />

	<dsp:include page="../common/HeadBody.jsp">
		<dsp:param name="pagetitle" value="Contact Customer Service" />
	</dsp:include>

	<dsp:include page="../common/ModalBrand.jsp"></dsp:include>
	<span class=profilelittle> <dsp:a href="my_profile.jsp">MY PROFILE</dsp:a>
	> CONTACT CUSTOMER SERVICE</span>
	<p><span class=storebig>Send Feedback to the Pioneer Cycling
	Service Team</span><br>
	<p><dsp:droplet name="Switch">
		<dsp:param bean="Profile.transient" name="value" />
		<dsp:oparam name="true">

			<table width=500 cellpadding=0 cellspacing=0 border=0>
				<tr>
					<td class="box-top-profile">&nbsp;Oops!</td>
				</tr>
				<tr>
					<td>&nbsp;<br>
					<span class="error">You can't send us email if we don't know
					who you are. Please log in first.</span>
					<p><dsp:a href="my_profile.jsp">Click here to log in
           </dsp:a>
					<p><dsp:a href="../store_home.jsp">Click here to return to the
             Pioneer Cycling Store's home page
           </dsp:a>
					<p>&nbsp;
					</td>
				</tr>
			</table>

		</dsp:oparam>

		<dsp:oparam name="default">
			<!-- Assume update success for sending email -->
			<table cellspacing=0 cellpadding=0 border=0>

				<!-- Whether or not email is sent successfully or not, we come back here -->
				<dsp:getvalueof id="form86" bean="/OriginatingRequest.requestURI"
					idtype="java.lang.String">
					<dsp:form action="<%=form86%>" method="POST">

						<!-- Setup gutter and make space -->
						<tr>
							<td><dsp:img height="1" width="100" src="../images/d.gif" /><br>
							</td>
							<td>&nbsp;&nbsp;</td>
							<td><dsp:img height="1" width="400" src="../images/d.gif" /></td>
						</tr>

						<tr valign=top>
							<td><dsp:droplet name="Switch">
								<dsp:param bean="EmailFormHandler.formError" name="value" />
								<dsp:oparam name="true">
									<span class=registrationerror> <span class=help>Problems
									were encountered sending your feedback:</span>
									<p>
									<UL>
										<dsp:droplet name="ProfileErrorMessageForEach">
											<dsp:param bean="EmailFormHandler.formExceptions"
												name="exceptions" />
											<dsp:oparam name="output">
												<LI><dsp:valueof param="message" />
											</dsp:oparam>
										</dsp:droplet>
									</UL>
									</span>
								</dsp:oparam>
								<dsp:oparam name="false">
									<span class=help>Please enter the subject and body of
									the email you would like to send.
									<p>Press 'Send Feedback' when you're done.
									</span>
								</dsp:oparam>
							</dsp:droplet></td>
							<td></td>
							<td>
							<table width=100% cellpadding=0 cellspacing=0 border=0>
								<tr>
									<td class=box-top-profile>&nbsp;Feedback</td>
								</tr>
							</table>
							<p>Sender<br>
							<b> <dsp:valueof bean="Profile.firstName" /> <dsp:valueof
								bean="Profile.middleName" /> <dsp:valueof
								bean="Profile.lastName" /> &nbsp; &lt;<dsp:valueof
								bean="Profile.email" />&gt; </b>
							<p>Recipient<br>
							<b><dsp:valueof value="santuc1990@gmail.com"
								converter="escapehtml" /></b>
							<p>Subject<br>
							<dsp:input bean="EmailFormHandler.subject" maxlength="100"
								size="30" type="text" />
							<p>Feedback message<br>

							<dsp:textarea bean="EmailFormHandler.body" rows="10" cols="50">
								<dsp:valueof bean="EmailFormHandler.body" />
							</dsp:textarea>
							<p>&nbsp;<br>

							<!-- Submit form to handleUpdate() handler --> <dsp:input
								bean="EmailFormHandler.sendSuccessURL" type="hidden"
								value="./email_sent.jsp" /> <dsp:input
								bean="EmailFormHandler.sendEmail" type="submit"
								value=" Send Feedback " />
							<p>&nbsp;
							<p>
							</td>
						</tr>
					</dsp:form>
				</dsp:getvalueof>
			</table>
		</dsp:oparam>
		<!-- End of switch clause: user logged in -->
	</dsp:droplet> <!-- End of Switch --> <dsp:include page="../common/StoreFooter.jsp"></dsp:include>
	<dsp:include page="../common/Copyright.jsp"></dsp:include>

	</BODY>
	</HTML>
</dsp:page>
<%-- @version $Id: //product/DCS/version/9.0/release/PioneerCyclingJSP/j2ee-apps/pioneer/web-app/en/user/contact_customer_service.jsp#1 $$Change: 508164 $--%>
