classdef DataManager
    %DATAMANAGER Summary of this class goes here
    %Detailed explanation goes here
    
    properties (SetAccess = private)
        xlsWriter;
        adapter;
        manager;
        dataObject;
    end
    
    methods (Access=public)        
        function this = DataManager()
            manager = InputManager();
            xlsWriter = XLSWriter();        
        end
    end
    
    methods (Access = private)
        
        function this = addComment(this,row,comment)
            d = this.dataObject;
            size_ = size(d);
            for i=2:size_(2)
                if strcmp(d{1,i},'Comment')
                    d{row,i} = [d{row,i},' ',comment];
                    break;
                end
            end
        end
        
        function this = removeColumn(this,col)
        end
        
        function this = removeRow(this,row)
        end        
    end
end

