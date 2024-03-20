SELECT 
  * 
FROM 
  [dbo].[Nashville Housing Data for Data Cleaning] 
  
  -- Standardize Date Format

  UPDATE 
  [dbo].[Nashville Housing Data for Data Cleaning] 
SET 
  SaleDate = CONVERT(DATE, SaleDate) 
SELECT 
  [SaleDate] 
FROM 
  [dbo].[Nashville Housing Data for Data Cleaning] 
  
  -- Populate Property Address data

  SELECT 
  * 
FROM 
  [dbo].[Nashville Housing Data for Data Cleaning] 
WHERE 
  [PropertyAddress] IS NULL 
ORDER BY 
  [ParcelID] 
SELECT 
  a.ParcelID, 
  a.PropertyAddress, 
  b.ParcelID, 
  b.PropertyAddress, 
  ISNULL(
    a.PropertyAddress, b.PropertyAddress
  ) 
FROM 
  [dbo].[Nashville Housing Data for Data Cleaning] a 
  JOIN [dbo].[Nashville Housing Data for Data Cleaning] b ON a.ParcelID = b.ParcelID 
  AND a.UniqueID <> b.UniqueID 
WHERE 
  a.PropertyAddress IS NULL 
UPDATE 
  a 
SET 
  [PropertyAddress] = ISNULL(
    a.[PropertyAddress], 'No Adress'
  ) 
FROM 
  [dbo].[Nashville Housing Data for Data Cleaning] a 
  JOIN [dbo].[Nashville Housing Data for Data Cleaning] b ON a.ParcelID = b.ParcelID 
  AND a.UniqueID <> b.UniqueID 
WHERE 
  a.PropertyAddress IS NULL 
SELECT 
  [UniqueID], 
  [ParcelID], 
  [PropertyAddress] 
FROM 
  [dbo].[Nashville Housing Data for Data Cleaning] 
WHERE 
  PropertyAddress = 'No Adress' 
  
  -- Breaking out Address into Individual Columns (Address, City, State)

  SELECT 
  PropertyAddress 
FROM 
  [dbo].[Nashville Housing Data for Data Cleaning] 
SELECT 
  SUBSTRING(
    PropertyAddress, 
    1, 
    CHARINDEX(',', PropertyAddress) -1
  ) AS Address1, 
  SUBSTRING(
    PropertyAddress, 
    CHARINDEX(',', PropertyAddress) + 1, 
    LEN(PropertyAddress)
  ) AS Address2 
FROM 
  [dbo].[Nashville Housing Data for Data Cleaning] 
ALTER TABLE 
  [dbo].[Nashville Housing Data for Data Cleaning] 
ADD 
  PropertySplitAddress Nvarchar(255);
UPDATE 
  [dbo].[Nashville Housing Data for Data Cleaning] 
SET 
  PropertySplitAddress = CASE WHEN CHARINDEX(',', PropertyAddress) > 0 THEN SUBSTRING(
    PropertyAddress, 
    1, 
    CHARINDEX(',', PropertyAddress) -1
  ) ELSE PropertyAddress END 
ALTER TABLE 
  [dbo].[Nashville Housing Data for Data Cleaning] 
ADD 
  PropertySplitCity Nvarchar(255);
UPDATE 
  [dbo].[Nashville Housing Data for Data Cleaning] 
SET 
  PropertySplitCity = SUBSTRING(
    PropertyAddress, 
    CHARINDEX(',', PropertyAddress) + 1, 
    LEN(PropertyAddress)
  ) 
SELECT 
  * 
FROM 
  [dbo].[Nashville Housing Data for Data Cleaning] 
SELECT 
  PARSENAME(
    REPLACE(OwnerAddress, ',', '.'), 
    3
  ), 
  PARSENAME(
    REPLACE(OwnerAddress, ',', '.'), 
    2
  ), 
  PARSENAME(
    REPLACE(OwnerAddress, ',', '.'), 
    1
  ) 
FROM 
  [dbo].[Nashville Housing Data for Data Cleaning] 
ALTER TABLE 
  [dbo].[Nashville Housing Data for Data Cleaning] 
ADD 
  OwnerSplitAddress Nvarchar(255);
UPDATE 
  [dbo].[Nashville Housing Data for Data Cleaning] 
SET 
  OwnerSplitAddress = PARSENAME(
    REPLACE(OwnerAddress, ',', '.'), 
    3
  ) 
ALTER TABLE 
  [dbo].[Nashville Housing Data for Data Cleaning] 
ADD 
  OwnerSplitCity Nvarchar(255);
UPDATE 
  [dbo].[Nashville Housing Data for Data Cleaning] 
SET 
  OwnerSplitCity = PARSENAME(
    REPLACE(OwnerAddress, ',', '.'), 
    2
  ) 
ALTER TABLE 
  [dbo].[Nashville Housing Data for Data Cleaning] 
ADD 
  OwnerSplitState Nvarchar(255);
UPDATE 
  [dbo].[Nashville Housing Data for Data Cleaning] 
SET 
  OwnerSplitState = PARSENAME(
    REPLACE(OwnerAddress, ',', '.'), 
    1
  ) 
SELECT 
  * 
FROM 
  [dbo].[Nashville Housing Data for Data Cleaning] 
  
  -- Change Y and N to Yes and No in "Sold as Vacant" field

  SELECT 
  DISTINCT(SoldAsVacant), 
  Count(SoldAsVacant) 
FROM 
  [dbo].[Nashville Housing Data for Data Cleaning] 
GROUP BY 
  SoldAsVacant 
ORDER BY 
  2 
SELECT 
  SoldAsVacant, 
  CASE WHEN SoldAsVacant = '1' THEN 'Yes' WHEN SoldAsVacant = '0' THEN 'No' ELSE SoldAsVacant END 
FROM 
  [dbo].[Nashville Housing Data for Data Cleaning] 
UPDATE 
  [dbo].[Nashville Housing Data for Data Cleaning] 
SET 
  SoldAsVacant = CASE WHEN SoldAsVacant = '1' THEN 'Yes' WHEN SoldAsVacant = '0' THEN 'No' ELSE SoldAsVacant END 
  
  -- Remove Duplicates
  
  WITH RowNumCTE AS(
    Select 
      *, 
      ROW_NUMBER() OVER (
        PARTITION BY ParcelID, 
        PropertyAddress, 
        SalePrice, 
        SaleDate, 
        LegalReference 
        ORDER BY 
          UniqueID
      ) AS row_num 
    FROM 
      [dbo].[Nashville Housing Data for Data Cleaning]
  ) 
SELECT 
  * 
FROM 
  RowNumCTE 
WHERE 
  row_num > 1 
ORDER BY 
  PropertyAddress 
  
  -- Delete Unused Columns

  ALTER TABLE 
  [dbo].[Nashville Housing Data for Data Cleaning] 
DROP 
  COLUMN OwnerAddress, 
  TaxDistrict, 
  PropertyAddress, 
  SaleDate

