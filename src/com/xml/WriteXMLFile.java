/*
<?xml version="1.0" encoding="UTF-8" standalone="no" ?> 
<orders>
	<order id="010001">
		<username>Tuhin Chandra</username>
		<commerceItemId>ci10234</commerceItemId>
		<orderTotal>122.00</orderTotal>
	</order>
</orders>
 */

package com.xml;

import java.io.File;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

public class WriteXMLFile {

	public static void main(String argv[]) {

		try {

			DocumentBuilderFactory docFactory = DocumentBuilderFactory
					.newInstance();
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

			// root element - orders
			Document doc = docBuilder.newDocument();
			Element rootElementOrders = doc.createElement("orders");
			doc.appendChild(rootElementOrders);

			for (int i = 0; i < 5; i++) {
				// order elements
				Element order = doc.createElement("order");
				rootElementOrders.appendChild(order);

				// set attribute to order element
				Attr attr = doc.createAttribute("id");
				attr.setValue("o12345");
				order.setAttributeNode(attr);

				// shorten way
				// staff.setAttribute("id", "1");

				// username elements
				Element userName = doc.createElement("username");
				userName.appendChild(doc.createTextNode("Tuhin Chandra"));
				order.appendChild(userName);

				// commerceItemId elements
				Element commerceItemId = doc.createElement("commerceItemId");
				commerceItemId.appendChild(doc.createTextNode("ci12345"));
				order.appendChild(commerceItemId);

				// orderTotal elements
				Element orderTotal = doc.createElement("orderTotal");
				orderTotal.appendChild(doc.createTextNode("1224.5"));
				order.appendChild(orderTotal);
			}
			// write the content into xml file
			TransformerFactory transformerFactory = TransformerFactory
					.newInstance();
			Transformer transformer = transformerFactory.newTransformer();
			DOMSource source = new DOMSource(doc);
			StreamResult result = new StreamResult(new File("C:\\order.xml"));

			// Output to console for testing
			// StreamResult result = new StreamResult(System.out);

			transformer.transform(source, result);

			System.out.println("File saved!");

		} catch (ParserConfigurationException pce) {
			pce.printStackTrace();
		} catch (TransformerException tfe) {
			tfe.printStackTrace();
		}
	}
}