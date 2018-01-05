clc, clear all
%% lire et redimensionner l'image
img=imread('ssearch_test.jpg');
img=imresize(img,[256 128]);
%% split
[split_img,~]=bilel_split(img,1);
nb_regions=max(max(split_img));
%ordonner le num des r�gions pour faciliter le travail
k=1;
for i = 1 : nb_regions
    [row,col]=find(split_img==i);
    if (isempty(row)==0)
        split_img(sub2ind(size(split_img),row',col'))=k;
        k=k+1;
    end
end
%% chercher les voisins de chaque r�gion
nb_regions=max(max(split_img));
neighbor_matrix = find_neighbors(split_img,nb_regions);
%% merge
merge_operations=999;
merged_img=split_img;
%si aucune op�ration de merge n'est effectu�e l'it�ration pr�c�dente le
%merge est fini
while merge_operations > 0
    merge_operations=0;
    %merge
    [new_merged_img,merge_operations]= bilel_merge(img,merged_img,neighbor_matrix);
    %r�ordonner le nbre de r�gions
    k=1;
    for m = 1 : max(max(new_merged_img))
        [row,col]=find(new_merged_img==m);
        if (isempty(row)==0)
            merged_img(sub2ind(size(merged_img),row',col'))=k;
            k=k+1;
        end
    end
    %recherche des voisins des nouvelles r�gions
    neighbor_matrix = find_neighbors(merged_img,k);
end
%% �limination des r�gions trop petites
remove_operations=999;
while remove_operations > 0
    remove_operations=0;
    %�liminer les petites r�gions
    [remove_operations,merged_img_rr]=remove_small_regions(merged_img,100,neighbor_matrix);
    %r�ordonner le nbre de r�gions
    k=1;
    for m = 1 : max(max(new_merged_img))
        [row,col]=find(merged_img_rr==m);
        if (isempty(row)==0)
            merged_img(sub2ind(size(merged_img),row',col'))=k;
            k=k+1;
        end
    end
    %recherche des voisins des nouvelles r�gions
    neighbor_matrix = find_neighbors(merged_img,k);
end