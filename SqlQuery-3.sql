-- BÖLÜM-18

--SELECT İLE TABLOYA İNSET YAPMAK :

-- amacımız Customers tablosundaki dataları yeni oluşturduğumuz CustomersWork tablosuna aktarmak 
select * from CustomersWork

--insert into CustomersWork (CustomerId,CompanyName , ContactName)
--values ('','','') -- bu şekilde ekleyebiliyoruz 

insert into CustomersWork (CustomerId,CompanyName ,ContactName)
select CustomerId,CompanyName ,ContactName from Customers
-- Customers tablosundaki ilk 3 kolonun verilerini CustomersWork tablosuna ekledik

select * from CustomersWork -- bunu çalıştırdığımız an veriler gelmiş olur (91 satır)

delete from CustomersWork -- ilişki olmadığı için siler

-- kullanılabilir yöntem !!
insert into CustomersWork (CustomerId,CompanyName ,ContactName)
select CustomerId,CompanyName ,ContactName from Customers
where ContactName like '%en%'
-- contactname kolonundaki verilerin ortasında "en" geçenleri ekle (Customers tablosundan CustomersWork tablosuna ekle)


---------------------------------------------------------------------------
-- JOİN İLE TABLOYA UPDATE YAPMAK :

-- CustomersWork de değiştirdiğimiz kısımları Customers'a Aaktarmak istiyoruz (mesela companyName kısmı olsun)
 update Customers set CompanyName = CustomersWork.CompanyName -- iki tabloda da karşılık gelen aynı verileri çekmek gerekir 
from 
Customers inner join CustomersWork  -- bu şarta uyanları , Customers tablosundaki CustomersWork tablosundaki CompanyName kısmıyla güncelle
on Customers.CustomerID =CustomersWork.CustomerID
--where CustomersWork.CompanyName like '%Test%' -- için de Test geçen verileri getir 


------------------------------------------------------------------------------------------------------
 -- JOİN İLE DELETE YAPMAK :
 -- Ben Customers Tablosundaki mesela 3 veriyi silmek istiyorum (ÖR)
 -- ilişkisel olduğu için tabladaki veriler silinmicek , ilişkisel olmasaydı tablo silinirdi

 DELETE Customers
  from  
Customers inner join CustomersWork  -- ?? bu şarta uyanları , iki  tabloda eşit olanları siler  
on Customers.CustomerID =CustomersWork.CustomerID

-- sonucun da bir FK hatası alırız , şundan dolayı : "FK_Orders_Customers" customers tablosunun orders tablosuyla ilişkisi olduğu için 
-- o verileri silmek için ilk önce orders tablosundan siparişi silicez , sonra gelip customers tablosundan müşteriyi silmemiz gerekir 


---------------------------------------------------------------------------------------------------------------------------------------
-- UNİON : İKİ TABLOYU ALT ALTA BİRLEŞTİRME (iki tablonu kolon sayısı eşit --> (eşit olan tablolar verilebilir)  ve veri tiplerin aynı olması gerekiyor )

--JOİN DE İKİ TABLOYU YAN YANA GETİRİYORDUK , UNİON DA ALT ALTA GETİRİYORUZ  (FARKLARI)

select * from Customers --91 rows 
select * from CustomersWork --17 row 
-- total rows 108 , bunların ikisinin beraber çalıştırırsak ayrı 2 sonuç gelir 

-- Ama biz tek sonuç istiyoruz , tek sonuç istiyoruz diye UNİON kullanıcaz


select CustomerId,CompanyName ,ContactName  from Customers --91 rows
union 
select * from CustomersWork --17 row 
-- SONUÇ ;  96 satır geldi , neden 108 değil ? --> tamamı farklı olanları getirir , aynı olanları 2 kez getirmez 
-- AMA BEN HEPSİNİ İSTİYORUM DENİLİYORSA ; " UNION ALL " YAZILIR  

-- problem şu ; siz bu iki tabloyu bir araya getirmek istiyorsun ama iki tablonun kolon sayısı birbirinden farklıdır .
-- ortak olan alanları çağıarabiliriz unıon da (2 tablonun ortak alanları)
