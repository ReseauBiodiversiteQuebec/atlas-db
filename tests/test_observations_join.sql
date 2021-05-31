select
	obs.id,
	obs.geom,
	obs.year_obs,
	obs.month_obs,
	obs.day_obs,
	obs.time_obs,
	ds.title as dataset,
	taxa.scientific_name as taxa,
	var.name as variable,
	obs.obs_value,
	eff.effort_variable as effort_variable,
	eff.effort_value as effort_value
from observations obs
left join datasets ds on ds.id = obs.id_datasets
left join taxa on taxa.id = obs.id_taxa
left join variables var on var.id = obs.id_variables
left join (
	select id_obs, _var.name as effort_variable, effort_value
	from efforts as _eff
	left join obs_efforts on obs_efforts.id_efforts = _eff.id
	left join variables _var on _var.id = _eff.id_variables) as eff
	on eff.id_obs = obs.id