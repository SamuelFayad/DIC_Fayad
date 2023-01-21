function chi = cost_fun(alpha_opt,subset,point_of_interest,def_interp,ref)
linearIndex = sub2ind(size(ref),subset.points_y(:)+  point_of_interest(2), subset.points_x(:)+ point_of_interest(1));

chi = sum((def_interp(subset.shape_fun*alpha_opt(1:end/2) +subset.points_y(:) + point_of_interest(2),...
    subset.shape_fun*alpha_opt(end/2+1:end) + subset.points_x(:) + point_of_interest(1))-...
    ref(linearIndex)).^2);
end