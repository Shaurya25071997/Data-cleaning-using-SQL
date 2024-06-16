create database housing

use housing

select * from [dbo].[Navilehosuing]

------------Standardize date format----------------------

select SaleDateConverted, convert(Date, Saledate) from [dbo].[Navilehosuing]


update  [dbo].[Navilehosuing] set SaleDate = convert(Date, SaleDate)

alter table [dbo].[Navilehosuing] add SaleDateConverted Date;

update [dbo].[Navilehosuing] set SaleDateConverted = convert(Date, SaleDate)

------------Populate property address data---------

select PropertyAddress from [dbo].[Navilehosuing] where PropertyAddress is null

select * from [dbo].[Navilehosuing] order by ParcelID;

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) from [dbo].[Navilehosuing] a
JOIN [dbo].[Navilehosuing] b on a.ParcelID  = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ] where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [dbo].[Navilehosuing] a
JOIN [dbo].[Navilehosuing] b on a.ParcelID  = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ] where a.PropertyAddress is null

------------ Breaking address into indidvidual acolumn (Address, State, City) ------------------------

select SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1) as address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , len(PropertyAddress)) as address

from [dbo].[Navilehosuing]

Alter table [dbo].[Navilehosuing]
Add PropertySplitAddress Nvarchar(255);

Update [dbo].[Navilehosuing] set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1)


Alter table [dbo].[Navilehosuing]
Add PropertySplitCity Nvarchar(255);

Update [dbo].[Navilehosuing] set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , len(PropertyAddress))

select * from [dbo].[Navilehosuing]

select OwnerAddress from [dbo].[Navilehosuing]

select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) 
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) 
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) 
from [dbo].[Navilehosuing]

Alter table [dbo].[Navilehosuing] add OwnerSplitAddress Nvarchar(255);

Update [dbo].[Navilehosuing] set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) 

Alter table [dbo].[Navilehosuing] add OwnerSplitState Nvarchar(255);

Update [dbo].[Navilehosuing] set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Alter table [dbo].[Navilehosuing] add OwnerSplitCity Nvarchar(255);

Update [dbo].[Navilehosuing] set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

select * from [dbo].[Navilehosuing]


--------------change Y and N as Yes and No in 'SoldAsVacant' field--------------

select distinct(SoldAsVacant), count(SoldAsVacant) from [dbo].[Navilehosuing] group by SoldAsVacant order by 2


select SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN  'Yes'
     WHEN SoldAsVacant =  'N' THEN  'NO'
	 ELSE SoldAsVacant
	 END
from [dbo].[Navilehosuing]

update [dbo].[Navilehosuing] set SoldAsVacant = 
CASE WHEN SoldAsVacant = 'Y' THEN  'Yes'
     WHEN SoldAsVacant =  'N' THEN  'NO'
	 ELSE SoldAsVacant
	 END
from [dbo].[Navilehosuing]

select distinct(SoldAsVacant), count(SoldAsVacant) from [dbo].[Navilehosuing] group by SoldAsVacant order by 2
     

----------------Remove Duplicates---------

select *, from [dbo].[Navilehosuing]

With RowNumCTE As(

select *,
ROW_NUMBER() Over (
Partition by ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order by
			 UniqueID
			 ) row_num

from [dbo].[Navilehosuing] )

select * from RowNumCTE where row_num > 1 order by PropertyAddress


 select * from [dbo].[Navilehosuing]

 ------------Delete Unused columns

 select * from [dbo].[Navilehosuing]

 Alter table [dbo].[Navilehosuing] drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

 select * from [dbo].[Navilehosuing]











