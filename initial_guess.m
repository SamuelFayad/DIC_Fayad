function initial_guess_param = initial_guess(image_ind,found_parameters)

if image_ind == 1
    initial_guess_param = found_parameters(:,:,image_ind);
else
    initial_guess_param = found_parameters(:,:,image_ind-1);
end
end