function [merged_img,merge_operations]= bilel_merge(img,split_img,neighbor_matrix)
%% initialise variables
merged_img=zeros(256,128);
merge_operations=0;
% find existing regions
existing_regions=unique(split_img(:))';
%% compute mean colors of regions
region_mean_colors=zeros(size(existing_regions,2),3);
for i = existing_regions
    [row,col]=find(split_img==i);
    region_colors=zeros(length(row),3);
    for k = 1:3
        %index=sub2ind([256 128 3],row,col,k*ones(length(row),1));
        index=row+(col-1)*size(img,1)+(k-1)*size(img,1)*size(img,2); 
        region_colors(:,k)=img(index);
    end
    region_mean_colors(i,1:3)=mean(region_colors);
end
%%merge the regions that satisfy the conditions
region_treatment_status=zeros(1,length(existing_regions));
for i = existing_regions
    %if the region is already merged, contine
    if region_treatment_status(i)==1
        continue;
    else
        %get the regions pixels and it's neighbors
        neighbors=neighbor_matrix(i).neighbors;
        [row,col]=find(split_img==i);
        %add the regions pixels to the new region map
        merged_img(sub2ind(size(img),row,col))=i;
        %mark the region as treated
        region_treatment_status(i)=1;
        for j = neighbors
            %find the distance between the mean colors of the region and
            %it's neighbors
            dist_r=(region_mean_colors(i,1)-region_mean_colors(j,1))^2;
            dist_g=(region_mean_colors(i,2)-region_mean_colors(j,2))^2;
            dist_b=(region_mean_colors(i,3)-region_mean_colors(j,3))^2;
            dist=sqrt(dist_r+dist_g+dist_b);
            %if the distance is small enough, merge.
            if dist < 16
                %add the pixels of the neighbor to merge to the new map as
                %pixels of the region being currently treated
                [rowj,colj]=find(split_img==j);
                indexj=rowj+(colj-1)*size(img,1);
                merged_img(indexj)=i;
                %count the merged region as treated
                region_treatment_status(j)=1;
                %increment the merge ops counter
                merge_operations=merge_operations+1;
            end
        end
    end
end
end