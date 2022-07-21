Use Manufacturer;

CREATE SCHEMA Product;
CREATE SCHEMA Supplier;

CREATE TABLE [Product].[Product]
( 
	[prod_id][int] PRIMARY KEY,
	[prod_name][varchar](50),
	quantity INT 
);

CREATE TABLE [Supplier].[Supplier]
(
	[supp_id][int] PRIMARY KEY,
	[supp_name][varchar](50),
	[supp_location][varchar](50),
	[supp_country][varchar](50),
	is_active [bit]
);


CREATE TABLE [Component]
(
	[comp_id][int] PRIMARY KEY,
	[comp_name][varchar](50),
	[description][varchar](50),
	quantity_comp [int]
);

CREATE TABLE [Product].[Prod_Comp]
(
	quantity_comp [int],
	prod_id [int],
	comp_id [int],	
	PRIMARY KEY (prod_id, comp_id)
);

CREATE TABLE [Supplier].[Comp_Supp]
(
	supp_id [int],
	comp_id [int],
	order_date [date],
	quantity [int],
	PRIMARY KEY (supp_id, comp_id)
);

ALTER TABLE Product.Prod_Comp
ADD CONSTRAINT FK1 FOREIGN KEY (prod_id) REFERENCES Product.Product (prod_id);

ALTER TABLE Product.Prod_Comp
ADD CONSTRAINT FK2 FOREIGN KEY (comp_id) REFERENCES Component (comp_id);

ALTER TABLE Supplier.Comp_Supp
ADD CONSTRAINT FK1 FOREIGN KEY (supp_id) REFERENCES Supplier.Supplier (supp_id);

ALTER TABLE Supplier.Comp_Supp
ADD CONSTRAINT FK2 FOREIGN KEY (comp_id) REFERENCES Component (comp_id);