clc, clear
%% read and resize image
img=imread('ssearch_test.jpg');
img=imresize(img,[256 128]);
%% split the image
[split_img,~]=bilel_split(img,1);
nb_regions=max(max(split_img));
%% reorder the region numbers, makes the work much easier
k=1;
for i = 1 : nb_regions
    [row,col]=find(split_img==i);
    if (isempty(row)==0)
        index=row+(col-1)*size(img,1);
        split_img(index)=k;
        k=k+1;
    end 
end
%% esablish a matrix of every region's neighbors
nb_regions=max(max(split_img));
neighbor_matrix = find_neighbors(split_img,nb_regions);
%% merge the split image
merge_operations=999;
merged_img=split_img;
%if no merge operations happened, that means the merging is finished
while merge_operations > 0
    merge_operations=0;
    %merge function
    [new_merged_img,merge_operations]= bilel_merge(img,merged_img,neighbor_matrix);
    %reorder region numbers, this removes "holes" in the neighbor_matrix
    k=1;
    for m = 1 : max(max(new_merged_img))
        [row,col]=find(new_merged_img==m);
        if (isempty(row)==0)
            index=row+(col-1)*size(img,1);
            merged_img(index)=k;
            k=k+1;
        end
    end
    %compute the new neighbor matrix
    neighbor_matrix = find_neighbors(merged_img,k);
end
%% remove small neghbors
%small region removal function
[remove_operations,merged_img_rr]=remove_small_regions(merged_img,100);
%reorder region numbers
k=1;
for m = 1 : max(max(merged_img_rr))
    [row,col]=find(merged_img_rr==m);
    if (isempty(row)==0)
        index=row+(col-1)*size(img,1);
        merged_img_rr(index)=k;
        k=k+1;
    end
    %compute the new number matrix
    neighbor_matrix = find_neighbors(merged_img,k);
end