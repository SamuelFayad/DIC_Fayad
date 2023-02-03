function ref = upload_ref_image()

f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]); %create a dummy figure so that uigetfile doesn't minimize our GUI
[FILENAME_REF, PATHNAME_REF] = uigetfile('*.*','Select reference image');
delete(f); %delete the dummy figure
ref = double(imread(strcat(PATHNAME_REF,'/',FILENAME_REF)));
end
