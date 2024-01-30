% MATLAB implementation of pong wars, the idea is taken from the following (Javascript)
% https://github.com/vnglst/pong-wars/blob/main/index.html
% Idea for Pong wars: https://twitter.com/nicolasdnl/status/1749715070928433161
function pong_wars_4balls
% Define the color palette

% Define 5 colors
colors = lines(5);
COLOR1 = colors(1,:);
COLOR2 = colors(2,:);
COLOR3 = colors(3,:);
COLOR4 = colors(4,:);
BALLCOLOR = colors(5,:);

% Define the figure and axes for the pong game
hFig = figure(Name="Pong Wars | MATLAB", NumberTitle="off", Color="white");
hAx = axes(Parent=hFig, XLim=[0 30], YLim=[0 30]);

% Define square size
SQUARE_SIZE = 1;
INITIAL_SPEED = 0.4;

% Calculate number of squares
numSquaresX = floor(hAx.XLim(2) / SQUARE_SIZE);
numSquaresY = floor(hAx.YLim(2) / SQUARE_SIZE);

% Initialize squares matrix (colored map)
squares = ones(numSquaresX, numSquaresY); % Color1
squares(round(numSquaresX / 2):end,1:round(numSquaresY / 2)-1) = 2; % Color2
squares(1:round(numSquaresX / 2)-1,round(numSquaresY / 2):end) = 3; % Color3
squares(round(numSquaresX / 2):end,round(numSquaresY / 2):end) = 4; % Color4

hIm = imagesc(hAx,squares');
colormap([COLOR1;COLOR2;COLOR3;COLOR4]) % 1,2,3,4

% Delete the axes box
hAx.XColor = "none";
hAx.YColor = "none";

% Initialize ball positions and velocities
% 3 4
% 1 2
x1 = hAx.XLim(2) / 4;
y1 = hAx.YLim(2) / 4;
dx1 = INITIAL_SPEED*2; % 100% up for ball 1
dy1 = -INITIAL_SPEED*2;

x2 = (hAx.XLim(2) / 4) * 3;
y2 = hAx.YLim(2) / 4;
dx2 = -INITIAL_SPEED;
dy2 = INITIAL_SPEED;

x3 = hAx.XLim(2) / 4;
y3 = (hAx.YLim(2) / 4) * 3;
dx3 = -INITIAL_SPEED;
dy3 = INITIAL_SPEED;

x4 = (hAx.XLim(2) / 4) * 3;
y4 = (hAx.YLim(2) / 4) * 3;
dx4 = -INITIAL_SPEED;
dy4 = INITIAL_SPEED;

% Create ball graphics objects
hBall1 = line(x1-SQUARE_SIZE/2, y1-SQUARE_SIZE/2,Marker='o',...
    MarkerSize=10, MarkerFaceColor=BALLCOLOR, MarkerEdgeColor=COLOR1);
hBall2 = line(x2-SQUARE_SIZE/2, y2-SQUARE_SIZE/2,'Marker','o',...
    MarkerSize=10, MarkerFaceColor=BALLCOLOR, MarkerEdgeColor=COLOR2);
hBall3 = line(x3-SQUARE_SIZE/2, y3-SQUARE_SIZE/2,'Marker','o',...
    MarkerSize=10, MarkerFaceColor=BALLCOLOR, MarkerEdgeColor=COLOR3);
hBall4 = line(x4-SQUARE_SIZE/2, y4-SQUARE_SIZE/2,'Marker','o',...
    MarkerSize=10, MarkerFaceColor=BALLCOLOR, MarkerEdgeColor=COLOR4);

% Start the game loop (need refactoring..)
while ishandle(hFig)
    % Update ball positions

    % With Day/Night boundary
    [dx1, dy1, squares] = updateSquareAndBounce(x1, y1, dx1, dy1, 1, squares, SQUARE_SIZE, hAx);
    [dx2, dy2, squares] = updateSquareAndBounce(x2, y2, dx2, dy2, 2, squares, SQUARE_SIZE, hAx);
    [dx3, dy3, squares] = updateSquareAndBounce(x3, y3, dx3, dy3, 3, squares, SQUARE_SIZE, hAx);
    [dx4, dy4, squares] = updateSquareAndBounce(x4, y4, dx4, dy4, 4, squares, SQUARE_SIZE, hAx);

    % With square box boundary
    [dx1, dy1] = checkBoundaryCollision(x1, y1, dx1, dy1, SQUARE_SIZE, hAx);
    [dx2, dy2] = checkBoundaryCollision(x2, y2, dx2, dy2, SQUARE_SIZE, hAx);
    [dx3, dy3] = checkBoundaryCollision(x3, y3, dx3, dy3, SQUARE_SIZE, hAx);
    [dx4, dy4] = checkBoundaryCollision(x4, y4, dx4, dy4, SQUARE_SIZE, hAx);

    % Move the balls
    x1 = x1 + dx1;
    y1 = y1 + dy1;
    x2 = x2 + dx2;
    y2 = y2 + dy2;
    x3 = x3 + dx3;
    y3 = y3 + dy3;
    x4 = x4 + dx4;
    y4 = y4 + dy4;

    % Update ball graphics objects
    hBall1.XData = x1-SQUARE_SIZE/2;
    hBall1.YData = y1-SQUARE_SIZE/2;
    hBall2.XData = x2-SQUARE_SIZE/2;
    hBall2.YData = y2-SQUARE_SIZE/2;
    hBall3.XData = x3-SQUARE_SIZE/2;
    hBall3.YData = y3-SQUARE_SIZE/2;
    hBall4.XData = x4-SQUARE_SIZE/2;
    hBall4.YData = y4-SQUARE_SIZE/2;

    % Update the colored map
    hIm.CData = squares';

    % Pause for a brief moment to control the speed of the animation
    pause(0.01);
end
end

function [dx, dy, squares] = updateSquareAndBounce(x, y, dx, dy, color, squares, SQUARE_SIZE, hAx)
% This function updates the color of the squares and calculates the new direction
% if a collision with a different colored square occurs.

numSquaresX = size(squares, 1);
numSquaresY = size(squares, 2);

% Check multiple points around the ball's circumference
for angle = 0:pi/4:(2*pi-pi/4) % four directions
    checkX = x + cos(angle) * (SQUARE_SIZE / 2);
    checkY = y + sin(angle) * (SQUARE_SIZE / 2);

    ii = floor(checkX / SQUARE_SIZE);
    jj = floor(checkY / SQUARE_SIZE);

    if ii >= 1 && ii <= numSquaresX && jj >= 1 && jj <= numSquaresY
        if ~(squares(ii, jj) == color)
            squares(ii, jj) = color;

            % Determine bounce direction based on the angle
            if abs(cos(angle)) > abs(sin(angle))
                dx = -dx;
            else
                dy = -dy;
            end

            % Add some randomness to the bounce to prevent the balls from getting stuck in a loop
            dx = dx*(1+0.01*(rand-0.5));
            dy = dy*(1+0.01*(rand-0.5));
        end
    end
end
end


function [dx, dy] = checkBoundaryCollision(x, y, dx, dy, SQUARE_SIZE, hAx)
% This function checks for collisions with the boundaries of the canvas.

if (x + dx >= hAx.XLim(2) - SQUARE_SIZE / 2) || (x + dx <= SQUARE_SIZE / 2)
    dx = -dx;
end
if (y + dy >= hAx.YLim(2) - SQUARE_SIZE / 2) || (y + dy <= SQUARE_SIZE / 2)
    dy = -dy;
end
end