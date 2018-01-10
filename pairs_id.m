clc
clear
%initialisation des variables
idss=zeros(1853,9);
%% chemin des caméras
maindir=dir('E:\PFE\databases\DukeReID-master\ReID');
for i = 1:8
    istr=num2str(i);
    campath(i,:)=eval(['(''E:\PFE\databases\DukeReID-master\ReID\cam',istr,''');']);
end
%% détection des identités présentes dans la database
for p = 1:8
    %chemin de la caméra i
    tmpdir=dir(campath(p,:));
    %détection des identités dans la caméra i
    for i = 3:length(tmpdir)
        tmpids(i)=str2double(tmpdir(i).name);
    end
    %stockage du chemin et des identités
    persdir{p}=tmpdir;
    ids{p}=tmpids;
    clearvars('tmpids');
end
%% tri du vecteur identités
idss=[ids{1},ids{2},ids{3},ids{4},ids{5},ids{6},ids{7},ids{8}];
idss=sort(idss);
idss=unique(idss);
idss=idss';
%% détection des identités présentes dans chaque caméra
for p = 1:8
    % identités présentes dans la caméra p
    tmpids=ids{p};
    for i = 3:length(tmpids)
        % recherche de l'identité i dans le vecteur des identités
        lin=find(idss == tmpids(i));
        % écrire 1 dans la ligne qui correspond à l'identité i
        if (isempty(lin) ~= 1)
            if (size(lin,1) > 1)
                idss(tmpids(i)+1,p+1)=1;
            else
                idss(lin,p+1)=1;
            end
        end
    end
end
%sauvegarder les résultats
save('ids_tables.mat','idss');

