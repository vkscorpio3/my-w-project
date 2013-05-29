<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<dsp:page>

<dsp:droplet name="/atg/dynamo/droplet/ForEach">
	<dsp:param bean="/atg/userprofiling/Profile.activePromotions" name="array"/>
	<dsp:oparam name="outputStart">
		<b>You have these promotions:</b><p>
	</dsp:oparam>
	<dsp:oparam name="output">
		<dsp:valueof param="element.promotion.displayName"/><br>
	</dsp:oparam>
	<dsp:oparam name="empty">You have no promotions</dsp:oparam>
</dsp:droplet>

</dsp:page>
