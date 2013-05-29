<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<dsp:page>

<dsp:importbean bean="/atg/commerce/promotion/CouponFormHandler"/>

<dsp:droplet name="/atg/dynamo/droplet/Switch">
<dsp:param bean="CouponFormHandler.formError" name="value"/>
<dsp:oparam name="true">
  <font color=cc0000><STRONG>There was a problem getting this coupon
  <UL>
    <dsp:droplet name="/atg/dynamo/droplet/ErrorMessageForEach">
      <dsp:param bean="CouponFormHandler.formExceptions" name="exceptions"/>
      <dsp:oparam name="output">
        <LI><dsp:valueof param="message"/>
      </dsp:oparam>
    </dsp:droplet>
    </UL></STRONG></font>
</dsp:oparam>
</dsp:droplet>


<b>If you have a coupon, type its code here:</b><br>
<dsp:form action="../cart.jsp" method="post">

<% /* Where to go to on success or failure */%>

<dsp:input bean="CouponFormHandler.claimCouponSuccessURL" beanvalue="/OriginatingRequest.requestURI" type="hidden"/>
<dsp:input bean="CouponFormHandler.claimCouponErrorURL" beanvalue="/OriginatingRequest.requestURI" type="hidden"/>


<%/* Get the coupon claim code */%>
Coupon code: <dsp:input bean="CouponFormHandler.couponClaimCode" type="text"/>

<dsp:input bean="CouponFormHandler.claimCoupon" type="submit" value="Claim it"/>
</dsp:form>

</dsp:page>
<%-- @version $Id: //product/DCS/version/9.0/release/PioneerCyclingJSP/j2ee-apps/pioneer/web-app/en/user/CouponClaim.jsp#1 $$Change: 508164 $--%>
