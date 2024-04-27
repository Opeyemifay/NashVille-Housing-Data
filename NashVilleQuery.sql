
/* Cleaning Data In Sql Queries*/

SELECT *
FROM PortfolioProject.dbo.NashVilleHousingData
    
---------------------------------------------------------------------
/* Standardized Date Format*/

SELECT SaleDateN, CONVERT(DATE, SaleDate)
FROM PortfolioProject.dbo.NashVilleHousingData

UPDATE NashVilleHousingData
SET SaleDate = CONVERT(DATE, SaleDate)

ALTER TABLE NashVilleHousingData
Add SaleDateN Date;

UPDATE NashVilleHousingData
SET SaleDateN = CONVERT(DATE, SaleDate)

---------------------------------------------------------------------------------
--Populate Property Address Data--
SELECT *
FROM PortfolioProject.dbo.NashVilleHousingData
--WHERE PropertyAddress is null--
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
	FROM PortfolioProject.dbo.NashVilleHousingData a
	JOIN PortfolioProject.dbo.NashVilleHousingData b
		ON a.ParcelID = b.ParcelID
		AND a.[UniqueID ] <> b.[UniqueID ]
	WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
	FROM PortfolioProject.dbo.NashVilleHousingData a
	JOIN PortfolioProject.dbo.NashVilleHousingData b
		ON a.ParcelID = b.ParcelID
		AND a.[UniqueID ] <> b.[UniqueID ]
	WHERE a.PropertyAddress is null

-------------------------------------------------------------------------------
--Splitting Address Into Individual Columns(Address, City, State)--
SELECT PropertyAddress
FROM PortfolioProject.dbo.NashVilleHousingData
--WHERE PropertyAddress is null--
--ORDER BY ParcelID

SELECT 
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
	FROM PortfolioProject.dbo.NashVilleHousingData

	ALTER TABLE NashvilleHousingData
	Add PropertySplitAddress Nvarchar(255);

	Update NashvilleHousingData
	SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


	ALTER TABLE NashvilleHousingData
	Add PropertySplitCity Nvarchar(255);

	Update NashvilleHousingData
	SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

	Select *
	From PortfolioProject.dbo.NashvilleHousingData

---------------------------------------------------------------------------
--Splitting OwnerAddress into Columns(Address, City, State)--

Select OwnerAddress
From PortfolioProject.dbo.NashVilleHousingData


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousingData



ALTER TABLE NashvilleHousingData
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousingData
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousingData
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject.dbo.NashvilleHousingData


--------------------------------------------------------------------------------------------------
-- Changing Y and N to Yes and No in "Sold and Vacant" Fields.
SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject.dbo.NashVilleHousingData
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant =  'N' THEN 'No'
		ELSE SoldAsVacant
		END
	FROM PortfolioProject.dbo.NashVilleHousingData

	UPDATE NashVilleHousingData
	SET  SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant =  'N' THEN 'No'
		ELSE SoldAsVacant
		END
	FROM PortfolioProject.dbo.NashVilleHousingData

-------------------------------------------------------------------------------
--Removing Duplcates--

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousingData
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

DELETE
From RowNumCTE
Where row_num > 1


Select *
From PortfolioProject.dbo.NashvilleHousingData


---------------------------------------------------------------------------------------
--Delete Unused Column--

Select *
From PortfolioProject.dbo.NashvilleHousingData


ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate