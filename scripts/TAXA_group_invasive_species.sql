INSERT INTO taxa_groups (vernacular_fr, vernacular_en, level)
VALUES ('Espèces envahissantes', 'Invasive species', 2);


DO
$$
DECLARE
    id_group integer;
BEGIN
SELECT id INTO id_group from taxa_groups where vernacular_en = 'Invasive species';
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Harmonia axyridis' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Anoplophora glabripennis' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Popillia japonica' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Bythotrephes longimanus' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Eriocheir sinensis' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Hemimysis anomala' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Orconectes rusticus' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Dreissena bugensis' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Dreissena polymorpha' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Potamopyrgus antipodarum' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Corbicula fluminea' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Echinogammarus ischnus' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Bellamya chinensis' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Cervus elaphus' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Cygnus olor' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Ctenopharyngodon idella' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Lepomis cyanellus' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Pseudorasbora parva' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Scardinius erythrophthalmus' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Neogobius melanostomus' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Carassius auratus' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Tinca tinca' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Trachemys scripta elegans' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Channa' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Parachanna' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Trapa natans' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Nymphoides peltata' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Hydrocharis morsus-ranae' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Eichhornia crassipes' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Pistia stratiotes' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Salvinia' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Cabomba caroliniana' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Brazilian waterweed' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Hydrilla verticillata' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Myriophyllum aquaticum' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Myriophyllum spicatum' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Potamogeton crispus' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Phalaris arundinacea' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Butomus umbellatus' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Glyceria maxima' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Iris pseudacorus' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Rorippa amphibia' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Phragmites australis australis' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Lythrum salicaria' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Stratiotes aloides' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Alliaria petiolata' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Anthriscus sylvestris' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Heracleum sphondylium' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Heracleum mantegazzianum' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Symphytum officinale' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Vincetoxicum rossicum' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Vincetoxicum nigrum' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Aegopodium podagraria' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Acer platanoides' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Acer negundo' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Galium mollugo' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Impatiens glandulifera' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Miscanthus sacchariflorus' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Frangula alnus' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Rhamnus carthartica' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Ulmus pumila' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Pastinaca sativa' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Petasites japonicus' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Reynoutria xbohemica' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Reynoutria sachalinensis' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Reynoutria japonica' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Helianthus tuberosus' scientific_name;
INSERT INTO public.taxa_group_members ("id_group", "scientific_name") SELECT id_group, 'Valeriana officinalis' scientific_name;
COMMIT;
END;
$$;