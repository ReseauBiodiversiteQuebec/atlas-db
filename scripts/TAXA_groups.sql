--
-- Taxa group resoucres creation
--


DROP TABLE IF EXISTS public.taxa_groups CASCADE;
CREATE TABLE IF NOT EXISTS public.taxa_groups (
    id serial primary key,
    short varchar(20),
    vernacular_fr text,
    vernacular_en text,
    level integer,
    source_desc text,
    groups_within text[]
);

CREATE INDEX IF NOT EXISTS taxa_groups_short_idx ON public.taxa_groups (short);
-- Create unique index on short name
CREATE UNIQUE INDEX IF NOT EXISTS taxa_groups_short_unique_idx ON public.taxa_groups (short);

--
-- Data for Name: taxa_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- DESCRIPTION OF LEVELS
-- 0: All quebec taxa, members are gathered from the observations within_quebec
-- 1: High level groups, Contains exclusive taxas to other level 1 groups
-- 2: Application level groups defined by scientific_name, From specific list for specific analysis, may overlaps with other groups
-- 3: Application level groups defined by other groups instead of scientific_name

COPY taxa_groups (short, id, vernacular_fr, vernacular_en, level, source_desc) FROM stdin;
AMPHIBIANS	1	Amphibiens	Amphibians	1	NULL
BIRDS	2	Oiseaux	Birds	1	NULL
MAMMALS	3	Mammifères	Mammals	1	NULL
REPTILES	4	Reptiles	Reptiles	1	NULL
FISH	5	Poissons	Fish	1	NULL
TUNICATES	6	Tuniciers	Tunicates	1	NULL
LANCELETS	7	Céphalocordés	Lancelets	1	NULL
ARTHROPODS	8	Arthropodes	Arthropods	1	NULL
OTHER_INVERTEBRATES	9	Autres invertébrés	Other invertebrates	1	NULL
OTHER_TAXONS	10	Autres taxons	Other taxons	1	NULL
FUNGI	11	Mycètes	Fungi	1	NULL
ANGIOSPERMS	12	Angiospermes	Angiosperms	1	NULL
CONIFERS	13	Conifères	Conifers	1	NULL
VASCULAR_CRYPTOGAM	14	Cryptogames vasculaires	Vascular cryptogam	1	NULL
OTHER_GYMNOSPERMS	15	Autres gymnospermes	Other gymnosperms	1	NULL
ALGAE	16	Algues	Algae	1	NULL
BRYOPHYTES	17	Bryophytes	Bryophytes	1	NULL
OTHER_PLANTS	18	Autres plantes	Other plants	1	NULL
QUEBEC	20	Québec	Quebec	2	NULL
ALL_SPECIES	19	Toutes les espèces	All species	0	NULL
INVASIVE_SPECIES	25	Espèces envahissantes	Invasive species	2	NULL
CDPNQ_SUSC	21	Espèce susceptible		2	CDPNQ
CDPNQ_VUL	22	Espèce vulnérable		2	CDPNQ
CDPNQ_VUL_HARVEST	23	Espèce vulnérable à la récolte		2	CDPNQ
CDPNQ_ENDANGERED	24	Espèce menacée		2	CDPNQ
CDPNQ_S1	27	S1	S1	2	CDPNQ
CDPNQ_S2	28	S2	S2	2	CDPNQ
CDPNQ_S3	29	S3	S3	2	CDPNQ
SENSITIVE	31	Espèces sensibles	Sensitive species	2	CDPNQ
\.

INSERT INTO public.taxa_group_members (short, id, vernacular_fr, vernacular_en, level, groups_within)
VALUES
    -- ('CDPNQ_RISK', ARRAY['CDPNQ_S1', 'CDPNQ_S2', 'CDPNQ_S3']),
    -- ('CDPNQ_STATUS', ARRAY['CDPNQ_SUSC', 'CDPNQ_VUL', 'CDPNQ_VUL_HARVEST', 'CDPNQ_ENDANGERED']);
    ('CDPNQ_RISK', 30, 'En situation précaire', 'At risk', 3, ARRAY['CDPNQ_S1', 'CDPNQ_S2', 'CDPNQ_S3']),
    ('CDPNQ_STATUS', 26, 'Espèces à statut CDPNQ', 'Species at risk ', 3, ARRAY['CDPNQ_SUSC', 'CDPNQ_VUL', 'CDPNQ_VUL_HARVEST', 'CDPNQ_ENDANGERED']);




--
-- Data for Name: taxa_group_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

DROP TABLE IF EXISTS public.taxa_group_members CASCADE;
CREATE TABLE public.taxa_group_members (
    short varchar(20),
    scientific_name text
);


COPY public.taxa_group_members (short, scientific_name) FROM stdin;
AMPHIBIANS	Amphibia
BIRDS	Aves
MAMMALS	Mammalia
REPTILES	Reptilia
FISH	Myxini
FISH	Holocephali
FISH	Actinopterygii
FISH	Cephalaspidomorphi
FISH	Elasmobranchii
FISH	Coelacanthiformes
TUNICATES	Ascidiacea
TUNICATES	Thaliacea
TUNICATES	Appendicularia
LANCELETS	Leptocardii
ARTHROPODS	Arthropoda
OTHER_INVERTEBRATES	Hemichordata
OTHER_INVERTEBRATES	Micrognathozoa
OTHER_INVERTEBRATES	Mollusca
OTHER_INVERTEBRATES	Myxozoa
OTHER_INVERTEBRATES	Nematoda
OTHER_INVERTEBRATES	Nematomorpha
OTHER_INVERTEBRATES	Nemertea
OTHER_INVERTEBRATES	Onychophora
OTHER_INVERTEBRATES	Orthonectida
OTHER_INVERTEBRATES	Phoronida
OTHER_INVERTEBRATES	Placozoa
OTHER_INVERTEBRATES	Platyhelminthes
OTHER_INVERTEBRATES	Porifera
OTHER_INVERTEBRATES	Rotifera
OTHER_INVERTEBRATES	Sipuncula
OTHER_INVERTEBRATES	Xenacoelomorpha
OTHER_INVERTEBRATES	Tardigrada
OTHER_INVERTEBRATES	Acanthocephala
OTHER_INVERTEBRATES	Annelida
OTHER_INVERTEBRATES	Brachiopoda
OTHER_INVERTEBRATES	Bryozoa
OTHER_INVERTEBRATES	Cephalorhyncha
OTHER_INVERTEBRATES	Chaetognatha
OTHER_INVERTEBRATES	Cnidaria
OTHER_INVERTEBRATES	Ctenophora
OTHER_INVERTEBRATES	Cycliophora
OTHER_INVERTEBRATES	Dicyemida
OTHER_INVERTEBRATES	Echinodermata
OTHER_INVERTEBRATES	Entoprocta
OTHER_INVERTEBRATES	Gastrotricha
OTHER_INVERTEBRATES	Gnathostomulida
OTHER_TAXONS	Protozoa
OTHER_TAXONS	Viruses
OTHER_TAXONS	Chromista
OTHER_TAXONS	Bacteria
OTHER_TAXONS	Archaea
FUNGI	Fungi
ANGIOSPERMS	Magnoliopsida
ANGIOSPERMS	Liliopsida
CONIFERS	Pinopsida
VASCULAR_CRYPTOGAM	Lycopodiopsida
VASCULAR_CRYPTOGAM	Polypodiopsida
OTHER_GYMNOSPERMS	Gnetopsida
OTHER_GYMNOSPERMS	Cycadopsida
OTHER_GYMNOSPERMS	Ginkgoopsida
ALGAE	Chlorophyta
ALGAE	Charophyta
ALGAE	Rhodophyta
BRYOPHYTES	Bryophyta
OTHER_PLANTS	Glaucophyta
OTHER_PLANTS	Anthocerotophyta
OTHER_PLANTS	Marchantiophyta
CDPNQ_SUSC	Acipenser fulvescens
CDPNQ_SUSC	Lasiurus cinereus
CDPNQ_SUSC	Prionace glauca
CDPNQ_SUSC	Lasiurus borealis
CDPNQ_SUSC	Juglans cinerea
CDPNQ_SUSC	Carya ovata
CDPNQ_SUSC	Tofieldia coccinea
CDPNQ_SUSC	Microtus chrotorrhinus
CDPNQ_SUSC	Puccinellia nuttalliana
CDPNQ_SUSC	Esox niger
CDPNQ_SUSC	Calypso bulbosa
CDPNQ_SUSC	Synaptomys cooperi
CDPNQ_SUSC	Trichostema dichotomum
CDPNQ_SUSC	Sorex gaspensis
CDPNQ_SUSC	Microtus pinetorum
CDPNQ_SUSC	Gomphaeschna furcillata
CDPNQ_SUSC	Anarhichas minor
CDPNQ_SUSC	Anguilla rostrata
CDPNQ_SUSC	Sympetrum corruptum
CDPNQ_SUSC	Phocoena phocoena
CDPNQ_SUSC	Balaenoptera physalus
CDPNQ_SUSC	Balaenoptera musculus
CDPNQ_SUSC	Ammodramus savannarum
CDPNQ_SUSC	Desmognathus fuscus
CDPNQ_SUSC	Parkesia motacilla
CDPNQ_SUSC	Esox americanus
CDPNQ_SUSC	Cardellina canadensis
CDPNQ_SUSC	Leucoraja ocellata
CDPNQ_SUSC	Quercus bicolor
CDPNQ_SUSC	Hypericum virginicum
CDPNQ_SUSC	Sagina saginoides
CDPNQ_SUSC	Myoxocephalus quadricornis
CDPNQ_SUSC	Myoxocephalus thompsonii
CDPNQ_SUSC	Acipenser oxyrinchus
CDPNQ_SUSC	Euphagus carolinus
CDPNQ_SUSC	Draba corymbosa
CDPNQ_SUSC	Gymnocolea inflata
CDPNQ_SUSC	Lophozia ventricosa
CDPNQ_SUSC	Pompeius verna
CDPNQ_SUSC	Sorex dispar
CDPNQ_SUSC	Lasionycteris noctivagans
CDPNQ_SUSC	Myotis leibii
CDPNQ_SUSC	Glaucomys volans
CDPNQ_SUSC	Mustela nivalis
CDPNQ_SUSC	Cardamine bulbosa
CDPNQ_SUSC	Cinclidium latifolium
CDPNQ_SUSC	Sauteria alpina
CDPNQ_SUSC	Orthotrichum pallens
CDPNQ_SUSC	Noturus flavus
CDPNQ_SUSC	Ameiurus natalis
CDPNQ_SUSC	Delphinapterus leucas
CDPNQ_SUSC	Coregonus artedi
CDPNQ_SUSC	Hybognathus hankinsoni
CDPNQ_SUSC	Notropis rubellus
CDPNQ_SUSC	Brosme brosme
CDPNQ_SUSC	Odobenus rosmarus
CDPNQ_SUSC	Eubalaena glacialis
CDPNQ_SUSC	Oeneis bore
CDPNQ_SUSC	Euptoieta claudia
CDPNQ_SUSC	Euphyes dion
CDPNQ_SUSC	Erynnis martialis
CDPNQ_SUSC	Opheodrys vernalis
CDPNQ_SUSC	Storeria dekayi
CDPNQ_SUSC	Nerodia sipedon
CDPNQ_SUSC	Erythemis simplicicollis
CDPNQ_SUSC	Lycaena dospassosi
CDPNQ_SUSC	Scapania scandica
CDPNQ_SUSC	Anarhichas lupus
CDPNQ_SUSC	Anarhichas denticulatus
CDPNQ_SUSC	Clemmys guttata
CDPNQ_SUSC	Scapania irrigua
CDPNQ_SUSC	Lampropeltis triangulum
CDPNQ_SUSC	Phoca vitulina
CDPNQ_SUSC	Tritomaria quinquedentata
CDPNQ_SUSC	Diadophis punctatus
CDPNQ_SUSC	Ceratodon heterophyllus
CDPNQ_SUSC	Gadus morhua
CDPNQ_SUSC	Salvelinus alpinus
CDPNQ_SUSC	Botrychium pinnatum
CDPNQ_SUSC	Hemidactylium scutatum
CDPNQ_SUSC	Pseudacris maculata
CDPNQ_SUSC	Lithobates palustris
CDPNQ_SUSC	Oceanodroma leucorhoa
CDPNQ_SUSC	Carex macloviana
CDPNQ_SUSC	Cephaloziella rubella
CDPNQ_SUSC	Sphagnum perfoliatum
CDPNQ_SUSC	Eleocharis mamillata
CDPNQ_SUSC	Perimyotis subflavus
CDPNQ_SUSC	Calidris canutus
CDPNQ_SUSC	Marchantia polymorpha
CDPNQ_SUSC	Cephaloziella uncinata
CDPNQ_SUSC	Cypripedium reginae
CDPNQ_SUSC	Proserpinaca palustris
CDPNQ_SUSC	Sphagnum mirum
CDPNQ_SUSC	Contopus cooperi
CDPNQ_SUSC	Cistothorus platensis
CDPNQ_SUSC	Galium brevipes
CDPNQ_SUSC	Festuca baffinensis
CDPNQ_SUSC	Tyto alba
CDPNQ_SUSC	Asio flammeus
CDPNQ_SUSC	Chordeiles minor
CDPNQ_SUSC	Antrostomus vociferus
CDPNQ_SUSC	Chaetura pelagica
CDPNQ_SUSC	Vermivora chrysoptera
CDPNQ_VUL	Histrionicus histrionicus
CDPNQ_VUL	Percina copelandi
CDPNQ_VUL	Ursus maritimus
CDPNQ_VUL	Allium tricoccum
CDPNQ_VUL	Rangifer tarandus
CDPNQ_VUL	Pseudacris triseriata
CDPNQ_VUL	Ixobrychus exilis
CDPNQ_VUL	Bucephala islandica
CDPNQ_VUL	Haliaeetus leucocephalus
CDPNQ_VUL	Aquila chrysaetos
CDPNQ_VUL	Falco peregrinus
CDPNQ_VUL	Osmerus mordax
CDPNQ_VUL	Catharus bicknelli
CDPNQ_VUL	Notropis bifrenatus
CDPNQ_VUL	Alosa sapidissima
CDPNQ_VUL	Goodyera pubescens
CDPNQ_VUL	Graptemys geographica
CDPNQ_VUL	Helianthus divaricatus
CDPNQ_VUL	Valeriana uliginosa
CDPNQ_VUL	Glyptemys insculpta
CDPNQ_VUL	Gyrinophilus porphyriticus
CDPNQ_VUL	Acer nigrum
CDPNQ_VUL	Moxostoma carinatum
CDPNQ_VUL_HARVEST	Matteuccia struthiopteris
CDPNQ_VUL_HARVEST	Trillium grandiflorum
CDPNQ_VUL_HARVEST	Adiantum pedatum
CDPNQ_VUL_HARVEST	Asarum canadense
CDPNQ_VUL_HARVEST	Sanguinaria canadensis
CDPNQ_VUL_HARVEST	Uvularia grandiflora
CDPNQ_VUL_HARVEST	Cardamine diphylla
CDPNQ_VUL_HARVEST	Lilium canadense
CDPNQ_ENDANGERED	Monarda punctata
CDPNQ_ENDANGERED	Pinus rigida
CDPNQ_ENDANGERED	Desmognathus ochrophaeus
CDPNQ_ENDANGERED	Hydrophyllum canadense
CDPNQ_ENDANGERED	Charadrius melodus
CDPNQ_ENDANGERED	Emydoidea blandingii
CDPNQ_ENDANGERED	Cicuta maculata
CDPNQ_ENDANGERED	Melanerpes erythrocephalus
CDPNQ_ENDANGERED	Setophaga cerulea
CDPNQ_ENDANGERED	Podiceps auritus
CDPNQ_ENDANGERED	Sterna dougallii
CDPNQ_ENDANGERED	Ulmus thomasii
CDPNQ_ENDANGERED	Panax quinquefolius
CDPNQ_ENDANGERED	Ammocrypta pellucida
CDPNQ_ENDANGERED	Moxostoma hubbsi
CDPNQ_ENDANGERED	Lanius ludovicianus
CDPNQ_ENDANGERED	Ichthyomyzon fossor
CDPNQ_ENDANGERED	Carex glacialis
CDPNQ_ENDANGERED	Apalone spinifera
CDPNQ_ENDANGERED	Sternotherus odoratus
CDPNQ_ENDANGERED	Pterospora andromedea
CDPNQ_ENDANGERED	Coenonympha nipisiquit
CDPNQ_ENDANGERED	Dermochelys coriacea
CDPNQ_ENDANGERED	Coturnicops noveboracensis
CDPNQ_ENDANGERED	Hydroprogne caspia
INVASIVE_SPECIES	Galium mollugo
INVASIVE_SPECIES	Harmonia axyridis
INVASIVE_SPECIES	Anoplophora glabripennis
INVASIVE_SPECIES	Popillia japonica
INVASIVE_SPECIES	Bythotrephes longimanus
INVASIVE_SPECIES	Eriocheir sinensis
INVASIVE_SPECIES	Hemimysis anomala
INVASIVE_SPECIES	Orconectes rusticus
INVASIVE_SPECIES	Dreissena bugensis
INVASIVE_SPECIES	Dreissena polymorpha
INVASIVE_SPECIES	Potamopyrgus antipodarum
INVASIVE_SPECIES	Corbicula fluminea
INVASIVE_SPECIES	Echinogammarus ischnus
INVASIVE_SPECIES	Bellamya chinensis
INVASIVE_SPECIES	Cervus elaphus
INVASIVE_SPECIES	Cygnus olor
INVASIVE_SPECIES	Ctenopharyngodon idella
INVASIVE_SPECIES	Lepomis cyanellus
INVASIVE_SPECIES	Pseudorasbora parva
INVASIVE_SPECIES	Scardinius erythrophthalmus
INVASIVE_SPECIES	Neogobius melanostomus
INVASIVE_SPECIES	Carassius auratus
INVASIVE_SPECIES	Tinca tinca
INVASIVE_SPECIES	Trachemys scripta elegans
INVASIVE_SPECIES	Channa
INVASIVE_SPECIES	Parachanna
INVASIVE_SPECIES	Trapa natans
INVASIVE_SPECIES	Nymphoides peltata
INVASIVE_SPECIES	Hydrocharis morsus-ranae
INVASIVE_SPECIES	Eichhornia crassipes
INVASIVE_SPECIES	Pistia stratiotes
INVASIVE_SPECIES	Salvinia
INVASIVE_SPECIES	Cabomba caroliniana
INVASIVE_SPECIES	Brazilian waterweed
INVASIVE_SPECIES	Hydrilla verticillata
INVASIVE_SPECIES	Myriophyllum aquaticum
INVASIVE_SPECIES	Myriophyllum spicatum
INVASIVE_SPECIES	Potamogeton crispus
INVASIVE_SPECIES	Phalaris arundinacea
INVASIVE_SPECIES	Butomus umbellatus
INVASIVE_SPECIES	Glyceria maxima
INVASIVE_SPECIES	Iris pseudacorus
INVASIVE_SPECIES	Rorippa amphibia
INVASIVE_SPECIES	Phragmites australis australis
INVASIVE_SPECIES	Lythrum salicaria
INVASIVE_SPECIES	Stratiotes aloides
INVASIVE_SPECIES	Alliaria petiolata
INVASIVE_SPECIES	Anthriscus sylvestris
INVASIVE_SPECIES	Heracleum sphondylium
INVASIVE_SPECIES	Heracleum mantegazzianum
INVASIVE_SPECIES	Symphytum officinale
INVASIVE_SPECIES	Vincetoxicum rossicum
INVASIVE_SPECIES	Vincetoxicum nigrum
INVASIVE_SPECIES	Aegopodium podagraria
INVASIVE_SPECIES	Acer platanoides
INVASIVE_SPECIES	Acer negundo
INVASIVE_SPECIES	Impatiens glandulifera
INVASIVE_SPECIES	Miscanthus sacchariflorus
INVASIVE_SPECIES	Frangula alnus
INVASIVE_SPECIES	Rhamnus carthartica
INVASIVE_SPECIES	Ulmus pumila
INVASIVE_SPECIES	Pastinaca sativa
INVASIVE_SPECIES	Petasites japonicus
INVASIVE_SPECIES	Reynoutria xbohemica
INVASIVE_SPECIES	Reynoutria sachalinensis
INVASIVE_SPECIES	Reynoutria japonica
INVASIVE_SPECIES	Helianthus tuberosus
INVASIVE_SPECIES	Valeriana officinalis
CDPNQ_S1	Apalone spinifera
CDPNQ_S1	Noturus insignis
CDPNQ_S1	Podiceps auritus
CDPNQ_S1	Charadrius melodus
CDPNQ_S1	Hydroprogne caspia
CDPNQ_S1	Sterna dougallii
CDPNQ_S1	Melanerpes erythrocephalus
CDPNQ_S1	Lanius ludovicianus
CDPNQ_S1	Setophaga cerulea
CDPNQ_S1	Parkesia motacilla
CDPNQ_S1	Centronyx henslowii
CDPNQ_S1	Calidris canutus rufa
CDPNQ_S1	Sorex dispar
CDPNQ_S1	Lasiurus borealis
CDPNQ_S1	Careproctus reinhardti
CDPNQ_S1	Coregonus artedi
CDPNQ_S1	Moxostoma hubbsi
CDPNQ_S1	Melanogrammus aeglefinus
CDPNQ_S1	Pollachius virens
CDPNQ_S1	Scomber scombrus
CDPNQ_S1	Gymnelus viridis
CDPNQ_S1	Lycodes esmarkii
CDPNQ_S1	Anarhichas minor
CDPNQ_S1	Cryptacanthodes maculatus
CDPNQ_S1	Lophius americanus
CDPNQ_S1	Sorex gaspensis
CDPNQ_S1	Myotis lucifugus
CDPNQ_S1	Myotis leibii
CDPNQ_S1	Myotis septentrionalis
CDPNQ_S1	Perimyotis subflavus
CDPNQ_S1	Hemitripterus americanus
CDPNQ_S1	Delphinapterus leucas
CDPNQ_S1	Balaenoptera musculus
CDPNQ_S1	Eubalaena glacialis
CDPNQ_S1	Gulo gulo
CDPNQ_S1	Phoca vitulina mellonae
CDPNQ_S1	Rangifer tarandus
CDPNQ_S1	Myoxocephalus thompsonii
CDPNQ_S2	Calidris pusilla
CDPNQ_S2	Limanda ferruginea
CDPNQ_S2	Chaetura pelagica
CDPNQ_S2	Progne subis
CDPNQ_S2	Cistothorus platensis
CDPNQ_S2	Catharus bicknelli
CDPNQ_S2	Vermivora cyanoptera
CDPNQ_S2	Vermivora chrysoptera
CDPNQ_S2	Ammodramus savannarum
CDPNQ_S2	Anguilla rostrata
CDPNQ_S2	Hybognathus hankinsoni
CDPNQ_S2	Moxostoma carinatum
CDPNQ_S2	Rangifer tarandus
CDPNQ_S2	Sternotherus odoratus
CDPNQ_S2	Podiceps grisegena
CDPNQ_S2	Chlidonias niger
CDPNQ_S2	Coccyzus americanus
CDPNQ_S2	Emydoidea blandingii
CDPNQ_S2	Delphinapterus leucas
CDPNQ_S2	Desmognathus ochrophaeus
CDPNQ_S2	Pseudacris triseriata
CDPNQ_S2	Pseudacris maculata
CDPNQ_S2	Ichthyomyzon fossor
CDPNQ_S2	Artediellus uncinatus
CDPNQ_S2	Icelus spatula
CDPNQ_S2	Liparis gibbus
CDPNQ_S2	Cyclopterus lumpus
CDPNQ_S2	Esox americanus vermiculatus
CDPNQ_S2	Boreogadus saida
CDPNQ_S2	Gadus ogac
CDPNQ_S2	Ammocrypta pellucida
CDPNQ_S2	Phalaropus tricolor
CDPNQ_S2	Glaucomys volans
CDPNQ_S2	Microtus pinetorum
CDPNQ_S2	Mustela nivalis
CDPNQ_S2	Storeria dekayi
CDPNQ_S2	Thamnophis saurita
CDPNQ_S2	Hydrobates leucorhous
CDPNQ_S2	Ixobrychus exilis
CDPNQ_S3	Pipilo erythrophthalmus
CDPNQ_S3	Spizella pusilla
CDPNQ_S3	Ammospiza nelsoni
CDPNQ_S3	Dolichonyx oryzivorus
CDPNQ_S3	Sturnella magna
CDPNQ_S3	Icterus spurius
CDPNQ_S3	Branta hutchinsii
CDPNQ_S3	Anser albifrons
CDPNQ_S3	Anser rossii
CDPNQ_S3	Branta bernicla
CDPNQ_S3	Mareca penelope
CDPNQ_S3	Aythya valisineria
CDPNQ_S3	Numenius phaeopus
CDPNQ_S3	Limosa haemastica
CDPNQ_S3	Arenaria interpres
CDPNQ_S3	Calidris bairdii
CDPNQ_S3	Calidris maritima
CDPNQ_S3	Calidris himantopus
CDPNQ_S3	Calidris subruficollis
CDPNQ_S3	Limnodromus scolopaceus
CDPNQ_S3	Hydrocoloeus minutus
CDPNQ_S3	Xema sabini
CDPNQ_S3	Pelecanus erythrorhynchos
CDPNQ_S3	Ursus maritimus
CDPNQ_S3	Phalacrocorax carbo
CDPNQ_S3	Somateria mollissima
CDPNQ_S3	Larus glaucoides
CDPNQ_S3	Megascops asio
CDPNQ_S3	Thryothorus ludovicianus
CDPNQ_S3	Ichthyomyzon unicuspis
CDPNQ_S3	Acipenser fulvescens
CDPNQ_S3	Acipenser oxyrinchus
CDPNQ_S3	Hiodon alosoides
CDPNQ_S3	Exoglossum maxillingua
CDPNQ_S3	Notropis rubellus
CDPNQ_S3	Carpiodes cyprinus
CDPNQ_S3	Microgadus tomcod
CDPNQ_S3	Brosme brosme
CDPNQ_S3	Didelphis virginiana
CDPNQ_S3	Dorosoma cepedianum
CDPNQ_S3	Butorides virescens
CDPNQ_S3	Nycticorax nycticorax
CDPNQ_S3	Spatula discors
CDPNQ_S3	Melanitta deglandi
CDPNQ_S3	Circus hudsonius
CDPNQ_S3	Buteo lagopus
CDPNQ_S3	Charadrius semipalmatus
CDPNQ_S3	Charadrius vociferus
CDPNQ_S3	Limnodromus griseus
CDPNQ_S3	Phalaropus lobatus
CDPNQ_S3	Chordeiles minor
CDPNQ_S3	Contopus cooperi
CDPNQ_S3	Eremophila alpestris
CDPNQ_S3	Petrochelidon pyrrhonota
CDPNQ_S3	Oporornis agilis
CDPNQ_S3	Pooecetes gramineus
CDPNQ_S3	Euphagus carolinus
CDPNQ_S3	Calidris melanotos
CDPNQ_S3	Calidris mauri
CDPNQ_S3	Gyrinophilus porphyriticus
CDPNQ_S3	Hemidactylium scutatum
CDPNQ_S3	Bucephala islandica
CDPNQ_S3	Melanerpes carolinus
CDPNQ_S3	Mola mola
CDPNQ_S3	Myoxocephalus scorpius
CDPNQ_S3	Gymnocanthus tricuspis
CDPNQ_S3	Leptagonus decagonus
CDPNQ_S3	Eumicrotremus spinosus
CDPNQ_S3	Alosa sapidissima
CDPNQ_S3	Esox americanus americanus
CDPNQ_S3	Esox niger
CDPNQ_S3	Notropis bifrenatus
CDPNQ_S3	Moxostoma valenciennesi
CDPNQ_S3	Noturus flavus
CDPNQ_S3	Ameiurus natalis
CDPNQ_S3	Phycis chesteri
CDPNQ_S3	Morone chrysops
CDPNQ_S3	Lepomis peltastes
CDPNQ_S3	Percina copelandi
CDPNQ_S3	Pholis gunnellus
CDPNQ_S3	Lycodes lavalaei
CDPNQ_S3	Lycodes vahlii
CDPNQ_S3	Eumesogrammus praecisus
CDPNQ_S3	Lumpenus lampretaeformis
CDPNQ_S3	Scophthalmus aquosus
CDPNQ_S3	Hippoglossus hippoglossus
CDPNQ_S3	Pleuronectes putnami
CDPNQ_S3	Pseudopleuronectes americanus
CDPNQ_S3	Centroscyllium fabricii
CDPNQ_S3	Lasionycteris noctivagans
CDPNQ_S3	Eptesicus fuscus
CDPNQ_S3	Lasiurus cinereus
CDPNQ_S3	Tamias minimus
CDPNQ_S3	Lagenorhynchus albirostris
CDPNQ_S3	Orcinus orca
CDPNQ_S3	Balaenoptera physalus
CDPNQ_S3	Megaptera novaeangliae
CDPNQ_S3	Rangifer tarandus
CDPNQ_S3	Glyptemys insculpta
CDPNQ_S3	Graptemys geographica
CDPNQ_S3	Lampropeltis triangulum
CDPNQ_S3	Nerodia sipedon
CDPNQ_S3	Osmerus mordax
CDPNQ_S3	Salvelinus alpinus oquassa
CDPNQ_S3	Gadus morhua
CDPNQ_S3	Ichthyomyzon castaneus
CDPNQ_S3	Gavia pacifica
CDPNQ_S3	Ardea alba
CDPNQ_S3	Cygnus buccinator
CDPNQ_S3	Somateria spectabilis
CDPNQ_S3	Histrionicus histrionicus
CDPNQ_S3	Oxyura jamaicensis
CDPNQ_S3	Aquila chrysaetos
CDPNQ_S3	Falco sparverius
CDPNQ_S3	Coturnicops noveboracensis
CDPNQ_S3	Pluvialis dominica
CDPNQ_S3	Tringa flavipes
CDPNQ_S3	Tringa semipalmata
CDPNQ_S3	Bartramia longicauda
CDPNQ_S3	Limosa fedoa
CDPNQ_S3	Calidris alpina
CDPNQ_S3	Stercorarius pomarinus
CDPNQ_S3	Stercorarius parasiticus
CDPNQ_S3	Stercorarius longicaudus
CDPNQ_S3	Chroicocephalus ridibundus
CDPNQ_S3	Fratercula arctica
CDPNQ_S3	Asio flammeus
CDPNQ_S3	Antrostomus vociferus
CDPNQ_S3	Contopus virens
CDPNQ_S3	Stelgidopteryx serripennis
CDPNQ_S3	Riparia riparia
CDPNQ_S3	Hirundo rustica
CDPNQ_S3	Polioptila caerulea
CDPNQ_S3	Hylocichla mustelina
CDPNQ_S3	Vireo flavifrons
SENSITIVE	Desmognathus ochrophaeus
SENSITIVE	Melanoplus gaspesiensis
SENSITIVE	Oeneis bore gaspeensis
SENSITIVE	Coenonympha nipisiquit
SENSITIVE	Lasionycteris noctivagans
SENSITIVE	Lasiurus cinereus
SENSITIVE	Myotis septentrionalis
SENSITIVE	Myotis leibii
SENSITIVE	Lasiurus borealis
SENSITIVE	Myotis lucifugus
SENSITIVE	Perimyotis subflavus
SENSITIVE	Margaritifera margaritifera
SENSITIVE	Aquila chrysaetos
SENSITIVE	Centronyx henslowii
SENSITIVE	Falco peregrinus
SENSITIVE	Melanerpes erythrocephalus
SENSITIVE	Lanius ludovicianus
SENSITIVE	Allium tricoccum
SENSITIVE	Aplectrum hyemale
SENSITIVE	Calypso bulbosa
SENSITIVE	Cirsium scariosum
SENSITIVE	Cypripedium passerinum
SENSITIVE	Cypripedium reginae
SENSITIVE	Cypripedium arietinum
SENSITIVE	Acer nigrum
SENSITIVE	Gentianopsis virgata macounii
SENSITIVE	Gentianopsis crinita
SENSITIVE	Geranium maculatum
SENSITIVE	Panax quinquefolius
SENSITIVE	Goodyera pubescens
SENSITIVE	Houstonia longifolia
SENSITIVE	Hydrophyllum canadense
SENSITIVE	Lobelia spicata
SENSITIVE	Monarda punctata
SENSITIVE	Galearis spectabilis
SENSITIVE	Ulmus thomasii
SENSITIVE	Phegopteris hexagonoptera
SENSITIVE	Platanus occidentalis
SENSITIVE	Platanthera macrophylla
SENSITIVE	Pterospora andromedea
SENSITIVE	Verbena simplex
SENSITIVE	Woodsia obtusa obtusa
SENSITIVE	Acipenser oxyrinchus
SENSITIVE	Acipenser fulvescens
SENSITIVE	Diadophis punctatus
SENSITIVE	Storeria dekayi
SENSITIVE	Nerodia sipedon
SENSITIVE	Opheodrys vernalis
SENSITIVE	Thamnophis saurita
SENSITIVE	Lampropeltis triangulum
SENSITIVE	Glyptemys insculpta
SENSITIVE	Graptemys geographica
SENSITIVE	Emydoidea blandingii
SENSITIVE	Sternotherus odoratus
SENSITIVE	Clemmys guttata
SENSITIVE	Apalone spinifera
\.

--
-- Name: taxa_group_members_id_group_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

CREATE INDEX IF NOT EXISTS id_taxa_obs_idx
  ON public.taxa_obs_ref_lookup (id_taxa_obs);

ALTER TABLE taxa_group_members add unique (id_group, scientific_name);


--
-- PostgreSQL database dump complete
--

--
-- CREATE TAXA LOOKUP
--

DROP MATERIALIZED VIEW IF EXISTS public.taxa_obs_group_lookup CASCADE;
CREATE MATERIALIZED VIEW public.taxa_obs_group_lookup AS (
    WITH level_1_2_lookup AS (
        select distinct
            short, obs_lookup.id_taxa_obs, taxa_groups.id id_group
        from public.taxa_group_members group_m
        join taxa_groups using (short)
        left join public.taxa_ref
            on group_m.scientific_name = taxa_ref.scientific_name
        left join public.taxa_obs_ref_lookup obs_lookup
            on taxa_ref.id = obs_lookup.id_taxa_ref
        where taxa_groups.level = ANY(ARRAY[1, 2])
    )
    select
        id_taxa_obs, id_group
    from level_1_2_lookup
    UNION
    SELECT distinct on (id_taxa_obs)
        id_taxa_obs, taxa_groups.id id_group
    FROM observations_partitions.within_quebec, taxa_groups
    WHERE level = 0
    UNION
    SELECT id_taxa_obs, level_3_groups.id id_group
    FROM taxa_groups as level_3_groups, level_1_2_lookup
    WHERE level_3_groups.level = 3
        AND level_1_2_lookup.short = ANY(level_3_groups.groups_within)
);


CREATE INDEX IF NOT EXISTS taxa_obs_group_lookup_id_taxa_obs_idx
  ON public.taxa_obs_group_lookup (id_taxa_obs);

CREATE INDEX IF NOT EXISTS taxa_obs_group_lookup_id_group_idx
    ON public.taxa_obs_group_lookup (id_group);