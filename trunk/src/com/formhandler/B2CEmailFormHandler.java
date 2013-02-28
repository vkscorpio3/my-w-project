/*<ATGCOPYRIGHT>
 * Copyright (C) 1999-2008 Art Technology Group, Inc.
 * All Rights Reserved.  No use, copying or distribution of this
 * work may be made except in accordance with a valid license
 * agreement from Art Technology Group.  This notice must be
 * included on all copies, modifications and derivatives of this
 * work.
 *
 * Art Technology Group (ATG) MAKES NO REPRESENTATIONS OR WARRANTIES 
 * ABOUT THE SUITABILITY OF THE SOFTWARE, EITHER EXPRESS OR IMPLIED, 
 * INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. ATG SHALL NOT BE
 * LIABLE FOR ANY DAMAGES SUFFERED BY LICENSEE AS A RESULT OF USING, 
 * MODIFYING OR DISTRIBUTING THIS SOFTWARE OR ITS DERIVATIVES.
 *
 * "Dynamo" is a trademark of Art Technology Group, Inc.
 </ATGCOPYRIGHT>*/

package com.formhandler;

import atg.userprofiling.Profile;
import atg.service.email.EmailFormHandler;
import atg.servlet.DynamoHttpServletRequest;
import atg.servlet.DynamoHttpServletResponse;
import java.io.IOException;
import javax.servlet.ServletException;

/**
 * This class handles sending an email to Pioneer Cycling's customer support
 * group. It extends <code>atg.service.email.EmailFormHandler</code>, overriding
 * the <code>sendMail()</code> method to extract the user's name, repository id,
 * and email address from her/his profile, and sending the email to a fixed
 * destination (by default, <code>customer_svc@pioneer_cycling.com</code>)
 * 
 * 
 * @see atg.service.email.EmailFormHandler
 * @author Pierre Billon
 * @version $Id:
 *          //product/DCS/version/9.0/Java/atg/projects/b2cstore/B2CEmailFormHandler
 *          .java#1 $$Change: 508164 $
 * @updated $DateTime: 2008/09/05 22:50:13 $$Author: rbarbier $
 * 
 **/

public class B2CEmailFormHandler extends EmailFormHandler {
	// -------------------------------------
	// Class version string

	public static String CLASS_VERSION = "$Id: //product/DCS/version/9.0/Java/atg/projects/b2cstore/B2CEmailFormHandler.java#1 $$Change: 508164 $";

	// -------------------------------------
	// Properties

	// -------------------------------------
	// property: customerServiceEmail
	String mDefaultEmailAddress;

	/**
	 * Sets property customerServiceEmailAddress, the fixed recipient of
	 * feedback email messages from registered users of the PioneerCycling
	 * store.
	 * 
	 * @beaninfo description: email address for Pioneer Cycle customer service
	 *           displayName: Customer Service Email Address
	 **/
	public void setDefaultEmailAddress(
			String pCustomerServiceEmailAddress) {
		mDefaultEmailAddress = pCustomerServiceEmailAddress;
	}

	/**
	 * Returns property customerServiceEmailAddress
	 **/
	public String getDefaultEmailAddress() {
		return mDefaultEmailAddress;
	}

	// -------------------------------------
	// property: profile
	Profile mProfile;

	/**
	 * Sets property profile
	 * 
	 * @beaninfo description: User profile displayName: User Profile
	 **/
	public void setProfile(Profile pProfile) {
		mProfile = pProfile;
	}

	/**
	 * Returns property profile
	 **/
	public Profile getProfile() {
		return mProfile;
	}

	// -------------------------------------
	// Constructors

	// -------------------------------------
	/**
	 * Constructs a B2CEmailFormHandler.
	 */
	public B2CEmailFormHandler() {
	}

	// -------------------------------------
	/**
	 * 
	 * Customizes the send operation. Overrides the sender and recipient
	 * properties to the following:
	 * <p>
	 * <i>sender:</i><code> full name (id) &lt;email&gt;</code><br>
	 * <i>recipient:</i><code> customer_svc@pioneer_cycling.com</code>
	 * <p>
	 * The full name and email address come from the user's profile, and the id
	 * is the user's profile repository id. The recipient is the value specified
	 * in the properties file for the customerServiceEmailAddress.
	 * <p>
	 * The <code>EmailFormHandler</code>'s <code>sendMail()</code> is then
	 * called normally.
	 * 
	 * @return a boolean value
	 **/
	protected boolean sendMail(DynamoHttpServletRequest pRequest,
			DynamoHttpServletResponse pResponse) throws ServletException,
			IOException {
		Profile profile = getProfile();

		String firstName = (String) profile.getPropertyValue("firstName");
		String middleName = (String) profile.getPropertyValue("middleName");
		String lastName = (String) profile.getPropertyValue("lastName");
		String email = (String) profile.getPropertyValue("email");
		profile.setPropertyValue("mail.smtp.starttls.enable", "true");
		// Compose the sender tag as: firstName middleName lastName (id)
		// <emailaddress>
		StringBuffer buf = new StringBuffer();
		if (firstName != null)
			buf.append(firstName);
		if (middleName != null)
			buf.append(" " + middleName);
		if (lastName != null)
			buf.append(" " + lastName);
		buf.append(" (" + profile.getRepositoryId() + ")");
		buf.append(" <" + email + ">");
		setSender(buf.toString());

		// the recipient is a property of this component (Pioneer Cycling's
		// customer service email address)
		setRecipient(getDefaultEmailAddress());
		return super.sendMail(pRequest, pResponse);
	}

	// -------------------------------------
}
