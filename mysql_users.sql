SET 
	@SCORING_HOST = '192.168.111.1',  # set to scoring machine
    @SCORING_USER = 'scoring', # Set to scoring user name
    @SCORING_TABLE = 'scoring_table', # Set to scoring table name
    @SCORING_DB = 'scoring', # Set to scoring db name
    @ROOT_HOST = '%' # SET TO localhost on comp machine
;

# Set login locations
UPDATE mysql.user SET Host=@SCORING_HOST WHERE User=@SCORING_USER;
UPDATE mysql.user SET Host=@ROOT_HOST WHERE User='root';

# Remove all scoring user permissions
SET @query = CONCAT('REVOKE ALL PRIVILEGES, GRANT OPTION FROM \'', @SCORING_USER, '\'@\'', @SCORING_HOST, '\';');
PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

FLUSH PRIVILEGES;

SET @query = CONCAT('GRANT SELECT, INSERT, UPDATE ON ', @SCORING_DB, '.', @SCORING_TABLE, ' TO \'', @SCORING_USER, '\'@\'', @SCORING_HOST, '\';');
PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

FLUSH PRIVILEGES;