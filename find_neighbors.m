function neighbor_matrix = find_neighbors(split_img,nb_regions)
%% initialise neighbor structure
neighbor_matrix(nb_regions).region=0;
neighbor_matrix(nb_regions).neighbors=[];
%% padding the region map with 0s
padded_split=zeros(258,130);
padded_split(2:257,2:129)=split_img;
%% detecting region edges
%prewitt works best, no thinning because it creates holes in the edges
BW = edge(padded_split,'prewitt',0,'both','nothinning');
%find the pixels that form the edges
[r,c]=find(BW==1);
for i = 1 : length(r)
    %ignore region 0
    if(padded_split(r(i),c(i))~=0)
        neighbor_matrix(padded_split(r(i),c(i))).region=padded_split(r(i),c(i));
        n_vect=sort([padded_split(r(i)-1,c(i)),padded_split(r(i)+1,c(i)),padded_split(r(i),c(i)-1),padded_split(r(i),c(i)+1)]);
        neighbor_matrix(padded_split(r(i),c(i))).neighbors=[neighbor_matrix(padded_split(r(i),c(i))).neighbors,n_vect];
        %this is hella slow
        neighbor_matrix(padded_split(r(i),c(i))).neighbors=unique(neighbor_matrix(padded_split(r(i),c(i))).neighbors);
        neighbor_matrix(padded_split(r(i),c(i))).neighbors=neighbor_matrix(padded_split(r(i),c(i))).neighbors(neighbor_matrix(padded_split(r(i),c(i))).neighbors~=0);
        neighbor_matrix(padded_split(r(i),c(i))).neighbors=neighbor_matrix(padded_split(r(i),c(i))).neighbors(neighbor_matrix(padded_split(r(i),c(i))).neighbors~=padded_split(r(i),c(i)));
    end
end
end