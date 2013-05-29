$(document)
		.ready(
				function() {
					$("#btnPersonalInfoSave").hide();
					$("#btnBillingInfoSave").hide();
					$("#btnShippingInfoSave").hide();
					$("#btnPersonalInfoEdit")
							.click(
									function() {
										$("#btnPersonalInfoSave").show();
										$(this).hide();
										$("#tdFirstName")
												.replaceWith(
														function() {
															return "<input type=\"text\" id=\"FirstName\" value=\""
																	+ $(this)
																			.html()
																	+ "\" />";
														});
										$("#tdLastName")
												.replaceWith(
														function() {
															return "<input type=\"text\" id=\"LastName\" value=\""
																	+ $(this)
																			.html()
																	+ "\" />";
														});
										$("#tdMiddleName")
												.replaceWith(
														function() {
															return "<input type=\"text\" id=\"MiddleName\"  value=\""
																	+ $(this)
																			.html()
																	+ "\" />";
														});
										$("#tdEmail")
												.replaceWith(
														function() {
															return "<input type=\"text\" id=\"Email\"  value=\""
																	+ $(this)
																			.html()
																	+ "\" />";
														});
										$("#tdTelephone")
												.replaceWith(
														function() {
															return "<input type=\"text\" id=\"Telephone\"  value=\""
																	+ $(this)
																			.html()
																	+ "\" />";
														});
									});

					$("#btnPersonalInfoSave").click( function() {
						$("#btnPersonalInfoEdit").show();
						$(this).hide();
						$("#hiddenFirstName").val($("#FirstName").val());
						$("#hiddenLastName").val($("#LastName").val());
						$("#hiddenMiddleName").val($("#MiddleName").val());
						$("#hiddenEmail").val($("#Email").val());
						$("#hiddenTelephone").val($("#Telephone").val());

					});

					$("#btnBillingInfoEdit")
							.click(
									function() {
										$("#btnBillingInfoSave").show();
										$(this).hide();
										$("#tdBillAddress")
												.replaceWith(
														function() {
															return "<input type=\"text\" id=\"BillAddress\" value=\""
																	+ $(this)
																			.html()
																	+ "\" />";
														});
										$("#tdBillCity")
												.replaceWith(
														function() {
															return "<input type=\"text\" id=\"BillCity\"   value=\""
																	+ $(this)
																			.html()
																	+ "\" />";
														});
										$("#tdBillState")
												.replaceWith(
														function() {
															return "<input type=\"text\" id=\"BillState\"   value=\""
																	+ $(this)
																			.html()
																	+ "\" />";
														});
										$("#tdBillZip")
												.replaceWith(
														function() {
															return "<input type=\"text\" id=\"BillZip\"   value=\""
																	+ $(this)
																			.html()
																	+ "\" />";
														});
										$("#tdBillCountry")
												.replaceWith(
														function() {
															return "<input type=\"text\" id=\"BillCountry\"   value=\""
																	+ $(this)
																			.html()
																	+ "\" />";
														});
										$("#tdBillPhone")
												.replaceWith(
														function() {
															return "<input type=\"text\" id=\"BillPhone\"   value=\""
																	+ $(this)
																			.html()
																	+ "\" />";
														});
									});

					$("#btnBillingInfoSave").click( function() {
						$("#btnBillingInfoEdit").show();
						$(this).hide();
						$("#hiddenBillAddress").val($("#BillAddress").val());
						$("#hiddenBillCity").val($("#BillCity").val());
						$("#hiddenBillState").val($("#BillState").val());
						$("#hiddenBillZip").val($("#BillZip").val());
						$("#hiddenBillCountry").val($("#BillCountry").val());
						$("#hiddenBillPhone").val($("#BillPhone").val());

					});

					$("#btnShippingInfoEdit")
							.click(
									function() {
										$("#btnShippingInfoSave").show();
										$(this).hide();
										$("#tdShipAddress")
												.replaceWith(
														function() {
															return "<input type=\"text\" id=\"ShipAddress\" value=\""
																	+ $(this)
																			.html()
																	+ "\" />";
														});
										$("#tdShipCity")
												.replaceWith(
														function() {
															return "<input type=\"text\" id=\"ShipCity\" value=\""
																	+ $(this)
																			.html()
																	+ "\" />";
														});
										$("#tdShipState")
												.replaceWith(
														function() {
															return "<input type=\"text\" id=\"ShipState\" value=\""
																	+ $(this)
																			.html()
																	+ "\" />";
														});
										$("#tdShipZip")
												.replaceWith(
														function() {
															return "<input type=\"text\" id=\"ShipZip\" value=\""
																	+ $(this)
																			.html()
																	+ "\" />";
														});
										$("#tdShipCountry")
												.replaceWith(
														function() {
															return "<input type=\"text\" id=\"ShipCountry\" value=\""
																	+ $(this)
																			.html()
																	+ "\" />";
														});
									});

					$("#btnShippingInfoSave").click( function() {
						$("#btnShippingInfoEdit").show();
						$(this).hide();
						$("#hiddenShipAddress").val($("#ShipAddress").val());
						$("#hiddenShipCity").val($("#ShipCity").val());
						$("#hiddenShipState").val($("#ShipState").val());
						$("#hiddenShipZip").val($("#ShipZip").val());
						$("#hiddenShipCountry").val($("#ShipCountry").val());
						$("#hiddenShipPhone").val($("#BillPhone").val());

					});
				});
