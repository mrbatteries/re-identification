function [remove_ops,merged_img_rr]=remove_small_regions(merged_img,size_limit)
%% variable initialisation
merged_img_rr=merged_img;
remove_ops=0;
region_sizes=zeros(max(max(merged_img)),2);
%% find out the existing regions and their sizes
for a = 1 : max(max(merged_img))
        [row,~]=find(merged_img==a);
        region_sizes(a,2)=length(row);
        region_sizes(a,1)=a;
end
%sort the sizes vector, it makes the while condition easierr
[sorted_region_sizes(:,2),sorted_region_sizes(:,1)]=sort(region_sizes(:,2));
%% removing small regions
i=1;
while(sorted_region_sizes(i,2)<size_limit)
     [row,col]=find(merged_img==sorted_region_sizes(i,1));
     merged_img_rr(sub2ind(size(merged_img_rr),row',col'))=-1;
     i=i+1;
end
end
