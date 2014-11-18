function ImageClickCallback(objHandle, eventData)
    axesHandle = get(objHandle,'Parent');
    coordinates = get(axesHandle,'CurrentPoint'); 
    coordinates = coordinates(1,1:2)
end

