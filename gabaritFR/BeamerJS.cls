% !TeX encoding = UTF-8
% !TeX program = xelatex
% !TeX spellcheck = fr_CA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  BeamerJS — classe de présentation pour les mathématiques
%  Jérôme Soucy (jsoucy@mat.ulaval.ca)
%  Première version  : 22 décembre 2022
%  Version actuelle  : v2.1 — octobre 2026
%
%  Copyright 2022-2026 Jérôme Soucy
%
%  This work may be distributed and/or modified under the
%  conditions of the LaTeX Project Public License, either version 1.3c
%  of this license or (at your option) any later version.
%  The latest version of this license is in
%    https://www.latex-project.org/lppl.txt
%  and version 1.3c or later is part of all distributions of LaTeX
%  version 2008 or later.
%
%  This work has the LPPL maintenance status `maintained'.
%  The Current Maintainer of this work is Jérôme Soucy.
%  This work consists of the file BeamerJS.cls.
%
%  En bref : vous pouvez utiliser, copier et redistribuer cette classe
%  librement. Une version modifiée doit porter un autre nom de fichier (ou
%  être clairement identifiée comme modifiée) ; voir le fichier LICENSE.
%
%  Compilation : XeLaTeX (recommandé) ou LuaLaTeX, puis biber.
%                pdfLaTeX fonctionne aussi, avec Latin Modern partout.
%
%  Sommaire
%    1. Options de classe            9. Page de section, plan
%    2. Moteur, langue et polices   10. Blocs beamer standard
%    3. Extensions                  11. Boîtes à filet latéral
%    4. Palettes                    12. Commandes de mise en forme
%    5. Réglages beamer généraux    13. Nuages de points (processus ponctuels)
%    6. Titre de diapositive        14. Bibliographie
%    7. Pied de page, progression   15. Compatibilité unicode-math
%    8. Page titre                  16. Noms anglais (alias)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}[2023/06/01]
\ProvidesClass{BeamerJS}[2026/10/06 v2.1 Classe beamer de Jerome Soucy]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Options de classe
%    Langue   : fr (défaut de ce gabarit) | en
%    Palette  : nuit (défaut) | terre | ardoise | laval
%               (alias anglais : night | earth | slate)
%    Police   : charter (défaut) | baskerville | newcm | source | libertinus
%    Mise en page :
%      pied             affiche le pied de page (titre court, section, numéro)
%      sansprogres      retire la barre de progression
%      sanssectionpage  retire la diapo automatique en début de section
%    Toute autre option est transmise à beamer (p. ex. handout).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Les noms « fr » et « en » sont volontairement courts : « french » ou
% « english » seraient aussi lus par babel comme options globales.
\newif\ifJS@anglais   \JS@anglaisfalse
\DeclareOption{fr}{\JS@anglaisfalse}
\DeclareOption{en}{\JS@anglaistrue}

\def\JS@palette{nuit}
\DeclareOption{nuit}{\def\JS@palette{nuit}}
\DeclareOption{terre}{\def\JS@palette{terre}}
\DeclareOption{ardoise}{\def\JS@palette{ardoise}}
\DeclareOption{laval}{\def\JS@palette{laval}}
\DeclareOption{night}{\def\JS@palette{nuit}}
\DeclareOption{earth}{\def\JS@palette{terre}}
\DeclareOption{slate}{\def\JS@palette{ardoise}}

\def\JS@police{charter}
\DeclareOption{charter}{\def\JS@police{charter}}
\DeclareOption{baskerville}{\def\JS@police{baskerville}}
\DeclareOption{newcm}{\def\JS@police{newcm}}
\DeclareOption{source}{\def\JS@police{source}}
\DeclareOption{libertinus}{\def\JS@police{libertinus}}

\newif\ifJS@pied      \JS@piedfalse
\newif\ifJS@progres   \JS@progrestrue
\newif\ifJS@sectionpage \JS@sectionpagetrue
\newif\ifJS@annexe   \JS@annexefalse

\DeclareOption{pied}{\JS@piedtrue}
\DeclareOption{sansprogres}{\JS@progresfalse}
\DeclareOption{sanssectionpage}{\JS@sectionpagefalse}
\DeclareOption{footer}{\JS@piedtrue}
\DeclareOption{noprogress}{\JS@progresfalse}
\DeclareOption{nosectionpage}{\JS@sectionpagefalse}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax

\LoadClass[aspectratio=169,xcolor=table,12pt]{beamer}

% Textes produits par la classe, selon la langue choisie
\ifJS@anglais
	\def\JS@str@defn{Definition}
	\def\JS@str@thm{Theorem}
	\def\JS@str@prop{Proposition}
	\def\JS@str@lemme{Lemma}
	\def\JS@str@coro{Corollary}
	\def\JS@str@ex{Example}
	\def\JS@str@rem{Remark}
	\def\JS@str@preuve{Proof}
	\def\JS@str@suite{(continued)}
	\def\JS@str@annexe{appendix}
	\def\JS@str@plan{Outline}
\else
	\def\JS@str@defn{Définition}
	\def\JS@str@thm{Théorème}
	\def\JS@str@prop{Proposition}
	\def\JS@str@lemme{Lemme}
	\def\JS@str@coro{Corollaire}
	\def\JS@str@ex{Exemple}
	\def\JS@str@rem{Remarque}
	\def\JS@str@preuve{Démonstration}
	\def\JS@str@suite{(suite)}
	\def\JS@str@annexe{annexe}
	\def\JS@str@plan{Plan}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Moteur, langue et polices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{iftex}
\newif\ifJS@unicode
\ifXeTeX\JS@unicodetrue\fi
\ifLuaTeX\JS@unicodetrue\fi

% Jeux de polices de texte. Les mathématiques restent en Latin Modern Math :
% chaque jeu est donc choisi pour s'accorder à sa couleur — axe vertical,
% contraste marqué — tout en gardant une sans serif contemporaine pour la
% structure (titres, pied de page, étiquettes des boîtes).
%
%   charter     XCharter + Inter        robuste au projecteur     (défaut)
%   baskerville Baskervaldx + Inter     le plus proche des maths
%   newcm       New Computer Modern     accord parfait, plus classique
%   source      Source Serif + Sans     le plus contemporain
%   libertinus  Libertinus              sobre et compact
%
% Les polices sont appelées par leur nom de fichier : elles viennent de
% l'arborescence TeX Live (et donc d'Overleaf), rien à installer.
\@namedef{JS@fnt@charter}{%
	\setmainfont{XCharter}[Extension=.otf,
		UprightFont=*-Roman, ItalicFont=*-Italic,
		BoldFont=*-Bold, BoldItalicFont=*-BoldItalic]%
	\setsansfont{Inter}[Extension=.otf,
		UprightFont=*-Regular, ItalicFont=*-Italic,
		BoldFont=*-SemiBold, BoldItalicFont=*-SemiBoldItalic,
		Scale=MatchUppercase]%
	\setmonofont{SourceCodePro}[Extension=.otf,
		UprightFont=*-Regular, ItalicFont=*-RegularIt,
		BoldFont=*-Semibold, BoldItalicFont=*-SemiboldIt,
		Scale=MatchLowercase]}
\@namedef{JS@fnt@baskerville}{%
	\setmainfont{Baskervaldx}[Extension=.otf,
		UprightFont=*-Reg, ItalicFont=*-Ita,
		BoldFont=*-Bol, BoldItalicFont=*-BolIta]%
	\setsansfont{Inter}[Extension=.otf,
		UprightFont=*-Regular, ItalicFont=*-Italic,
		BoldFont=*-SemiBold, BoldItalicFont=*-SemiBoldItalic,
		Scale=MatchUppercase]%
	\setmonofont{SourceCodePro}[Extension=.otf,
		UprightFont=*-Regular, ItalicFont=*-RegularIt,
		BoldFont=*-Semibold, BoldItalicFont=*-SemiboldIt,
		Scale=MatchLowercase]}
\@namedef{JS@fnt@newcm}{%
	\setmainfont{NewCM10}[Extension=.otf,
		UprightFont=*-Book, ItalicFont=*-BookItalic,
		BoldFont=*-Bold, BoldItalicFont=*-BoldItalic]%
	\setsansfont{Inter}[Extension=.otf,
		UprightFont=*-Regular, ItalicFont=*-Italic,
		BoldFont=*-SemiBold, BoldItalicFont=*-SemiBoldItalic,
		Scale=MatchUppercase]%
	\setmonofont{NewCMMono10}[Extension=.otf,
		UprightFont=*-Book, ItalicFont=*-BookItalic,
		BoldFont=*-Bold, BoldItalicFont=*-BoldOblique]}
\@namedef{JS@fnt@source}{%
	\setmainfont{SourceSerif4}[Extension=.otf,
		UprightFont=*-Light, ItalicFont=*-LightIt,
		BoldFont=*-Semibold, BoldItalicFont=*-SemiboldIt]%
	\setsansfont{SourceSans3}[Extension=.otf,
		UprightFont=*-Regular, ItalicFont=*-RegularIt,
		BoldFont=*-Semibold, BoldItalicFont=*-SemiboldIt,
		Scale=MatchUppercase]%
	\setmonofont{SourceCodePro}[Extension=.otf,
		UprightFont=*-Regular, ItalicFont=*-RegularIt,
		BoldFont=*-Semibold, BoldItalicFont=*-SemiboldIt,
		Scale=MatchLowercase]}
\@namedef{JS@fnt@libertinus}{%
	\setmainfont{LibertinusSerif}[Extension=.otf,
		UprightFont=*-Regular, ItalicFont=*-Italic,
		BoldFont=*-Bold, BoldItalicFont=*-BoldItalic]%
	\setsansfont{LibertinusSans}[Extension=.otf,
		UprightFont=*-Regular, ItalicFont=*-Italic,
		BoldFont=*-Bold, Scale=MatchUppercase]%
	\setmonofont{LibertinusMono-Regular.otf}[Scale=MatchLowercase,
		AutoFakeBold=1.6, AutoFakeSlant=0.2]}

\ifJS@unicode
	\RequirePackage{fontspec}
		\@nameuse{JS@fnt@\JS@police}
	\RequirePackage{polyglossia}
		\ifJS@anglais
			\setdefaultlanguage[variant=american]{english}
			\setotherlanguage[frenchpart=false]{french}
		\else
			\setdefaultlanguage[frenchpart=false]{french}
			\setotherlanguage{english}
		\fi
	\RequirePackage{mathtools}
	\RequirePackage[bold-style=ISO,
					partial=upright,
					warnings-off={mathtools-colon,mathtools-overbracket}]{unicode-math}
		\setmathfont{latinmodern-math.otf}
		% Le \setminus de Latin Modern Math est trop court : on l'emprunte.
		\setmathfont[range=\setminus]{STIXTwoMath-Regular.otf}
\else
	\ifJS@anglais
		\RequirePackage[french,english]{babel}
	\else
		\RequirePackage[english,french]{babel}
	\fi
	\RequirePackage[T1]{fontenc}
	\RequirePackage[utf8]{inputenc}
	\RequirePackage{lmodern}
	\RequirePackage{amsmath,amssymb,mathtools,stmaryrd}
\fi

% Le corps de texte passe en serif : beamer met tout en sans par défaut, ce
% qui désaccorde le texte courant des formules en Latin Modern Math. La sans
% serif est réservée à la structure, où elle est déclarée explicitement.
\renewcommand{\familydefault}{\rmdefault}

\RequirePackage{microtype}

% biblatex glisse un espace de largeur nulle entre les parties d'un nom, que
% toutes les polices ne couvrent pas. On le remplace par un vrai zéro plutôt
% que de laisser XeTeX signaler un caractère manquant à chaque référence.
\ifJS@unicode
	\RequirePackage{newunicodechar}
	\newunicodechar{^^^^200b}{\hskip0pt\relax}
\fi

% unicode-math ne fournit pas les noms hérités de stmaryrd : on les rétablit
% pour que \llbracket et \rrbracket fonctionnent avec tous les moteurs.
\ifJS@unicode
	\providecommand{\llbracket}{\lBrack}
	\providecommand{\rrbracket}{\rBrack}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Extensions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{graphicx}
\RequirePackage{booktabs}
\RequirePackage{array}
\RequirePackage{varwidth}
\RequirePackage{xstring}
\RequirePackage{csquotes}
\RequirePackage[many]{tcolorbox}
\RequirePackage{fontawesome5}
\ifJS@anglais
	\RequirePackage[per-mode=symbol,locale=US]{siunitx}
\else
	\RequirePackage[per-mode=symbol,locale=FR]{siunitx}
\fi
\RequirePackage{tikz}
	\usetikzlibrary{calc,positioning,arrows.meta,shapes.geometric,
					decorations.pathreplacing,backgrounds,fit,patterns}
\RequirePackage{pgfplots}
	\pgfplotsset{compat=1.18}
\RequirePackage{url}
	\renewcommand{\UrlFont}{\scriptsize\ttfamily}
\RequirePackage{hyperref}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Palettes
%    Dominante  : titres, structure
%    Secondaire : appuis discrets
%    Accent     : mise en évidence, liens
%    Fond       : fond de diapo
%    Les noms anglais Primary, Secondary, Accent et Background désignent les
%    mêmes couleurs (section 16).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\@namedef{JS@pal@nuit}{%
	\definecolor{Dominante}{HTML}{22364F}%   bleu de nuit
	\definecolor{Secondaire}{HTML}{5A7184}%  ardoise
	\definecolor{Accent}{HTML}{B5651D}%      cuivre
	\definecolor{Fond}{HTML}{FCFCFA}}
\@namedef{JS@pal@terre}{%
	\definecolor{Dominante}{RGB}{96,52,34}%
	\definecolor{Secondaire}{RGB}{140,110,95}%
	\definecolor{Accent}{RGB}{239,131,84}%
	\definecolor{Fond}{RGB}{252,252,252}}
\@namedef{JS@pal@ardoise}{%
	\definecolor{Dominante}{HTML}{2F3E46}%
	\definecolor{Secondaire}{HTML}{52796F}%
	\definecolor{Accent}{HTML}{9C6644}%
	\definecolor{Fond}{HTML}{FBFBF9}}
\@namedef{JS@pal@laval}{%
	\definecolor{Dominante}{RGB}{237,28,36}%
	\definecolor{Secondaire}{HTML}{6B6B6B}%
	\definecolor{Accent}{RGB}{251,199,7}%
	\definecolor{Fond}{RGB}{252,252,252}}

% Noms anglais des palettes, pour \apercupalette
\expandafter\let\csname JS@pal@night\expandafter\endcsname\csname JS@pal@nuit\endcsname
\expandafter\let\csname JS@pal@earth\expandafter\endcsname\csname JS@pal@terre\endcsname
\expandafter\let\csname JS@pal@slate\expandafter\endcsname\csname JS@pal@ardoise\endcsname

\@nameuse{JS@pal@\JS@palette}

% Couleurs de la palette laval, toujours disponibles
\definecolor{rougelaval}{RGB}{237,28,36}
\definecolor{jaunelaval}{RGB}{251,199,7}

% Couleurs de service
\definecolor{VertPreuve}{HTML}{2E6B4F}
\definecolor{RougeNotation}{HTML}{8B2635}
\definecolor{GrisExemple}{HTML}{4A4A4A}
\colorlet{DominanteBG}{Dominante!7}
\colorlet{AccentBG}{Accent!10}
\colorlet{PreuveBG}{VertPreuve!6}
\colorlet{ExempleBG}{black!4}
\colorlet{NotationBG}{RougeNotation!6}
\definecolor{LumiereBG}{RGB}{250,248,235}

% Aperçu d'une palette, quelle que soit celle du document (nom français ou
% anglais) :
%   \apercupalette{terre}
% Les \definecolor restent locaux au groupe : la palette du document n'est
% pas touchée.
\newcommand{\apercupalette}[1]{%
	\begingroup
		\@nameuse{JS@pal@#1}%
		\begin{tikzpicture}[baseline=(n.base)]
			\foreach \JS@c [count=\JS@k] in {Dominante,Secondaire,Accent}
				\fill[\JS@c] ({0.62*(\JS@k-1)},0) rectangle ++(0.52,0.52);
			\draw[black!25, fill=Fond] (1.86,0) rectangle ++(0.52,0.52);
			\node[anchor=west, font=\sffamily\small, text=Dominante]
				(n) at (2.6,0.26) {#1};
		\end{tikzpicture}%
	\endgroup}

\hypersetup{
	pdfencoding=auto,
	breaklinks=true,
	colorlinks=true,
	linkcolor=.,
	filecolor=Accent,
	urlcolor=Accent,
	anchorcolor=.,
	citecolor=Accent}

% Réglages pgfplots par défaut : les graphiques reprennent la palette et les
% tailles de la présentation, sans avoir à les redire dans chaque figure.
\pgfplotsset{
	every axis/.append style={
		axis lines=left,
		axis line style={black!45},
		tick style={black!45},
		ymajorgrids, grid style={black!12},
		label style={font=\small},
		tick label style={font=\small},
		legend style={draw=none, fill=none, font=\small},
		legend cell align=left,
		scaled ticks=false,
		width=0.8\linewidth, height=5.2cm,
	},
	cycle list={%
		{Dominante, mark=*, mark size=1.6pt, thick, mark options={fill=Dominante}},
		{Accent, mark=square*, mark size=1.5pt, thick, mark options={fill=Accent}},
		{VertPreuve, mark=triangle*, mark size=1.9pt, thick, mark options={fill=VertPreuve}},
		{Secondaire, mark=diamond*, mark size=1.9pt, thick, mark options={fill=Secondaire}},
	},
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5. Réglages beamer généraux
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\usefonttheme{professionalfonts}
\setbeamersize{sidebar width left=0pt,
			   text margin left=0.9cm, text margin right=0.9cm}
\setbeamertemplate{navigation symbols}{}

% Structure en sans serif, texte courant en serif : la hiérarchie se lit
% d'un coup d'oeil et les formules restent dans la famille du texte.
\setbeamerfont{title}{family=\sffamily, size=\LARGE, series=\bfseries}
\setbeamerfont{subtitle}{family=\sffamily, size=\large, series=\mdseries}
\setbeamerfont{author}{family=\sffamily, size=\normalsize}
\setbeamerfont{institute}{family=\sffamily, size=\small}
\setbeamerfont{date}{family=\sffamily, size=\small}
\setbeamerfont{frametitle}{family=\sffamily, size=\large, series=\bfseries}
\setbeamerfont{framesubtitle}{family=\sffamily, size=\small, series=\mdseries}
\setbeamerfont{section title}{family=\sffamily, size=\LARGE, series=\bfseries}
\setbeamerfont{section in toc}{family=\sffamily, size=\normalsize}
\setbeamerfont{subsection in toc}{family=\sffamily, size=\small}
\setbeamerfont{footline}{family=\sffamily, size=\scriptsize}
\setbeamerfont{caption}{size=\small}
\setbeamerfont{caption name}{family=\sffamily, series=\bfseries}
\setbeamerfont{block title}{family=\sffamily, size=\normalsize, series=\bfseries}

\setbeamercolor{background canvas}{bg=Fond}
\setbeamercolor{normal text}{bg=Fond, fg=black!88}
\setbeamercolor{structure}{fg=Dominante}
\setbeamercolor{alerted text}{fg=Accent}
\setbeamercolor{example text}{fg=VertPreuve}
\setbeamercolor{title}{fg=Dominante}
\setbeamercolor{subtitle}{fg=Secondaire}
\setbeamercolor{frametitle}{fg=Dominante, bg=}
\setbeamercolor{framesubtitle}{fg=Secondaire, bg=}
\setbeamercolor{section title}{fg=Dominante}
\setbeamercolor{section in toc}{fg=black!85}
\setbeamercolor{footline}{fg=Secondaire, bg=}
\setbeamercolor{caption name}{fg=Dominante}

\setbeamercolor{itemize item}{fg=Dominante}
\setbeamercolor{itemize subitem}{fg=Secondaire}
\setbeamercolor{itemize subsubitem}{fg=Secondaire}
\setbeamercolor{enumerate item}{fg=Dominante}
\setbeamercolor{enumerate subitem}{fg=Secondaire}
\setbeamercolor{description item}{fg=Dominante}

\setbeamertemplate{itemize item}{\small\raise0.15ex\hbox{$\bullet$}}
\setbeamertemplate{itemize subitem}{\rule[0.45ex]{0.5em}{0.7pt}}
\setbeamertemplate{itemize subsubitem}{\scriptsize\raise0.15ex\hbox{$\circ$}}
\setbeamertemplate{enumerate item}{\insertenumlabel.}
\setbeamertemplate{enumerate subitem}{\insertsubenumlabel)}

\setlength{\parskip}{0.4em}
\linespread{1.04}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 6. Titre de diapositive
%    \begin{frame}{Titre}{Sous-titre facultatif}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\setbeamertemplate{frametitle}{%
	\nointerlineskip
	\vskip1.1ex
	\begin{beamercolorbox}[wd=\paperwidth,
						   leftskip=\beamer@leftmargin,
						   rightskip=\beamer@rightmargin]{frametitle}%
		\usebeamerfont{frametitle}\insertframetitle%
		\ifx\insertframesubtitle\@empty\else
			\par\vskip0.15em
			{\usebeamerfont{framesubtitle}\usebeamercolor[fg]{framesubtitle}%
			 \insertframesubtitle}%
		\fi
	\end{beamercolorbox}%
	\vskip1.6ex
}
% « (suite) » à partir de la deuxième page d'un cadre à \allowframebreaks
\setbeamertemplate{frametitle continuation}{%
	\ifnum\beamer@autobreakcount>1\relax
		\usebeamerfont{framesubtitle}\usebeamercolor[fg]{framesubtitle}%
		\space\JS@str@suite
	\fi}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 7. Pied de page et barre de progression
%    La barre, au bas de chaque diapo, avance avec \insertframenumber.
%    Le pied de page (option pied) affiche le titre court, la section et le
%    numéro de la diapo.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newlength{\JS@pbwd}
\newcommand{\JSbarreprogres}{%
	\ifnum\inserttotalframenumber>0\relax
		\setlength{\JS@pbwd}{\paperwidth}%
		\divide\JS@pbwd by \inserttotalframenumber
		\multiply\JS@pbwd by \insertframenumber
	\else
		\setlength{\JS@pbwd}{0pt}%
	\fi
	\nointerlineskip
	\hbox to \paperwidth{%
		\color{Dominante}\rule{\JS@pbwd}{2pt}%
		\color{Dominante!18}\rule{\dimexpr\paperwidth-\JS@pbwd\relax}{2pt}}%
}

\setbeamertemplate{footline}{%
	\ifJS@pied
		\begin{beamercolorbox}[wd=\paperwidth,ht=2.4ex,dp=1.4ex,
							   leftskip=\beamer@leftmargin,
							   rightskip=\beamer@rightmargin]{footline}%
			\usebeamerfont{footline}%
			\insertshorttitle
			\hfill
			\ifJS@annexe
				{\color{Secondaire!75}\JS@str@annexe}%
				\hfill
				{\color{Dominante}\faIcon{bookmark}}%
			\else
				{\color{Secondaire!75}\insertsection}%
				\hfill
				{\sffamily\color{Dominante}\insertframenumber}%
			\fi
		\end{beamercolorbox}%
	\else
		% sans pied de page, on laisse respirer au-dessus de la barre
		\vskip1.6ex
	\fi
	\ifJS@progres\ifJS@annexe\else\JSbarreprogres\fi\fi
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 8. Page titre
%    \title, \subtitle, \author, \date : commandes beamer habituelles
%    \evenement{...} : ligne d'événement (congrès, séminaire, lieu)
%    \fonction{...}  : titre professionnel sous le nom (\\ pour aller à la ligne)
%    \logotitre{...} : fichier du logo, à gauche (vide = aucun logo)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\JS@evenement{}
\newcommand{\evenement}[1]{\def\JS@evenement{#1}}
\def\JS@fonction{}
\newcommand{\fonction}[1]{\def\JS@fonction{#1}}
\def\JS@logo{}
\newcommand{\logotitre}[1]{\def\JS@logo{#1}}

% Filet tricolore de la page titre, réutilisable ailleurs : \JSfilet[largeur]
\newcommand{\JSfilet}[1][\linewidth]{%
	\begin{tikzpicture}
		\fill[Dominante] (0,0) rectangle (0.62*#1,2.6pt);
		\fill[Accent]    (0.62*#1,0) rectangle (0.86*#1,2.6pt);
		\fill[Secondaire!45] (0.86*#1,0) rectangle (#1,2.6pt);
	\end{tikzpicture}%
}

\defbeamertemplate*{title page}{JS}{%
	\thispagestyle{empty}
	\vspace*{0.9cm}
	\begin{minipage}{\linewidth}
		\raggedright
		{\usebeamerfont{title}\usebeamercolor[fg]{title}\inserttitle\par}
		\ifx\insertsubtitle\@empty\else
			\vskip0.35em
			{\usebeamerfont{subtitle}\usebeamercolor[fg]{subtitle}\insertsubtitle\par}
		\fi
	\end{minipage}
	\vskip0.75cm
	\JSfilet
	\vskip0.75cm
	\begin{minipage}[c]{0.28\linewidth}
		\ifx\JS@logo\@empty\else
			\includegraphics[width=3.4cm]{\JS@logo}%
		\fi
	\end{minipage}%
	\hfill
	\begin{minipage}[c]{0.68\linewidth}
		\raggedright
		{\usebeamerfont{author}\color{Dominante}\bfseries\insertauthor\par}
		\ifx\JS@fonction\@empty\else
			\vskip0.25em
			{\usebeamerfont{institute}\color{black!70}\JS@fonction\par}
		\fi
		\ifx\insertinstitute\@empty\else
			{\usebeamerfont{institute}\color{black!70}\insertinstitute\par}
		\fi
		\ifx\JS@evenement\@empty\else
			\vskip0.5em
			{\usebeamerfont{date}\color{Secondaire}\JS@evenement\par}
		\fi
		\ifx\insertdate\@empty\else
			{\usebeamerfont{date}\color{Secondaire}\insertdate\par}
		\fi
	\end{minipage}
	\vfill
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 9. Page de section et table des matières
%    Chaque \section produit une diapo de section (sauf sanssectionpage).
%    \planpartiel[titre] : plan avec la section courante mise en évidence.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\setbeamertemplate{section page}{%
	\vfill
	\begin{minipage}{\linewidth}
		\raggedright
		{\sffamily\fontsize{54}{54}\selectfont\color{Dominante!22}%
		 \bfseries\insertsectionnumber\par}
		\vskip-0.15em
		{\usebeamerfont{section title}\usebeamercolor[fg]{section title}%
		 \insertsection\par}
		\vskip0.5em
		{\color{Accent}\hrule height 2.2pt width 2.2cm}%
	\end{minipage}
	\vfill
}
\ifJS@sectionpage
	\AtBeginSection[]{\begin{frame}[plain,noframenumbering]\sectionpage\end{frame}}
\fi

\setbeamertemplate{section in toc}{%
	{\sffamily\color{Accent}\bfseries\inserttocsectionnumber.}\quad
	{\color{black!85}\inserttocsection}}
\setbeamertemplate{subsection in toc}{%
	\hspace*{1.6em}{\color{Secondaire}\rule[0.45ex]{0.5em}{0.7pt}}\quad
	{\color{black!70}\inserttocsubsection}\par}

\newcommand{\planpartiel}[1][\JS@str@plan]{%
	\begin{frame}{#1}
		\tableofcontents[currentsection,sectionstyle=show/shaded,
						 subsectionstyle=show/show/hide]
	\end{frame}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 10. Blocs beamer standard (block, alertblock, exampleblock), réharmonisés
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\setbeamertemplate{blocks}[default]
\setbeamercolor{block title}{bg=Dominante!12, fg=Dominante}
\setbeamercolor{block body}{bg=Dominante!5, fg=black!88}
\setbeamercolor{block title alerted}{bg=Accent!15, fg=Accent!75!black}
\setbeamercolor{block body alerted}{bg=Accent!6, fg=black!88}
\setbeamercolor{block title example}{bg=VertPreuve!12, fg=VertPreuve!85!black}
\setbeamercolor{block body example}{bg=VertPreuve!5, fg=black!88}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 11. Boîtes à filet latéral
%     \NouvelleBoiteJS{env}{Étiquette}{couleur du filet}{couleur du fond}
%     Chaque environnement accepte un argument optionnel : le nom du résultat.
%       \begin{thm}[Euler] ... \end{thm}
%     Les boîtes sont sécables : elles se poursuivent sur la diapo suivante
%     dans un cadre [allowframebreaks].
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\JS@suffixe}[1]{%
	\if\relax\detokenize{#1}\relax.\else\ (#1).\fi}

\newcommand{\NouvelleBoiteJS}[4]{%
	\newtcolorbox{#1}[1][]{%
		enhanced jigsaw, breakable,
		boxrule=0pt, boxsep=0pt, sharp corners,
		colback=#4, frame hidden,
		borderline west={2.4pt}{0pt}{#3},
		left=10pt, right=10pt, top=7pt, bottom=7pt,
		before skip=8pt, after skip=8pt,
		detach title, fonttitle=\sffamily\bfseries, coltitle=#3,
		title={#2\JS@suffixe{##1}},
		before upper={\tcbtitle\hspace{0.45em}},
	}%
}

\NouvelleBoiteJS{defn}{\JS@str@defn}{Dominante}{DominanteBG}
\NouvelleBoiteJS{thm}{\JS@str@thm}{VertPreuve}{PreuveBG}
\NouvelleBoiteJS{prop}{\JS@str@prop}{VertPreuve}{PreuveBG}
\NouvelleBoiteJS{lemme}{\JS@str@lemme}{VertPreuve}{PreuveBG}
\NouvelleBoiteJS{coro}{\JS@str@coro}{VertPreuve}{PreuveBG}
\NouvelleBoiteJS{ex}{\JS@str@ex}{GrisExemple}{ExempleBG}
\NouvelleBoiteJS{rem}{\JS@str@rem}{Accent}{AccentBG}
\NouvelleBoiteJS{preuve}{\JS@str@preuve}{Secondaire}{ExempleBG}

% Boîtes à pictogramme : une idée (ampoule), une convention de notation (crayon)
\newtcolorbox{lumiere}{%
	enhanced jigsaw, breakable,
	boxrule=0pt, boxsep=0pt, sharp corners,
	colback=LumiereBG, frame hidden,
	borderline west={2.4pt}{0pt}{jaunelaval},
	left=10pt, right=10pt, top=7pt, bottom=7pt,
	before skip=8pt, after skip=8pt,
	detach title,
	title={{\color{jaunelaval}\faIcon[regular]{lightbulb}}},
	before upper={\tcbtitle\hskip0.8em},
}
\newtcolorbox{notation}{%
	enhanced jigsaw, breakable,
	boxrule=0pt, boxsep=0pt, sharp corners,
	colback=NotationBG, frame hidden,
	borderline west={2.4pt}{0pt}{RougeNotation},
	left=10pt, right=10pt, top=7pt, bottom=7pt,
	before skip=8pt, after skip=8pt,
	detach title,
	title={{\color{RougeNotation}\faIcon[regular]{edit}}},
	before upper={\tcbtitle\hskip0.8em},
}

% Boîte encadrée à titre libre : \begin{boite}{Titre} ... \end{boite}
\newtcolorbox{boite}[1]{%
	enhanced, breakable,
	sharp corners, boxrule=0.7pt,
	colback=Fond, colframe=Dominante!45,
	coltitle=Fond, colbacktitle=Dominante,
	fonttitle=\sffamily\bfseries\small,
	attach boxed title to top left={xshift=8pt, yshift=-\tcboxedtitleheight/2},
	boxed title style={sharp corners, boxrule=0pt, size=small},
	top=10pt, bottom=8pt, left=10pt, right=10pt,
	before skip=10pt, after skip=8pt,
	title={#1},
}

% Encadré de mise en valeur, sans titre : la phrase à retenir
\newtcolorbox{apoint}{%
	enhanced, sharp corners, boxrule=0pt,
	colback=Accent!10, frame hidden,
	borderline west={2.4pt}{0pt}{Accent},
	left=10pt, right=10pt, top=8pt, bottom=8pt,
	before skip=8pt, after skip=8pt,
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 12. Commandes de mise en forme
%     \defi{terme}        terme défini, en gras dans la couleur dominante
%     \surligne{texte}    surlignage dans la couleur d'accent
%     \attention{texte}   gras dans la couleur d'accent
%     \exergue{citation}{auteur}
%     \debutannexe ... \finannexe   diapos d'annexe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\defi}[1]{\textbf{\color{Dominante}#1}}
\newcommand{\surligne}[1]{\colorbox{Accent!22}{\strut #1}}
\newcommand{\attention}[1]{\textbf{\color{Accent}#1}}

% Citation détachée
\newcommand{\exergue}[2]{%
	\begin{center}
	\begin{minipage}{0.82\linewidth}
		{\color{Dominante!35}\Large\faIcon{quote-left}}\hskip0.4em
		\emph{#1}\par\vskip0.3em
		\hfill{\small\color{Secondaire}--- #2}
	\end{minipage}
	\end{center}}

% Diapos de rappel en annexe : numérotation gelée, pied de page allégé.
% \inserttotalframenumber ne compte donc que le corps de l'exposé, ce qui
% laisse la barre de progression atteindre exactement 100 % à la dernière
% diapo avant l'annexe. \finannexe se place juste avant \end{document}.
\newcounter{JS@framesauve}
\newcommand{\debutannexe}{%
	\appendix
	\JS@annexetrue
	\setcounter{JS@framesauve}{\value{framenumber}}}
\newcommand{\finannexe}{\setcounter{framenumber}{\value{JS@framesauve}}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 13. Outils graphiques pour les processus ponctuels
%     À placer dans un environnement tikzpicture.
%     \JSnuage[style]{largeur}{hauteur}{n}{graine}
%         nuage de n points uniformes dans une fenêtre largeur x hauteur (cm)
%     \JSnuagePoisson[style]{largeur}{hauteur}{intensite}{graine}
%         effectif tiré d'une loi de Poisson d'espérance intensite*aire
%     \JSdernierN : effectif du dernier \JSnuagePoisson, utilisable dans le texte
%     La même graine redonne le même nuage d'une compilation à l'autre.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\tikzset{
	fenetre/.style={draw=Dominante!55, fill=Dominante!4, thick},
	pointJS/.style={circle, fill=Accent, inner sep=0pt, minimum size=3.6pt},
}

\newcommand{\JSnuage}[5][pointJS]{%
	\pgfmathsetseed{#5}%
	\draw[fenetre] (0,0) rectangle (#2,#3);
	\foreach \JS@i in {1,...,#4}{%
		\pgfmathsetmacro{\JS@x}{rnd*#2}%
		\pgfmathsetmacro{\JS@y}{rnd*#3}%
		\node[#1] at (\JS@x,\JS@y) {};}%
}

% Tirage de N ~ Poisson(mu), mu = intensite x aire, par la méthode de Knuth.
% exp(-mu) sous-passe la précision de pgfmath dès que mu dépasse ~7 : on scinde
% donc en blocs de moyenne au plus 5 et on somme (une somme de Poisson
% indépendantes de moyennes mu_i est une Poisson de moyenne somme des mu_i).
\newcount\JS@Ntot
\newcommand{\JSnuagePoisson}[5][pointJS]{%
	\pgfmathsetseed{#5}%
	\pgfmathsetmacro{\JS@mu}{#4*#2*#3}%
	\pgfmathtruncatemacro{\JS@blocs}{max(ceil(\JS@mu/5),1)}%
	\pgfmathsetmacro{\JS@mub}{\JS@mu/\JS@blocs}%
	\pgfmathsetmacro{\JS@seuil}{exp(-\JS@mub)}%
	\global\JS@Ntot=0\relax
	\foreach \JS@b in {1,...,\JS@blocs}{%
		\pgfmathsetmacro{\JS@p}{1}%
		\pgfmathsetmacro{\JS@k}{0}%
		\pgfmathloop
			\ifdim\JS@p pt>\JS@seuil pt
				\pgfmathsetmacro{\JS@k}{\JS@k+1}%
				\pgfmathsetmacro{\JS@p}{\JS@p*rnd}%
		\repeatpgfmathloop
		\pgfmathtruncatemacro{\JS@kk}{max(\JS@k-1,0)}%
		\global\advance\JS@Ntot by \JS@kk\relax
	}%
	\draw[fenetre] (0,0) rectangle (#2,#3);
	\ifnum\JS@Ntot>0
		\foreach \JS@i in {1,...,\the\JS@Ntot}{%
			\pgfmathsetmacro{\JS@x}{rnd*#2}%
			\pgfmathsetmacro{\JS@y}{rnd*#3}%
			\node[#1] at (\JS@x,\JS@y) {};}%
	\fi
}

\newcommand{\JSdernierN}{\the\JS@Ntot}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 14. Bibliographie
%     biblatex + biber. Le fichier references.bib est chargé automatiquement
%     s'il existe ; sinon, \addbibresource{...} dans le préambule.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ifJS@anglais
	\RequirePackage[style=numeric,backend=biber,language=english]{biblatex}
\else
	\RequirePackage[style=numeric,backend=biber,language=french]{biblatex}
		\DefineBibliographyStrings{french}{in={dans},inseries={dans}}
\fi
\IfFileExists{references.bib}{\addbibresource{references.bib}}{}
\setbeamertemplate{bibliography item}[text]
\setbeamercolor{bibliography item}{fg=Accent}
\setbeamercolor{bibliography entry author}{fg=Dominante}
\setbeamercolor{bibliography entry title}{fg=black!85}
\setbeamercolor{bibliography entry location}{fg=black!65}
\setbeamercolor{bibliography entry note}{fg=black!65}
\renewcommand*{\bibfont}{\small}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 15. Compatibilité avec les constantes droites sous XeLaTeX / LuaLaTeX
%     Certains fichiers de macros définissent \piu, \gammau ou \eu par
%     \text{\upshape\pi}, ce qui va chercher un caractère mathématique dans une
%     police de texte. unicode-math fournit les versions droites : on les
%     substitue si ces commandes existent.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ifJS@unicode
	\AtBeginDocument{%
		\@ifundefined{piu}{}{\renewcommand{\piu}{\uppi}}%
		\@ifundefined{gammau}{}{\renewcommand{\gammau}{\upgamma}}%
		\@ifundefined{eu}{}{\renewcommand{\eu}{\mathrm{e}}}%
	}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 16. Noms anglais
%     Chaque commande et chaque environnement a un équivalent anglais, pour
%     qu'un même document puisse être écrit avec l'un ou l'autre jeu de noms.
%     Les deux noms désignent exactement le même objet.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Couleurs
\colorlet{Primary}{Dominante}
\colorlet{Secondary}{Secondaire}
\colorlet{Background}{Fond}

% Page titre et plan
\NewCommandCopy{\event}{\evenement}
\NewCommandCopy{\position}{\fonction}
\NewCommandCopy{\titlelogo}{\logotitre}
\NewCommandCopy{\JSrule}{\JSfilet}
\NewCommandCopy{\partialtoc}{\planpartiel}
\NewCommandCopy{\JSprogressbar}{\JSbarreprogres}
\NewCommandCopy{\palettepreview}{\apercupalette}

% Mise en forme
\NewCommandCopy{\term}{\defi}
\NewCommandCopy{\highlight}{\surligne}
\NewCommandCopy{\stress}{\attention}
\NewCommandCopy{\bigquote}{\exergue}
\NewCommandCopy{\startappendix}{\debutannexe}
\NewCommandCopy{\stopappendix}{\finannexe}

% Boîtes
\NewCommandCopy{\NewBoxJS}{\NouvelleBoiteJS}
% beamer définit déjà un environnement lemma : la boîte le remplace.
\DeclareEnvironmentCopy{lemma}{lemme}
\NewEnvironmentCopy{proofbox}{preuve}
\NewEnvironmentCopy{idea}{lumiere}
\NewEnvironmentCopy{framedbox}{boite}
\NewEnvironmentCopy{keypoint}{apoint}

% Nuages de points
\NewCommandCopy{\JSscatter}{\JSnuage}
\NewCommandCopy{\JSpoissonScatter}{\JSnuagePoisson}
\NewCommandCopy{\JSlastN}{\JSdernierN}

\endinput
