CREATE DATABASE practica
GO

USE practica
GO

CREATE TABLE ciudades(
idCiudad int not null primary key identity(1,1),
nombre varchar(50)
)
GO
INSERT INTO ciudades VALUES
('Purísima'), ('León'), ('San Francisco'), ('Guanajuato'), ('Silao')

CREATE TABLE vendedores(
idVendedor int not null primary key identity(1,1),
nombre varchar(100),
direccion varchar(150),
codigoPostal int,
idPueblo int,
CONSTRAINT fk_idPueblo_vendedores FOREIGN KEY (idPueblo) REFERENCES ciudades(idCiudad)
)
GO
INSERT INTO vendedores VALUES
('Pedro', 'Rosal #123', 36123, 5), ('Valedor', 'Cristal #13', 36131, 4), ('Miguel', 'Veneros #112', 36567, 2),
('Ramón', 'Morelos #812', 36400, 1), ('Juan', 'Madero #321', 36138, 1), ('Jesús', 'Pedro Moreno #123', 36123, 2)
GO


CREATE TABLE clientes(
idCliente int not null primary key identity(1,1),
nombre varchar(50),
direccion varchar(150),
estatus int,
codigoPostal int,
ciudad varchar(50),
vendedorActual int,
CONSTRAINT fk_venddedorActual_cliente FOREIGN KEY (vendedorActual) REFERENCES vendedores(idVendedor)
)
GO
INSERT INTO clientes VALUES
('Carlos Hernández', 'Gardenia #168', 1, 36416, 'Purísima', 1), 
('Miguel Hernández', 'Gardenia #168', 1, 36416, 'Purísima', 4),
('´Ramiro Rendon', 'Morelos #16', 1, 36400, 'Purísima', 5),
('Paulina Guerrero', 'Veneros #132', 1, 35600, 'León', 1),
('Bruno Pinilla', 'Torres #220', 1, 35400, 'Silao', 2)
GO

CREATE TABLE articulos(
idArticulo int not null primary key identity(1,1),
descripcion varchar(200),
precio decimal(10,2),
stock int,
stockMinimo int
)
GO
INSERT INTO articulos VALUES
('Pelota', 12.00, 50, 30), ('Balón', 50.00, 30, 30), ('Guantes', 30.00, 20, 20),
('Tachones', 200.00, 50, 30), ('Mochila', 70.00, 40, 40), ('Gorra', 40.00, 20, 10)
GO

CREATE TABLE facturas(
idFactura int not null primary key identity(1,1),
importe decimal(10, 2),
fecha date,
idCliente int,
idVendedor int,
iva decimal(10, 2),
descuento decimal(10, 2),
CONSTRAINT fk_idCliente_facturas FOREIGN KEY (idCliente) REFERENCES clientes(idCliente),
CONSTRAINT fk_idVendedor_facturas FOREIGN KEY (idVendedor) REFERENCES vendedores(idVendedor)
)
GO
INSERT INTO facturas VALUES
(2000.00, '2024-05-20', 1, 1, 20.00, 10), (1500.00, '2024-04-28', 2, 4, 20.00, 5),
(300.00, '2024-01-10', 3, 5, 20.00, 15), (23300.00, '2024-05-12', 4, 1, 20.00, 30),
(2900.00, '2024-03-07', 5, 2, 20.00, 9), (12900.00, '2024-02-16', 1, 1, 20.00, 20)
GO

CREATE TABLE detalleFacturas(
idDetalleFactura int not null primary key identity(1,1),
idFactura int,
idProducto int,
cantidadSolicitada int,
subtotal decimal(10,2),
CONSTRAINT fk_idFactura_detalleFactura FOREIGN KEY(idFactura) REFERENCES facturas(idFactura),
CONSTRAINT fk_idProducto_detalleFactura FOREIGN KEY(idProducto) REFERENCES articulos(idArticulo)
)
GO
INSERT INTO detalleFacturas VALUES
(1, 4, 5, 1000), (1, 2, 20, 1000),
(2, 6, 15, 600), (2, 3, 30, 900),
(3, 1, 12, 300), 
(4, 1, 150, 1800), (4, 2, 15, 2500), (4, 3, 150, 4500),(4, 4, 30, 6000),  (4, 5, 25, 3500), (4, 6, 200, 5000),
(5, 1, 75, 900), (5, 2, 20, 1000), (5, 4, 5, 1000), 
(6, 1, 100, 1200), (6, 2, 20, 1000), (6, 3, 100, 3000), (6, 4, 15, 3000),  (6, 5, 10, 700), (6, 6, 100, 4000)



