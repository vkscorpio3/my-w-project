package com.servlet;
import org.apache.velocity.Template;
import org.apache.velocity.servlet.VelocityServlet;
import org.apache.velocity.app.Velocity;
import org.apache.velocity.context.Context;
import javax.servlet.http.*;

public class HelloTest extends VelocityServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public Template handleRequest( HttpServletRequest request,
                                   HttpServletResponse response,
                                   Context context ) {

        Template template = null;
        try {
            context.put("name", "John");
            context.put("company", "Kogent Solutions Inc.");
            template = Velocity.getTemplate("hello.vm");
        } 
        catch( Exception e ) {
          System.err.println("Exception caught: " + e.getMessage());
        }
        return template;
    }
}

