function rslt = color_check(img)
    %% variable initialisation
    % change the image variable type to avoid the rounding when using uint8
    img=cast(img,'double');
    color_cube=zeros(4,4,4);
    near_px=0;
    img_size=size(img,1)*size(img,2);
    %% find the mean color in the image
    mean_color=mean(mean(img));
    mean_color=[mean_color(:,:,1),mean_color(:,:,2),mean_color(:,:,3)];
    mean_color=fix(mean_color./64)+1;
    %% fill out the "color cube" with the number of occurences of colors in
    %% the image
    for i = 1:size(img,1)
        for j = 1:size(img,2)
            px_r=fix(img(i,j,1)/64);
            px_g=fix(img(i,j,2)/64);
            px_b=fix(img(i,j,3)/64);
            color_cube(px_r+1,px_g+1,px_b+1)=color_cube(px_r+1,px_g+1,px_b+1)+1;
        end
    end
    %% calculate the number of pixels with a color near the mean color
    near_px=near_px+color_cube(mean_color(1),mean_color(2),mean_color(3));
    if mean_color(1)<4
        near_px=near_px+color_cube(mean_color(1)+1,mean_color(2),mean_color(3));
    end
    if mean_color(1)>1
        near_px=near_px+color_cube(mean_color(1)-1,mean_color(2),mean_color(3));
    end
    if mean_color(2)<4
        near_px=near_px+color_cube(mean_color(1),mean_color(2)+1,mean_color(3));
    end
    if mean_color(2)>1
        near_px=near_px+color_cube(mean_color(1),mean_color(2)-1,mean_color(3));
    end
    if mean_color(3)<4
        near_px=near_px+color_cube(mean_color(1),mean_color(2),mean_color(3)+1);
    end
    if mean_color(3)>1
        near_px=near_px+color_cube(mean_color(1),mean_color(2),mean_color(3)-1);
    end
    %% check if the number of pixels verifies the condition
    if(near_px<0.9*img_size)
        rslt=1;
    else
        rslt=0;
    end
end