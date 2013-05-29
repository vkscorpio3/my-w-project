<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<dsp:page>

	<dsp:droplet name="/atg/dynamo/droplet/ForEach">
		<dsp:param bean="/atg/userprofiling/Profile.activePromotions"
			name="array" />
		<dsp:oparam name="outputStart">
			<b>You have these promotions:</b>
			<p>
		</dsp:oparam>
		<dsp:oparam name="output">
			<dsp:valueof param="element.promotion.id" />
			<br>
		</dsp:oparam>
		<dsp:oparam name="empty">You have no promotions</dsp:oparam>
	</dsp:droplet>

</dsp:page>
<%-- @version $Id: //product/DCS/version/9.0/release/PioneerCyclingJSP/j2ee-apps/pioneer/web-app/en/common/DisplayActivePromotions.jsp#1 $$Change: 508164 $--%>
