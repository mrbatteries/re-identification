head_x_weights=exp(-abs(((1:128) - 64))/64);
torso_x_weights=exp(-abs(((1:128) - 64))/64);
legs_x_weights=exp(-abs(((32.5:0.5:96) - 64))/64);
feet_x_weights=exp(-abs(((32.5:0.5:96) - 64))/64);
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