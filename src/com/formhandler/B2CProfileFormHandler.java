/*<ATGCOPYRIGHT>
 * Copyright (C) 1997-2008 Art Technology Group, Inc.
 * All Rights Reserved.  No use, copying or distribution ofthis
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

// ATG User Profiling
import atg.userprofiling.Profile;
import atg.commerce.profile.CommerceProfileFormHandler;
import atg.commerce.profile.CommerceProfileTools;
import atg.commerce.profile.CommercePropertyManager;
import atg.dtm.*;

// Repository classes
import atg.repository.MutableRepository;
import atg.repository.RepositoryException;
import atg.repository.MutableRepositoryItem;
import atg.repository.RepositoryItem;
import atg.repository.RepositoryPropertyDescriptor;
import atg.beans.DynamicPropertyDescriptor;

// Exception classes
import java.io.IOException;
import javax.servlet.ServletException;
import atg.droplet.DropletFormException;

// DynamoServlet classes
import atg.servlet.DynamoHttpServletRequest;
import atg.servlet.DynamoHttpServletResponse;

// Used for displaying form errors
import atg.core.util.ResourceUtils;
import java.text.MessageFormat;
import java.util.Locale;
import java.util.ResourceBundle;

// Collection classes
import java.util.*;

// Transaction Management classes
import javax.transaction.*;

/**
 * Before creating the user, check whether the user has requested that her/his
 * billing address be used as the shipping address. If so, copy the billing
 * address fields into the shipping address.
 * <p>
 * After creating the user, update current user's secondaryAddressMap (in the
 * profile repository) to include the shipping address, indexed with the
 * nickname provided.
 * 
 * @beaninfo description: A form handler that manages the current user's profile
 *           attribute: functionalComponentCategory Form Handlers attribute:
 *           featureComponentCategory attribute: icon
 *           /atg/ui/common/images/formhandlercomp.gif
 * 
 * @author Pierre Billon
 * @version $Id:
 *          //product/DCS/version/9.0/Java/atg/projects/b2cstore/B2CProfileFormHandler
 *          .java#1 $$Change: 508164 $
 * @updated $DateTime: 2008/09/05 22:50:13 $$Author: rbarbier $
 */

public class B2CProfileFormHandler extends CommerceProfileFormHandler {
	// -------------------------------------
	/** Class version string */
	public static final String CLASS_VERSION = "$Id: //product/DCS/version/9.0/Java/atg/projects/b2cstore/B2CProfileFormHandler.java#1 $$Change: 508164 $";

	// -------------------------------------
	// Constants
	// -------------------------------------
	public static String RESOURCE_BUNDLE = "atg.projects.b2cstore.B2CUserResources";

	static final String MSG_ERR_CREATING_ADDRESS = "errorCreatingAddress";
	static final String MSG_ERR_DELETING_ADDRESS = "errorDeletingAddress";
	static final String MSG_ERR_UPDATING_ADDRESS = "errorUpdatingAddress";
	static final String MSG_DUPLICATE_ADDRESS_NICKNAME = "errorDuplicateNickname";
	static final String MSG_ERR_MODIFYING_NICKNAME = "errorModifyingNickname";
	static final String MSG_MISSING_ADDRESS_PROPERTY = "missingAddressProperty";

	static final String MSG_ERR_CREATING_CC = "errorCreatingCreditCard";
	static final String MSG_MISSING_CC_PROPERTY = "missingCreditCardProperty";
	static final String MSG_DUPLICATE_CC_NICKNAME = "errorDuplicateCCNickname";
	static final String MSG_INVALID_CC = "errorInvalidCreditCard";

	static final String MSG_MISSING_DEFAULT_CC = "missingDefaultCreditCard";

	// -------------------------------------
	// Member Variables
	// -------------------------------------

	// -------------------------------------
	// Properties
	// -------------------------------------

	// --------------------------------
	// ------ Utility Properties ------
	// --------------------------------
	//
	// The following properties support the handlers in this class, by
	// providing a target for form tags (editValue and shipToBillingAddress),
	// and by exposing user-modifiable string constants (address and card
	// properties).
	//
	// 1. editValue
	// 2. shipToBillingAddress
	// 3. defaultCreditCardID
	// 4. defaultCarrier
	// 5. addressProperties
	// 6. requiredAddressProperties
	// 7. cardProperties

	// -------------------------------------
	// property: editValue

	HashMap mEditValue = new HashMap();

	/**
	 * @return The value of the property EditValue. This is a map that stores
	 *         the pending values for an editing operations on the B2CStore
	 *         profile
	 * @beaninfo description: map storing edit value for the B2CStore profile.
	 */
	public Map getEditValue() {
		return mEditValue;
	}

	// -------------------------------------
	// property: shipToBillingAddress
	boolean mShipToBillingAddress;

	/**
	 * Sets property shipToBillingAddress, indicating that the billing address
	 * should be copied to the shipping address.
	 **/
	public void setShipToBillingAddress(boolean pShipToBillingAddress) {
		mShipToBillingAddress = pShipToBillingAddress;
	}

	/**
	 * Returns property shipToBillingAddress, indicating that the billing
	 * address should be copied to the shipping address.
	 * 
	 * @beaninfo description: true if the shipping address is identical to the
	 *           billing address
	 **/
	public boolean isShipToBillingAddress() {
		return mShipToBillingAddress;
	}

	/**
	 * A helper method to return the CommercePropertyManager.
	 **/
	CommercePropertyManager retrieveCommercePropertyManager() {
		return (CommercePropertyManager) getProfileTools().getPropertyManager();
	}

	// -------------------------------------
	// property: defaultCreditCardID
	// pje
	String mDefaultCreditCardID;

	/**
	 * @param pID
	 *            The credit card ID to be used as the default credit card
	 * @beaninfo description: Credit card ID to be used as the default credit
	 *           card.
	 */
	public void setDefaultCreditCardID(String pID) {
		mDefaultCreditCardID = pID;
	}

	public String getDefaultCreditCardID() {
		return mDefaultCreditCardID;
	}

	// -------------------------------------
	// property: defaultCarrier
	// pje
	String mDefaultCarrier;

	public void setDefaultCarrier(String pShipper) {
		mDefaultCarrier = pShipper;
	}

	/**
	 * @beaninfo description: the default carrier to be used
	 **/
	public String getDefaultCarrier() {
		return mDefaultCarrier;
	}

	// -------------------------------------
	// property: addressProperties
	String[] mAddressProperties = new String[] { "firstName", "middleName",
			"lastName", "address1", "address2", "city", "state", "postalCode",
			"country", "ownerId" };

	/**
	 * Sets property addressProperties, naming the properties in a secondary
	 * address record.
	 **/
	public void setAddressProperties(String[] pAddressProperties) {
		mAddressProperties = pAddressProperties;
	}

	/**
	 * Returns property addressProperties, naming the properties in a secondary
	 * address record.
	 * 
	 * @beaninfo description: List of address properties that are available
	 **/
	public String[] getAddressProperties() {
		return mAddressProperties;
	}

	// ---------------------------------------------------------------------------
	// property: CompatibilityMode
	// ---------------------------------------------------------------------------

	boolean mCompatibilityMode = false;

	/**
	 * Sets the compatibility Mode property. This property is used by the
	 * various initialize methods to determine whether the list of properties
	 * should be populated from the property arrays or whether the properties
	 * should be initialized from the property manager. By default this is set
	 * to false which uses the property manager properties.
	 * 
	 * @param pCompatibilityMode
	 *            - true will cause the behavior to be identical to previous
	 *            versions (pre 5.5), false is the new behavior. Defaults is
	 *            <code>false</code>.
	 * 
	 * @beaninfo description: If true will cause the behavior to be indentical
	 *           to the previous versions of the product (pre 5.5) properties
	 *           are populated from arrays. Default is false, populate from
	 *           property manager
	 **/
	public void setCompatibilityMode(boolean pCompatibilityMode) {
		mCompatibilityMode = pCompatibilityMode;
	}

	/**
	 * Return the value of the CompatibilityMode property.
	 **/
	public boolean isCompatibilityMode() {
		return mCompatibilityMode;
	}

	List mAddressPropertyList = null;

	/**
	 * Sets the Address property list, which is a list that mirrors the original
	 * design of the AddressProperties property with the property names defined
	 * in a configuration file. This List will be created by the
	 * initializeAddressPropertyList method creating the appropriate list
	 * containing the values from the property manager.
	 * 
	 * @param the
	 *            Address property list that needs to be set.
	 */
	public void setAddressPropertyList(List pAddressPropertyList) {
		mAddressPropertyList = pAddressPropertyList;
	}

	/**
	 * If the address property list is null, the initializeAddressPropertyList
	 * method is called to create a list from the appropriate property manager
	 * class.
	 * 
	 * @return a List that contains the Address properties that are available
	 * 
	 * @beaninfo description: The address property list.
	 **/
	public List getAddressPropertyList() {
		if (mAddressPropertyList == null) {
			setAddressPropertyList(initializeAddressPropertyList());
		}
		return mAddressPropertyList;
	}

	/**
	 * This method initializes the list of properties that are used for the
	 * Address information. It consults the compatibilityMode property to
	 * determine whether the old style of defining the property names are used
	 * <code>true</code> or whether the property manager should be used
	 * <code>false</code>. This is the method that should be overriden if new
	 * properties are added to the list of Address properties. The easiest way
	 * to add new properties is to do the following: <code>
	 *  List newList = super.initializeAddressPropertyList();
	 *  newList.add("yourownproperty");
   * </code>
	 **/

	public List initializeAddressPropertyList() {
		List nl = new ArrayList(10);

		// If we are not in compatibility mode then we will work from the
		// property manager
		if (!isCompatibilityMode()) {
			CommercePropertyManager cpmgr = retrieveCommercePropertyManager();
			nl.add(cpmgr.getAddressFirstNamePropertyName());
			nl.add(cpmgr.getAddressMiddleNamePropertyName());
			nl.add(cpmgr.getAddressLastNamePropertyName());
			nl.add(cpmgr.getAddressLineOnePropertyName());
			nl.add(cpmgr.getAddressLineTwoPropertyName());
			nl.add(cpmgr.getAddressCityPropertyName());
			nl.add(cpmgr.getAddressStatePropertyName());
			nl.add(cpmgr.getAddressPostalCodePropertyName());
			nl.add(cpmgr.getAddressCountryPropertyName());
			nl.add(cpmgr.getAddressOwnerPropertyName());
		} else {
			for (int i = 0; i < mAddressProperties.length; i++) {
				nl.add(mAddressProperties[i]);
			}
		}
		return nl;
	}

	// -------------------------------------
	// property: requiredAddressProperties
	// NOTE: I don't think I need to add ownerId to this list...
	String[] mRequiredAddressProperties = new String[] { "nickname",
			"firstName", "lastName", "address1", "city", "postalCode",
			"country" };

	/**
	 * Sets property requiredAddressProperties, naming the properties considered
	 * mandatory when creating a secondary address record.
	 **/
	public void setRequiredAddressProperties(String[] pRequiredAddressProperties) {
		mRequiredAddressProperties = pRequiredAddressProperties;
	}

	/**
	 * Returns property requiredAddressProperties, naming the properties
	 * considered mandatory when creating a secondary address record.
	 * 
	 * @beaninfo description: The required list of address properties.
	 **/
	public String[] getRequiredAddressProperties() {
		return mRequiredAddressProperties;
	}

	// -------------------------------------
	// property: cardProperties
	String[] mCardProperties = new String[] { "creditCardNumber",
			"creditCardType", "expirationMonth", "expirationYear" };

	/**
	 * Sets property cardProperties, naming the properties in a credit card
	 * entry.
	 **/
	public void setCardProperties(String[] pCardProperties) {
		mCardProperties = pCardProperties;
	}

	/**
	 * Returns property cardProperties, naming the properties in a credit card
	 * entry.
	 * 
	 * @beaninfo description: The list of card properties that are available
	 **/
	public String[] getCardProperties() {
		return mCardProperties;
	}

	List mCardPropertyList = null;

	/**
	 * Sets the Card property list, which is a list that mirrors the original
	 * design of the AddressProperties property with the proeprty names defined
	 * in a configuration file. This List List will be created by the
	 * initializeCardPropertyList method creating the appropriate list
	 * containing the values from the property manager.
	 * 
	 * @param the
	 *            CardPropertyList list that needs to be set.
	 **/
	public void setCardPropertyList(List pCardPropertyList) {
		mCardPropertyList = pCardPropertyList;
	}

	/**
	 * If the CardPropertyList is null, the initializeCardPropertyList method is
	 * called to create a list from the appropriate property manager class.
	 * 
	 * @return a List that contains the Credit card properties that are
	 *         available.
	 * @beaninfo description: List of credit card properties.
	 **/
	public List getCardPropertyList() {
		if (mCardPropertyList == null) {
			setCardPropertyList(initializeCardPropertyList());
		}
		return mCardPropertyList;
	}

	/**
	 * This method initializes the list of properties that are used for the
	 * Credit card information. It consults the compatibilityMode property to
	 * determine whether the old style of defining the property names are used
	 * <code>true</code> or whether the property manager should be used
	 * <code>false</code>. This is the method that should be overriden if new
	 * properties are added to the list of Credit card properties. The easiest
	 * way to add new properties is to do the following: <code>
	 *   List newList = super.initializeCardPropertyList();
	 *   newList.add("yourownproperty");
   *  </code>
	 **/
	public List initializeCardPropertyList() {
		List nl = new ArrayList(4);

		if (!isCompatibilityMode()) {
			CommercePropertyManager cpmgr = retrieveCommercePropertyManager();

			nl.add(cpmgr.getCreditCardNumberPropertyName());
			nl.add(cpmgr.getCreditCardTypePropertyName());
			nl.add(cpmgr.getCreditCardExpirationMonthPropertyName());
			nl.add(cpmgr.getCreditCardExpirationYearPropertyName());
		} else {
			for (int i = 0; i < mCardProperties.length; i++) {
				nl.add(mCardProperties[i]);
			}

		}
		return nl;
	}

	// -------------------------------------------------
	// ------ Properties associated with handlers ------
	// -------------------------------------------------
	//
	// The following properties are set through a hyperlink, and their
	// value is used by the corresponding handler.
	//
	// 1. editAddress
	// 2. removeAddress
	// 3. removeCard

	// -------------------------------------
	// property: editAddress
	String mEditAddress;

	/**
	 * Sets property editAddress, naming the address to be edited in the
	 * edit_secondary_address.jhtml page.
	 **/
	public void setEditAddress(String pEditAddress) {
		mEditAddress = pEditAddress;
	}

	/**
	 * Returns property editAddress, naming the address to be edited in the
	 * edit_secondary_address.jhtml page.
	 * 
	 * @beaninfo description: The edit address property.
	 **/
	public String getEditAddress() {
		return mEditAddress;
	}

	// -------------------------------------
	// property: removeAddress
	String mRemoveAddress;

	/**
	 * Sets property removeAddress, naming the address to be removed by
	 * handleRemoveAddress().
	 **/
	public void setRemoveAddress(String pRemoveAddress) {
		mRemoveAddress = pRemoveAddress;
	}

	/**
	 * Returns property removeAddress, naming the address to be removed by
	 * handleRemoveAddress().
	 * 
	 * @beaninfo expert: false
	 **/
	public String getRemoveAddress() {
		return mRemoveAddress;
	}

	// -------------------------------------
	// property: removeCard
	String mRemoveCard;

	/**
	 * Sets property removeCard, naming the address to be removed by
	 * handleRemoveCard().
	 **/
	public void setRemoveCard(String pRemoveCard) {
		mRemoveCard = pRemoveCard;
	}

	/**
	 * Returns property removeCard, naming the address to be removed by
	 * handleRemoveCard().
	 * 
	 * @beaninfo expert: false
	 **/
	public String getRemoveCard() {
		return mRemoveCard;
	}

	// ------------------------------------
	// ------ Redirection properties ------
	// ------------------------------------
	//
	// The following properties are set in a jhtml form to instruct a handler
	// to redirect the user in case of success or failure.
	//
	// 1. newAddressSuccessURL
	// newAddressErrorURL
	// 2. updateAddressSuccessURL
	// updateAddressErrorURL
	// 3. changeAddressNicknameSuccessURL
	// changeAddressNicknameErrorURL
	// 4. createCardSuccessURL
	// createCardErrorURL
	// 5. removeCardSuccessURL
	// removeCardErrorURL

	// -------------------------------------
	// property: newAddressSuccessURL
	String mNewAddressSuccessURL;

	/**
	 * Sets property newAddressSuccessURL, used to redirect user after
	 * successfully creating an address.
	 **/
	public void setNewAddressSuccessURL(String pNewAddressSuccessURL) {
		mNewAddressSuccessURL = pNewAddressSuccessURL;
	}

	/**
	 * Returns property newAddressSuccessURL, used to redirect user after
	 * successfully creating an address.
	 * 
	 * @beaninfo description: The the url to redirect user to after successfully
	 *           creating an address
	 **/
	public String getNewAddressSuccessURL() {
		return mNewAddressSuccessURL;
	}

	// -------------------------------------
	// property: newAddressErrorURL
	String mNewAddressErrorURL;

	/**
	 * Sets property newAddressErrorURL, used to redirect user in case of an
	 * error creating an address.
	 **/
	public void setNewAddressErrorURL(String pNewAddressErrorURL) {
		mNewAddressErrorURL = pNewAddressErrorURL;
	}

	/**
	 * Returns property newAddressErrorURL, used to redirect user in case of an
	 * error creating an address.
	 * 
	 * @beaninfo description: The URL to redirect the user to in case of an
	 *           error creating the address.
	 **/
	public String getNewAddressErrorURL() {
		return mNewAddressErrorURL;
	}

	// -------------------------------------
	// property: updateAddressSuccessURL
	String mUpdateAddressSuccessURL;

	/**
	 * Sets property updateAddressSuccessURL, used to redirect user when an
	 * address is successfully updated.
	 **/
	public void setUpdateAddressSuccessURL(String pUpdateAddressSuccessURL) {
		mUpdateAddressSuccessURL = pUpdateAddressSuccessURL;
	}

	/**
	 * Returns property updateAddressSuccessURL, used to redirect user when an
	 * address is successfully updated.
	 * 
	 * @beaninfo description: The URL to redirect the user to when the address
	 *           has been updated successfully.
	 **/
	public String getUpdateAddressSuccessURL() {
		return mUpdateAddressSuccessURL;
	}

	// -------------------------------------
	// property: updateAddressErrorURL
	String mUpdateAddressErrorURL;

	/**
	 * Sets property updateAddressErrorURL, used to redirect user in case of an
	 * error updating an address.
	 **/
	public void setUpdateAddressErrorURL(String pUpdateAddressErrorURL) {
		mUpdateAddressErrorURL = pUpdateAddressErrorURL;
	}

	/**
	 * Returns property updateAddressErrorURL, used to redirect user in case of
	 * an error updating an address.
	 * 
	 * @beaninfo description: The URL to redirect the user to in case of an
	 *           error updating the address.
	 **/
	public String getUpdateAddressErrorURL() {
		return mUpdateAddressErrorURL;
	}

	// -------------------------------------
	// property: changeAddressNicknameSuccessURL
	String mChangeAddressNicknameSuccessURL;

	/**
	 * Sets property changeAddressNicknameSuccessURL, used to redirect user when
	 * an address nickname is successfully updated.
	 **/
	public void setChangeAddressNicknameSuccessURL(
			String pChangeAddressNicknameSuccessURL) {
		mChangeAddressNicknameSuccessURL = pChangeAddressNicknameSuccessURL;
	}

	/**
	 * Returns property changeAddressNicknameSuccessURL, used to redirect user
	 * when an address nickname is successfully updated.
	 * 
	 * @beaninfo description: The URL to redirect the user to when the address
	 *           nickname is successfully updated.
	 **/
	public String getChangeAddressNicknameSuccessURL() {
		return mChangeAddressNicknameSuccessURL;
	}

	// -------------------------------------
	// property: changeAddressNicknameErrorURL
	String mChangeAddressNicknameErrorURL;

	/**
	 * Sets property changeAddressNicknameErrorURL, used to redirect user in
	 * case of an error updating an address nickname.
	 **/
	public void setChangeAddressNicknameErrorURL(
			String pChangeAddressNicknameErrorURL) {
		mChangeAddressNicknameErrorURL = pChangeAddressNicknameErrorURL;
	}

	/**
	 * Returns property changeAddressNicknameErrorURL, used to redirect user in
	 * case of an error updating an address nickname.
	 * 
	 * @beaninfo description: The URL to redirect the user to in case of an
	 *           error updating the address nickname
	 **/
	public String getChangeAddressNicknameErrorURL() {
		return mChangeAddressNicknameErrorURL;
	}

	// -------------------------------------
	// property: createCardSuccessURL
	String mCreateCardSuccessURL;

	/**
	 * Sets property createCardSuccessURL, used to redirect user if a new credit
	 * card was successfully added.
	 **/
	public void setCreateCardSuccessURL(String pCreateCardSuccessURL) {
		mCreateCardSuccessURL = pCreateCardSuccessURL;
	}

	/**
	 * Returns property createCardSuccessURL, used to redirect user if a new
	 * credit card was successfully added.
	 * 
	 * @beaninfo description: The URL to redirect the user to if a new credit
	 *           card was successfully added.
	 **/
	public String getCreateCardSuccessURL() {
		return mCreateCardSuccessURL;
	}

	// -------------------------------------
	// property: createCardErrorURL
	String mCreateCardErrorURL;

	/**
	 * Sets property createCardErrorURL, used to redirect user in case of an
	 * error adding a new credit card.
	 **/
	public void setCreateCardErrorURL(String pCreateCardErrorURL) {
		mCreateCardErrorURL = pCreateCardErrorURL;
	}

	/**
	 * Returns property createCardErrorURL, used to redirect user in case of an
	 * error adding a new credit card.
	 * 
	 * @beaninfo description: The URL to redirect the user to in case of an
	 *           error while adding a new credit card.
	 **/
	public String getCreateCardErrorURL() {
		return mCreateCardErrorURL;
	}

	// -------------------------------------
	// property: removeCardSuccessURL
	String mRemoveCardSuccessURL;

	/**
	 * Sets property removeCardSuccessURL, used to redirect user when a credit
	 * card is successfully removed.
	 **/
	public void setRemoveCardSuccessURL(String pRemoveCardSuccessURL) {
		mRemoveCardSuccessURL = pRemoveCardSuccessURL;
	}

	/**
	 * Returns property removeCardSuccessURL, used to redirect user in a credit
	 * card is successfully removed.
	 * 
	 * @beaninfo description: The URL to redirect the user to if the removal of
	 *           credit card was successful
	 **/
	public String getRemoveCardSuccessURL() {
		return mRemoveCardSuccessURL;
	}

	// -------------------------------------
	// property: removeCardErrorURL
	String mRemoveCardErrorURL;

	/**
	 * Sets property removeCardErrorURL, used to redirect user in case of an
	 * error removing a credit card.
	 **/
	public void setRemoveCardErrorURL(String pRemoveCardErrorURL) {
		mRemoveCardErrorURL = pRemoveCardErrorURL;
	}

	/**
	 * Returns property removeCardErrorURL, used to redirect user in case of an
	 * error removing a credit card.
	 * 
	 * @beaninfo description: The URL to redirect the user to in case of an
	 *           error while removing a credit card.
	 **/
	public String getRemoveCardErrorURL() {
		return mRemoveCardErrorURL;
	}

	// -------------------------------------
	// Constructors
	// -------------------------------------

	/**
	 * Constructs an instanceof B2CProfileFormHandler
	 */
	public B2CProfileFormHandler() {
	}

	// -------------------------------------
	// Utility Methods (private)
	// -------------------------------------

	// -------------------------------------
	// utility: getLocale
	// Determine the user's current locale, if available

	private Locale getLocale(DynamoHttpServletRequest request) {
		atg.servlet.RequestLocale reqLocale = request.getRequestLocale();
		if (reqLocale == null)
			return null;
		else
			return reqLocale.getLocale();
	}

	// -------------------------------------
	// utility: redirectIfPossible
	// If a redirect URL is provided, redirect, otherwise return quietly

	private boolean redirectIfPossible(String redirectURL,
			DynamoHttpServletRequest pRequest,
			DynamoHttpServletResponse pResponse) throws IOException {
		if (redirectURL == null || redirectURL.length() == 0)
			return true;
		else {
			pResponse.sendLocalRedirect(redirectURL, pRequest);
			return false;
		}
	}

	// -------------------------------------
	// utility: generateFormException 1
	// Create a form exception, by looking up the excption code in a resource
	// file identified by the RESOURCE_BUNDLE constant (defined above)

	private void generateFormException(String whatException,
			RepositoryException repositoryExc, DynamoHttpServletRequest pRequest) {
		ResourceBundle bundle = ResourceUtils.getBundle(RESOURCE_BUNDLE,
				getLocale(pRequest));
		String errorStr = bundle.getString(whatException);
		addFormException(new DropletFormException(errorStr, repositoryExc,
				whatException));
	}

	// -------------------------------------
	/**
	 * 
	 // utility: generateFormException 2 // Create a form exception, by
	 * looking up the exception code in a resource // file identified by the
	 * RESOURCE_BUNDLE constant (defined above). // Substitute the provided
	 * string in the exception text.
	 * 
	 * @param whatException
	 * @param substitutionText
	 * @param pRequest
	 */
	private void generateFormException(String whatException,
			String substitutionText, DynamoHttpServletRequest pRequest) {
		ResourceBundle bundle = ResourceUtils.getBundle(RESOURCE_BUNDLE,
				getLocale(pRequest));
		String rawErrorStr = bundle.getString(whatException);

		// Don't try to get a resource value if the key is null
		String propertyAsText = null;
		if (substitutionText != null && substitutionText.length() > 0)
			propertyAsText = bundle.getString(substitutionText);

		if (propertyAsText == null || propertyAsText.length() == 0)
			propertyAsText = substitutionText;

		String formattedErrorStr = (new MessageFormat(rawErrorStr))
				.format(new String[] { propertyAsText });
		addFormException(new DropletFormException(formattedErrorStr,
				getAbsoluteName() + ".editValue." + substitutionText,
				whatException));
	}

	// -------------------------------------
	// Form Handlers
	// -------------------------------------

	// ----------- (pre)CreateUser ------------
	/**
	 * 
	 * Before creating the user, this method:
	 * <ol>
	 * <li>Copies the first, middle, and last names to the billing address.
	 * </ul>
	 * 
	 * @param pRequest
	 *            the servlet's request
	 * @param pResponse
	 *            the servlet's response
	 * @exception ServletException
	 *                if there was an error while executing the code
	 * @exception IOException
	 *                if there was an error with servlet io
	 */
	protected void preCreateUser(DynamoHttpServletRequest pRequest,
			DynamoHttpServletResponse pResponse) throws ServletException,
			IOException {
		super.preCreateUser(pRequest, pResponse);

		// 1. Copy the first, middle, and last name fields from the user profile
		// to the billing and shipping addresses
		String firstName = (String) getValueProperty("firstName");
		String middleName = (String) getValueProperty("middleName");
		String lastName = (String) getValueProperty("lastName");

		// Extract the billingAddress and shippingAddress, as dictionary
		// objects,
		// from the values dictionary.
		Dictionary billingAddress = (Dictionary) getValueProperty("billingAddress");
		Dictionary shippingAddress = (Dictionary) getValueProperty("shippingAddress");

		// Copy all three names to billing & shipping addresses
		if (billingAddress != null) {
			billingAddress.put("firstName", firstName);
			billingAddress.put("middleName", middleName);
			billingAddress.put("lastName", lastName);
		}

		if (shippingAddress != null && !isShipToBillingAddress()) {
			shippingAddress.put("firstName", firstName);
			shippingAddress.put("middleName", middleName);
			shippingAddress.put("lastName", lastName);
		}

	}

	// ----------- (post)CreateUser ------------
	/**
	 * Set the registration date to 'now'. If the user has asked to use the same
	 * address for shipping and billing, make it so.
	 * <p>
	 * 
	 * @param pRequest
	 *            the servlet's request
	 * @param pResponse
	 *            the servlet's response
	 * @exception ServletException
	 *                if there was an error while executing the code
	 * @exception IOException
	 *                if there was an error with servlet io
	 */
	protected void postCreateUser(DynamoHttpServletRequest pRequest,
			DynamoHttpServletResponse pResponse) throws ServletException,
			IOException {
		super.postCreateUser(pRequest, pResponse);
		CommercePropertyManager cpmgr = retrieveCommercePropertyManager();

		Boolean isCreated = (Boolean) pRequest
				.getObjectParameter(HANDLE_CREATE_PARAM);
		if ((isCreated != null) && (isCreated.booleanValue())) {
			// We need the user's profile and shipping addresses
			Profile profile = getProfile();
			RepositoryItem shippingAddress = (RepositoryItem) profile
					.getPropertyValue(cpmgr.getShippingAddressPropertyName());

			// 1. Set Registration date to 'now'
			profile.setPropertyValue(cpmgr.getRegistrationDatePropertyName(),
					new java.util.Date());

			// 2. If the user has asked to use the billing address as her/his
			// shipping address...
			if (isShipToBillingAddress()) {
				RepositoryItem billaddr = (RepositoryItem) profile
						.getPropertyValue(cpmgr.getBillingAddressPropertyName());
				profile.setPropertyValue(
						cpmgr.getShippingAddressPropertyName(), billaddr);
			}
		}

	}

	/*
	 * --------------------------------------------------------------------------
	 * Create new shipping address
	 * 
	 * in PioneerCycling/user:
	 * 
	 * new_shipping_address.jhtml -> form returns user to address_book.jhtml -
	 * submit invokes _newAddress_ handler
	 */

	// ----------- Submit: newAddress ------------
	/**
	 * Creates a new shipping address using the entries entered in the editValue
	 * map by the new_shipping_address.jhtml page. The address will be indexed
	 * using the nickname provided by the user.
	 * 
	 * @param pRequest
	 *            the servlet's request
	 * @param pResponse
	 *            the servlet's response
	 * @exception ServletException
	 *                if there was an error while executing the code
	 * @exception IOException
	 *                if there was an error with servlet io
	 */
	public boolean handleNewAddress(DynamoHttpServletRequest pRequest,
			DynamoHttpServletResponse pResponse) throws ServletException,
			IOException {
		TransactionManager tm = getTransactionManager();
		TransactionDemarcation td = getTransactionDemarcation();
		CommercePropertyManager cpmgr = retrieveCommercePropertyManager();

		try {
			if (tm != null)
				td.begin(tm, TransactionDemarcation.REQUIRED);

			// redirect now if there were missing required properties
			if (getFormError())
				return redirectIfPossible(getNewAddressErrorURL(), pRequest,
						pResponse);

			Profile profile = getProfile();
			MutableRepository repository = (MutableRepository) profile
					.getRepository();
			Map secondaryAddresses = (Map) profile.getPropertyValue(cpmgr
					.getSecondaryAddressPropertyName());

			// What address fields are we looking for
			String[] addressProperties = getAddressProperties();

			Iterator addressIterator = getAddressPropertyList().iterator();

			// Get editValue map, containing the user form data
			HashMap newAddress = (HashMap) getEditValue();
			String nickname = (String) newAddress.get("nickname");

			// Check that the nickname is not already used for a secondary
			// address
			if (((Map) profile.getPropertyValue(cpmgr
					.getSecondaryAddressPropertyName())).get(nickname) != null) {
				ResourceBundle bundle = ResourceUtils.getBundle(
						RESOURCE_BUNDLE, getLocale(pRequest));
				String rawErrorStr = bundle
						.getString(MSG_DUPLICATE_ADDRESS_NICKNAME);
				String formattedErrorStr = (new MessageFormat(rawErrorStr))
						.format(new String[] { nickname });
				addFormException(new DropletFormException(formattedErrorStr,
						getAbsoluteName() + "editValue.nickname",
						MSG_DUPLICATE_ADDRESS_NICKNAME));
				return redirectIfPossible(getNewAddressErrorURL(), pRequest,
						pResponse);
			}

			// If we successfully collected all needed user input, create a new
			// address
			try {
				// Create a repository item to be filled with stuff.
				MutableRepositoryItem address = repository.createItem(cpmgr
						.getContactInfoItemDescriptorName());

				// Copy values from the newAddress object
				Object property;
				String propertyName;
				while (addressIterator.hasNext()) {
					propertyName = (String) addressIterator.next();
					property = newAddress.get(propertyName);
					if (property != null)
						address.setPropertyValue(propertyName, property);
				}

				// Update adress into the db and insert into secondaryAddresses
				// map
				repository.addItem(address);
				secondaryAddresses.put(nickname, address);

				// empty out the map
				newAddress.clear();
			} catch (RepositoryException repositoryExc) {
				generateFormException(MSG_ERR_CREATING_ADDRESS, repositoryExc,
						pRequest);
				if (isLoggingError())
					logError(repositoryExc);

				// failure - redirect if an error URL was specified
				return redirectIfPossible(getNewAddressErrorURL(), pRequest,
						pResponse);
			}

			// Success; redirect if required to do so following success
			return redirectIfPossible(getNewAddressSuccessURL(), pRequest,
					pResponse);
		} catch (TransactionDemarcationException e) {
			throw new ServletException(e);
		} finally {
			try {
				if (tm != null)
					td.end();
			} catch (TransactionDemarcationException e) {
				if (isLoggingDebug())
					logDebug("Ignoring exception", e);
			}
		}
	}

	/*
	 * --------------------------------------------------------------------------
	 * Edit secondary address
	 * 
	 * in PioneerCycling/user:
	 * 
	 * address_book.jhtml -> hyperlink to edit_secondary_address.jhtml (link
	 * invokes _editAddress_ handler)
	 * 
	 * edit_secondary_address.jhtml -> form returns user to address_book.jhtml
	 * (submit invokes _updateAddress_ handler) -> form returns user to
	 * address_book.jhtml (submit invokes _updateAddressAndMakeDefault_ handler)
	 * -> form returns user to address_book.jhtml (submit invokes
	 * _changeAddressNickname_ handler)
	 */

	// ----------- Submit: EditAddress ------------
	/**
	 * Copy the named seconary address into the editValue map, allowing the user
	 * to edit them in the edit_secondary_address.jhtml page.
	 * 
	 * @param pRequest
	 *            the servlet's request
	 * @param pResponse
	 *            the servlet's response
	 * @exception ServletException
	 *                if there was an error while executing the code
	 * @exception IOException
	 *                if there was an error with servlet io
	 */
	public boolean handleEditAddress(DynamoHttpServletRequest pRequest,
			DynamoHttpServletResponse pResponse) throws ServletException,
			IOException {
		TransactionManager tm = getTransactionManager();
		TransactionDemarcation td = getTransactionDemarcation();
		CommercePropertyManager cpmgr = retrieveCommercePropertyManager();

		try {
			if (tm != null)
				td.begin(tm, TransactionDemarcation.REQUIRED);

			String nickname = getEditAddress();
			if (nickname == null || nickname.trim().length() == 0) {
				// we should only get here through a hyperlink that supplies the
				// secondary address nickname. Just in case, exit quietly.
				return true;
			}
			Profile profile = getProfile();
			Map secondaryAddress = (Map) profile.getPropertyValue(cpmgr
					.getSecondaryAddressPropertyName());
			MutableRepositoryItem theAddress = (MutableRepositoryItem) secondaryAddress
					.get(nickname);
			Map edit = getEditValue();

			// record the nickname for posterity (actually, the updateAddress
			// handler)
			edit.put("nickname", nickname);
			// and for the changeAddressNickname handler
			edit.put("newNickname", nickname);
			String[] addressProps = getAddressProperties();
			// Store each property in the map, for use by
			// edit_secondary_address.jhtml
			Object property;
			for (int i = 0; i < addressProps.length; i++) {
				property = theAddress.getPropertyValue(addressProps[i]);
				if (property != null)
					edit.put(addressProps[i], property);
			}

			return true;
		} catch (TransactionDemarcationException e) {
			throw new ServletException(e);
		} finally {
			try {
				if (tm != null)
					td.end();
			} catch (TransactionDemarcationException e) {
				if (isLoggingDebug())
					logDebug("Ignoring exception", e);
			}
		}
	}

	// ----------- Submit: updateAddress ------------
	/**
	 * Update the secondary address as modified by the user.
	 * 
	 * @param pRequest
	 *            the servlet's request
	 * @param pResponse
	 *            the servlet's response
	 * @exception ServletException
	 *                if there was an error while executing the code
	 * @exception IOException
	 *                if there was an error with servlet io
	 */
	public boolean handleUpdateAddress(DynamoHttpServletRequest pRequest,
			DynamoHttpServletResponse pResponse) throws RepositoryException,
			ServletException, IOException {
		TransactionManager tm = getTransactionManager();
		TransactionDemarcation td = getTransactionDemarcation();
		CommercePropertyManager cpmgr = retrieveCommercePropertyManager();

		try {
			if (tm != null)
				td.begin(tm, TransactionDemarcation.REQUIRED);

			// redirect now if there were missing required properties
			if (getFormError())
				return redirectIfPossible(getUpdateAddressErrorURL(), pRequest,
						pResponse);

			Profile profile = getProfile();
			MutableRepository repository = (MutableRepository) profile
					.getRepository();
			Map secondaryAddress = (Map) profile.getPropertyValue(cpmgr
					.getSecondaryAddressPropertyName());

			Map edit = getEditValue();
			String nickname = (String) edit.get("nickname");

			MutableRepositoryItem theAddress = (MutableRepositoryItem) secondaryAddress
					.get(nickname);

			// What address fields are we looking for
			String[] addressProps = getAddressProperties();

			// Copy each property
			Object property;
			for (int i = 0; i < addressProps.length; i++) {
				property = edit.get(addressProps[i]);
				if (property != null)
					theAddress.setPropertyValue(addressProps[i], property);
			}

			try {
				repository.updateItem(theAddress);
			} catch (RepositoryException repositoryExc) {
				generateFormException(MSG_ERR_UPDATING_ADDRESS, repositoryExc,
						pRequest);
				if (isLoggingError())
					logError(repositoryExc);

				return redirectIfPossible(getUpdateAddressErrorURL(), pRequest,
						pResponse);
			}

			edit.clear();

			return redirectIfPossible(getUpdateAddressSuccessURL(), pRequest,
					pResponse);
		} catch (TransactionDemarcationException e) {
			throw new ServletException(e);
		} finally {
			try {
				if (tm != null)
					td.end();
			} catch (TransactionDemarcationException e) {
				if (isLoggingDebug())
					logDebug("Ignoring exception", e);
			}
		}
	}

	// ----------- Submit: updateAddressAndMakeDefault ------------
	/**
	 * Update the secondary address as modified by the user, and copy its
	 * contents to the default shipping address.
	 * 
	 * @param pRequest
	 *            the servlet's request
	 * @param pResponse
	 *            the servlet's response
	 * @exception ServletException
	 *                if there was an error while executing the code
	 * @exception IOException
	 *                if there was an error with servlet io
	 */
	public boolean handleUpdateAddressAndMakeDefault(
			DynamoHttpServletRequest pRequest,
			DynamoHttpServletResponse pResponse) throws RepositoryException,
			ServletException, IOException {
		TransactionManager tm = getTransactionManager();
		TransactionDemarcation td = getTransactionDemarcation();
		try {
			if (tm != null)
				td.begin(tm, TransactionDemarcation.REQUIRED);

			// Record nickname
			String nickname = (String) getEditValue().get("nickname");
			// Update the address normally
			handleUpdateAddress(pRequest, pResponse);
			// Make this address the default
			try {
				makeAddressDefaultShippingAddress(getProfile(), nickname);
			} catch (Exception e) {
				generateFormException(MSG_ERR_UPDATING_ADDRESS,
						"defaultAddressName", pRequest);
			}

			return true;
		} catch (TransactionDemarcationException e) {
			throw new ServletException(e);
		} finally {
			try {
				if (tm != null)
					td.end();
			} catch (TransactionDemarcationException e) {
				if (isLoggingDebug())
					logDebug("Ignoring exception", e);
			}
		}
	}

	// ------------ Submit: ChangeAddressNickname ------------
	/**
	 * Changes the key in the secondaryAddresses map for the given address.
	 * 
	 * @param pRequest
	 *            the servlet's request
	 * @param pResponse
	 *            the servlet's response
	 * @exception ServletException
	 *                if there was an error while executing the code
	 * @exception IOException
	 *                if there was an error with servlet io
	 */
	public boolean handleChangeAddressNickname(
			DynamoHttpServletRequest pRequest,
			DynamoHttpServletResponse pResponse) throws ServletException,
			IOException {
		TransactionManager tm = getTransactionManager();
		TransactionDemarcation td = getTransactionDemarcation();
		try {
			if (tm != null)
				td.begin(tm, TransactionDemarcation.REQUIRED);

			// Commerce profile tools and property manager
			CommerceProfileTools cptools = (CommerceProfileTools) getProfileTools();
			CommercePropertyManager cpmgr = (CommercePropertyManager) getProfileTools()
					.getPropertyManager();

			// Get old and new nickname values
			Map edit = getEditValue();
			String oldNickname = (String) edit.get("nickname");
			String newNickname = (String) edit.get("newNickname");
			if (oldNickname == null || newNickname == null
					|| oldNickname.equals(newNickname))
				return true;

			// Update address book with new nickname
			try {
				// Get profile and address book map to contactInfo repository
				// items.
				Profile profile = getProfile();
				Map secondaryAddress = (Map) profile.getPropertyValue(cpmgr
						.getSecondaryAddressPropertyName());
				// Get address repository item
				RepositoryItem oldAddress = (RepositoryItem) secondaryAddress
						.get(oldNickname);

				// Remove old nickname
				secondaryAddress.remove(oldNickname);

				// Call addProfileRepositoryAddress to add address to address
				// book
				cptools.addProfileRepositoryAddress(profile, newNickname,
						oldAddress);
			} catch (RepositoryException repositoryExc) {
				generateFormException(MSG_ERR_MODIFYING_NICKNAME,
						repositoryExc, pRequest);
				if (isLoggingError())
					logError(repositoryExc);

				// failure - redirect if an error URL was specified
				return redirectIfPossible(getChangeAddressNicknameErrorURL(),
						pRequest, pResponse);
			}

			// Success; redirect if required to do so following success
			return redirectIfPossible(getChangeAddressNicknameSuccessURL(),
					pRequest, pResponse);
		} catch (TransactionDemarcationException e) {
			throw new ServletException(e);
		} finally {
			try {
				if (tm != null)
					td.end();
			} catch (TransactionDemarcationException e) {
				if (isLoggingDebug())
					logDebug("Ignoring exception", e);
			}
		}
	}

	/*
	 * --------------------------------------------------------------------------
	 * Remove secondary address
	 * 
	 * in PioneerCycling/user:
	 * 
	 * address_book.jhtml -> hyperlink back to itself (link invokes
	 * _removeAddress_ handler)
	 */

	// ------------ Submit: RemoveAddress ------------
	/**
	 * This handler deletes a secondary address named in the removeAddress
	 * property. A hyperlink in the address_book.jhtml page both sets the
	 * property and invokes the handler.
	 * 
	 * @param pRequest
	 *            the servlet's request
	 * @param pResponse
	 *            the servlet's response
	 * @exception ServletException
	 *                if there was an error while executing the code
	 * @exception IOException
	 *                if there was an error with servlet io
	 */
	public boolean handleRemoveAddress(DynamoHttpServletRequest pRequest,
			DynamoHttpServletResponse pResponse) throws ServletException,
			IOException {
		TransactionManager tm = getTransactionManager();
		TransactionDemarcation td = getTransactionDemarcation();
		try {
			if (tm != null)
				td.begin(tm, TransactionDemarcation.REQUIRED);

			CommercePropertyManager cpmgr = (CommercePropertyManager) getProfileTools()
					.getPropertyManager();
			String nickname = getRemoveAddress();
			if (nickname == null || nickname.trim().length() == 0) {
				if (isLoggingDebug())
					logDebug("A null or empty nickname was provided to handleRemoveAddress");
				// if no nickname provided, do nothing.
				return true;
			}

			Profile profile = getProfile();
			// MutableRepository repository = (MutableRepository)
			// profile.getRepository();
			Map secondaryAddress = (Map) profile.getPropertyValue(cpmgr
					.getSecondaryAddressPropertyName());
			secondaryAddress.remove(nickname);
			return true;
		} catch (TransactionDemarcationException e) {
			throw new ServletException(e);
		} finally {
			try {
				if (tm != null)
					td.end();
			} catch (TransactionDemarcationException e) {
				if (isLoggingDebug())
					logDebug("Ignoring exception", e);
			}
		}
	}

	/*
	 * --------------------------------------------------------------------------
	 * Select Shipping address
	 * 
	 * in PioneerCycling/user:
	 * 
	 * address_book.jhtml -> form pointing back to itself (submit invokes
	 * _selectDefaultAddress_ handler)
	 */

	// ------------ Submit: SelectDefaultAddress ------------
	/**
	 * Copy the contents of a secondary address (identified in the editValue map
	 * by the entry <i>defaultAddressNickname</i>) to the default shipping
	 * address.
	 * 
	 * @param pRequest
	 *            the servlet's request
	 * @param pResponse
	 *            the servlet's response
	 * @exception ServletException
	 *                if there was an error while executing the code
	 * @exception IOException
	 *                if there was an error with servlet io
	 */
	public boolean handleSelectDefaultAddress(
			DynamoHttpServletRequest pRequest,
			DynamoHttpServletResponse pResponse) throws ServletException,
			IOException {
		TransactionManager tm = getTransactionManager();
		TransactionDemarcation td = getTransactionDemarcation();
		CommercePropertyManager cpmgr = retrieveCommercePropertyManager();

		try {
			if (tm != null)
				td.begin(tm, TransactionDemarcation.REQUIRED);

			// Get the nickname of the desired address, using the editValue map
			String nickname = (String) getEditValue().get(
					"defaultAddressNickname");

			if (nickname == null || nickname.trim().length() == 0) {
				if (isLoggingDebug())
					logDebug("A null or empty nickname was provided to handleSelectDefaultAddress");
				// if no nickname was provided, exit quietly
				return true;
			}

			// Make the selected address the default
			try {
				makeAddressDefaultShippingAddress(getProfile(), nickname);
			} catch (Exception e) {
				generateFormException(MSG_ERR_UPDATING_ADDRESS,
						"defaultAddressName", pRequest);
			}

			return true;
		} catch (TransactionDemarcationException e) {
			throw new ServletException(e);
		} finally {
			try {
				if (tm != null)
					td.end();
			} catch (TransactionDemarcationException e) {
				if (isLoggingDebug())
					logDebug("Ignoring exception", e);
			}
		}
	}

	// ------ Utility method: copy secondary address to default shipping address
	// ------
	/**
	 * For the given Profile, make the address known by pNickname the default
	 * shipping address.
	 * 
	 * @param pProfile
	 *            the User's profile
	 * @param pNickname
	 *            the name of the address to make default private boolean
	 *            makeAddressDefaultShippingAddress( Profile pProfile, String
	 *            pNickname ) throws RepositoryException {
	 * 
	 *            // put the shipping address into a temp address
	 *            MutableRepositoryItem shippingAddress =
	 *            (MutableRepositoryItem)
	 *            pProfile.getPropertyValue("shippingAddress");
	 * 
	 *            // delete shipping address from the repository
	 *            ((CommerceProfileTools
	 *            )getProfileTools()).removeProfileRepositoryAddress(pProfile,
	 *            "shippingAddress");
	 * 
	 *            // Move the selected member of secondary addresses into the
	 *            shipping address. Map secondaryAddresses = (Map)
	 *            pProfile.getPropertyValue("secondaryAddresses");
	 *            MutableRepositoryItem newShippingAddress =
	 *            (MutableRepositoryItem) secondaryAddresses.get( pNickname );
	 *            if (isLoggingDebug()) logDebug
	 *            ("set shipping address to new shipping Address: " +
	 *            newShippingAddress.getRepositoryId());
	 *            pProfile.setPropertyValue("shippingAddress",
	 *            newShippingAddress);
	 * 
	 *            // put the old shipping address into the secondary addresses
	 *            if it is not already there if
	 *            (!secondaryAddresses.containsValue(shippingAddress))
	 *            secondaryAddresses.put("Former Default Shipping Address",
	 *            shippingAddress);
	 * 
	 *            return true; }
	 */

	private boolean makeAddressDefaultShippingAddress(Profile pProfile,
			String pNickname) {
		CommercePropertyManager cpmgr = retrieveCommercePropertyManager();

		Map secondaryAddresses = (Map) pProfile.getPropertyValue(cpmgr
				.getSecondaryAddressPropertyName());
		MutableRepositoryItem shippingAddress = (MutableRepositoryItem) pProfile
				.getPropertyValue(cpmgr.getShippingAddressPropertyName());
		if (!secondaryAddresses.containsValue(shippingAddress))
			secondaryAddresses.put("Former Default Shipping Address",
					shippingAddress);

		// Move the selected member of secondary addresses into the shipping
		// address.
		MutableRepositoryItem newShippingAddress = (MutableRepositoryItem) ((CommerceProfileTools) getProfileTools())
				.getProfileAddress(pProfile, pNickname);
		if (isLoggingDebug())
			logDebug("set shipping address to new shipping Address: "
					+ newShippingAddress.getRepositoryId());
		pProfile.setPropertyValue(cpmgr.getShippingAddressPropertyName(),
				newShippingAddress);

		return true;
	}

	// ------------ Submit: SetExpressCheckout ------------
	/**
	 * Enable or disable express checkout
	 * 
	 * If disabling, clear the default credit card in the user's profile so that
	 * that credit card may be safely deleted.
	 * 
	 * Note that if you are enabling express checkout, the user must have a
	 * valid credit card selected for defaultCreditCard, a valid shipping method
	 * selected, and a valid shipping address. Therefore, it's better to use
	 * handleSetExpressCheckout() to enable express checkout instead of this
	 * method, since the former will set these values and ensure express
	 * checkout is enabled at the same time.
	 * 
	 * This handler should now be used only to disable express checkout.
	 * 
	 * @param pRequest
	 *            the servlet's request
	 * @param pResponse
	 *            the servlet's response
	 * @exception ServletException
	 *                if there was an error while executing the code
	 * @exception IOException
	 *                if there was an error with servlet io
	 */
	public boolean handleSetExpressCheckout(DynamoHttpServletRequest pRequest,
			DynamoHttpServletResponse pResponse) throws ServletException,
			IOException {
		CommercePropertyManager cpmgr = retrieveCommercePropertyManager();

		String expressCheckoutStr = (String) getEditValue().get(
				"expressCheckout");

		if (expressCheckoutStr == null || expressCheckoutStr.length() == 0) {
			if (isLoggingDebug())
				logDebug("expressCheckout not set");
			return true;
		}

		Boolean expressCheckout = Boolean.valueOf(expressCheckoutStr);

		if (isLoggingDebug())
			logDebug("setting expressCheckout to: " + expressCheckout);

		Profile profile = getProfile();

		if (!expressCheckout.booleanValue()) {
			// If disabling express checkout, clear the default credit card
			// so it's able to be deleted from the credit card editing page
			// and so that if it is deleted, and express checkout is re-
			// enabled, it's not invalid.
			profile.setPropertyValue(cpmgr.getDefaultCreditCardPropertyName(),
					null);
		}

		// Finally, enable express checkout in profile
		profile.setPropertyValue("expressCheckout", expressCheckout);

		return true;
	}

	// ------------ Submit: SetExpressCheckoutPreferences ------------
	/**
	 * Set values used for express checkout
	 * 
	 * @param pRequest
	 *            the servlet's request
	 * @param pResponse
	 *            the servlet's response
	 * @exception ServletException
	 *                if there was an error while executing the code
	 * @exception IOException
	 *                if there was an error with servlet io
	 */
	public boolean handleSetExpressCheckoutPreferences(
			DynamoHttpServletRequest pRequest,
			DynamoHttpServletResponse pResponse) throws ServletException,
			IOException {
		TransactionManager tm = getTransactionManager();
		TransactionDemarcation td = getTransactionDemarcation();
		CommercePropertyManager cpmgr = retrieveCommercePropertyManager();

		try {
			if (tm != null)
				td.begin(tm, TransactionDemarcation.REQUIRED);

			// Set the default carrier
			getProfile().setPropertyValue(
					cpmgr.getDefaultShippingMethodPropertyName(),
					getDefaultCarrier());

			// Set the default address
			String defaultAddressName = (String) getEditValue().get(
					"defaultAddressNickname");
			if (defaultAddressName == null
					|| defaultAddressName.trim().length() == 0) {
				if (isLoggingInfo())
					logInfo("A null or empty nickname was provided to handleSetExpressCheckoutPreferences");
			} else {
				try {
					makeAddressDefaultShippingAddress(getProfile(),
							defaultAddressName);
				} catch (Exception e) {
					generateFormException(MSG_ERR_UPDATING_ADDRESS,
							"defaultAddressName", pRequest);
				}
			}

			if (isLoggingDebug()) {
				logDebug("B2CProfileFormHandler validated nickname, defaultCreditCardID = "
						+ getDefaultCreditCardID());
			}

			// Set the default credit card
			if (!makeCreditCardDefault(getProfile(), getDefaultCreditCardID())) {
				if (isLoggingDebug())
					logDebug(MSG_MISSING_DEFAULT_CC);
				generateFormException(MSG_MISSING_DEFAULT_CC,
						"defaultCreditCard", pRequest);
			}

			// Make sure express checkout is enabled
			getProfile().setPropertyValue("expressCheckout", Boolean.TRUE);

			return true;
		} catch (TransactionDemarcationException e) {
			throw new ServletException(e);
		} finally {
			try {
				if (tm != null)
					td.end();
			} catch (TransactionDemarcationException e) {
				if (isLoggingDebug())
					logDebug("Ignoring exception", e);
			}
		}
	}

	// ------ Utility method: copy credit card id to profile's defaultCreditCard
	// ------
	/**
	 * Make the credit card identified by pCreditCardID default in the given
	 * profile.
	 * 
	 * @param pProfile
	 *            The Profile object
	 * @param pCreditCardID
	 *            The ID of the credit card to be default pje
	 */
	protected boolean makeCreditCardDefault(Profile pProfile,
			String pCreditCardID) {

		MutableRepository repository = (MutableRepository) pProfile
				.getRepository();
		CommercePropertyManager cpmgr = retrieveCommercePropertyManager();

		Map cards = (Map) pProfile.getPropertyValue(cpmgr
				.getCreditCardPropertyName());

		Iterator i = cards.values().iterator();
		while (i.hasNext()) {
			RepositoryItem card = (RepositoryItem) i.next();
			if (card != null) {
				String id = (String) card.getPropertyValue("id");
				if (pCreditCardID.equals(id)) {
					pProfile.setPropertyValue(cpmgr
							.getDefaultCreditCardPropertyName(), card);
					return true;
				}
			}
		}

		return false;
	}

	/*
	 * --------------------------------------------------------------------------
	 * Create new credit card entry
	 * 
	 * in PioneerCycling/user:
	 * 
	 * credit_cards.jhtml -> form points back to itself (submit invokes
	 * _createNewCreditCard_ handler) -> hyperlink back to itself (submit
	 * invokes _removeCard_ handler)
	 */

	// ------------ Submit: CreateNewCreditCard ------------
	/**
	 * Creates a new credit card using the entries entered in the editValue map
	 * by the credit_card.jhtml page
	 * 
	 * @param pRequest
	 *            the servlet's request
	 * @param pResponse
	 *            the servlet's response
	 * @exception ServletException
	 *                if there was an error while executing the code
	 * @exception IOException
	 *                if there was an error with servlet io
	 */
	public boolean handleCreateNewCreditCard(DynamoHttpServletRequest pRequest,
			DynamoHttpServletResponse pResponse) throws ServletException,
			IOException {
		TransactionManager tm = getTransactionManager();
		TransactionDemarcation td = getTransactionDemarcation();
		CommercePropertyManager cpmgr = retrieveCommercePropertyManager();
		try {
			if (tm != null)
				td.begin(tm, TransactionDemarcation.REQUIRED);

			Profile profile = getProfile();
			MutableRepository repository = (MutableRepository) profile
					.getRepository();
			Map creditCards = (Map) profile.getPropertyValue(cpmgr
					.getCreditCardPropertyName());
			ResourceBundle bundle = ResourceUtils.getBundle(RESOURCE_BUNDLE,
					getLocale(pRequest));

			// Identify credit card properties we need from user
			String[] cardProperties = getCardProperties();

			Iterator cardPropertyIterator = getCardPropertyList().iterator();

			// Get editValue map, containing the credit card properties
			HashMap newCard = (HashMap) getEditValue();

			boolean isMissingField = false;
			// Verify all required fields entered before creating new card
			Object property = null;
			String propertyName = null;
			while (cardPropertyIterator.hasNext()) {
				propertyName = (String) cardPropertyIterator.next();
				property = newCard.get(propertyName);
				if (property == null || ((String) property).length() == 0) {
					generateFormException(MSG_MISSING_CC_PROPERTY,
							propertyName, pRequest);
					isMissingField = true;
				}
			}
			if (isMissingField)
				return true;

			// Check that the nickname is not already used for a credit card
			String cardNickname = (String) newCard.get(cpmgr
					.getCreditCardNicknamePropertyName());
			if (creditCards.get(cardNickname) != null) {
				String rawErrorStr = bundle
						.getString(MSG_DUPLICATE_CC_NICKNAME);
				String formattedErrorStr = (new MessageFormat(rawErrorStr))
						.format(new String[] { cardNickname });
				addFormException(new DropletFormException(formattedErrorStr,
						getAbsoluteName() + "editValue.creditCardNickname",
						MSG_DUPLICATE_CC_NICKNAME));
				return true;
			}

			try {
				// Create a repository item to be filled with stuff.
				MutableRepositoryItem card = repository.createItem(cpmgr
						.getCreditCardItemDescriptorName());

				// Copy values from the newCreditCard object
				cardPropertyIterator = getCardPropertyList().iterator();
				while (cardPropertyIterator.hasNext()) {
					propertyName = (String) cardPropertyIterator.next();
					property = newCard.get(propertyName);
					card.setPropertyValue(propertyName, property);
				}

				// Set billing address
				card.setPropertyValue(cpmgr
						.getCreditCardBillingAddressPropertyName(),
						profile.getPropertyValue(cpmgr
								.getBillingAddressPropertyName()));

				// Insert card into the db
				repository.addItem(card);

				// Insert the credit card into the creditCards map
				// Did the user provide us with a name?
				String key = (String) newCard.get(cpmgr
						.getCreditCardNicknamePropertyName());
				if (key == null || key.trim().length() == 0) {
					// If no name, generate unique key
					// Use the credit card type (convert any spaces to _ so as
					// to find it in the bundle
					StringBuffer buffer = new StringBuffer((String) card
							.getPropertyValue(cpmgr
									.getCreditCardTypePropertyName()));
					for (int i = 0; i < buffer.length(); i++) {
						if (buffer.charAt(i) == ' ')
							buffer.setCharAt(i, '_');
					}
					// Generate the key as CARD-ABBREV + CardNumber
					String abbrev = bundle.getString(buffer.toString());
					if (abbrev == null)
						abbrev = "";
					key = abbrev
							+ (String) card.getPropertyValue(cpmgr
									.getCreditCardNumberPropertyName());
				}

				// Set the new credit card
				creditCards.put(key, card);

				// empty out the map
				newCard.clear();
			} catch (RepositoryException repositoryExc) {
				generateFormException(MSG_ERR_CREATING_CC, repositoryExc,
						pRequest);
				if (isLoggingError())
					logError(repositoryExc);

				return redirectIfPossible(getCreateCardErrorURL(), pRequest,
						pResponse);
			}

			return redirectIfPossible(getCreateCardSuccessURL(), pRequest,
					pResponse);
		} catch (TransactionDemarcationException e) {
			throw new ServletException(e);
		} finally {
			try {
				if (tm != null)
					td.end();
			} catch (TransactionDemarcationException e) {
				if (isLoggingDebug())
					logDebug("Ignoring exception", e);
			}
		}
	}

	// ------ Utility method: validate credit card number & expiration date
	// ------
	/**
	 * Validate the credit card number entered and the expiration date (must be
	 * later than today).
	 * 
	 * @param card
	 *            A hashmap containing the user-entered credit card data
	 * @param bundle
	 *            A ResourceBundle providing the error message text
	 * @return true if the credit card is valid
	 **/

	// ------------ Submit: RemoveCard ------------
	/**
	 * Delete a specified credit card for the current user.
	 * 
	 * @param pRequest
	 *            the servlet's request
	 * @param pResponse
	 *            the servlet's response
	 * @exception ServletException
	 *                if there was an error while executing the code
	 * @exception IOException
	 *                if there was an error with servlet io
	 */
	public boolean handleRemoveCard(DynamoHttpServletRequest pRequest,
			DynamoHttpServletResponse pResponse) throws ServletException,
			IOException {
		TransactionManager tm = getTransactionManager();
		TransactionDemarcation td = getTransactionDemarcation();
		CommercePropertyManager cpmgr = retrieveCommercePropertyManager();

		try {
			if (tm != null)
				td.begin(tm, TransactionDemarcation.REQUIRED);

			String targetCard = getRemoveCard();
			if (targetCard == null || targetCard.trim().length() == 0) {
				if (isLoggingDebug())
					logDebug("A null or empty nickname was provided to handleRemoveCard");
				// if no nickname provided, do nothing.
				return redirectIfPossible(getRemoveCardErrorURL(), pRequest,
						pResponse);
			}
			Profile profile = getProfile();
			MutableRepository repository = (MutableRepository) profile
					.getRepository();
			Map creditCards = (Map) profile.getPropertyValue(cpmgr
					.getCreditCardPropertyName());
			MutableRepositoryItem card = (MutableRepositoryItem) creditCards
					.get(targetCard);
			creditCards.remove(targetCard);

			// Success; redirect if required to do so following success
			return redirectIfPossible(getRemoveCardSuccessURL(), pRequest,
					pResponse);
		} catch (TransactionDemarcationException e) {
			throw new ServletException(e);
		} finally {
			try {
				if (tm != null)
					td.end();
			} catch (TransactionDemarcationException e) {
				if (isLoggingDebug())
					logDebug("Ignoring exception", e);
			}
		}
	}

	/**
	 * Create a new repository item with the same properties as the source item.
	 * This will copy only primitive properties. It will not create new
	 * properties that are repository items. This would be useful if we were
	 * copying the shipping addr from the billing addr, but instead we are just
	 * referring.
	 * 
	 * @returns MutableRepositoryItem the cloned item
	 **/
	MutableRepositoryItem cloneItem(RepositoryItem pSource)
			throws RepositoryException {
		// Create a new repository item to be filled with the properties of
		// pSource.
		MutableRepository repository = (MutableRepository) getProfile()
				.getRepository();
		MutableRepositoryItem newItem = repository.createItem(pSource
				.getItemDescriptor().getItemDescriptorName());
		return cloneItem(pSource, newItem);
	}

	/**
	 * Create a new repository item with the same properties as the source item.
	 * This will copy only primitive properties. It will not create new
	 * properties that are repository items. This would be useful if we were
	 * copying the shipping addr from the billing addr, but instead we are just
	 * referring.
	 * 
	 * @returns MutableRepositoryItem the cloned item
	 **/
	MutableRepositoryItem cloneItem(RepositoryItem pSource,
			MutableRepositoryItem pDest) throws RepositoryException {
		MutableRepository repository = (MutableRepository) getProfile()
				.getRepository();
		DynamicPropertyDescriptor[] pds = pSource.getItemDescriptor()
				.getPropertyDescriptors();
		for (int i = 0; i < pds.length; i++) {
			RepositoryPropertyDescriptor pd = (RepositoryPropertyDescriptor) pds[i];
			if (isLoggingDebug())
				logDebug("copying property : " + pd.getName());
			if (!pd.getName().equals("id"))
				pDest.setPropertyValue(pd.getName(), pSource
						.getPropertyValue(pd.getName()));
		}

		return pDest;
	}

} // end of class

