# BeamerJS

**Gabarit beamer pour les présentations mathématiques · A beamer template for mathematics talks**

![Aperçu · Preview](templateEN/images/preview.png)

| | Français | English |
|---|---|---|
| Dossier · Folder | [`gabaritFR/`](gabaritFR/) | [`templateEN/`](templateEN/) |
| Documentation | [README](gabaritFR/README.md) | [README](templateEN/README.md) |
| Démonstration · Demo | [demonstration.pdf](gabaritFR/demonstration.pdf) | [demo.pdf](templateEN/demo.pdf) |
| Exemple minimal · Minimal example | [exemple-minimal.tex](gabaritFR/exemple-minimal.tex) | [minimal-example.tex](templateEN/minimal-example.tex) |

## Français

BeamerJS est une classe LaTeX pour les exposés de mathématiques. Elle offre
un format 16:9, quatre palettes, cinq jeux de polices, des boîtes pour les
définitions, les théorèmes et les démonstrations, une barre de progression et
des nuages de points aléatoires en TikZ.

Chaque dossier est complet et autonome. Pour l'utiliser, copiez le dossier de
votre langue, ou importez-le dans Overleaf (compilateur : XeLaTeX). Les deux
classes ont exactement le même code : seuls les commentaires et la langue par
défaut changent, et l'option `fr` ou `en` permet de passer de l'une à l'autre.

## English

BeamerJS is a LaTeX class for mathematics talks. It provides a 16:9 format,
four palettes, five font sets, boxes for definitions, theorems and proofs, a
progress bar, and random point clouds drawn with TikZ.

Each folder is complete and self-contained. To use it, copy the folder in your
language, or upload it to Overleaf (compiler: XeLaTeX). Both classes share
exactly the same code: only the comments and the default language differ, and
the `fr` or `en` option switches from one to the other.

## Pour les mainteneurs · For maintainers

- `outils/verifier-classes.py` vérifie que les deux `BeamerJS.cls` ont le même
  code · checks that both `BeamerJS.cls` files share the same code.
- `outils/archives-overleaf.sh` produit `gabaritFR.zip` et `templateEN.zip`,
  prêts à importer dans Overleaf · builds zip files ready to upload to Overleaf.
- Le workflow GitHub Actions compile les quatre documents à chaque envoi ·
  the GitHub Actions workflow compiles the four documents on every push.

## Licence · License

© 2022–2026 Jérôme Soucy. `BeamerJS.cls` est distribuée sous la
[LaTeX Project Public License](https://www.latex-project.org/lppl/) 1.3c ou
ultérieure · is released under the LPPL 1.3c or later. Les fichiers d'exemple
sont libres de toute condition · The example files carry no conditions.
