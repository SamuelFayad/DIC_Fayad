function px_exclude = ROI(ref)

f = figure;
imagesc(uint8(ref)), colormap gray, axis equal
title('Draw Exclusion')
[~,j_px_exclude,i_px_exclude] = roipoly(); % this has the option of other ROI types
delete(f)

px_exclude.i_px = i_px_exclude;
px_exclude.j_px = j_px_exclude;
end
