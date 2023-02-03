function px_include = ROI(ref)
f = figure;
imagesc(uint8(ref)), colormap gray, axis equal
title('Draw ROI')
[~,j_px_include,i_px_include] = roipoly(); % this has the option of other ROI types
delete(f)
px_include.i_px = i_px_include;
px_include.j_px = j_px_include;
end