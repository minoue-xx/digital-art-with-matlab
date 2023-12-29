function parallaxPlotIncrement(img1, img2)
% PARAKKAXPLOT(IMG1, IMG2) - Plot scatter points that shows the black
% and white IMG1 with IMG2 hidden behind IMG1 pixels.
% Rotating the axes around Z will reveal IMG2, and hide IMG1 behind IMG2.

arguments
    img1 (:,:) double
    img2 (:,:) double
end

[ verts1(:,2), verts1(:,1) ] = find(img1);
[ verts2(:,2), verts2(:,1) ] = find(img2);

verts3 = verts1;
verts3(:,3) = -1; % Starts with img1, add Z values.  -1 means not used


hs = scatter3(verts3(:,1), verts3(:,3), verts3(:,2), 30, 'w', 'Marker','.');
view([ 0 0 ]);
axis vis3d padded on
box on
daspect([1 1 1]);
xticks([]);
yticks([]);
zticks([]);
xlim([-2,65])
ylim([-2,65])
zlim([-2,65])
set(gca,'ZDir','reverse',...
    'Color','none',...
    'BoxStyle','full',...
    'XColor',[.5 .5 .5],...
    'YColor',[.5 .5 .5],...
    'ZColor',[.5 .5 .5]);
set(gcf,'Color','black');



filename = 'demo_sample_increment.gif'; % Specify the output file name

frame = getframe(gcf); % Figure 画面をムービーフレーム（構造体）としてキャプチャ
tmp = frame2im(frame); % 画像に変更
[A,map] = rgb2ind(tmp,128); % RGB -> インデックス画像に
imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',0.1);
imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.4);


pause(1)
angles = linspace(0,-90,20);
for ii=1:10
    view([ angles(ii) -(cosd(angles(ii)*4)-1)*5 ]);
    drawnow
    frame = getframe(gcf); % Figure 画面をムービーフレーム（構造体）としてキャプチャ
    tmp = frame2im(frame); % 画像に変更
    [A,map] = rgb2ind(tmp,128); % RGB -> インデックス画像に
    imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.075);

end
imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.3);
% for idx=linspace(0,90,50)
%     view([ idx (cosd(idx*4)-1)*5 ]);
%     drawnow
% end

for idx = 1:height(verts2)
    % idx = 1;
    verts3 = parallaxIncrement(verts1, verts2, idx, false, verts3);

    hs.XData = verts3(:,1);
    hs.YData = verts3(:,3);
    hs.ZData = verts3(:,2);


    if idx == ceil(height(verts2)*0.25)
        for ii=10:-1:1
            view([ angles(ii) -(cosd(angles(ii)*4)-1)*5 ]);
            drawnow
            frame = getframe(gcf); % Figure 画面をムービーフレーム（構造体）としてキャプチャ
            tmp = frame2im(frame); % 画像に変更
            [A,map] = rgb2ind(tmp,128); % RGB -> インデックス画像に
            imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.1);

        end
    end

    if idx == ceil(height(verts2)*0.30)
        for ii=1:20
            view([ angles(ii) -(cosd(angles(ii)*4)-1)*5 ]);
            drawnow
            frame = getframe(gcf); % Figure 画面をムービーフレーム（構造体）としてキャプチャ
            tmp = frame2im(frame); % 画像に変更
            [A,map] = rgb2ind(tmp,128); % RGB -> インデックス画像に
            imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.1);

        end
    end

    if idx == ceil(height(verts2)*0.60)
        for ii=20:-1:12
            view([ angles(ii) -(cosd(angles(ii)*4)-1)*5 ]);
            drawnow
            frame = getframe(gcf); % Figure 画面をムービーフレーム（構造体）としてキャプチャ
            tmp = frame2im(frame); % 画像に変更
            [A,map] = rgb2ind(tmp,128); % RGB -> インデックス画像に
            imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.1);

        end
    end



    if idx < ceil(height(verts2)*0.60) && mod(idx,10) == 0
        drawnow
        frame = getframe(gcf); % Figure 画面をムービーフレーム（構造体）としてキャプチャ
        tmp = frame2im(frame); % 画像に変更
        [A,map] = rgb2ind(tmp,128); % RGB -> インデックス画像に
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.075);
    elseif idx > ceil(height(verts2)*0.60) && mod(idx,50) == 0
        drawnow
        frame = getframe(gcf); % Figure 画面をムービーフレーム（構造体）としてキャプチャ
        tmp = frame2im(frame); % 画像に変更
        [A,map] = rgb2ind(tmp,128); % RGB -> インデックス画像に
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.075);
    end

end


for ii=12:-1:1
    view([ angles(ii) -(cosd(angles(ii)*4)-1)*5 ]);
    drawnow
    frame = getframe(gcf); % Figure 画面をムービーフレーム（構造体）としてキャプチャ
    tmp = frame2im(frame); % 画像に変更
    [A,map] = rgb2ind(tmp,128); % RGB -> インデックス画像に
    imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.1);

end

pause(1)
imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.4);
for ii=1:20
    view([ angles(ii) -(cosd(angles(ii)*4)-1)*5 ]);
    drawnow
    frame = getframe(gcf); % Figure 画面をムービーフレーム（構造体）としてキャプチャ
    tmp = frame2im(frame); % 画像に変更
    [A,map] = rgb2ind(tmp,128); % RGB -> インデックス画像に
    imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.05);

end
imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.2);
imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.2);

for ii=20:-1:1
    view([ angles(ii) (cosd(angles(ii)*4)-1)*5 ]);
    drawnow
    frame = getframe(gcf); % Figure 画面をムービーフレーム（構造体）としてキャプチャ
    tmp = frame2im(frame); % 画像に変更
    [A,map] = rgb2ind(tmp,128); % RGB -> インデックス画像に
    imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.05);

end
imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.2);



end

function verts3 = parallaxIncrement(v1, v2, idx, flag, v3)
% Convert img1 and img2 into a single set of vertices
% which represent BOTH images, where 1 image is hidden behind
% the other, but revealed with a view change.

verts3 = v3;
%     verts3(:,3) = -1; % Starts with img1, add Z values.  -1 means not used

% Basic idea:  V1 is the image we first show, this is the reference image.
% For each vertex in V2, find an unused vertrc in V1 at the same Y and set Z to the X.
% If NO MATCH, we need to add a new vertex

% First find points that haven't been used yet.
match = find_matching_index(verts3, v2, idx, 'unused');

if match
    % We have a match, set Z of a random pt in img1 to x of img2.
    verts3(match,3) = v2(idx,1);
else
    % We have no matches.  Look for existing matches of the Y coord, and hide
    % our new point behind that.
    match = find_matching_index(verts3, v2, idx, 'any');
    if match
        % We found at least one, so hide this new pixel behind one of them
        verts3(end+1,:) = [ verts3(match,1) v2(idx,2) v2(idx,1) ]; %#ok
    else
        % No match - hide this in the margins
        verts3(end+1,:) = [ -1 v2(idx,2) v2(idx,1) ]; %#ok
    end
end

% Lastly, find points from the first image (V1) that don't already
% have a corresponding point from the second image (V2), and move
% them behind other points in V2.
% Note: All points from V2 are now in our destination image VERTS3.
if flag
    lost = find(verts3(:,3)==-1);
    for lidx = 1:numel(lost)
        idx = lost(lidx);
        % Only find used points since we are finding homes for unused points.
        match = find_matching_index(verts3, verts3, idx, 'used');
        if match
            verts3(idx,3) = verts3(match,3);
        else
            % Just ignore it.
        end
    end
end

end

function match = find_matching_index(dest, src, idx, flag)
% For the DEST image, find a random vertex in DEST that matches the
% SRC image point at IDX.
% If UNUSED is true, make sure the found vertex has not be used already.
mask = dest(:,2)==src(idx,2);
switch flag
    case 'unused'
        % Only match vertices not yet used.
        mask = mask & dest(:,3)==-1;
    case 'used'
        % Only match vertices that have been used.
        mask = mask & dest(:,3)~=-1;
end
% Get the indices to the found points
match_indices = find(mask);
if isempty(match_indices)
    match = 0;
else
    % Of the found points, find a random vertex from that list.
    match = match_indices(randi(numel(match_indices)));
end
end