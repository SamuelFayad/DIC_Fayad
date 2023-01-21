function subset_struct = create_subset(subset_info)


if strcmp(subset_info.shape,'circle')
else % make it a square
    subset_struct.points_x = (-(subset_info.size-1)/2:(subset_info.size-1)/2).*ones(subset_info.size);
    subset_struct.points_y = subset_struct.points_x';
end

if strcmp(subset_info.shape_function,'quadratic')
else
    subset_struct.shape_fun = [ones(size(subset_struct.points_x(:))) subset_struct.points_x(:) subset_struct.points_y(:)];
    subset_struct.order = 6;
 
end

end