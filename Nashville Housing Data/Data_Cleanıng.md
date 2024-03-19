# Nashville Housing Data
## An SQL Data Cleaning Project
### by salihyasincetin@hotmail.com

In this project, I will convert the data set given to me into appropriate formats with appropriate SQL.

This data set contains information about houses in the city of Nashville. We would like to restructure the data to a more organized and usable form.

In this project, we will

1. Standardizing the date format in the dataset.
2. Filling in the property address information in the dataset
3. Separating the address field into distinct columns for address, city, and state in the dataset.
4. Converting 'Y' values to 'Yes' and 'N' values to 'No' in the 'Sold as Vacant' field in the dataset
5. Eliminating duplicate entries from the dataset.
6. Removing unused columns from the dataset.

Lets take a look at the first few rows to examine the data in its original form.

````sql
SELECT * FROM(
SELECT *, ROW_NUMBER() OVER (ORDER BY [UniqueID]) AS c
FROM Nashville_Housing_Data) AS sanal_tablo
WHERE sira_numarasi BETWEEN 1 AND 10
````
**Results:**
| UniqueID | ParcelID        | LandUse       | PropertyAddress | SaleDate                | SalePrice               | LegalReference | SoldAsVacant     | OwnerName | OwnerAddress                  | Acreage | TaxDistrict                 | LandValue | BuildingValue           | TotalValue | YearBuilt | Bedrooms | FullBath | HalfBath | SaleDates | HalfBath  |   
|----------|-----------------|---------------|-----------------|-------------------------|-------------------------|----------------|------------------|-----------|-------------------------------|---------|-----------------------------|-----------|-------------------------|------------|-----------|----------|----------|----------|-----------|---|
| 1        | 105 11 0 080.00 | SINGLE FAMILY | 1802            | STEWART PL, NASHVILLE   | 2013-01-11 00:00:00.000 | 191500,00      | 20130118-0006337 | 0         | STINSON, LAURA M.             | 1802    | STEWART PL, NASHVILLE, TN   | 17        | URBAN SERVICES DISTRICT | 32000      | 134400    | 168300   | 1941     | 2        | 1         | 0 | 
| 2        | 118 03 0 130.00 | SINGLE FAMILY | 2761            | ROSEDALE PL, NASHVILLE  | 2013-01-18 00:00:00.000 | 202000,00      | 20130124-0008033 | 0         | NUNES, JARED R.               | 2761    | ROSEDALE PL, NASHVILLE, TN  | 11        | CITY OF BERRY HILL      | 34000      | 157800    | 191800   | 2000     | 3        | 2         | 1 | 
| 3        | 119 01 0 479.00 | SINGLE FAMILY | 224             | PEACHTREE ST, NASHVILLE | 2013-01-18 00:00:00.000 | 32000,00       | 20130128-0008863 | 0         | WHITFORD, KAREN               | 224     | PEACHTREE ST, NASHVILLE, TN | 17        | URBAN SERVICES DISTRICT | 25000      | 243700    | 268700   | 1948     | 4        | 2         | 0 | 
| 4        | 119 05 0 186.00 | SINGLE FAMILY | 316             | LUTIE ST, NASHVILLE     | 2013-01-23 00:00:00.000 | 102000,00      | 20130131-0009929 | 0         | HENDERSON, JAMES P. & LYNN P. | 316     | LUTIE ST, NASHVILLE, TN     | 34        | URBAN SERVICES DISTRICT | 25000      | 138100    | 164800   | 1910     | 2        | 1         | 0 | 
| 5        | 119 05 0 387.00 | SINGLE FAMILY | 2626            | FOSTER AVE, NASHVILLE   | 2013-01-04 00:00:00.000 | 93736,00       | 20130118-0006110 | 0         | MILLER, JORDAN                | 2626    | FOSTER AVE, NASHVILLE, TN   | 17        | URBAN SERVICES DISTRICT | 25000      | 86100     | 113300   | 1945     | 2        | 1         | 0 | 
 

- #### Since the date data in our table is in datetime format, time data appears next to the date, but we do not want this. Let's standardize our time data and just write the date

BEFORE : 

| SaleDate   |
|-------------------------|
| 2013-01-11 00:00:00.000 |
| 2013-01-18 00:00:00.000 |
| 2013-01-18 00:00:00.000 |
| 2013-01-23 00:00:00.000 |
| 2013-01-04 00:00:00.000 |   

````sql
UPDATE [dbo].[Nashville Housing Data for Data Cleaning]
SET SaleDate = CONVERT(DATE,SaleDate)
````

AFTER :

| SaleDate   |
|------------|
| 2013-01-11 |
| 2013-01-18 |
| 2013-01-18 |
| 2013-01-23 |
| 2013-01-04 |

- #### In the table, we see that some values are empty in the [PropertyAddress] column, but every house should have an address. When we examine the table, we see that this is because some [ParcelID] values are the same. For this reason, while one [ParcelID] address is written, the other copy is not. Let's fix this

````sql
UPDATE a
SET [PropertyAddress] = ISNULL(a.[PropertyAddress], 'No Adress')
FROM [dbo].[Nashville Housing Data for Data Cleaning] a
JOIN [dbo].[Nashville Housing Data for Data Cleaning] b
  ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL
````
In summary, this code is used to replace NULL values in the "PropertyAddress" column with 'No Address' in the "Nashville Housing Data for Data Cleaning" database. It operates among records with matching "ParcelID" values but differing "UniqueID" values.  

- #### We have a column that clearly indicates the address, but we want to divide them into columns to clearly see the values such as city and address etc. Let's see what we can do for this.

````sql
- UPDATE [dbo].[Nashville Housing Data for Data Cleaning]
SET PropertySplitAddress = 
CASE
WHEN CHARINDEX(',', PropertyAddress) > 0 THEN SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1 )
ELSE PropertyAddress
END

- UPDATE [dbo].[Nashville Housing Data for Data Cleaning]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))
````
In summary, these SQL statements are used to split the "PropertyAddress" into separate columns for address and city based on the comma delimiter.

- #### Let's do a similar operation in the [OwnerAddress] column to see it clearly again.

````sql
- UPDATE [dbo].[Nashville Housing Data for Data Cleaning]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

- UPDATE [dbo].[Nashville Housing Data for Data Cleaning]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

- UPDATE [dbo].[Nashville Housing Data for Data Cleaning]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
````
In summary, these SQL statements are used to split the "OwnerAddress" into separate columns for address, city, and state based on the comma delimiter and populate the corresponding columns accordingly.

- #### We noticed that some of the yes or no values in the [SoldAsVacant] column are written as "Yes" and some are written as "Y". The same goes for the "NO" values. Let's standardize all the values.

````sql
UPDATE [dbo].[Nashville Housing Data for Data Cleaning]
SET SoldAsVacant = 
CASE 
WHEN SoldAsVacant = '1' THEN 'Yes'
WHEN SoldAsVacant = '0' THEN 'No'
ELSE SoldAsVacant
END
````
In summary, this SQL statement is used to standardize the values in the "SoldAsVacant" column, replacing '1' with 'Yes', '0' with 'No', and leaving other values unchanged.

- #### Let's write some code using CTE to eliminate duplicates

````sql
WITH RowNumCTE AS(
Select *,
ROW_NUMBER() OVER (
PARTITION BY 
ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
ORDER BY UniqueID) AS row_num

FROM [dbo].[Nashville Housing Data for Data Cleaning])
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress
````
In summary, this query identifies duplicate rows within the "Nashville Housing Data for Data Cleaning" table based on specific columns and presents them in the result set for further analysis or action.

- #### Finally, let's eliminate the columns we don't use so that they don't distract us.

````sql
ALTER TABLE [dbo].[Nashville Housing Data for Data Cleaning]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
````
In summary, this SQL statement alters the structure of the "Nashville Housing Data for Data Cleaning" table by dropping four columns: "OwnerAddress", "TaxDistrict", "PropertyAddress", and "SaleDate".




  


