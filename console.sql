CREATE DATABASE view_procedure;
USE view_procedure;

CREATE TABLE bill ( #PHIEU XUAT
                      number_of_votes_cast INT AUTO_INCREMENT PRIMARY KEY ,
                      export_date DATE NOT NULL ,
                      customer_name VARCHAR(200) NOT NULL
);

CREATE TABLE supplies ( #VAT TU
                          material_code INT AUTO_INCREMENT PRIMARY KEY ,
                          name_supplies VARCHAR(200) NOT NULL ,
                          unit VARCHAR(50) NOT NULL ,
                          percent DOUBLE NOT NULL
);


CREATE TABLE orders ( #DON DAT HANG
                        order_number INT  PRIMARY KEY ,
                        order_date DATE NOT NULL ,
                        supplier_code INT,
                        CONSTRAINT fk_order_supplier FOREIGN KEY (supplier_code) REFERENCES supplier (supplier_code)
);

CREATE TABLE supplier ( # NHA CUNG CAP
                          supplier_code INT PRIMARY KEY ,
                          supplier_name VARCHAR(200) NOT NULL ,
                          address VARCHAR(200),
                          phone VARCHAR(100)
);

CREATE TABLE import_coupon ( # PHIEU NHAP
                               number_votes_entered INT PRIMARY KEY ,
                               date_added DATE NOT NULL ,
                               order_number INT,
                               CONSTRAINT fk_import_coupon_orders FOREIGN KEY (order_number) REFERENCES orders(order_number)
);

CREATE TABLE order_details ( #CHI TIET DON DAT HANG
                               material_code INT,
                               order_number INT,
                               order_quantity INT NOT NULL ,
                               CONSTRAINT fk_order_details_supplies FOREIGN KEY (material_code) REFERENCES supplies(material_code),
                               CONSTRAINT fk_order_details_order FOREIGN KEY (order_number) REFERENCES orders (order_number)
);

CREATE TABLE export_details ( # CHI TIET PHIEU XUAT
                                number_of_votes_cast INT,
                                material_code INT,
                                number_of_exports INT NOT NULL ,
                                export_unit_price DOUBLE NOT NULL,
                                CONSTRAINT fk_export_details_bill FOREIGN KEY (number_of_votes_cast) REFERENCES bill (number_of_votes_cast),
                                CONSTRAINT fk_export_details_supplies FOREIGN KEY (material_code) REFERENCES supplies(material_code)
);

CREATE TABLE inventory ( # TON KHO
                           month_inventory DATE PRIMARY KEY ,
                           material_code INT,
                           number_of_periods INT NOT NULL ,
                           total_quantity_entered INT NOT NULL ,
                           total_output INT NOT NULL,
                           last_quantity INT NOT NULL ,
                           CONSTRAINT fk_inventory_supplies FOREIGN KEY (material_code) REFERENCES supplies(material_code)
);

CREATE TABLE entry_details ( # CHI TIET PHIEU NHAP
                               number_votes_entered INT,
                               material_code INT,
                               number_of_import INT NOT NULL ,
                               import_unit_price DOUBLE NOT NULL,
                               CONSTRAINT fk_entry_details_import_coupon FOREIGN KEY (number_votes_entered) REFERENCES import_coupon (number_votes_entered),
                               CONSTRAINT fk_entry_details_import_supplies FOREIGN KEY (material_code) REFERENCES supplies (material_code)
);

INSERT INTO bill VALUES
(1,'2020-03-01', 'Ho Thi Loi'),
(2,'2020-03-10', 'Nguyen Thi Xuan'),
(3,'2020-04-20', 'Pham Quynh Trang'),
(4,'2020-02-15', 'Nguyen Van An'),
(5,'2020-03-30', 'Ho Duc Anh');

INSERT INTO supplies VALUES
(111, 'Thep Viet Nhat', 'Kg', 0.5),
(112, 'Cat Be Tong', 'Kg', 0.3),
(113, 'Da Xay Dung', 'Kg', 0.4),
(114, 'Thep Cuon', 'Kg', 0.4),
(115, 'Sat POMINA', 'Kg', 0.5);

INSERT INTO orders VALUES
(1, '2020-02-14', 100),
(2, '2020-04-02',101),
(3, '2020-02-26',102),
(4, '2020-03-20',103),
(5, '2020-04-20',104);

INSERT INTO supplier VALUES
(100, 'CTY CP Xay Dung COTECCONS', 'Ha Noi','0387501045'),
(101, 'CTY CP Tap Doan Hoa Binh','Ha Noi', 0381672038),
(102, 'CTY TNHH Dau Tu Xay Dung UNICONS', 'Ha Noi', 0352201000),
(103, 'CTY CP FECON', 'Ha Noi', 0387662020),
(104, 'CTY Dau Tu Phat Trien Do Thi','Ha Noi', 0376442040);

INSERT INTO import_coupon VALUES
(1001,'2020-02-20',1),
(1002,'2020-03-01',2),
(1003,'2020-04-04',3),
(1004,'2020-02-01',4),
(1005,'2020-03-10',5);

INSERT INTO order_details VALUES
(111,1,1000),
(112,2,500),
(113,3,1000),
(114,4,300),
(115,5,500);

INSERT INTO export_details VALUES
(1,111,600,20.5),
(2,112,200,15.5),
(3,113,500,12.0),
(4,114,100,21.0),
(5,115,300,17.5);

INSERT INTO inventory VALUES
('2020-03-30',111,1200,1000,2000,200),
('2020-04-01',112,800,500,1000,300),
('2020-04-30',113,1100,1000,1900,200),
('2020-02-28',114,500,300,400,400),
('2020-04-25',115,600,500,1000,100);

INSERT INTO entry_details VALUES
(1001,111,800,19.0),
(1002,112,1000,14.5),
(1003,113,500,10.0),
(1004,114,600,19.5),
(1005,115,800,15.5);

# TAO VIEW CHI TIET PHIEU NHAP
CREATE VIEW view_import_coupon AS SELECT import_coupon.number_votes_entered, s.material_code, number_of_import, import_unit_price,sum(number_of_import * import_unit_price) FROM import_coupon
        INNER JOIN entry_details ed on import_coupon.number_votes_entered = ed.number_votes_entered
        INNER JOIN supplies s on ed.material_code = s.material_code;

SELECT * FROM view_import_coupon;

# TAO VIEW CHI TIET PHIEU VAT TU
CREATE VIEW view_import_coupon_supplies AS SELECT ic.number_votes_entered, s.material_code,name_supplies,number_of_import, import_unit_price,sum(number_of_import * import_unit_price)'Thanh tien' FROM entry_details
        INNER JOIN import_coupon ic on entry_details.number_votes_entered = ic.number_votes_entered
        INNER JOIN supplies s on entry_details.material_code = s.material_code;

# TAO VIEW CHI TIET PHIEU NHAP VAT TU , PHIEU NHAP
CREATE VIEW view_entry_details_import_coupon_supplies AS SELECT ic.number_votes_entered,date_added,order_number,s.material_code,name_supplies,number_of_import,import_unit_price, sum(number_of_import * import_unit_price)'Thanh tien' FROM entry_details
        INNER JOIN import_coupon ic on entry_details.number_votes_entered = ic.number_votes_entered
        INNER JOIN supplies s on entry_details.material_code = s.material_code;

# TAO VIEW CHI TIET PHIEU NHAP VAT TU , PHIEU NHAP, DON HANG
CREATE VIEW view_entry_details_import_coupon_supplies_order AS SELECT ic.number_votes_entered, date_added,o.order_number,supplier_code,s.material_code,name_supplies, number_of_import,import_unit_price,sum(number_of_import * import_unit_price)'Thanh tien' FROM entry_details
        INNER JOIN supplies s on entry_details.material_code = s.material_code
        INNER JOIN import_coupon ic on entry_details.number_votes_entered = ic.number_votes_entered
        INNER JOIN orders o on ic.order_number = o.order_number;

# TAO VIEW CHI TIET PHIEU XUAT
CREATE VIEW view_bill AS SELECT number_of_votes_cast,material_code,number_of_exports, export_unit_price, sum(number_of_exports * export_unit_price)'Thanh tien' FROM export_details;

# TAO VIEW CHI TIET PHIEU XUAT VAT TU
CREATE VIEW view_bill_supplies AS SELECT number_of_votes_cast, export_details.material_code,name_supplies,number_of_exports,export_unit_price FROM export_details
       INNER JOIN supplies s on export_details.material_code = s.material_code;

#TAO VIEW CHI TIET PHIEU XUAT VAT TU, PHIEU XUAT
CREATE VIEW view_bill_supplies_export_details AS SELECT b.number_of_votes_cast,customer_name,s.material_code,name_supplies,number_of_exports,export_unit_price FROM export_details
        INNER JOIN supplies s on export_details.material_code = s.material_code
        INNER JOIN bill b on export_details.number_of_votes_cast = b.number_of_votes_cast;

#TAO PROCEDURE
CREATE PROCEDURE get_last_quantity(IN cusNum INT(100))
BEGIN
    SELECT last_quantity FROM inventory WHERE material_code = cusNum;
end;
CALL get_last_quantity(111);

# TONG TIEN XUAT THEO MA VAT TU
CREATE PROCEDURE get_total_payments(IN total INT(100))
BEGIN
    SELECT number_of_exports, export_unit_price, sum(number_of_exports * export_unit_price)'Tong tien'FROM export_details
            INNER JOIN supplies s on export_details.material_code = s.material_code
    WHERE export_details.material_code = total GROUP BY s.material_code;
end;
CALL get_total_payments(112);

#TONG SO LUONG DAT THEO SO DON HANG
CREATE PROCEDURE get_total_order_quantity(IN total_order INT(100))
BEGIN
    SELECT order_details.order_number,order_quantity, count(order_quantity)'Tong luong don dat hang' FROM order_details
        JOIN orders o on order_details.order_number = o.order_number  WHERE material_code = total_order GROUP BY o.order_number;
end;
CALL get_total_order_quantity(111);

#TAO SAN PHAM DUNG DE THEM 1 DON DAT HANG
CREATE PROCEDURE add_order()
BEGIN
     INSERT INTO orders VALUES (6,'2020-04-25',100);
end;
CALL add_order();
SELECT * FROM orders;

# TAO SAN PHAM DE THEM 1 CHI TIET DON DAT HANG
CREATE PROCEDURE add_order_details()
BEGIN
    INSERT INTO order_details VALUES (111,2,800);
end;
CALL add_order_details();
SELECT * FROM order_details;
