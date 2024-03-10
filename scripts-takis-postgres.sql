select * from information_schema.tables where table_schema = 'public';

select * from transactions t;

update transactions set amount = amount - 328.68 where transaction_id = 'f13872b0-50d3-46c9-bf00-d5a62e750793';

update transactions set amount = amount + 100 where transaction_id = 'f13872b0-50d3-46c9-bf00-d5a62e750793';

select * from transactions t where transaction_id = '0f2ad721-60b1-48d6-9a2d-ab6c04a6cb5e';

update transactions set amount = 555 where transaction_id = '0f2ad721-60b1-48d6-9a2d-ab6c04a6cb5e';

-- capture before records on debezium
alter table transactions replica identity full;


ALTER TABLE transactions ADD COLUMN modified_by TEXT;
ALTER TABLE transactions ADD COLUMN modified_at TIMESTAMP;

-- Function that updates the modified_by and modified_at fields
CREATE OR REPLACE FUNCTION record_change_user()
RETURNS TRIGGER AS $$
BEGIN
    NEW.modified_by := current_user; -- sets the modified_by field to the current user
    NEW.modified_at := CURRENT_TIMESTAMP; -- sets the modified_at field to the current time
    RETURN NEW; -- returns the modified row
END;
$$ LANGUAGE plpgsql;

-- Trigger that calls the function before any UPDATE operation on the 'transactions' table
CREATE TRIGGER trigger_record_user_update
BEFORE UPDATE ON transactions
FOR EACH ROW EXECUTE FUNCTION record_change_user();

drop trigger trigger_record_user_update on transactions;

CREATE OR REPLACE FUNCTION record_changed_columns()
RETURNS TRIGGER AS $$
DECLARE
    change_details JSONB;
BEGIN
    change_details := '{}'::JSONB; -- Initialize an empty JSONB object

    -- Check each column for changes and record as necessary
    IF NEW.amount IS DISTINCT FROM OLD.amount THEN
        change_details := jsonb_insert(change_details, '{amount}', jsonb_build_object('old', OLD.amount, 'new', NEW.amount));
    END IF;

    -- Add user and timestamp
    change_details := change_details || jsonb_build_object('modified_by', current_user, 'modified_at', now());

    -- Update the change_info column
    NEW.change_info := change_details;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

ALTER TABLE TRANSACTIONS ADD COLUMN change_info JSONB;

CREATE TRIGGER trigger_record_change_info
BEFORE UPDATE ON transactions
FOR EACH ROW EXECUTE FUNCTION record_changed_columns();
