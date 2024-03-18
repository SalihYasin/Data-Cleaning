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
SELECT *
FROM Nashville_Housing_Data
LIMIT 10;
````
**Results:**

| UniqueID  | ParcelID        | LandUse       | PropertyAddress                         | SaleDate         | SalePrice | LegalReference   | SoldAsVacant | OwnerName                             | OwnerAddress                                | Acreage | TaxDistrict               | LandValue | BuildingValue | TotalValue | YearBuilt | Bedrooms | FullBath | HalfBath |
|-----------|-----------------|---------------|-----------------------------------------|------------------|-----------|------------------|--------------|---------------------------------------|---------------------------------------------|---------|---------------------------|-----------|---------------|------------|-----------|----------|----------|----------|
| 2045      | 007 00 0 125.00 | SINGLE FAMILY | 1808  FOX CHASE DR, GOODLETTSVILLE      | April 9, 2013    | 240000    | 20130412-0036474 | No           | FRAZIER, CYRENTHA LYNETTE             | 1808  FOX CHASE DR, GOODLETTSVILLE,   TN    | 2,3     | GENERAL SERVICES DISTRICT | 50000     | 168200        | 235700     | 1986      | 3        | 3        | 0        |
| 16918     | 007 00 0 130.00 | SINGLE FAMILY | 1832  FOX CHASE DR, GOODLETTSVILLE      | June 10, 2014    | 366000    | 20140619-0053768 | No           | BONER, CHARLES & LESLIE               | 1832  FOX CHASE DR, GOODLETTSVILLE,   TN    | 3,5     | GENERAL SERVICES DISTRICT | 50000     | 264100        | 319000     | 1998      | 3        | 3        | 2        |
| 54582     | 007 00 0 138.00 | SINGLE FAMILY | 1864 FOX CHASE  DR, GOODLETTSVILLE      | September 26,2016| 435000    | 20160927-0101718 | No           | WILSON, JAMES E. & JOANNE             | 1864  FOX CHASE DR, GOODLETTSVILLE,   TN    | 2,9     | GENERAL SERVICES DISTRICT | 50000     | 216200        | 298000     | 1987      | 4        | 3        | 0        |
| 43070     | 007 00 0 143.00 | SINGLE FAMILY | 1853  FOX CHASE DR, GOODLETTSVILLE      | January 29, 2016 | 255000    | 20160129-0008913 | No           | BAKER, JAY K. & SUSAN E.              | 1853  FOX CHASE DR, GOODLETTSVILLE,   TN    | 2,6     | GENERAL SERVICES DISTRICT | 50000     | 147300        | 197300     | 1985      | 3        | 3        | 0        |
| 22714     | 007 00 0 149.00 | SINGLE FAMILY | 1829  FOX CHASE DR, GOODLETTSVILLE      | October 10, 2014 | 278000    | 20141015-0095255 | No           | POST, CHRISTOPHER M. & SAMANTHA C.    | 1829  FOX CHASE DR, GOODLETTSVILLE,   TN    | 2       | GENERAL SERVICES DISTRICT | 50000     | 152300        | 202300     | 1984      | 4        | 3        | 0        |
| 18367     | 007 00 0 151.00 | SINGLE FAMILY | 1821  FOX CHASE DR, GOODLETTSVILLE      | July 16, 2014    | 267000    | 20140718-0063802 | No           | FIELDS, KAREN L. & BRENT A.           | 1821  FOX CHASE DR, GOODLETTSVILLE,   TN    | 2       | GENERAL SERVICES DISTRICT | 50000     | 190400        | 259800     | 1980      | 3        | 3        | 0        |
| 19804     | 007 14 0 002.00 | SINGLE FAMILY | 2005  SADIE LN, GOODLETTSVILLE          | August 28, 2014  | 171000    | 20140903-0080214 | No           | HINTON, MICHAEL R. & CYNTHIA M. MOORE | 2005  SADIE LN, GOODLETTSVILLE, TN          | 1,03    | GENERAL SERVICES DISTRICT | 40000     | 137900        | 177900     | 1976      | 3        | 2        | 0        |
| 54583     | 007 14 0 024.00 | SINGLE FAMILY | 1917 GRACELAND  DR, GOODLETTSVILLE      |September 27,2016 | 262000    | 20161005-0105441 | No           | BAILOR, DARRELL & TAMMY               | 1917  GRACELAND DR, GOODLETTSVILLE,   TN    | 1,03    | GENERAL SERVICES DISTRICT | 40000     | 157900        | 197900     | 1978      | 3        | 2        | 0        |
| 36500     | 007 14 0 026.00 | SINGLE FAMILY | 1428  SPRINGFIELD HWY,   GOODLETTSVILLE | August 14, 2015  | 285000    | 20150819-0083440 | No           | ROBERTS, MISTY L. & ROBERT M.         | 1428  SPRINGFIELD HWY,   GOODLETTSVILLE, TN | 1,67    | GENERAL SERVICES DISTRICT | 45400     | 176900        | 222300     | 2000      | 3        | 2        | 1        |
| 19805     | 007 14 0 034.00 | SINGLE FAMILY | 1420  SPRINGFIELD HWY,   GOODLETTSVILLE | August 29, 2014  | 340000    | 20140909-0082348 | No           | LEE, JEFFREY & NANCY                  | 1420  SPRINGFIELD HWY,   GOODLETTSVILLE, TN | 1,3     | GENERAL SERVICES DISTRICT | 40000     | 179600        | 219600     | 1995      | 5        | 3        | 0        |
