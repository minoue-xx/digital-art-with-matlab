% MATLAB implementation of pong wars, the idea is taken from the following (Javascript)
% https://github.com/vnglst/pong-wars/blob/main/index.html
% Idea for Pong wars: https://twitter.com/nicolasdnl/status/1749715070928433161
function pong_wars
% Define the color palette
% Source palette: https://twitter.com/AlexCristache/status/1738610343499157872
colorPalette.MysticMint = [217, 232, 227] / 255;
colorPalette.NocturnalExpedition = [17, 76, 90] / 255;

% Define colors for day and night
DAY_COLOR = colorPalette.MysticMint;
NIGHT_COLOR = colorPalette.NocturnalExpedition;
DAY_BALL_COLOR = colorPalette.NocturnalExpedition;
NIGHT_BALL_COLOR = colorPalette.MysticMint;

% Define the figure and axes for the pong game
hFig = figure(Name="Pong Wars | MATLAB", NumberTitle="off", Color="white");
hAx = axes(Parent=hFig, XLim=[0 30], YLim=[0 30]);

% Define square size
SQUARE_SIZE = 1;
INITIAL_SPEED = 0.5;

% Calculate number of squares
numSquaresX = floor(hAx.XLim(2) / SQUARE_SIZE);
numSquaresY = floor(hAx.YLim(2) / SQUARE_SIZE);

% Initialize squares matrix (colored map)
squares = zeros(numSquaresX, numSquaresY);
squares(round(numSquaresX / 2):end,:) = 1; % night

hIm = imagesc(hAx,squares');
colormap([DAY_COLOR;NIGHT_COLOR]) % 0:day, 1:night

% Delete the axes box
hAx.XColor = "none";
hAx.YColor = "none";

% Initialize ball positions and velocities
x1 = hAx.XLim(2) / 4;
y1 = hAx.YLim(2) / 2;
dx1 = INITIAL_SPEED;
dy1 = -INITIAL_SPEED;

x2 = (hAx.XLim(2) / 4) * 3;
y2 = hAx.YLim(2) / 2;
dx2 = -INITIAL_SPEED;
dy2 = INITIAL_SPEED;

% Create ball graphics objects
hBall1 = line(x1-SQUARE_SIZE/2, y1-SQUARE_SIZE/2,Marker='o',...
    MarkerSize=8, MarkerFaceColor=DAY_BALL_COLOR);
hBall2 = line(x2-SQUARE_SIZE/2, y2-SQUARE_SIZE/2,'Marker','o',...
    MarkerSize=8, MarkerFaceColor=NIGHT_BALL_COLOR);

% Start the game loop
while ishandle(hFig)
    % Update ball positions

    % With Day/Night boundary
    DAY_COLORID = 0;
    [dx1, dy1, squares] = updateSquareAndBounce(x1, y1, dx1, dy1, DAY_COLORID, squares, SQUARE_SIZE, hAx);
    NIGHT_COLORID = 1;
    [dx2, dy2, squares] = updateSquareAndBounce(x2, y2, dx2, dy2, NIGHT_COLORID, squares, SQUARE_SIZE, hAx);

    % With square box boundary
    [dx1, dy1] = checkBoundaryCollision(x1, y1, dx1, dy1, SQUARE_SIZE, hAx);
    [dx2, dy2] = checkBoundaryCollision(x2, y2, dx2, dy2, SQUARE_SIZE, hAx);

    % Move the balls
    x1 = x1 + dx1;
    y1 = y1 + dy1;
    x2 = x2 + dx2;
    y2 = y2 + dy2;

    % Update ball graphics objects
    hBall1.XData = x1-SQUARE_SIZE/2;
    hBall1.YData = y1-SQUARE_SIZE/2;
    hBall2.XData = x2-SQUARE_SIZE/2;
    hBall2.YData = y2-SQUARE_SIZE/2;

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