function [split_img,nb_regions]=bilel_split(img,region_id)
%%initialisation des variables
x_half=fix(size(img,1)/2);
y_half=fix(size(img,2)/2);
%incr�menter le oompteur de r�gion
region_id=region_id+1;
%nb_regions=region_id;
%si la taille minimum est atteinte, affecter la r�gion et incr�menter le
%compteur
if (size(img,1)<=2 || size(img,2)<=1)
    split_img=region_id;
    region_id=region_id+1;
    nb_regions=region_id;
else
    %v�rifier si un split doit se faire
    split_check=color_check(img);
    %pas de split, affecter la r�gion et incr�menter la r�gion
    if split_check==0
        split_img=region_id;
        region_id=region_id+1;
        nb_regions=region_id;
    else
    %split, diviser la r�gion en 4 et appeler cette fonction r�cursivement
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
%retourner le nombre de r�gions actuel
nb_regions=region_id;
end