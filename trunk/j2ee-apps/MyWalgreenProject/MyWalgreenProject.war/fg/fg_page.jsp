<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<dsp:page>
<html>
<html>
<head>
<style><style type="text/css">

.gallerycontainer{
position: relative;
/*Add a height attribute and set to largest image's height to prevent overlaying*/
}

.thumbnail img{
border: 1px solid white;
margin: 0 5px 5px 0;
}

.thumbnail:hover{
background-color: transparent;
}

.thumbnail:hover img{
border: 1px solid blue;
}

.thumbnail span{ /*CSS for enlarged image*/
position: absolute;
background-color: lightyellow;
padding: 5px;
left: -1000px;
border: 1px dashed gray;
visibility: hidden;
color: black;
text-decoration: none;
}

.thumbnail span img{ /*CSS for enlarged image*/
border-width: 0;
padding: 2px;
}

.thumbnail:hover span{ /*CSS for enlarged image*/
visibility: visible;
top: 0;
left: 300px; /*position where enlarged image should offset horizontally */
z-index: 50;
}

</style>

</head>
<body>

<div class="gallerycontainer">

<a class="thumbnail" href="#thumb"><dsp:img src="../photo/e-commerce.jpg" alt="Walgreens"  width="550" height="200"/><span><dsp:img src="../photo/e-commerce.jpg" /><br /></span></a>

<a class="thumbnail" href="#thumb"><dsp:img src="../photo/e-ticaret-siteleri.jpg" alt="Walgreens" width="550" height="200"/><span><dsp:img src="../photo/e-ticaret-siteleri.jpg" /><br /></span></a>

<br />

<a class="thumbnail" href="#thumb"><dsp:img src="../photo/ecommerce-1.jpg" alt="Walgreens" width="550" height="200"/><span><dsp:img src="../photo/ecommerce-1.jpg" /><br /></span></a> 

<a class="thumbnail" href="#thumb"><dsp:img src="../photo/new-ecommerce.jpg" alt="Walgreens" width="550" height="200"/><span><dsp:img src="../photo/new-ecommerce.jpg" /><br /></span></a>

</div>


</body>
</html>
</dsp:page>