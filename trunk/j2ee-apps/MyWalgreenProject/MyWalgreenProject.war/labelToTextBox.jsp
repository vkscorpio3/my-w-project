<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Success</title>
<script src="jquery-1.7.1.min.js"></script>
<script>
	
	$(document).ready(
			function() {
				$("#Edit").click(
						function() {
							$("label").replaceWith(
									function() {
										return "<input type=\"text\" value=\""
												+ $(this).html() + "\" />";
									});
						});
			});
</script>
</head>
<body>
<h1>Label to Text Box</h1>
<label>First Name</label>
<input type="button" value="Edit" id="Edit" />
</body>
</html>