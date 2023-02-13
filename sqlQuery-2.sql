-- DİSTİNCT : TABLODA AYNI OLAN VERİLERİN TEKRARLANMASI DURUMUNDA ,TEK VERİ OLARAK GETİRMEK İÇİN KULLANILIR 

SELECT distinct(City) as notrepeatcountry FROM Customers
order by City

select distinct(Country), as notRepeat from Employees
 order by Country

 --her iki kolon verirseniz distinct çalışmaz(yukarıdaki sorguda )
 -- 1 alan da tekrar eden bir şey var mı ? ya bakar aslında distinct

 select distinct Country , City  from Customers
 ORDER BY Country

 select COUNT(distinct Country ) from Customers
 -- satır sayısını verir tekrarsız (21 satır)

 select COUNT(Country) from Customers
 --(91 satır geldi)

 

 ----------------------------------------------------------------------------

-- GROUP BY : ARKADA HER LİSTE İÇİN GRUP OLUŞTURUR , DAHA SONRA GELEN HAVİNG İFADESİ BU GRUPLANAN KOLONLARI ESAS ALIR 

SELECT Country ,City , COUNT(*) as ADET FROM Customers
group by Country ,City having Count(*)>1
--customers tablosundan country ,city kolonları getir ve count ile satır sayısı Adet 
--ismiyle kolon olarak getirir 
-- daha sonra country ve city kolonlarını listeler ama 
-- (havingten sonrası) adet sayısı 1 den büyük olanları getirir


SELECT Country , COUNT(*)  SATIRSAYISI FROM Customers
GROUP BY Country  
-- ÖNEMLİ : "GROUP BY" DEDİĞİMİZ DE KOLONDA BULUNAN TEKRARLI VERİLER , 1 KEZ YAZILARAK GROUPLANDIRILIRLAR

-- GROUP BY --> yazıldığında aslında her veri (kolon) için arkada bir liste oluşturur.
-- ve olulşturulan liste ile her veri için count ile satır sayısı tek tek sayar 


SELECT Country , City , COUNT(*) adet  FROM Customers
GROUP BY Country,City
-- country , city e göre gruplanır ve o country , city nin kaç adet olduğunu yazan kolon vardır  


-----------------------------------------------------------------------------------------------------------------------------------

--HAVİNG : having kısmında kümülatif kısımlar kullanılır ; şöyle SUM,COUNT,AVG ..GİBİ

SELECT Country ,City , COUNT(*) adet FROM Customers
where City <> 'Nantes' -- sorgunun burasına kadar ; tüm verileri filitreliyor where ile
Group By Country ,City having Count(*)>1  -- havingi , where ile karıştırmayın . Having , kümülatif işlemler de (sum , avg,count) ,liste içindeki sorgulara uygulanır 
Order BY Country  -- ORDER BY İLE ÜKLE İSMİ A-Z YE SIRALANDI

--şehri 'nantes' den farklı olanları grupla demek aslında 
-- <> : farklıdır demek (olmayan)

--NOT!! : HAVİNG kümülatif olan durumlar da ; SUM , COUNT ,AVG gibi kümülatif kısımlarda kullanılır .



--------------------------------------------------------------------------------------------------------------------------------------
-- JOIN : BİR ARAYA GETİRMEK , BİRLEŞTİRMEK

-- 1) İNNER JOİN : ORTAK OLANLARI EŞLEŞTİRİR , İKİ TABLO DA EŞLEŞENLERİ GETİR

-- aşağıdaki iki tabloda (Categories ve Products) 'ın ortak  eşleşeni categoryId 

Select * from Products inner join Categories --products tablosunu getir ve ınner join ile categori tablosu ile işlem yapıcaz 
ON Products .CategoryID=Categories.CategoryID -- ON şu kurala göre diyor aslında 
--Product tablosundaki categorıId ile Categori tablosundaki categoryId istenen kuralı getirir
-- eğer eşleşen yoksa getirmez 

-- NOT : EĞER SİZ BİR E-TİCARET SİTESİNE KAYIT OLDUNUZ 
--AMA ÜRÜN ALMADINIZ , BU DURUM DA İNNER JOIN SORGUSUN DA  
-- SİSTEM DE EŞLEŞMEZSİNİZ , GÖZÜKMEZSİNİZ 


SELECT * from Products p inner join Categories c
on p.CategoryID=c.CategoryID
where p.UnitPrice>20 
order by  UnitPrice , p.CategoryID  -- default asc - artan sırada 


--ÖRNEK :3 TABLOYU JOIN ETME --> Products, OrderDate VE Quantity * UnitPrice ([Order Details])
--PRODUCTS TAB --> ÜRÜNLER 
--ORDERS TAB - ORDERDATE --> NE ZAMAN ALDIK
--ORDER DETAİLS TAB -UNİTPRİCE * QUANİTY --> NE KADAR KAZANDIK

SELECT p.ProductName , o.OrderDate,od.Quantity * od.UnitPrice as Total
FROM Products p inner join [Order Details] od -- product tab. productId nin bulunduğu ikinci tablo order details dir ve ortak alanları alıyoruz 
on p.ProductID =od.ProductID -- 2 tabloda productId'leri aynı olanlar getirilir 
inner join Orders o 
on o.OrderID =od.OrderID  -- burada orderId'leri aynı olanlar getirilir
order by p.ProductName ,o.OrderDate

-- BENİM ÖRNEĞİM ;
select e.Address musteriadresi , c.CustomerID ,o.CustomerID,e.EmployeeID from  Customers c inner join Orders o
on c.CustomerID =o.CustomerID
inner join Employees e 
on o.EmployeeID=e.EmployeeID
where e.Address is not null --boş olmayanları getir , çalışan adresi olanları getir 

--------------------------------------------------------------------------------------------------------------------------------------------------
-- 2) LEFT JOIN  : LEFT JOİN DE BEN TABLOLAR DA EŞLEŞMEYEN DATALARIN DA GELMESİNİ İSTERİM 

-- AYNI KOLONLARA SAHİP OLMAYAN DEMEK EŞLEŞMEYEN 
-- ÖR: SİZ BİR E-TİCARET SİTESİNE KAYIT OLUYORSUN İLK DEFA VE O MARKA SİZE ÖZEL İNDİRİM YAPMAK İSİTOR 
-- ; BU DURUM DA MÜŞTERİ TABLOSUNDA VARSIN AMA ŞİPARİŞ TABLOSUNDA YOK. 
--HEM JOIN OLANLARI GETİRİYOR HEM DE JOIN OLMAYANLARI 


--stoktaki hangi ürünü satamıyoruz , bunu da şöyle anlarız ProductId si hiç geçmemesi gerekir 
SELECT  * FROM Products p left join [Order Details] od
on p.ProductID =od.ProductID
where od.ProductID is null  -- is null : "kayıt yok" demek  , satış yapılmayanları filitrele
-- sonucunda biz bütün ürünleri satmışız 


select * from Customers c left join Orders o -- inner join ile 830 satır ve left join ile 832 satır geld
on c.CustomerID =o.CustomerID
where o.CustomerID is null -- siparişler de ,  biz hiç ürün satamadığımız firmaları dinliyoruz 
-- not : tablonun diğer kısımlarını customer tab. ile eşleyemediği için order tab. eşleşemeyen alanları NULL olarak geçer ve onları da gösterir 


select * from Customers c inner join Orders o -- 830 satır 
on c.CustomerID=o.CustomerID

-- !!NOT (LEFT JOİN) : "LEFT" DEMEK ASLINDA JOİNİN SOLU VE SAĞIDIR 
-- SOLDAKİ TABLODA OLUP ,SAĞDAKİ TABLODA OLMAYANLARI DA GETİRİR . 2 TABLONUN HEPSİNİ GETİRİR

--"where o.CustomerID is null "  BU KISIM DA , İKİ TABLODAKİ CUSTOMERID LERE BAKILIIP 
-- ID Sİ MÜŞTERİ TABLOSUNDA OLUP , ŞİPARİŞ TABLOSUNDA OLMAYAN ID VARSA ; "DİYORUZ Kİ O ZAMAN BU ÜRÜN HİÇ  BİT MÜŞTERİYE SATILMAMIŞ"



--SELECT * FROM Customers
--where  CustomerID='PARIS'
--CustomerID ='FISSA' 

--KISACA : LEFT JOİN --> SOLUNDA OLAN TABLOYU OLUP , SAĞINDA OLAMAYAN TABLOYU DA GETİRİR 
-- VE SOLUNDAKİ TAB İLE SAĞINDAKİ TABLONUN EŞLEŞMEDİĞİ YERLERDE (KOLON KARŞILIĞI OLMADIĞI )
--SOLUNDAKİ TABLONUN DEĞERLERİ "NULL" GELİR 


-----------------------------------------------------------------------------------------

-- 3) RİGHT  JOİN :
-- LEFT JOİNE GÖRE TAM TERSİ ASLINDA 
-- KISACA : RİGHT JOİN --> SAĞINDAKİ TABLO DA OLUP (TÜMÜNÜ) , SOLUNDAKİ TABLO DA OLMAYANLARI DA GETİRİYORDU (TÜMÜNÜ GETİRİR)
-- VE SAĞINDAKİ TABLO İLE SOLUNDAKİ TABLONUN EŞLEŞMEDİĞİ YERLER DE SOLUNDAKİ TABLONUN DEĞERLERİ "NULL" GELİR 
--ASLIN DA TABLOYU DA GETİRİR AMA ESAS SAĞ TARAF ALINIR GİBİ DÜŞÜNÜLEBİLİR !!


select * from  Orders od right join  Customers c
on c.CustomerID=od.CustomerID
where od.CustomerID is null

select * from Orders o right join Customers c
on c.CustomerID=o.CustomerID
where o.CustomerID is null

-- ASLINDA HESPİNDE ASIL ALINAN TABLO SOLDAKİ (from dan sonra gelen tablo )

-- customer tab - 832 veri var , orders tab - 830 veri var ---> bura da fazla olan 2 veri hiç satılmaış demek midir ?


----------------------------------------------------------------------------------------------------------
-- 4) FULL JOİN : diğer anlattığımız 3 join  i de kapsar 
-- right-left-inner join olanları getiriyor 

select  * from Customers c full join Orders o
on o.CustomerID= c.CustomerID

----------------------------------------------------------------------------------

-- NOT :(ÖZET)
-- 1)İKİ TABLODAN EŞLELENLERİ GETİRİR YALNIZ (İNNER )
-- 2) SOLDAKİ TABLODA OLUP , SAĞDAKİ TAB OLMAYANLARI GETİRİR (LEFT)
-- 3) SAĞDAKİ TABLOYU OLUP  , SOLDAKİ TABLODA OLAMYANLARI GETİRİR (RİGHT)--> SOLDAKİ TAB İLE EŞLEŞMEYENLERİN DEĞERİNİ YAZAR İS NULL KISMIN DA
-- 4) LEFT , RİGH VE İNNER JOİNLER OLAN TÜM DURUMLARI GETİRİR (FULL)

--*-*-*-*-*-*-*-*-*-*-*---*-*-*-*-*-*-*-*-*-*-*---*-*-*-*-*-*-*-*-*-*-*---*-*-*-*-*-*-*-*-*-*-*---*-*-*-*-*-*-*-*-*-*-*---*-*-*-*-*-*-*-*-*-*-*-

--WORKSHOP-1
-- HİÇ SATIŞ(ORDERS) YAPAMAYAN  PERSONELİMİZ(ÇALIŞAN -EMPLOYEES ) VAR MI ? ,VARSA BU PERSONEL KİMDİR VE KİMLERDİR 

SELECT * FROM Employees e left join Orders o -- ÇALIŞAN TABLOSUNDA OLUP(solda olup), SATIŞ YAPAMAYAN OLACAK (sağda olmayan)--> (LEFT)
on e.EmployeeID =o.EmployeeID
where o.EmployeeID is null
order by o.EmployeeID
--satış yapmayan personel yoktur 

--WORKSHOP-2


--1) Hangi üründen (products) kaç tane satmışız(orders) ?(10 dk)(1.)

select p.ProductName , COUNT(*)  as adet from Products p inner join [Order Details] od
on p.ProductID =od.ProductID
where od.Discount>0 -- kampanyalı şatışı getirir 
group by p.ProductName   --having COUNT(*)>0
order by p.ProductName
--bitti (15 dk civarı) --> unutmuşum konuyu  (doğru)


--2) Hangi kategoriden(categories) kaç tane satmışız(orders) ?(5 dk)

select c.CategoryName , COUNT(*) as ADET from Categories c inner join Products p
on c.CategoryID =p.CategoryID
inner join [Order Details] od 
on p.ProductID =od.ProductID
group by c.CategoryName --having COUNT(*)>0
order by c.CategoryName
 
 -- BİTTİ   (doğru)

 --- WORKSHOP -3 (farklı bir soru !!!) 

--1)ÇALIŞANLAR TABLOSUNDA- REPORTS TO (ŞİRKETTE BİR ÜSTÜNÜ VERİR YANİ BİŞR ÜSTÜNE RAPOR VERİYORMUŞ  )
-- 1.KOLONDA ÇALIŞAN İSMİ , 2. KOLONDA İSE İŞYERİNDEKİ ÜSTÜ NEDİR (İSİM OLARAK YAZACAK)

SELECT e2.FirstName +' '+ e2.LastName PERSONEL,  e1.FirstName +' '+ e1.LastName ÜSBİRİMİ  from  Employees e1 right join Employees e2
on e1.EmployeeID=e2.ReportsTo
 
 -- null gelsin istemiyorsak inner join kullanırız 
 

-- AYNI TABLOYU JOİNLEDİK VE ; ON DAN SONRA İLK TABLODAN PERSONEL İSİMLERİNİ ÇEKTİK 
--İKİNCİ TABLODAN ÜSTLERİ ÇEKTİK 


--çözümü : aynı tabloyu kendisiyle join edicez



-------------------------------------------------------------------------------------------------------------------------------------------

-- INSERT - UPDATE - DELETE 

--1) INSERT INTO (insert---> ekleme , into --> içine )

insert into Categories (CategoryName,Description) -- parantez içindekiler kolonlar eklenmek istenen
values ('test categoy','test category description')

-- sonucunda : .. row affected çıktısını alırısan ---> bu bir satır etkilendi bundan demek (eklendiğini gösterir )

insert into [Order Details] values (10248 ,12,15,10,0)
-- kolonları vermediğiniz zaman bütün kolonlra ekleme yapmanız gerekir 
---------------------------------------------------------------------------------------------------------------

--2) UPDATE (GÜNCELLEME İÇİN KULLANILIR , set --> ayarlama anlamında kullanılır  )
 UPDATE Territories set TerritoryDescription='ankara ' -- birden fazla kolonu güncellemek için virgülle devam edip kolonlar yazılabilir
 --NOT : EĞER YUKARIDAKŞ KAYIDI ÇALIŞTIRIRSAM BÜTN TABLOYU GÜNCELLEMİŞ OLUP 
 --DESCRİPTİON BÖLÜMÜNE ANKARA İLE GÜNCELLENDİ
 -- BU ÇOK TEHLİKELİ BİR DURUMDUR , BÜYÜK PROJELER DE SIKKINTI YARATIR .
 
 --categoryID=10 olanı değiştirmek istiyorum
 update Categories set CategoryName ='test kategori' , Description =' test category description '
 where CategoryID >= 8


-- ??örnek :territories - regionID kolonun da 1 numaralılar karadeniz , 2 numaralılar ege , 3 numaralılar marmara ... olsun 

 --update Territories set RegionID =
  
  ---------------------------------------------------------------------------------------------------------------
  
  --3) DELETE (SİLME İŞLEMİ YAPILIR )

  DELETE FROM Categories -- BU ŞEKİLDE ÇALIŞTIRIRSAK , TABLODA BİR İLİİŞKİ YOKSA DİREKT TABLOYU SİLER 
  -- AMA NİR İLİŞKİ VARSA , BUNU SİLEMİYORUM DER (FOREİGN KEY VARSA MESELA )

  delete from Categories where CategoryID=9

  ----------------------------------------------------------------------------------------------------------
   --- profesyonel sorgular 




