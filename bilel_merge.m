function [merged_img,merge_operations]= bilel_merge(img,split_img,neighbor_matrix)
%initialisation des variables
merged_img=zeros(256,128);
merge_operations=0;
%déterminer les régions existantes
existing_regions=unique(split_img(:))';
%calculer la couleur moyenne des régions
region_mean_colors=zeros(size(existing_regions,2),3);
for i = existing_regions
    [row,col]=find(split_img==i);
    region_colors=zeros(length(row),3);
    for k = 1:3
        index=sub2ind([256 128 3],row',col',k*ones(1,length(row)));
        region_colors(:,k)=img(index);
    end
    region_mean_colors(i,1:3)=mean(region_colors);
end
%merge des régions
region_treatment_status=zeros(1,length(existing_regions));
for i = existing_regions
    if region_treatment_status(i)==1
        continue;
    else
        neighbors=neighbor_matrix(i).neighbors;
        [row,col]=find(split_img==i);
        merged_img(sub2ind(size(img),row',col'))=i;
        region_treatment_status(i)=1;
        for j = neighbors
            dist_r=(region_mean_colors(i,1)-region_mean_colors(j,1))^2;
            dist_g=(region_mean_colors(i,2)-region_mean_colors(j,2))^2;
            dist_b=(region_mean_colors(i,3)-region_mean_colors(j,3))^2;
            dist=sqrt(dist_r+dist_g+dist_b);
            if dist < 16
                [rowj,colj]=find(split_img==j);
                merged_img(sub2ind(size(img),rowj',colj'))=i;
                region_treatment_status(j)=1;
                merge_operations=merge_operations+1;
            end
        end
    end
end
end