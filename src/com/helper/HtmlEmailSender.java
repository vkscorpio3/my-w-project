package com.helper;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.InputStreamReader;
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

import com.bean.OrderBean;
import com.bean.Products;

public class HtmlEmailSender {

	public void sendHtmlEmail(String host, String port, final String userName,
			final String password, String toAddress, String subject,
			String message) throws AddressException, MessagingException {

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

	/**
	 * Test the send html e-mail method
	 * @throws Exception 
	 * 
	 */
	public static void main(String[] args) throws Exception {
		// SMTP server information
		String host = "smtp.gmail.com";
		String port = "587";
		String mailFrom = "javamailtesting1@gmail.com";
		String password = "javamailtesting1";

		// outgoing message information
		String mailTo = "santuc1990@gmail.com";
		String subject = "HTML Mail";

		// message contains HTML markups
		String message = "";//readFile("C:/login.html");
		OrderBean order=new OrderBean();
		Products product1=new Products();
		product1.setCommerceItemId("c123");
		product1.setProductName("Pantene");
		product1.setQuantity("1");
		product1.setSkuId("sku123");
		product1.setListPrice("10");
		product1.setProductId("prod123");
		product1.setSalePrice("9");
		List<Products> pList=new ArrayList<Products>();
		pList.add(product1);
		Products product2=new Products();
		product2.setCommerceItemId("c456");
		product2.setProductName("Dove");
		product2.setQuantity("2");
		product2.setSkuId("sku456");
		product2.setListPrice("20");
		product2.setProductId("prod456");
		product2.setSalePrice("19");
		pList.add(product2);
		order.setOrderId("o123456");
		order.setOrderMap(pList);
		order.setOrderTotal("47");
		message=new EmailDemo().generateVelocityTemplate(order);
		HtmlEmailSender mailer = new HtmlEmailSender();

		try {
			mailer.sendHtmlEmail(host, port, mailFrom, password, mailTo,
					subject, message);
			System.out.println("Email sent.");
		} catch (Exception ex) {
			System.out.println("Failed to sent email.");
			ex.printStackTrace();
		}
	}

	public static String readFile(String file) {
		String message = "";
		try {
			// Open the file that is the first
			// command line parameter
			FileInputStream fstream = new FileInputStream(file);
			// Get the object of DataInputStream
			DataInputStream in = new DataInputStream(fstream);
			BufferedReader br = new BufferedReader(new InputStreamReader(in));
			// Read File Line By Line
			String strLine;
			while ((strLine  = br.readLine()) != null) {
				// Print the content on the console
				message += strLine;
			}
			// Close the input stream
			in.close();
		} catch (Exception e) {// Catch exception if any
			System.err.println("Error: " + e.getMessage());
		}
		return message;
	}
}
