
drop trigger if exists action_user_logger on public.observations;
create or replace function public.log_action_user() 
returns trigger LANGUAGE 'plpgsql'
as $BODY$ 
	begin
		NEW.modified_by = current_user;
		NEW.modified_at = NOW();
		return NEW;
	end;
$BODY$;



create trigger action_user_logger before insert or update on public.observations for each row execute procedure public.log_action_user();


