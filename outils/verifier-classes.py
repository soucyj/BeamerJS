#!/usr/bin/env python3
"""Vérifie que gabaritFR/BeamerJS.cls et templateEN/BeamerJS.cls ont le même code.

Les commentaires sont ignorés. Seules deux différences sont permises : la
langue par défaut (\\JS@anglaisfalse / \\JS@anglaistrue) et la description
dans \\ProvidesClass.

Usage : python3 outils/verifier-classes.py   (depuis la racine du dépôt)
"""
import difflib
import re
import sys
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent
FR = RACINE / "gabaritFR" / "BeamerJS.cls"
EN = RACINE / "templateEN" / "BeamerJS.cls"

# Lignes qui ont le droit de différer, normalisées des deux côtés
PERMISES = [
    (re.compile(r"\\JS@anglais(false|true)$"), r"\\JS@anglais<défaut>"),
    (re.compile(r"(\\ProvidesClass\{BeamerJS\}\[[^ ]+ v[0-9.]+) .*\]$"), r"\1 <description>]"),
]


def code(chemin):
    lignes = []
    for ligne in chemin.read_text(encoding="utf-8").splitlines():
        # Retire le commentaire (un % non précédé d'une barre oblique inverse)
        ligne = re.sub(r"(?<!\\)%.*", "", ligne).rstrip()
        if not ligne.strip():
            continue
        for motif, remplacement in PERMISES:
            ligne = motif.sub(remplacement, ligne)
        lignes.append(ligne)
    return lignes


def main():
    fr, en = code(FR), code(EN)
    if fr == en:
        print("OK : les deux classes ont le même code.")
        return 0
    print("Les deux classes diffèrent :\n")
    sys.stdout.writelines(
        l + "\n" for l in difflib.unified_diff(
            fr, en, "gabaritFR/BeamerJS.cls", "templateEN/BeamerJS.cls", lineterm=""))
    return 1


if __name__ == "__main__":
    sys.exit(main())
