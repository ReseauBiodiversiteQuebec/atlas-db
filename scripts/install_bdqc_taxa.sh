cd /usr/lib/python3.7
git clone https://github.com/ReseauBiodiversiteQuebec/bdqc_taxa.git
cd ./bdqc_taxa
python3.7 bdqc_taxa/setup.py install
chmod -R 755 ./bdqc_taxa