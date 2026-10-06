% !TeX encoding = UTF-8
% !TeX program = xelatex
% !TeX spellcheck = en_US
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  BeamerJS — a beamer class for mathematics talks
%  Jérôme Soucy (jsoucy@mat.ulaval.ca)
%  First version    : December 22, 2022
%  Current version  : v2.1 — October 2026
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
%  In short: you may use, copy and redistribute this class freely. A
%  modified version must use a different file name (or be clearly marked as
%  modified); see the LICENSE file.
%
%  Compile with: XeLaTeX (recommended) or LuaLaTeX, then biber.
%                pdfLaTeX also works, with Latin Modern throughout.
%
%  Contents
%    1. Class options                9. Section page, outline
%    2. Engine, language and fonts  10. Standard beamer blocks
%    3. Packages                    11. Side-rule boxes
%    4. Palettes                    12. Formatting commands
%    5. General beamer settings     13. Point clouds (point processes)
%    6. Frame title                 14. Bibliography
%    7. Footer, progress bar        15. unicode-math compatibility
%    8. Title page                  16. English names (aliases)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}[2023/06/01]
\ProvidesClass{BeamerJS}[2026/10/06 v2.1 Beamer class by Jerome Soucy]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Class options
%    Language : en (default in this template) | fr
%    Palette  : night (default) | earth | slate | laval
%               (French names: nuit | terre | ardoise)
%    Font     : charter (default) | baskerville | newcm | source | libertinus
%    Layout   :
%      footer         show the footer (short title, section, frame number)
%      noprogress     remove the progress bar
%      nosectionpage  remove the automatic frame at the start of each section
%      (French names: pied, sansprogres, sanssectionpage)
%    Any other option is passed on to beamer (e.g. handout).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The names "fr" and "en" are deliberately short: "french" or "english"
% would also be read by babel as global options.
\newif\ifJS@anglais   \JS@anglaistrue
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

% Strings typeset by the class, depending on the chosen language
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
% 2. Engine, language and fonts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{iftex}
\newif\ifJS@unicode
\ifXeTeX\JS@unicodetrue\fi
\ifLuaTeX\JS@unicodetrue\fi

% Text font sets. Mathematics stays in Latin Modern Math, so each set is
% chosen to match its texture (vertical stress, strong contrast) while
% keeping a contemporary sans serif for the structure (titles, footer,
% box labels).
%
%   charter     XCharter + Inter        robust on a projector     (default)
%   baskerville Baskervaldx + Inter     closest to the math font
%   newcm       New Computer Modern     perfect match, more classic
%   source      Source Serif + Sans     the most contemporary
%   libertinus  Libertinus              sober and compact
%
% Fonts are loaded by file name: they ship with TeX Live (and therefore
% with Overleaf), nothing to install.
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
		% Latin Modern Math's \setminus is too short: borrow STIX Two's.
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

% Body text is set in serif: beamer uses sans serif by default, which clashes
% with formulas in Latin Modern Math. The sans serif is kept for structure,
% where it is declared explicitly.
\renewcommand{\familydefault}{\rmdefault}

\RequirePackage{microtype}

% biblatex inserts a zero-width space between name parts, which not every
% font covers. Replace it with a true zero skip rather than letting XeTeX
% report a missing character for every reference.
\ifJS@unicode
	\RequirePackage{newunicodechar}
	\newunicodechar{^^^^200b}{\hskip0pt\relax}
\fi

% unicode-math does not provide the legacy stmaryrd names: restore them so
% that \llbracket and \rrbracket work with every engine.
\ifJS@unicode
	\providecommand{\llbracket}{\lBrack}
	\providecommand{\rrbracket}{\rBrack}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Packages
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
%    Primary    (Dominante)  : titles, structure
%    Secondary  (Secondaire) : discreet support
%    Accent                  : emphasis, links
%    Background (Fond)       : frame background
%    Both names refer to the same colours (section 16).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\@namedef{JS@pal@nuit}{%
	\definecolor{Dominante}{HTML}{22364F}%   night blue
	\definecolor{Secondaire}{HTML}{5A7184}%  slate
	\definecolor{Accent}{HTML}{B5651D}%      copper
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

% English palette names, for \palettepreview
\expandafter\let\csname JS@pal@night\expandafter\endcsname\csname JS@pal@nuit\endcsname
\expandafter\let\csname JS@pal@earth\expandafter\endcsname\csname JS@pal@terre\endcsname
\expandafter\let\csname JS@pal@slate\expandafter\endcsname\csname JS@pal@ardoise\endcsname

\@nameuse{JS@pal@\JS@palette}

% Colours of the laval palette, always available
\definecolor{rougelaval}{RGB}{237,28,36}
\definecolor{jaunelaval}{RGB}{251,199,7}

% Utility colours
\definecolor{VertPreuve}{HTML}{2E6B4F}
\definecolor{RougeNotation}{HTML}{8B2635}
\definecolor{GrisExemple}{HTML}{4A4A4A}
\colorlet{DominanteBG}{Dominante!7}
\colorlet{AccentBG}{Accent!10}
\colorlet{PreuveBG}{VertPreuve!6}
\colorlet{ExempleBG}{black!4}
\colorlet{NotationBG}{RougeNotation!6}
\definecolor{LumiereBG}{RGB}{250,248,235}

% Preview of a palette (English or French name), whatever the document's
% palette:
%   \palettepreview{earth}   (French: \apercupalette{terre})
% The \definecolor calls stay local to the group: the document palette is
% left untouched.
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

% Default pgfplots settings: plots follow the palette and sizes of the
% presentation, without repeating them in each figure.
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
% 5. General beamer settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\usefonttheme{professionalfonts}
\setbeamersize{sidebar width left=0pt,
			   text margin left=0.9cm, text margin right=0.9cm}
\setbeamertemplate{navigation symbols}{}

% Sans serif for structure, serif for running text: the hierarchy reads at a
% glance and formulas stay in the same family as the text.
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
% 6. Frame title
%    \begin{frame}{Title}{Optional subtitle}
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
% "(continued)" from the second page of an [allowframebreaks] frame on
\setbeamertemplate{frametitle continuation}{%
	\ifnum\beamer@autobreakcount>1\relax
		\usebeamerfont{framesubtitle}\usebeamercolor[fg]{framesubtitle}%
		\space\JS@str@suite
	\fi}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 7. Footer and progress bar
%    The bar at the bottom of each frame advances with \insertframenumber.
%    The footer (option footer) shows the short title, the section and the
%    frame number.
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
		% without a footer, leave some air above the bar
		\vskip1.6ex
	\fi
	\ifJS@progres\ifJS@annexe\else\JSbarreprogres\fi\fi
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 8. Title page
%    \title, \subtitle, \author, \institute, \date : usual beamer commands
%    \event{...}      (\evenement) : event line (conference, seminar, place)
%    \position{...}   (\fonction)  : job title under the name (\\ for a new line)
%    \titlelogo{...}  (\logotitre) : logo file, on the left (empty = no logo)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\JS@evenement{}
\newcommand{\evenement}[1]{\def\JS@evenement{#1}}
\def\JS@fonction{}
\newcommand{\fonction}[1]{\def\JS@fonction{#1}}
\def\JS@logo{}
\newcommand{\logotitre}[1]{\def\JS@logo{#1}}

% Three-colour rule of the title page, reusable elsewhere: \JSrule[width]
% (French: \JSfilet)
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
% 9. Section page and table of contents
%    Each \section produces a section frame (unless nosectionpage).
%    \partialtoc[title] (\planpartiel): outline with the current section
%    highlighted.
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
% 10. Standard beamer blocks (block, alertblock, exampleblock), restyled
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\setbeamertemplate{blocks}[default]
\setbeamercolor{block title}{bg=Dominante!12, fg=Dominante}
\setbeamercolor{block body}{bg=Dominante!5, fg=black!88}
\setbeamercolor{block title alerted}{bg=Accent!15, fg=Accent!75!black}
\setbeamercolor{block body alerted}{bg=Accent!6, fg=black!88}
\setbeamercolor{block title example}{bg=VertPreuve!12, fg=VertPreuve!85!black}
\setbeamercolor{block body example}{bg=VertPreuve!5, fg=black!88}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 11. Side-rule boxes
%     \NewBoxJS{env}{Label}{rule colour}{background colour}
%     (French: \NouvelleBoiteJS)
%     Each environment takes an optional argument: the name of the result.
%       \begin{thm}[Euler] ... \end{thm}
%     English names: defn, thm, prop, lemma, coro, ex, rem, proofbox.
%     The boxes are breakable: they continue on the next frame inside an
%     [allowframebreaks] frame.
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

% Icon boxes: an idea (light bulb, env. idea), a notation (pencil, env. notation)
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

% Framed box with a free title: \begin{framedbox}{Title} ... \end{framedbox}
% (French: boite)
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

% Highlight box without a title, for the take-away sentence:
% \begin{keypoint} ... \end{keypoint}   (French: apoint)
\newtcolorbox{apoint}{%
	enhanced, sharp corners, boxrule=0pt,
	colback=Accent!10, frame hidden,
	borderline west={2.4pt}{0pt}{Accent},
	left=10pt, right=10pt, top=8pt, bottom=8pt,
	before skip=8pt, after skip=8pt,
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 12. Formatting commands (French names in parentheses)
%     \term{word}          (\defi)       defined term, bold in the primary colour
%     \highlight{text}     (\surligne)   highlight in the accent colour
%     \stress{text}        (\attention)  bold in the accent colour
%     \bigquote{quote}{author}  (\exergue)
%     \startappendix ... \stopappendix  (\debutannexe, \finannexe)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\defi}[1]{\textbf{\color{Dominante}#1}}
\newcommand{\surligne}[1]{\colorbox{Accent!22}{\strut #1}}
\newcommand{\attention}[1]{\textbf{\color{Accent}#1}}

% Displayed quotation
\newcommand{\exergue}[2]{%
	\begin{center}
	\begin{minipage}{0.82\linewidth}
		{\color{Dominante!35}\Large\faIcon{quote-left}}\hskip0.4em
		\emph{#1}\par\vskip0.3em
		\hfill{\small\color{Secondaire}--- #2}
	\end{minipage}
	\end{center}}

% Backup frames in an appendix: numbering frozen, lighter footer.
% \inserttotalframenumber therefore only counts the body of the talk, so the
% progress bar reaches exactly 100 % on the last frame before the appendix.
% \stopappendix goes right before \end{document}.
\newcounter{JS@framesauve}
\newcommand{\debutannexe}{%
	\appendix
	\JS@annexetrue
	\setcounter{JS@framesauve}{\value{framenumber}}}
\newcommand{\finannexe}{\setcounter{framenumber}{\value{JS@framesauve}}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 13. Drawing tools for point processes
%     To be used inside a tikzpicture environment.
%     \JSscatter[style]{width}{height}{n}{seed}          (\JSnuage)
%         n uniform points in a width x height window (cm)
%     \JSpoissonScatter[style]{width}{height}{intensity}{seed}  (\JSnuagePoisson)
%         number of points drawn from a Poisson law with mean intensity*area
%     \JSlastN (\JSdernierN): number of points of the last \JSpoissonScatter,
%         usable in the text
%     The same seed gives the same cloud from one compilation to the next.
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

% Draw N ~ Poisson(mu), mu = intensity x area, with Knuth's method.
% exp(-mu) underflows pgfmath's precision once mu exceeds ~7, so we split
% into blocks of mean at most 5 and add them up (a sum of independent
% Poisson variables with means mu_i is Poisson with mean sum of the mu_i).
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
% 14. Bibliography
%     biblatex + biber. The file references.bib is loaded automatically if it
%     exists; otherwise use \addbibresource{...} in the preamble.
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
% 15. Upright constants under XeLaTeX / LuaLaTeX
%     Some macro files define \piu, \gammau or \eu as \text{\upshape\pi},
%     which looks for a math character in a text font. unicode-math provides
%     the upright versions: substitute them when these commands exist.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ifJS@unicode
	\AtBeginDocument{%
		\@ifundefined{piu}{}{\renewcommand{\piu}{\uppi}}%
		\@ifundefined{gammau}{}{\renewcommand{\gammau}{\upgamma}}%
		\@ifundefined{eu}{}{\renewcommand{\eu}{\mathrm{e}}}%
	}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 16. English names
%     Every command and environment has an English name, defined here as a
%     copy of the French one. Both names refer to exactly the same object, so
%     a document can use either set.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Colours
\colorlet{Primary}{Dominante}
\colorlet{Secondary}{Secondaire}
\colorlet{Background}{Fond}

% Title page and outline
\NewCommandCopy{\event}{\evenement}
\NewCommandCopy{\position}{\fonction}
\NewCommandCopy{\titlelogo}{\logotitre}
\NewCommandCopy{\JSrule}{\JSfilet}
\NewCommandCopy{\partialtoc}{\planpartiel}
\NewCommandCopy{\JSprogressbar}{\JSbarreprogres}
\NewCommandCopy{\palettepreview}{\apercupalette}

% Formatting
\NewCommandCopy{\term}{\defi}
\NewCommandCopy{\highlight}{\surligne}
\NewCommandCopy{\stress}{\attention}
\NewCommandCopy{\bigquote}{\exergue}
\NewCommandCopy{\startappendix}{\debutannexe}
\NewCommandCopy{\stopappendix}{\finannexe}

% Boxes
\NewCommandCopy{\NewBoxJS}{\NouvelleBoiteJS}
% beamer already defines a lemma environment: the box replaces it.
\DeclareEnvironmentCopy{lemma}{lemme}
\NewEnvironmentCopy{proofbox}{preuve}
\NewEnvironmentCopy{idea}{lumiere}
\NewEnvironmentCopy{framedbox}{boite}
\NewEnvironmentCopy{keypoint}{apoint}

% Point clouds
\NewCommandCopy{\JSscatter}{\JSnuage}
\NewCommandCopy{\JSpoissonScatter}{\JSnuagePoisson}
\NewCommandCopy{\JSlastN}{\JSdernierN}

\endinput
