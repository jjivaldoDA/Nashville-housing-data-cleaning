-- 1. Comprendre les données
-- Afficher les colonnes et 1000 premières lignes 
SELECT * 
FROM nashville LIMIT 1000; 

-- Afficher le nombre de lignes
SELECT COUNT(*) 
FROM nashville; 

-- Statistiques descriptives de la variable continue SalePrice
SELECT 
COUNT(SalePrice) as Count,
SUM(SalePrice) as Total, 
AVG(SalePrice) as Moyenne,
MAX(SalePrice) as Maximum,
MIN(SalePrice) as Minimum
FROM nashville; 

-- Tableau de fréquence de la variable LandUse
SELECT 
DISTINCT LandUse,
COUNT(LandUse) as Frequence
FROM nashville
GROUP BY LandUse
ORDER BY Frequence DESC; 

-- 2. Supprimer ou corriger les doublons
-- Affiche le nombre de fois qu'apparait une valeur distinct de la variable UniqueID 
SELECT 
UniqueID,
COUNT(DISTINCT UniqueID) as Doublons
FROM nashville
GROUP BY UniqueID
HAVING Doublons >1; 

-- Afficher les lignes qui se répétent grâce aux partitions
With RowNumCTE AS(
Select *,
	ROW_NUMBER() Over (
	Partition by ParcelID,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference
				 Order by UniqueID) as row_num
From nashville)
Select *
From RowNumCTE
Where row_num > 1
ORDER BY LegalReference; -- Affiche les lignes en doublons précisée par la partition.

-- Supprimer les lignes qui se répétent grâce aux partitions.
WITH RowNumCTE as (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID,
                         PropertyAddress,
                         SaleDate,
                         SalePrice,
                         LegalReference
            ORDER BY UniqueID) as row_num
    FROM nashville
)
DELETE FROM nashville
WHERE UniqueID in (
    SELECT UniqueID
    FROM RowNumCTE
    WHERE row_num > 1
); 

-- 3. Gérer les valeurs manquantes
-- Identifier les valeur manquantes pour les variable INT 
SET @VMI = NULL; -- Creation de la variable
SELECT
  GROUP_CONCAT(CONCAT('`', COLUMN_NAME, '` IS NULL') SEPARATOR ' OR ') INTO @VMI
FROM
  INFORMATION_SCHEMA.COLUMNS
WHERE
  TABLE_NAME = 'nashville' AND DATA_TYPE='INT'; -- Génération de la condition WHERE pour vérifier les valeurs NULL dans toutes les colonnes INT de my_table.

SET @VMI = CONCAT('SELECT * FROM nashville WHERE ', @VMI); -- Création de la requête SQL complète.
PREPARE stmt FROM @VMI; -- Préparation de la requête SQL dynamique. 
EXECUTE stmt; -- exécution de la requête SQL dynamique.
DEALLOCATE PREPARE stmt; -- Nettoyage de l'instruction préparée.

-- Identifier les valeur manquantes pour les variable TEXT
SET @VMT = NULL;
SELECT
  GROUP_CONCAT(CONCAT('(`', COLUMN_NAME, '` IS NULL OR `', COLUMN_NAME, '` = \'\')') SEPARATOR ' OR ') INTO @VMT
FROM
  INFORMATION_SCHEMA.COLUMNS
WHERE
  TABLE_NAME = 'nashville' AND DATA_TYPE='text';

SET @VMT = CONCAT('SELECT * FROM nashville WHERE ', @VMT);
SELECT @VMT;
PREPARE stmt FROM @VMT;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- SUPPRIMER les lignes contenant des valeurs manquantes pour les variables text
DELETE FROM nashville
WHERE PropertyAddress='' OR OwnerName ='';
 
-- 4. Correction des types de données
-- Afficher le nom des column et leur Data type
SELECT 
	COLUMN_NAME, 
	DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'nashville'; 

-- Voir les données actuelles
SELECT SaleDate FROM nashville;

-- Convertir et afficher les résultats
SELECT 
    SaleDate,
    STR_TO_DATE(SaleDate, '%M %d, %Y') AS datetime_column
FROM nashville;
    
-- Ajouter une nouvelle colonne et copier les valeurs converties
ALTER TABLE nashville 
ADD COLUMN datetime_column DATETIME;

UPDATE nashville
SET datetime_column = STR_TO_DATE(SaleDate, '%M %d, %Y');

-- Remplacer l'ancienne colonne par la nouvelle colonne
ALTER TABLE nashville DROP COLUMN SaleDate;
ALTER TABLE nashville CHANGE datetime_column SaleDate DATETIME;

-- 5. Standardisation et normalisation des données
-- Inspection de la variable "SoldAsVacant"
SELECT DISTINCT SoldAsVacant, 
COUNT(SoldAsVacant) as nb
FROM nashville
GROUP BY SoldAsVacant
ORDER BY nb DESC;

-- Modifier N -> No & Y -> Yes
SELECT 
	CASE WHEN SoldAsVacant = 'N' THEN 'No'
		WHEN SoldAsVacant ='Y' THEN 'Yes'
        ELSE SoldAsVacant
        END as TestNewColumn,
        SoldAsVacant
FROM nashville
WHERE SoldAsVacant = 'N'
ORDER BY SoldAsVacant DESC;

-- Transformation des données
UPDATE nashville
SET SoldAsVacant =
	CASE WHEN SoldAsVacant = 'N' THEN 'No'
		WHEN SoldAsVacant ='Y' THEN 'Yes'
        ELSE SoldAsVacant
        END;

-- Vérification de la modification
SELECT DISTINCT SoldAsVacant, 
COUNT(SoldAsVacant) as nb
FROM nashville
GROUP BY SoldAsVacant
ORDER BY nb DESC;


-- 6. Création de nouvelles variables (Feature engineering)
-- Variable pour quantitifier le gap entre la valeur du bien et le prix proposé. 
SELECT SalePrice, 
TotalValue, 
SalePrice-TotalValue AS Gap
FROM nashville;

ALTER TABLE nashville 
ADD COLUMN Gap INT;

UPDATE nashville
SET Gap=SalePrice-TotalValue;

-- Extraire les détails de l'addresse de la propriété
Select 
		Substring(PropertyAddress, LOCATE(',' , PropertyAddress) +1) as PropretyCity,
        RIGHT(OwnerAddress,2) as OwnerLivingState
FROM nashville;

-- Les Colonnes

ALTER TABLE nashville
ADD COLUMN PropretyCity TEXT;

ALTER TABLE nashville
ADD COLUMN OwnerLivingState TEXT;

-- Remplissage des colonnes

UPDATE nashville
SET PropretyCity = Substring(PropertyAddress, LOCATE(',' , PropertyAddress) +1);

UPDATE nashville
SET OwnerLivingState = RIGHT(OwnerAddress,2);

-- CHECK des valeurs ajoutées 
SELECT
    PropretyCity,
    OwnerLivingState
FROM nashville;
-- 7. Réduction de la dimensionnalité
-- Supprission des colonnes inutiles
ALTER TABLE nashville
DROP COLUMN OwnerAddress, 
DROP COLUMN PropertyAddress,
DROP COLUMN OwnerName;

-- Check de la nouvelle table
SELECT * FROM nashville 