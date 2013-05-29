package com.tool;

import javax.naming.InitialContext;
import javax.transaction.TransactionManager;

import atg.dtm.TransactionDemarcation;
import atg.dtm.TransactionDemarcationException;
import atg.nucleus.GenericService;
import atg.repository.MutableRepository;
import atg.repository.MutableRepositoryItem;
import atg.repository.Repository;
import atg.repository.RepositoryException;
import atg.repository.RepositoryItem;
import atg.repository.RepositoryView;
import atg.repository.rql.RqlStatement;

import com.bean.SKUBean;
import com.bean.User;

public class SkuSetupTool extends GenericService {
	private Repository repository;
	private Repository productCatalog;
	private RepositoryView repositoryView;
	RepositoryItem[] repositoryItem;
	private MutableRepository mutableRepository;
	private MutableRepository dmutableRepository;

	public Repository getRepository() {
		return repository;
	}

	public void setRepository(Repository repository) {
		this.repository = repository;
	}

	public MutableRepository getMutableRepository() {
		return mutableRepository;
	}

	public void setMutableRepository(MutableRepository mutableRepository) {
		this.mutableRepository = mutableRepository;
	}

	public MutableRepository getDmutableRepository() {
		return dmutableRepository;
	}

	public void setDmutableRepository(MutableRepository dmutableRepository) {
		this.dmutableRepository = dmutableRepository;
	}

	public Repository getProductRepository() {
		return productCatalog;
	}

	public void setProductRepository(Repository productRepository) {
		this.productCatalog = productRepository;
	}

	/**
	 * Get All the Details of All Products
	 * 
	 * @param productId
	 * @return Array of Repository Items...1 Array is 1 record
	 * @throws RepositoryException
	 */
	public RepositoryItem[] getSkuDetails(String skuId)
			throws RepositoryException {
		repositoryView = getProductRepository().getView("sku");
		Object[] param = null;
		RqlStatement rqlStatement = null;

		if (skuId.equals("ALL")) {
			rqlStatement = RqlStatement.parseRqlStatement("ALL");
		} else if (skuId.startsWith("sku")) {
			rqlStatement = RqlStatement.parseRqlStatement("id=?0");
			param = new Object[1];
			param[0] = skuId;
		} else {
			rqlStatement = RqlStatement
					.parseRqlStatement("displayName CONTAINS ?0");
			param = new Object[1];
			param[0] = skuId;
		}
		repositoryItem = rqlStatement.executeQuery(repositoryView, param);

		return repositoryItem;
	}

	/**
	 * Get All the Details of All Products
	 * 
	 * @param productId
	 * @return Array of Repository Items...1 Array is 1 record
	 * @throws RepositoryException
	 */
	public RepositoryItem[] getProductDetails(String productId)
			throws RepositoryException {
		repositoryView = getProductRepository().getView("product");
		Object[] param = null;
		RqlStatement rqlStatement = null;

		if (productId.equals("ALL")) {
			rqlStatement = RqlStatement.parseRqlStatement("ALL");
		} else if (productId.startsWith("prod")) {
			rqlStatement = RqlStatement.parseRqlStatement("id=?0");
			param = new Object[1];
			param[0] = productId;
		} else {
			rqlStatement = RqlStatement
					.parseRqlStatement("displayName CONTAINS ?0");
			param = new Object[1];
			param[0] = productId;
		}
		repositoryItem = rqlStatement.executeQuery(repositoryView, param);
		return repositoryItem;
	}

	@SuppressWarnings("static-access")
	public boolean addUser(User user) {
		boolean success = Boolean.FALSE;
		try {

			mutableRepository = getDmutableRepository();
			InitialContext ic = new InitialContext();
			TransactionManager tmgr = (TransactionManager) ic
					.lookup("dynamo:/atg/dynamo/transaction/TransactionManager");
			TransactionDemarcation td = new TransactionDemarcation();
			td.begin(tmgr, td.REQUIRED);
			MutableRepositoryItem item = mutableRepository
					.createItem("productCatalog");

			item.setPropertyValue("Password", user.getPassword());
			item.setPropertyValue("UserName", user.getUserName());
			item.setPropertyValue("Email", user.getEmail());
			item.setPropertyValue("Address", user.getAddress());
			item.setPropertyValue("DateOfBirth", user.getDateOfBirth());
			item.setPropertyValue("Gender", user.getSex());

			mutableRepository.addItem(item);
			td.end(false);
			success = Boolean.TRUE;

		} catch (Exception e) {
			e.printStackTrace();
			// throw e;
			System.out.println(e);
		}
		return success;

	}

	public boolean deleteUser(String userId) {
		@SuppressWarnings("unused")
		boolean flag = false;
		MutableRepository mutableRepository = getMutableRepository();
		MutableRepositoryItem mutableRepositoryItem = null;

		RepositoryItem repositoryItem;
		try {
			repositoryItem = mutableRepository.getItem(String.valueOf(userId),
					"user_db");
			if (null != repositoryItem) {
				System.out.println(repositoryItem);
				mutableRepository.removeItem(String.valueOf(userId), "user_db");
				mutableRepository.updateItem(mutableRepositoryItem);
			}

		} catch (RepositoryException e) {

			e.printStackTrace();
		}

		return true;
	}

	/**
	 * To Update the details of user
	 * @param prodCatalog TODO
	 * @param userId
	 * 
	 * @return
	 */
	@SuppressWarnings("static-access")
	public boolean updateSKUPropertyAddedManually(RepositoryItem prodCatalog, SKUBean skuBean) {
		boolean success = Boolean.FALSE;

		InitialContext ic = null;
		TransactionManager transManager = null;
		TransactionDemarcation td = null;

		try {
			ic = new InitialContext();
			transManager = (TransactionManager) ic
					.lookup("dynamo:/atg/dynamo/transaction/TransactionManager");
			td = new TransactionDemarcation();
			td.begin(transManager, td.REQUIRED);
			MutableRepository mutableRepository = (MutableRepository)prodCatalog.getRepository(); 
			MutableRepositoryItem mRepoItem = 
			mutableRepository.getItemForUpdate(prodCatalog.getRepositoryId(), 
			prodCatalog.getItemDescriptor().getItemDescriptorName()); 
			mRepoItem.setPropertyValue("fulfillerType", skuBean
					.getFulfillerType());
			mRepoItem.setPropertyValue("sddEnabled", skuBean.getSddEnabled());
			mRepoItem.setPropertyValue("webExclusive", skuBean
					.getWebExclusive());
			mRepoItem.setPropertyValue("activated", skuBean.getActivated());
			mRepoItem.setPropertyValue("shippingChargeCode", skuBean
					.getShippingChargeCode());
			mRepoItem.setPropertyValue("loyaltyEligible", skuBean
					.getLoyaltyEligible());
			mRepoItem.setPropertyValue("loyaltyRedeemable", skuBean
					.getLoyaltyRedeemable());
			if (isLoggingDebug()) {
				logDebug("[fulfillerType]:"
						+ mRepoItem.getPropertyValue("fulfillerType"));
				logDebug("[sddEnabled]:"
						+ mRepoItem.getPropertyValue("sddEnabled"));
				logDebug("[webExclusive]:"
						+ mRepoItem.getPropertyValue("webExclusive"));
				logDebug("[activated]:"
						+ mRepoItem.getPropertyValue("activated"));
				logDebug("[shippingChargeCode]:"
						+ mRepoItem.getPropertyValue("shippingChargeCode"));
				logDebug("[loyaltyEligible]:"
						+ mRepoItem.getPropertyValue("loyaltyEligible"));
				logDebug("[loyaltyRedeemable]:"
						+ mRepoItem.getPropertyValue("loyaltyRedeemable"));
			}
			mutableRepository.updateItem(mRepoItem);

			
			success = Boolean.TRUE;

		} catch (Exception e) {
			logError(
					getClass().getName()
							+ ".updateSKUPropertyAddedManually : Can't Update WWW_SKU Attributes",
					e);
		}finally{
			try {
				td.end(!success);
			} catch (TransactionDemarcationException e) {
				logError(getClass().getName()
						+ ".updateSKUPropertyAddedManually() :",e);
			}
		}
		return success;
	}

}
