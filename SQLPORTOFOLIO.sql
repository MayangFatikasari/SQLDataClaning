/*DATA CLEANING*/

Select *
From SQLPortofolio..NASHVILE

--Standarilasi Format 

Select SaleDateConverted, convert(date,saledate)
From SQLPortofolio..NASHVILE

update NASHVILE
set SaleDate = convert(date,saledate) 

ALTER TABLE NASHVILE
add  SaleDateConverted Date;

update NASHVILE
set SaleDateConverted = convert(date,saledate) 



------------------------------------------------------

--Populasi Alamat Properti

Select *
From SQLPortofolio..NASHVILE
--where PropertyAddress is Null
order by ParcelID

Select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL (A.PropertyAddress,B.PropertyAddress)
From SQLPortofolio..NASHVILE A
JOIN SQLPortofolio..NASHVILE B
	On A.ParcelID=B.ParcelID
	and A.[UniqueID ]<>B.[UniqueID] 
Where A.PropertyAddress is NULL

Update A
Set propertyaddress = ISNULL (A.PropertyAddress,B.PropertyAddress)
From SQLPortofolio..NASHVILE A
JOIN SQLPortofolio..NASHVILE B
	On A.ParcelID=B.ParcelID
	and A.[UniqueID ]<>B.[UniqueID]
Where A.PropertyAddress is NULL


------------------------------------------------------

--Break down Alamat terhadap Kolom Individu

Select PropertyAddress
From SQLPortofolio..NASHVILE
--where PropertyAddress is Null
--order by ParcelID

select
Substring (PropertyAddress, 1, CHARINDEX(',',Propertyaddress)-1) as Address
, Substring (PropertyAddress, CHARINDEX(',',Propertyaddress)+1, len(propertyaddress)) as Address
From SQLPortofolio..NASHVILE

ALTER TABLE NASHVILE
add  PropertySliptAddress Nvarchar(255);

update NASHVILE
set PropertySliptAddress = Substring (PropertyAddress, 1, CHARINDEX(',',Propertyaddress)-1)

ALTER TABLE NASHVILE
add  PropertySliptCity Nvarchar(255);

update NASHVILE
set PropertySliptCity = Substring (PropertyAddress, CHARINDEX(',',Propertyaddress)+1, len(propertyaddress))


Select*
From SQLPortofolio..NASHVILE

Select OwnerAddress
From SQLPortofolio..NASHVILE

Select 
PARSENAME(REPLACE(OwnerAddress, ',' ,'.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',' ,'.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',' ,'.'), 1)
From SQLPortofolio..NASHVILE

ALTER TABLE NASHVILE
add  OwnerSliptAddress Nvarchar(255);

update NASHVILE
set OwnerSliptAddress = PARSENAME(REPLACE(OwnerAddress, ',' ,'.'), 3)

ALTER TABLE NASHVILE
add  OwnerSliptCity Nvarchar(255);

update NASHVILE
set OwnerSliptCity = PARSENAME(REPLACE(OwnerAddress, ',' ,'.'), 2)

ALTER TABLE NASHVILE
add  OwnerSliptState Nvarchar(255);

update NASHVILE
set OwnerSliptState = PARSENAME(REPLACE(OwnerAddress, ',' ,'.'), 1)

Select *
From SQLPortofolio..NASHVILE


------------------------------------------------------

--Break down Alamat terhadap Kolom Individu


------------------------------------------------------

--Merubah Y dan N menjadi Yes dan No pada 'Sold As Vacant' 

select distinct(SoldAsVacant), count(SoldAsVacant)  
From SQLPortofolio..NASHVILE
group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' Then 'Yes'
		when SoldAsVacant = 'N' Then 'No'
		else SoldAsVacant
		END
From SQLPortofolio..NASHVILE

Update NASHVILE
set SoldAsVacant = case when SoldAsVacant = 'y' Then 'Yes'
		when SoldAsVacant = 'N' Then 'No'
		else SoldAsVacant
		END



------------------------------------------------------

--Hapus Duplikat Pada Database

WITH RowNumCTE as(
select *,
ROW_NUMBER() over (
partition by parcelID,
				PropertyAddress,
				SalePrice,
				Saledate,
				LegalReference
				ORder by 
					UniqueID
					) row_num

From SQLPortofolio..NASHVILE
)
DELETE
From RowNumCTE
where row_num>1

Select*
From SQLPortofolio..NASHVILE

alter table SQLPortofolio..NASHVILE
drop column owneraddress, taxdistrict, propertyaddress

alter table SQLPortofolio..NASHVILE
drop column saledate