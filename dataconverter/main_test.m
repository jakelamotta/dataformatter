function main_test

S.fH = figure('menubar','none');
im = imread( 'C:\Users\Public\Pictures\Sample Pictures\Chrysanthemum.jpg' );
y_min = NaN;
y_max = NaN;
x_min = NaN;
x_max = NaN;

S.aH = axes;
S.iH = imshow( im ); hold on
axis image;
d = 4;
X = [];
Y = [];

set(S.aH,'ButtonDownFcn',@startDragFcn)
set(S.iH,'ButtonDownFcn',@startDragFcn)
set(S.fH, 'WindowButtonUpFcn', @stopDragFcn);

function startDragFcn(varargin)
    set( S.fH, 'WindowButtonMotionFcn', @draggingFcn );
    pt = get(S.aH, 'CurrentPoint');
    x = pt(1,1);
    y = pt(1,2);
    X = x;
    Y = y;
end

function draggingFcn(varargin)
    S.iH = imshow( im ); hold on
    
    set(S.aH,'ButtonDownFcn',@startDragFcn)
    set(S.iH,'ButtonDownFcn',@startDragFcn)
    set(S.fH, 'WindowButtonUpFcn', @stopDragFcn);
    
    pt = get(S.aH, 'CurrentPoint');
    x = pt(1,1);
    y = pt(1,2);
    
    X = [X x];
    Y = [Y y];
    
    if isnan(x_min)
        x_min = x;
        x_max = x;
        y_min = y;
        y_max = y;
    end
    
    avgX = (x_min+x_max)/2;
    avgY = (y_min+y_max)/2;
    
    
    y_min = min(Y);
    x_min = min(X);
    x_max = max(X);
    y_max = max(Y);
    
    if x < avgX && y < avgY   
        x_min = max(x,x_min);
        y_min = max(y,y_min);
    elseif x > avgX && y < avgY    
        x_max = min(x,x_max);
        y_min = max(y,y_min);
    elseif x < avgX && y > avgY
        x_min = max(x,x_min);
        y_max = min(y,y_max);
    elseif x > avgX && y > avgY
        x_max = min(x,x_max);
        y_max = min(y,y_max);
    end
     
    plot([x_min,x_max],[y_min,y_min]);
    plot([x_min,x_max],[y_max,y_max]);
    plot([x_min,x_min],[y_min,y_max]);
    plot([x_max,x_max],[y_min,y_max]);
    
    hold off
end

function stopDragFcn(varargin)
    set(S.fH, 'WindowButtonMotionFcn', '');  %eliminate fcn on release
end

end