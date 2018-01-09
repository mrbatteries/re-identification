head_x_weights=-(((-64:64)/64).^2)+1;
torso_x_weights=-(((-64:64)/64).^2)+1;
legs_x_weights=-(((-64:64)/64).^2)+1;
feet_x_weights=-(((-64:64)/64).^2)+1;
head_y_weights=[ones(1,32),1:-1/16:0,zeros(1,256-49)];
torso_y_weights=[0:1/32:1,ones(1,128-33),1:-1/32:0,zeros(1,256-161)];
legs_y_weights=[zeros(1,96),0:1/32:1,ones(1,223-129),1:-1/32:0];
feet_y_weights=[zeros(1,208),0:1/16:1,ones(1,256-225)];
head_weight_matrix=head_y_weights'*head_x_weights;
torso_weight_matrix=torso_y_weights'*torso_x_weights;
legs_weight_matrix=legs_y_weights'*legs_x_weights;
feet_weight_matrix=feet_y_weights'*feet_x_weights;
len=max(max(merged_img_rr));
head_regions=zeros(len,1);
torso_regions=zeros(len,1);
legs_regions=zeros(len,1);
feet_regions=zeros(len,1);
for i = 1:256
        for j = 1:128
            px_regions=merged_img_rr(i,j);
            if (px_regions~=-1)
                head_regions(px_regions)=head_regions(px_regions)+1*head_weight_matrix(i,j);
                torso_regions(px_regions)=torso_regions(px_regions)+1*torso_weight_matrix(i,j);
                legs_regions(px_regions)=legs_regions(px_regions)+1*legs_weight_matrix(i,j);
                feet_regions(px_regions)=feet_regions(px_regions)+1*feet_weight_matrix(i,j);
            end
        end
end
[hr(:,1),hr(:,2)]=sort(head_regions);
[tr(:,1),tr(:,2)]=sort(torso_regions);
[lr(:,1),lr(:,2)]=sort(legs_regions);
[fr(:,1),fr(:,2)]=sort(feet_regions);
for i = 1:len-2
    [row,col]=find(merged_img_rr==i);
    region_colors=zeros(length(row),3);
    for k = 1:3
        index=row+(col-1)*size(img,1)+(k-1)*size(img,1)*size(img,2); 
        region_colors(:,k)=img(index);
    end
    region_mean_colors(i,1:3)=mean(region_colors);
end
%feature vector=[head r1 g1 b1 r2 b2 g2 ... r5 b5 g5 torso r1 g1 b1 ... r5
%g5 b5 legs r1 g1 b1 ... r5 g5 b5 feet r1 g1 b1 ... r5 b5 g5]
feature_vector=[region_mean_colors(hr(end:-1:end-4,2),1:3);region_mean_colors(tr(end:-1:end-4,2),1:3);region_mean_colors(lr(end:-1:end-4,2),1:3);region_mean_colors(fr(end:-1:end-4,2),1:3)];
feature_vector=reshape(feature_vector',[],1);
feature_vector=feature_vector/255;