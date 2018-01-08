function [split_img,nb_regions]=bilel_split(img,region_id)
%%variable initialisation
x_half=fix(size(img,1)/2);
y_half=fix(size(img,2)/2);
%increase region id counter
region_id=region_id+1;
%nb_regions=region_id;
%if region size is at minimum size, assign region counter and increment id
%counter
if (size(img,1)<=8 || size(img,2)<=4)
    split_img=region_id;
    region_id=region_id+1;
    nb_regions=region_id;
else
    %check if a split is necessary
    split_check=color_check(img);
    %no split, assign region and increment id counter
    if split_check==0
        split_img=region_id;
        region_id=region_id+1;
        nb_regions=region_id;
    else
    %split necessary, divide the region to 4 subregion and apply this
    %function to each subregion
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
%return the current number of regions
nb_regions=region_id;
end