function neighbor_matrix = find_neighbors(split_img,nb_regions)
%initialiser la structure des neighbors
neighbor_matrix(nb_regions).region=0;
neighbor_matrix(nb_regions).neighbors=[];
%ajout de 0 aux bords de l'image pour faciliter le travail aux bords
padded_split=zeros(258,130);
padded_split(2:257,2:129)=split_img;
%détection des bords des régions
BW = edge(padded_split,'prewitt',0,'both','nothinning');
[r,c]=find(BW==1);
for i = 1 : length(r)
    %ignorer la région 0 
    if(padded_split(r(i),c(i))~=0)
        neighbor_matrix(padded_split(r(i),c(i))).region=padded_split(r(i),c(i));
        n_vect=sort([padded_split(r(i)-1,c(i)),padded_split(r(i)+1,c(i)),padded_split(r(i),c(i)-1),padded_split(r(i),c(i)+1)]);
        neighbor_matrix(padded_split(r(i),c(i))).neighbors=[neighbor_matrix(padded_split(r(i),c(i))).neighbors,n_vect];
        neighbor_matrix(padded_split(r(i),c(i))).neighbors=unique(neighbor_matrix(padded_split(r(i),c(i))).neighbors);
        neighbor_matrix(padded_split(r(i),c(i))).neighbors=neighbor_matrix(padded_split(r(i),c(i))).neighbors(neighbor_matrix(padded_split(r(i),c(i))).neighbors~=0);
        neighbor_matrix(padded_split(r(i),c(i))).neighbors=neighbor_matrix(padded_split(r(i),c(i))).neighbors(neighbor_matrix(padded_split(r(i),c(i))).neighbors~=padded_split(r(i),c(i)));
    end
end
end