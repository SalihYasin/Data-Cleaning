-- Create table to import SQL data into and use for data cleaning.

DROP TABLE IF EXISTS [Nashville Housing Data for Data Cleaning];
CREATE TABLE [Nashville Housing Data for Data Cleaning] (
	[UniqueID] [int],
	[ParcelID] [nvarchar](50),
	[LandUse] [nvarchar](50),
	[SalePrice] [money],
	[LegalReference] [nvarchar](50),
	[SoldAsVacant] [nvarchar](50),
	[OwnerName] [nvarchar](100),
	[Acreage] [float] ,
	[LandValue] [int] ,
	[BuildingValue] [int] ,
	[TotalValue] [int] ,
	[YearBuilt] [smallint] ,
	[Bedrooms] [tinyint] ,
	[FullBath] [tinyint] ,
	[HalfBath] [tinyint] ,
	[PropertySplitAddress] [nvarchar](255) ,
	[PropertySplitCity] [nvarchar](255) ,
	[OwnerSplitAddress] [nvarchar](255) ,
	[OwnerSplitCity] [nvarchar](255) ,
	[OwnerSplitState] [nvarchar](255) 
);

COPY [Nashville Housing Data for Data Cleaning]  (
	full_name,
	age,
	maritial_status,
	email,
	phone,
	full_address,
	job_title,
	membership_date)
from 'C:\Users\PLANLAMA\Desktop\Nashville_Housing_Data_for_Data_Cleaning.csv'
delimiter ',' csv header;
