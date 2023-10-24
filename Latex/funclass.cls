% Put this file under "/usr/local/texlive/texmf-local/tex/latex/local".
% Use command "sudo texhash" after editting this file.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{funclass}[A Powerful Latex Class For Different Templates]

%----------------------------------------------------------------------------%
% defination of class variables
\newcommand{\@docOption}{basic}
\newcommand{\@fontSize}{12pt}
\newcommand{\@pagecolor}{}
\DeclareOption{note}{\renewcommand{\@docOption}{note}\renewcommand{\@fontSize}{10pt}}
\DeclareOption{cheatsheet}{\renewcommand{\@docOption}{cheatsheet}\renewcommand{\@fontSize}{10pt}}
\DeclareOption{assignment}{\renewcommand{\@docOption}{assignment}\renewcommand{\@fontSize}{12pt}}
\DeclareOption{basic}{\renewcommand{\@docOption}{basic}\renewcommand{\@fontSize}{12pt}}
\DeclareOption{beige}{\renewcommand{\@pagecolor}{\pagecolor{Beige!30}}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[\@fontSize]{article}
%----------------------------------------------------------------------------%
% load required packages
\RequirePackage{etex}
\RequirePackage[export]{adjustbox}
\RequirePackage[no-math]{fontspec}
\RequirePackage[svgnames, dvipsnames]{xcolor}
\RequirePackage[most]{tcolorbox} % needs to be placed after xcolor
\RequirePackage{amsmath}
\RequirePackage{array}
\RequirePackage{booktabs}
\RequirePackage{enumitem}
\RequirePackage{etoolbox}
\RequirePackage{fancyhdr}
\RequirePackage{float}
\RequirePackage{geometry}
\RequirePackage{graphicx}
\RequirePackage{hyperref}
\RequirePackage{ifthen}
\RequirePackage{keycommand}
\RequirePackage{lipsum}
\RequirePackage{minted}
\RequirePackage{multicol}
\RequirePackage{multirow}
\RequirePackage{soul}
\RequirePackage{tabularx}
\RequirePackage{tikz}
\usetikzlibrary{tikzmark}
\RequirePackage{titlesec}
\RequirePackage{unicode-math}
\RequirePackage{wrapfig}
\RequirePackage{xparse}
%----------------------------------------------------------------------------%
% redefine maketitle
\ifthenelse{\equal{\@docOption}{note}}{
    \renewcommand{\maketitle}{
        \@pagecolor
        \begin{center}
            {\LARGE\textbf{\Chalkboard\@title}}
        \end{center}
    }
    \renewcommand{\title}[1]{
        \renewcommand{\@title}{#1}
        \maketitle
        \thispagestyle{fancy}
        % Table of contents settings
        \renewcommand{\contentsname}{Summary\vspace{-1em}}
        \newcommand{\hrefMath}[1]{\texorpdfstring{##1}{}}
        \tableofcontents
    }
}{}
\ifthenelse{\equal{\@docOption}{cheatsheet}}{
    \renewcommand{\maketitle}{
        \@pagecolor
        \begin{center}
            {\Large\textbf{\Chalkboard\@title}}
        \end{center}
        \vspace{0.5em}
    }
    \renewcommand{\title}[1]{
        \renewcommand{\@title}{#1}
        \maketitle
        \thispagestyle{fancy}
    }
}{}
\ifthenelse{\equal{\@docOption}{assignment}}{
    \newcommand{\@sid}{}
    \newcommand{\sid}[1]{\renewcommand{\@sid}{#1}}
    \renewcommand\@maketitle{
        \@pagecolor
        \begin{center}
            {\Large\textbf{\@title}}\\[0.5em]
            \textbf{Name: }\@author \hspace{2em} \textbf{SID: }\@sid\\
            \@date
        \end{center}
    }
    \renewcommand{\title}[1]{
        \renewcommand{\@title}{#1}
        \maketitle
        \thispagestyle{fancy}
    }
}{}
\ifthenelse{\equal{\@docOption}{basic}}{
    \renewcommand\@maketitle{
        \@pagecolor
        \begin{center}
            {\Large\textbf{\@title}}
        \end{center}
    }
    \renewcommand{\title}[1]{
        \renewcommand{\@title}{#1}
        \maketitle
        \thispagestyle{fancy}
    }
}{}
%----------------------------------------------------------------------------%
% settings for environment wrapper
\BeforeBeginEnvironment{multicols}{\vspace{-1.5em}}
\AtBeginEnvironment{multicols}{\raggedcolumns}
\AtBeginEnvironment{table}{\setlength{\aboverulesep}{0em}\setlength{\belowrulesep}{0em}\def\arraystretch{1.2}\vspace{-1em}}
\AtEndEnvironment{table}{\vspace{-1em}}
\BeforeBeginEnvironment{figure}{\vspace{-0.5em}}
\AfterEndEnvironment{figure}{\vspace*{-1em}}
\AtEndEnvironment{document}{\immediate\write18{rm -r _minted*}}
%----------------------------------------------------------------------------%
% settings for document general fonts
\newcommand{\@fontFolder}{direct}
\newcommand{\indirectFontFolder}{\renewcommand{\@fontFolder}{indirect}}
% \indirectFontFolder % uncomment this line if your 'fonts' folder contains sub-folders
\IfFontExistsTF{Helvetica Neue}{
    \setmainfont{Helvetica Neue}
}{
    \ifthenelse{\equal{\@fontFolder}{indirect}}{
        \def\@fontPath{./fonts/Helvetica Neue/}
    }{
        \def\@fontPath{./fonts/}
    }
    \setmainfont{HelveticaNeue}[
        Path=\@fontPath,
        UprightFont=*,
        BoldFont=*-Bold,
        ItalicFont=*-Italic,
        BoldItalicFont=*-BoldItalic
    ]
}
\IfFontExistsTF{JetBrainsMono Nerd Font}{
    \setmonofont{JetBrainsMono Nerd Font}
    \newfontfamily\JBNF{JetBrainsMono Nerd Font}[Scale=1.5]
}{
    \ifthenelse{\equal{\@fontFolder}{indirect}}{
        \def\@fontPath{./fonts/JetBrainsMono Nerd Font/}
    }{
        \def\@fontPath{./fonts/}
    }
    \setmonofont{JetBrainsMonoNerdFont}[
        Path=\@fontPath,
        UprightFont=*-Regular,
        BoldFont=*-Bold,
        ItalicFont=*-Italic,
        BoldItalicFont=*-BoldItalic,
    ]
    \newfontfamily\JBNF{JetBrainsMonoNerdFont}[
        Path=\@fontPath,
        UprightFont=*-Regular,
        BoldFont=*-Bold,
        ItalicFont=*-Italic,
        BoldItalicFont=*-BoldItalic,
        Scale=1.5
    ]
}
\IfFontExistsTF{Chalkboard SE}{
    % No Italic style for Chalkboard SE
    \newfontfamily\Chalkboard{Chalkboard SE}
}{
    \ifthenelse{\equal{\@fontFolder}{indirect}}{
        \def\@fontPath{./fonts/Chalkboard/}
    }{
        \def\@fontPath{./fonts/}
    }
    \newfontfamily\Chalkboard{ChalkboardSE}[
        Path=\@fontPath,
        UprightFont=*-Regular,
        BoldFont=*-Bold
    ]
}
% settings for document math fonts
\IfFontExistsTF{Cambria Math}{
    \setmathfont{Cambria Math}
    \setmathfont[version=bold, FakeBold=7]{Cambria Math}
}{
    \ifthenelse{\equal{\@fontFolder}{indirect}}{
        \def\@fontPath{./fonts/Cambria/}
    }{
        \def\@fontPath{./fonts/}
    }
    \setmathfont{CambriaMath}[
        Path=\@fontPath,
    ]
    \setmathfont[version=bold, FakeBold=7]{CambriaMath}[
        Path=\@fontPath,
    ]
}
% settings for document page size
% A4 paper fill size: 210mm x 297mm
\ifthenelse{\equal{\@docOption}{note} \OR \equal{\@docOption}{cheatsheet}}{
    % setting for 'note' and 'cheatsheet'
    \geometry{a4paper, total={190mm,264mm}, left=10mm, top=15mm}
}{
    % setting for 'assignment' and 'basic'
    \geometry{a4paper, total={180mm,267mm}, left=15mm, top=15mm}
}
% href links no special effect
\hypersetup{hidelinks, colorlinks=true, urlcolor=black, linkcolor=black}
% settings for fancy header, footer, and page number
\fancyfootoffset{0pt}
\pagestyle{fancy}
\lhead{}\cfoot{-~\thepage~-}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\ifthenelse{\equal{\@docOption}{note} \OR \equal{\@docOption}{cheatsheet}}{
    % setting for 'note' and 'cheatsheet'
    \fancyhead[R]{\ifthenelse{\value{page}=1}{\color{gray}Last modified:\\\today}{}}
}{  
    % setting for 'assignment' and 'basic'
    \rhead{}
}
% settings for title formats
\ifthenelse{\equal{\@docOption}{note}}{
    \titleformat{\section}[hang]{\Large\bf\Chalkboard}{\arabic{section}.}{1em}{}[]
    \titlespacing{\section}{0em}{0.5em}{0.5em}[0em] % parameters: {space left}{space above}{space below}[space remain on the right]
    \titleformat{\subsection}[hang]{\large\bf\Chalkboard}{\arabic{section}.\arabic{subsection}.}{1em}{}[]
    \titlespacing{\subsection}{0em}{0.5em}{0.5em}[0em]
    \titleformat{\subsubsection}[runin]{\normalsize\bf\Chalkboard}{\roman{subsubsection}.}{0.5em}{}[\hspace*{1em}]
    \titlespacing{\subsubsection}{0em}{0em}{0em}[0em]
}{}
\ifthenelse{\equal{\@docOption}{cheatsheet}}{
    \titleformat{\section}[hang]{\large\bf\Chalkboard}{\arabic{section}.}{1em}{}[]
    \titlespacing{\section}{0em}{0em}{0em}[0em]
    \titleformat{\subsection}[hang]{\normalsize\bf\Chalkboard}{\arabic{section}.\arabic{subsection}.}{1em}{}[]
    \titlespacing{\subsection}{0em}{0em}{0em}[0em]
    \titleformat{\subsubsection}[runin]{\normalsize\bf\Chalkboard}{\roman{subsubsection}.}{0.5em}{}[\hspace*{1em}]
    \titlespacing{\subsubsection}{0em}{0em}{0em}[0em]
}{}
\ifthenelse{\equal{\@docOption}{assignment}}{
    \titleformat{\section}[hang]{\large\bf}{\arabic{section}.}{1em}{}[]
    \titlespacing{\section}{0em}{0em}{0em}[0em]
    \titleformat{\subsection}[runin]{\normalsize\bf}{}{0em}{}[\hspace*{1em}]
    \titlespacing{\subsection}{0em}{0em}{0em}[0em]
    \titleformat{\subsubsection}[runin]{\normalsize}{}{0em}{}[\hspace*{1em}]
    \titlespacing{\subsubsection}{0em}{0em}{0em}[0em]
}{}
\ifthenelse{\equal{\@docOption}{basic}}{
    \titleformat{\section}[hang]{\large\bf}{\arabic{section}.}{1em}{}[]
    \titlespacing{\section}{0em}{0em}{0em}[0em]
    \titleformat{\subsection}[hang]{\normalsize\bf}{\arabic{section}.\arabic{subsection}.}{1em}{}[]
    \titlespacing{\subsection}{0em}{0em}{0em}[0em]
    \titleformat{\subsubsection}[runin]{\normalsize\bf}{\roman{subsubsection}.}{0.5em}{}[\hspace*{1em}]
    \titlespacing{\subsubsection}{0em}{0em}{0em}[0em]
}{}
% Supplementary settings
\linespread{1.2} % set line spread
\renewcommand\tabularxcolumn[1]{m{#1}} % vertical centering text in X column
\setlength{\parindent}{1em}
\setlist[itemize, 1]{label=$\bullet$, nosep, leftmargin=1em}
\setlist[itemize, 2]{label=$\circ$, nosep, leftmargin=1.5em}
\setlist[enumerate, 1]{nosep, leftmargin=1.5em}
\setlist[enumerate, 2]{nosep, leftmargin=2em}
\ifthenelse{\equal{\@docOption}{note}}{
    \setlist[itemize, 1]{label=$\bullet$, nosep, leftmargin=1em, itemsep=0.5em}
    \setlist[itemize, 2]{label=$\circ$, nosep, leftmargin=1.5em, itemsep=0.5em}
    \setlist[enumerate, 1]{nosep, leftmargin=1.5em, itemsep=0.5em}
    \setlist[enumerate, 2]{nosep, leftmargin=2em, itemsep=0.5em}
    % itemsep: line space between the items in a list
    % topsep: top space before the first item in a list
    \setlength{\columnsep}{0em} % set width between page columns
    \setlength{\columnseprule}{0pt} % set column rule width
    \setlength{\headheight}{3em} % set the space between ceiling and header
    \setlength{\headsep}{1em} % set the space between header and text area
    \setlength{\footskip}{2.5em} % set the space between text area and footer
    \def\@codeInlineFontSize{\normalsize}
    \def\@codeBlockFontSize{\normalsize}
}{}
\ifthenelse{\equal{\@docOption}{cheatsheet}}{
    \setlength{\columnsep}{2em} % set width between columns
    \setlength{\columnseprule}{0.5pt} % set column rule width
    \setlength{\headheight}{3em} % set the space between ceiling and header
    \setlength{\headsep}{1em} % set the space between header and text area
    \setlength{\footskip}{2.5em} % set the space between text area and footer
    \def\@codeInlineFontSize{\normalsize}
    \def\@codeBlockFontSize{\normalsize}
}{}
\ifthenelse{\equal{\@docOption}{assignment} \OR \equal{\@docOption}{basic}}{
    \setlength{\columnsep}{0em} % set width between page columns
    \setlength{\columnseprule}{0pt} % set column rule width
    \setlength{\footskip}{1.5em} % set the space between text area and footer
    \def\@codeInlineFontSize{\footnotesize}
    \def\@codeBlockFontSize{\footnotesize}
}{}
%----------------------------------------------------------------------------%

%----------------------------------------------------------------------------%
% defination of useful functions
% highlight lines
% usage: \hl{content} --- for normal text
%        \highlight[color]{content} --- for display math
\def\SOUL@hlpreamble{ % eliminate the white space between highlighted lines
    \setul{\dp\strutbox}{\dimexpr\ht\strutbox+\dp\strutbox\relax}{\hspace{-0.5em}}
    \let\SOUL@stcolor\SOUL@hlcolor
    \SOUL@stpreamble
}
\colorlet{lightyellow}{yellow!33} % define highlight color
\sethlcolor{lightyellow} % set highlight color
\newcommand{\highlight}[2][yellow]{\colorbox{#1!33}{$\mathstrut #2$}}
% easy annotation
% usage: \node{name}{content} --- define a node for drawing annotation
%        \annotate[...]{node}{content} --- draw the annotation
%           Optional args:
%               xshift / yshift: move the position of content relative to node
%               node xshift / node yshift: move the position of ending arrow
%               arrow: |-(default), --, bend left, bend right
%                      if arrow=bend left/right, parameter `deg` must be filled in
%               deg: how much should the arrow bend (in 360 scale)
%               color: color of the content and arrow
%               anchor: arrow starting position relative to content (east, west, north, south)
\newcommand{\node}[2]{\tikzmarknode{#1}{#2}}
\newkeycommand{\annotate}[xshift=0em, yshift=0em, node xshift=0em, node yshift=0em, arrow=|-, deg, color=blue!67, anchor][2]{
  	\ifthenelse{\equal{\commandkey{anchor}}{}}{
    	\ifthenelse{\lengthtest{\commandkey{xshift}<0em}}{
      		\def\notationPos{east}
    	}{
      		\def\notationPos{west}
    	}
  	}{
    	\def\notationPos{\commandkey{anchor}}
  	}

  	\ifthenelse{\lengthtest{\commandkey{yshift}<0em}}{
    	\def\nodePos{south}
  	}{
    	\ifthenelse{\lengthtest{\commandkey{yshift}>0em}}{
      		\def\nodePos{north}
    	}{
      		\def\nodePos{center}
    	}
  	}

  	\ifthenelse{\NOT\equal{\commandkey{deg}}{}}{
    	\ifthenelse{\lengthtest{\commandkey{xshift}>0em} \AND \lengthtest{\commandkey{yshift}>0em}}{\def\arrow{to [bend left=\commandkey{deg}]}}{}
    	\ifthenelse{\lengthtest{\commandkey{xshift}<0em} \AND \lengthtest{\commandkey{yshift}<0em}}{\def\arrow{to [bend left=\commandkey{deg}]}}{}
    	\ifthenelse{\lengthtest{\commandkey{xshift}>0em} \AND \lengthtest{\commandkey{yshift}<0em}}{\def\arrow{to [bend right=\commandkey{deg}]}}{}
    	\ifthenelse{\lengthtest{\commandkey{xshift}<0em} \AND \lengthtest{\commandkey{yshift}>0em}}{\def\arrow{to [bend right=\commandkey{deg}]}}{}
    	\ifthenelse{\lengthtest{\commandkey{xshift}=0em} \OR \lengthtest{\commandkey{yshift}=0em}}{\def\arrow{--}}{}
  	}{
		\def\arrow{\commandkey{arrow}}
	}

  	\ifthenelse{\NOT\equal{\commandkey{arrow}}{|-}}{
    	\ifthenelse{\NOT\equal{\commandkey{arrow}}{--}}{\def\arrow{to [\commandkey{arrow}=\commandkey{deg}]}}{\def\arrow{\commandkey{arrow}}}
  	}{}

  	\begin{tikzpicture}[overlay,remember picture,>=stealth,nodes={align=center,inner ysep=0pt},<-]
    	\path (#1.\nodePos) ++ (\commandkey{xshift},\commandkey{yshift}) node[anchor=\notationPos,color=\commandkey{color}] (textBox){#2};
    	\draw [color=\commandkey{color}](#1.\nodePos) ++ (\commandkey{node xshift},\commandkey{node yshift}) \arrow (textBox.\notationPos);
  	\end{tikzpicture}
}
% insert code blocks
% usage: \code[python]{content} --- add an inline code block of specific language (default: Python)
% usage: \codeText[black]{content} --- add an inline code block of specific color (default: black, this macro can be used inside a table)
%        \readPython(*)[lineno]{path}[highlight][title] --- add a display Python code block from file
%        \readTxt(*)[lineno]{path}[highlight][title] --- add a display txt code block from file
\usemintedstyle{emacs} % set the style of rendered code block
\setminted{mathescape, escapeinside=||, breaklines, breaksymbolleft=\small\ensuremath{\hookrightarrow},
    fontsize=\@codeBlockFontSize, breakindentnchars=0, breaksymbolsepnchars=1, python3}
\tcbset{before skip=0.5\baselineskip+2pt, after skip=0.5\baselineskip+2pt}
\definecolor{codeBG}{HTML}{f7f7f7}

\NewTotalTCBox{\code}{ O{python} m }{enhanced, on line, left=1mm, right=1mm, top=0mm, bottom=0mm, colback=codeBG, colframe=gray!50, boxrule=1pt}
    {\mintinline[fontsize=\@codeInlineFontSize]{#1}{#2}}
\NewTotalTCBox{\codeText}{ O{black} m }{enhanced, on line, left=1mm, right=1mm, top=0mm, bottom=0mm, colback=codeBG, colframe=gray!50, boxrule=1pt}
    {\color{#1}\@codeInlineFontSize\texttt{#2}}

\NewDocumentCommand \processRead { m m m m m m }{
    \IfBooleanT{#1}{
        \tcbset{before skip=-\tcboxedtitleheight/2, title=\@codeBlockFontSize #6}
    }
    \IfNoValueTF{#2}{
        \def\first{1}
        \def\last{default}
    }{
        \providecommand{\lineInputParser}[2]{
            \def\first{##1}
            \def\last{##2}
        }
        \lineInputParser #2
    }

    \begin{tcolorbox}[
        enhanced, boxsep=0em, boxrule=1pt, colframe=gray!50, left=3mm, right=3mm, top=0.5em, bottom=0.5em,
        colback=codeBG, breakable, pad at break=0.5em, attach boxed title to top right={yshift=-0.4mm, xshift=-10mm},
        boxed title style={skin=enhancedfirst jigsaw, valign=center, top=0.1em, bottom=0.1em, colback=gray!25},
        center title, hbox boxed title, coltitle=gray
    ]
    \inputminted[firstline=\first, lastline=\last, highlightlines={#4}]{#5}{#3}
    \end{tcolorbox}

    \IfBooleanT{#1}{
        \tcbset{before skip=0.5\baselineskip+2pt, title={}}
    }
}
\NewDocumentCommand \readPython { s > {\SplitArgument{1}{-}} o m O{} O{Python} }{
    \processRead{#1}{#2}{#3}{#4}{python}{{\JBNF\symbol{"F0320}}\hspace{1em}\raisebox{0.25em}{#5}}
}
\NewDocumentCommand \readTxt { s > {\SplitArgument{1}{-}} o m O{} O{Console} }{
    \processRead{#1}{#2}{#3}{#4}{text}{{\JBNF\symbol{"F489}}\hspace{1em}\raisebox{0.25em}{#5}}
}
%----------------------------------------------------------------------------%
% defination of document specific functions
\ifthenelse{\equal{\@docOption}{note}}{
    % environment for Theorems (note)
    % usage: \begin{theorems} ... \end{theorems}
    \newenvironment{theorems}{\titleformat{\subsection}[hang]{\large\bf\Chalkboard}{\color{blue}Theorem \arabic{subsection}}{1em}{}[]}
        {\titleformat{\subsection}[hang]{\large\bf\Chalkboard}{\arabic{section}.\arabic{subsection}.}{1em}{}[]}
    % define new tcolorbox environment
    % usage: \begin{...} (\tcblower) \end{...}
    \newtcolorbox{MnV}{colback=SeaGreen!10!CornflowerBlue!10, colframe=RoyalPurple!50!Aquamarine!100!, fonttitle=\bfseries,
        sidebyside, halign=flush center, halign lower=flush center, title={\Chalkboard Mean and Variance}}
    \newtcolorbox{red}[1]{colback=red!5!white, colframe=red!75!black, fonttitle=\bfseries, title={\Chalkboard #1},
        before upper=\setlength{\parindent}{4.5mm}}
    \newenvironment{remarks}{\begin{itemize}}{\end{itemize}}
    \tcolorboxenvironment{remarks}{enhanced, colbacktitle=Apricot!15!white, colback=Apricot!15!white, borderline west={1mm}{0pt}{Salmon!75!Black},
        boxrule=0mm, frame hidden, fonttitle=\bfseries, coltitle=Salmon!75!Black, title={\Chalkboard Remarks}, left=1.5em, lefttitle=1.5em,
        top=0.5mm, toptitle=0.5mm, bottomtitle=0mm, before skip=0.5em, after skip=0.5em, sharp corners, breakable}
    \newenvironment{numbered_remarks}{\begin{enumerate}}{\end{enumerate}}
    \tcolorboxenvironment{numbered_remarks}{enhanced, colbacktitle=Apricot!15!white, colback=Apricot!15!white, borderline west={1mm}{0pt}{Salmon!75!Black},
        boxrule=0mm, frame hidden, fonttitle=\bfseries, coltitle=Salmon!75!Black, title={\Chalkboard Remarks}, left=1.5em, lefttitle=1.5em,
        top=0.5mm, toptitle=0.5mm, bottomtitle=0mm, before  skip=0.5em, after skip=0.5em, sharp corners, breakable}
}{}
%----------------------------------------------------------------------------%
