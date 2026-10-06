#!/bin/sh
# Produit gabaritFR.zip et templateEN.zip, prêts à importer dans Overleaf
# (New Project → Upload Project). Les fichiers auxiliaires de compilation
# sont exclus ; les PDF le sont aussi, Overleaf les recompile.
#
# Usage : sh outils/archives-overleaf.sh   (depuis la racine du dépôt)
set -e
cd "$(dirname "$0")/.."
mkdir -p dist
for dossier in gabaritFR templateEN; do
	rm -f "dist/$dossier.zip"
	(cd "$dossier" && git ls-files . | zip -q "../dist/$dossier.zip" -@ \
		-x 'demonstration.pdf' 'exemple-minimal.pdf' 'demo.pdf' 'minimal-example.pdf' \
		   'images/apercu.png' 'images/preview.png')
	echo "dist/$dossier.zip"
done
