-- Set variables (similar to the MySQL script)
DO $$ 
DECLARE
    SCORING_HOST TEXT := '%';           -- Set to the scoring machine's host (or IP)
    SCORING_USER TEXT := 'bill_kaplan';  -- Set to scoring user name
    SCORING_TABLE TEXT := 'users';           -- Set to scoring table name (can be specific)
    SCORING_DB TEXT := 'db';             -- Set to scoring db name
    ROOT_HOST TEXT := 'localhost';       -- Set to localhost on comp machine
BEGIN

    -- Set login locations for scoring user
    EXECUTE format('ALTER ROLE % WITH LOGIN HOST %', SCORING_USER, SCORING_HOST);
    
    -- Set login location for root user (PostgreSQL uses 'postgres' as superuser by default)
    EXECUTE format('ALTER ROLE postgres WITH LOGIN HOST %', ROOT_HOST);

    -- Remove all scoring user permissions
    EXECUTE format('REVOKE ALL PRIVILEGES ON DATABASE % FROM %', SCORING_DB, SCORING_USER);
    EXECUTE format('REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM %', SCORING_USER);

    -- Grant specific permissions to the scoring user on the scoring table
    EXECUTE format('GRANT SELECT, INSERT, UPDATE ON TABLE %I.%I TO %', SCORING_DB, SCORING_TABLE, SCORING_USER);

    -- Refresh the privileges (usually not necessary in PostgreSQL as it's applied immediately)
    -- This command is included for completeness but is not required in PostgreSQL.

    -- Revoke ability to write to files by removing the pg_write_server_files role
    REVOKE pg_write_server_files FROM bill_kaplan;

    -- Ensure user does not have superuser privileges, which can bypass file output restrictions
    ALTER ROLE bill_kaplan NOSUPERUSER;

    -- Optionally, you can revoke other file-related privileges (e.g., read/write on specific files), if needed.

END $$;

-- DO $$ 
-- DECLARE
--     user_record RECORD;
-- BEGIN
--     -- Loop through all roles in the database
--     FOR user_record IN 
--         SELECT rolname
--         FROM pg_roles
--         WHERE rolname NOT IN ('bill_kaplan', 'root') -- Exclude 'bill' and 'root'
--     LOOP
--         -- Revoke all privileges for the user
--         EXECUTE format('REVOKE ALL PRIVILEGES ON DATABASE % FROM %', current_database(), user_record.rolname);
--         EXECUTE format('REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM %', user_record.rolname);
--         EXECUTE format('REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM %', user_record.rolname);
--         EXECUTE format('REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public FROM %', user_record.rolname);
--         EXECUTE format('REVOKE ALL PRIVILEGES ON ALL TYPES IN SCHEMA public FROM %', user_record.rolname);
--         EXECUTE format('REVOKE ALL PRIVILEGES ON ALL SCHEMAS FROM %', user_record.rolname);

--         -- Drop the user role
--         EXECUTE format('DROP ROLE IF EXISTS %', user_record.rolname);
--     END LOOP;
-- END $$;
