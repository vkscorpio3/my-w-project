<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<dsp:page>
	<dsp:importbean bean="/atg/userprofiling/Profile" />
	<dsp:importbean bean="/atg/userprofiling/ProfileFormHandler" />
	<dsp:importbean bean="/atg/dynamo/Configuration" />
	<dsp:importbean bean="/atg/formhandler/SearchFormHandler" />
	<dsp:importbean bean="/atg/commerce/ShoppingCart" />
	<dsp:importbean bean="/atg/dynamo/droplet/ForEach" />
	<dsp:importbean bean="/atg/dynamo/droplet/Switch" />
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Insert title here</title>
	<script type="text/javascript" src="jquery.dropotron-1.0.js"></script>
	</head>
	<body>
	<div id="menu"><dsp:droplet
		name="/atg/commerce/catalog/CategoryLookup">
		<dsp:param name="id" value="cat10002" />
		<dsp:oparam name="output">
			<ul>

				<dsp:droplet name="ForEach">
					<dsp:param name="array" param="element.childCategories" />
					<dsp:param name="elementName" value="category" />
					<dsp:oparam name="output">
						<!-- Display Categories like WholeBikes,Parts etc -->
						<li><dsp:a href="../catalog/searchResult.jsp">
							<dsp:valueof param="category.displayName" />
							<dsp:param name="subCategoryId" param="category.id" />
							<span class="arrow"></span>
						</dsp:a>
						<ul>
							<dsp:droplet name="/atg/dynamo/droplet/ForEach">
								<dsp:param name="array" param="category.childCategories" />
								<dsp:param name="elementName" value="subCategory" />
								<dsp:oparam name="output">
									<!-- Display Sub Categories -->
									<li><dsp:a href="../catalog/searchResult.jsp">
										<dsp:valueof param="subCategory.displayName" />
										<dsp:droplet name="/atg/dynamo/droplet/IsEmpty">
											<dsp:param name="value" param="subCategory.childCategories" />
											<dsp:oparam name="false">
												<span class="arrow"></span>
											</dsp:oparam>
										</dsp:droplet>
										<br class="clearfix" />
										<dsp:param name="subCategoryId" param="subCategory.id" />
									</dsp:a> <dsp:droplet name="/atg/dynamo/droplet/IsEmpty">
										<dsp:param name="value" param="subCategory.childCategories" />
										<dsp:oparam name="true">
											<ul></ul>
										</dsp:oparam>
										<dsp:oparam name="false">
											<ul>
												<dsp:droplet name="/atg/dynamo/droplet/ForEach">
													<dsp:param name="array" param="subCategory.childCategories" />
													<dsp:param name="elementName" value="childSubCategory" />
													<dsp:oparam name="output">
														<!-- Display Sub categories of Sub Categories -->
														<li><dsp:a href="../catalog/searchResult.jsp">
															<dsp:valueof param="childSubCategory.displayName" />
															<br class="clearfix" />
															<dsp:param name="subCategoryId"
																param="childSubCategory.id" />
														</dsp:a>
													</dsp:oparam>
												</dsp:droplet>
											</ul>
										</dsp:oparam>
									</dsp:droplet>
								</dsp:oparam>
							</dsp:droplet>
						</ul>
					</dsp:oparam>
				</dsp:droplet>
			</ul>
		</dsp:oparam>
	</dsp:droplet></div>
	</body>
</dsp:page>
</html>