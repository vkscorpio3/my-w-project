package com.droplet;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;

import atg.repository.RepositoryException;
import atg.repository.RepositoryItem;
import atg.servlet.DynamoHttpServletRequest;
import atg.servlet.DynamoHttpServletResponse;
import atg.servlet.DynamoServlet;

import com.bean.OrderBean;
import com.bean.Products;
import com.tool.SearchDBManager;

public class HtmlEmailSenderDroplet extends DynamoServlet {
	SearchDBManager searchDBManager;
	public SearchDBManager getSearchDBManager() {
		return searchDBManager;
	}

	public void setSearchDBManager(SearchDBManager searchDBManager) {
		this.searchDBManager = searchDBManager;
	}

	@SuppressWarnings("unchecked")
	public void service(DynamoHttpServletRequest req,
			DynamoHttpServletResponse res) throws ServletException, IOException {
		String orderId = String.valueOf(req.getParameter("orderId"));
		OrderBean order = null;
		if (null != orderId) {
			// SMTP server information
			String host = "smtp.gmail.com";
			String port = "587";
			String mailFrom = "javamailtesting1@gmail.com";
			String password = "javamailtesting1";

			// outgoing message information
			String mailTo = "santuc1990@gmail.com";
			String message = "";

			// message contains HTML markups
			RepositoryItem[] orders = null;
			try {
				orders = searchDBManager.getOrderDetailByOrderId(req, orderId);
			} catch (RepositoryException e) {
				logError(e);
			}
			if (null != orders) {

				for (RepositoryItem repoItem : orders) {
					order = new OrderBean();
					List<Products> orderedProducts = new ArrayList<Products>();
					List<RepositoryItem> listCommerceItem = (List<RepositoryItem>) repoItem
							.getPropertyValue("commerceItems");
					if (null != listCommerceItem) {
						order.setOrderId(repoItem.getRepositoryId());
						Products product = null;
						for (RepositoryItem cItem : listCommerceItem) {
							product = new Products();
							product.setCommerceItemId(cItem.getRepositoryId());
							product.setSkuId(String.valueOf(cItem.getPropertyValue(
									"catalogRefId")));
							product.setProductId(String.valueOf(cItem.getPropertyValue(
									"productId")));
							product.setQuantity(String.valueOf(cItem.getPropertyValue(
									"quantity")));
							product.setListPrice(String.valueOf(((RepositoryItem) cItem
									.getPropertyValue("priceInfo"))
									.getPropertyValue("listPrice")));
							product.setSalePrice(String.valueOf(((RepositoryItem) cItem
									.getPropertyValue("priceInfo"))
									.getPropertyValue("salePrice")));
							try {
								RepositoryItem[] productRepo=searchDBManager.getProductDetails(product.getProductId());
								product.setProductName(String.valueOf(productRepo[0].getPropertyValue("displayName")));
							} catch (RepositoryException e) {
								logError(e);
							}
					
							orderedProducts.add(product);
						}
						order.setOrderMap(orderedProducts);
						order.setOrderTotal(String.valueOf(((RepositoryItem) repoItem
								.getPropertyValue("priceInfo"))
								.getPropertyValue("amount")));
						try {
						} catch (Exception e) {
							logError(e);
						}
					}
				}

			}

			String subject = "Your Order :" + orderId
					+ " has been Placed Successfully";
			try {
	            ClassLoader myClassLoader = ClassLoader.getSystemClassLoader();
	             
	             // Step 2: Define a class to be loaded.
	              
	            String classNameToBeLoaded = "com.tool.EmailSenderManager";
	 
	             
	             // Step 3: Load the class
	              
	            Class myClass = myClassLoader.loadClass(classNameToBeLoaded);
	 
	             
	             // Step 4: create a new instance of that class
	              
	            Object whatInstance = myClass.newInstance();
	 
	            OrderBean methodParameter = order;
	             
	             // Step 5: get the method, with proper parameter signature.
	             // The second parameter is the parameter type.
	             // There can be multiple parameters for the method we are trying to call,
	             // hence the use of array.
	 
	            Method myMethod = myClass.getMethod("generateVelocityTemplate",
	                    new Class[] { OrderBean.class });
	 
	             
	             // Step 6:
	             // Calling the real method. Passing methodParameter as
	             // parameter. You can pass multiple parameters based on
	             // the signature of the method you are calling. Hence
	             // there is an array.
	              
	            String returnValue = (String) myMethod.invoke(whatInstance,
	                    new Object[] { methodParameter });
	 
	            message=returnValue;
	        } catch (SecurityException e) {
	            e.printStackTrace();
	        } catch (IllegalArgumentException e) {
	            e.printStackTrace();
	        } catch (ClassNotFoundException e) {
	            e.printStackTrace();
	        } catch (InstantiationException e) {
	            e.printStackTrace();
	        } catch (IllegalAccessException e) {
	            e.printStackTrace();
	        } catch (NoSuchMethodException e) {
	            e.printStackTrace();
	        } catch (InvocationTargetException e) {
	            e.printStackTrace();
	        }
			try {
				sendHtmlEmail(host, port, mailFrom, password, mailTo, subject,
						message);
				logInfo("Email sent.");

			} catch (Exception ex) {
				logError("Failed to sent email:" + ex);
			}

		}

	}

	public void sendHtmlEmail(String host, String port,
			final String userName, final String password, String toAddress,
			String subject, String message) throws AddressException,
			MessagingException {

		// sets SMTP server properties
		Properties properties = new Properties();
		properties.put("mail.smtp.host", host);
		properties.put("mail.smtp.port", port);
		properties.put("mail.smtp.auth", "true");
		properties.put("mail.smtp.starttls.enable", "true");

		// creates a new session with an authenticator
		Authenticator auth = new Authenticator() {
			public PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(userName, password);
			}
		};

		Session session = Session.getInstance(properties, auth);

		// creates a new e-mail message
		Message msg = new MimeMessage(session);

		msg.setFrom(new InternetAddress(userName));
		InternetAddress[] toAddresses = { new InternetAddress(toAddress) };
		msg.setRecipients(Message.RecipientType.TO, toAddresses);
		msg.setSubject(subject);
		msg.setSentDate(new Date());
		// set plain text message
		msg.setContent(message, "text/html");

		// sends the e-mail
		Transport.send(msg);

	}
}
