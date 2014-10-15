function data = myTable(h,data)
    %h = figure('Position',[600 400 402 100],'numbertitle','off','MenuBar','none');
    defaultData = data;
    t = uitable(h,'Units','normalized','Position',[.10 .4, .8 .3],'Data', defaultData,'Tag','myTable',...
        'ColumnName', [],'RowName',[],...
        'CellSelectionCallback',@cellSelect);
    disp(get(t,'Position'));
    % create pushbutton to delete selected rows
    uicontrol(h,'Style','pushbutton','String','Delete','Callback',@deleteRow);
    
    %uiwait(h);
    data = get(t,'Data');
end

function cellSelect(src,evt)
    % get indices of selected rows and make them available for other callbacks
    index = evt.Indices;
    
    if any(index)             %loop necessary to surpress unimportant errors.
        rows = index(:,1);
        set(src,'UserData',rows);
    end
end

function deleteRow(~,~)
    th = findobj('Tag','myTable');
    % get current data
    data = get(th,'Data');
    % get indices of selected rows
    rows = get(th,'UserData');
    % create mask containing rows to keep
    mask = (1:size(data,1))';
    mask(rows) = [];
    % delete selected rows and re-write data
    data = data(mask,:);
    set(th,'Data',data);
end