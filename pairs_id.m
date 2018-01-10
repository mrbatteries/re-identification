clc
clear
%initialisation des variables
idss=zeros(1853,9);
%% chemin des cam�ras
maindir=dir('E:\PFE\databases\DukeReID-master\ReID');
for i = 1:8
    istr=num2str(i);
    campath(i,:)=eval(['(''E:\PFE\databases\DukeReID-master\ReID\cam',istr,''');']);
end
%% d�tection des identit�s pr�sentes dans la database
for p = 1:8
    %chemin de la cam�ra i
    tmpdir=dir(campath(p,:));
    %d�tection des identit�s dans la cam�ra i
    for i = 3:length(tmpdir)
        tmpids(i)=str2double(tmpdir(i).name);
    end
    %stockage du chemin et des identit�s
    persdir{p}=tmpdir;
    ids{p}=tmpids;
    clearvars('tmpids');
end
%% tri du vecteur identit�s
idss=[ids{1},ids{2},ids{3},ids{4},ids{5},ids{6},ids{7},ids{8}];
idss=sort(idss);
idss=unique(idss);
idss=idss';
%% d�tection des identit�s pr�sentes dans chaque cam�ra
for p = 1:8
    % identit�s pr�sentes dans la cam�ra p
    tmpids=ids{p};
    for i = 3:length(tmpids)
        % recherche de l'identit� i dans le vecteur des identit�s
        lin=find(idss == tmpids(i));
        % �crire 1 dans la ligne qui correspond � l'identit� i
        if (isempty(lin) ~= 1)
            if (size(lin,1) > 1)
                idss(tmpids(i)+1,p+1)=1;
            else
                idss(lin,p+1)=1;
            end
        end
    end
end
%sauvegarder les r�sultats
save('ids_tables.mat','idss');

