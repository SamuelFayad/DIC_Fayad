function def = upload_def_images()

f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]); %create a dummy figure so that uigetfile doesn't minimize our GUI
[FILENAME_DEF, PATHNAME_DEF] = uigetfile('*.*','Select deformed images','Multiselect','on');
delete(f); %delete the dummy figure

if iscell(FILENAME_DEF)
for image_ind = 1:size(FILENAME_DEF,2)
    % bug noticed, if single image, it indexes by character not string
    def(:,:,image_ind) = double(imread(char(strcat(PATHNAME_DEF,'\',FILENAME_DEF{image_ind}))));
end
else
    def = double(imread(char(strcat(PATHNAME_DEF,'\',FILENAME_DEF))));
    
end
end