%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a test function for the feature extraction from a split merged  %
% image                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% set horizontal weights
head_x_weights=-(((-64:64)/64).^2)+1;
torso_x_weights=-(((-64:64)/64).^2)+1;
legs_x_weights=-(((-64:64)/64).^2)+1;
feet_x_weights=-(((-64:64)/64).^2)+1;
%% set vertical weights
head_y_weights=[ones(1,32),1:-1/16:0,zeros(1,256-49)];
torso_y_weights=[0:1/32:1,ones(1,128-33),1:-1/32:0,zeros(1,256-161)];
legs_y_weights=[zeros(1,96),0:1/32:1,ones(1,223-129),1:-1/32:0];
feet_y_weights=[zeros(1,208),0:1/16:1,ones(1,256-225)];
%% multiply the weight vectors to get weight matrices
head_weight_matrix=head_y_weights'*head_x_weights;
torso_weight_matrix=torso_y_weights'*torso_x_weights;
legs_weight_matrix=legs_y_weights'*legs_x_weights;
feet_weight_matrix=feet_y_weights'*feet_x_weights;
%% variable initialization
len=max(max(merged_img_rr));
region_mean_colors=zeros(len-2,3);
head_regions=zeros(len,1);
torso_regions=zeros(len,1);
legs_regions=zeros(len,1);
feet_regions=zeros(len,1);
%% calculate weighted region occurences for each body segment
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
%% reduce the importance of regions that are on the left and right borders of the image
side_regions=unique(merged_img_rr(:,[1 128]));
side_regions=side_regions(side_regions~=-1);
head_regions(side_regions)=head_regions(side_regions)*0.25;
torso_regions(side_regions)=torso_regions(side_regions)*0.25;
legs_regions(side_regions)=legs_regions(side_regions)*0.25;
feet_regions(side_regions)=feet_regions(side_regions)*0.25;
%% sort the weighted region occurrences
[hr(:,1),hr(:,2)]=sort(head_regions);
[tr(:,1),tr(:,2)]=sort(torso_regions);
[lr(:,1),lr(:,2)]=sort(legs_regions);
[fr(:,1),fr(:,2)]=sort(feet_regions);
%% get the mean colors for each regions
for i = 1:len-2
    [row,col]=find(merged_img_rr==i);
    region_colors=zeros(length(row),3);
    for k = 1:3
        index=row+(col-1)*size(img,1)+(k-1)*size(img,1)*size(img,2); 
        region_colors(:,k)=img(index);
    end
    region_mean_colors(i,1:3)=mean(region_colors);
end
%% construct the feature vector from the mean colors of the 5 dominant regions in each body segment
%feature vector=[head r1 g1 b1 r2 b2 g2 ... r5 b5 g5 torso r1 g1 b1 ... r5
%g5 b5 legs r1 g1 b1 ... r5 g5 b5 feet r1 g1 b1 ... r5 b5 g5]
feature_vector=[region_mean_colors(hr(end:-1:end-4,2)-2,1:3);region_mean_colors(tr(end:-1:end-4,2)-2,1:3);region_mean_colors(lr(end:-1:end-4,2)-2,1:3);region_mean_colors(fr(end:-1:end-4,2)-2,1:3)];
feature_vector=reshape(feature_vector',[],1);
feature_vector=feature_vector/255;