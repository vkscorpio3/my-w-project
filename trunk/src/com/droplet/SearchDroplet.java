package com.droplet;

import java.io.IOException;

import javax.servlet.ServletException;

import com.tool.SearchDBManager;

import atg.repository.RepositoryException;
import atg.servlet.DynamoHttpServletRequest;
import atg.servlet.DynamoHttpServletResponse;
import atg.servlet.DynamoServlet;

public class SearchDroplet extends DynamoServlet {
	SearchDBManager searchDBManager;

	public SearchDBManager getSearchDBManager() {
		return searchDBManager;
	}

	public void setSearchDBManager(SearchDBManager searchDBManager) {
		this.searchDBManager = searchDBManager;
	}

	public void service(DynamoHttpServletRequest req,
			DynamoHttpServletResponse res) throws ServletException, IOException {
		String productId = String.valueOf(req
				.getParameter("searchProductValue"));
		if (null == productId) {
			try {
				req.setParameter("droplet_searchText", getSearchDBManager()
						.getCategoryDetails());

			} catch (RepositoryException e) {
				if (isLoggingError()) {
					logError("SearchDroplet.service():" + e.getMessage());
				}
			}
		} else {
			if (productId.startsWith("sku") && productId.length() >= 8) {
				try {
					req.setParameter("droplet_sku", getSearchDBManager()
							.getSkuDetails(productId));
				} catch (RepositoryException e) {
					if (isLoggingError()) {
						logError("SearchDroplet.service():" + e.getMessage());
					}
				}
			} else if (productId.startsWith("prod") && productId.length() >= 9){
				try {
					req.setParameter("droplet_skus", getSearchDBManager()
							.getProductDetails(productId));
				} catch (RepositoryException e) {
					if (isLoggingError()) {
						logError("SearchDroplet.service():" + e.getMessage());
					}
				}
			}
		}
		req.serviceLocalParameter("output", req, res);

	}
}
