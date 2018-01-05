function [remove_ops,merged_img_rr]=remove_small_regions(merged_img,size_limit,neighbor_matrix)
merged_img_rr=merged_img;
remove_ops=0;
region_sizes=zeros(max(max(merged_img)),2);
for a = 1 : max(max(merged_img))
        [row,~]=find(merged_img==a);
        region_sizes(a,2)=length(row);
        region_sizes(a,1)=a;
end
[sorted_region_sizes(:,2),sorted_region_sizes(:,1)]=sort(region_sizes(:,2));
i=1;
while(sorted_region_sizes(i,2)<size_limit)
    fprintf('region number :%d \n',sorted_region_sizes(i,1));
    fprintf('region   size :%d \n',sorted_region_sizes(i,2));
    neighbor_sizes=[];
    neighbor_sizes(:,1)=neighbor_matrix(sorted_region_sizes(i,1)).neighbors;
    neighbor_sizes(:,2)=region_sizes(neighbor_sizes(:,1),2);
    fprintf('neighbor numbers :%d \n',neighbor_sizes(:,1));
    fprintf('neighbor   sizes :%d \n',neighbor_sizes(:,2));
    [~,biggest_neighbor_index]=max(neighbor_sizes(:,2));
    fprintf('biggest neighbor is %d \n',neighbor_sizes(biggest_neighbor_index,1));
    [row,col]=find(merged_img==i);
    merged_img_rr(sub2ind(size(merged_img_rr),row',col'))=neighbor_sizes(biggest_neighbor_index,1);
    i=i+1;
    remove_ops=remove_ops+1;
end
% % k=1;
% % for i = 1 : max(max(merged_img_rr))
% %     [row,col]=find(merged_img_rr==i);
% %     if (isempty(row)==0)
% %         merged_img_rr(sub2ind(size(merged_img_rr),row',col'))=k;
% %         k=k+1;
% %     end
% % end
end
