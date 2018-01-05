function [split_img,nb_regions]=bilel_split(img,region_id)
%%initialisation des variables
x_half=fix(size(img,1)/2);
y_half=fix(size(img,2)/2);
%incrémenter le oompteur de région
region_id=region_id+1;
%nb_regions=region_id;
%si la taille minimum est atteinte, affecter la région et incrémenter le
%compteur
if (size(img,1)<=2 || size(img,2)<=1)
    split_img=region_id;
    region_id=region_id+1;
    nb_regions=region_id;
else
    %vérifier si un split doit se faire
    split_check=color_check(img);
    %pas de split, affecter la région et incrémenter la région
    if split_check==0
        split_img=region_id;
        region_id=region_id+1;
        nb_regions=region_id;
    else
    %split, diviser la région en 4 et appeler cette fonction récursivement
        [split_img(1:x_half,1:y_half),tmp_regions]=bilel_split(img(1:x_half,1:y_half,1:3),region_id);
        nb_regions=region_id;
        region_id=tmp_regions+1;
        [split_img(1:x_half,y_half+1:size(img,2)),tmp_regions]=bilel_split(img(1:x_half,y_half+1:size(img,2),1:3),region_id);
        nb_regions=region_id;
        region_id=tmp_regions+1;
        [split_img(x_half+1:size(img,1),1:y_half),tmp_regions]=bilel_split(img(x_half+1:size(img,1),1:y_half,1:3),region_id);
        nb_regions=region_id;
        region_id=tmp_regions+1;
        [split_img(x_half+1:size(img,1),y_half+1:size(img,2)),tmp_regions]=bilel_split(img(x_half+1:size(img,1),y_half+1:size(img,2),1:3),region_id);
        region_id=tmp_regions+1;
        nb_regions=region_id;
    end
end
%retourner le nombre de régions actuel
nb_regions=region_id;
end