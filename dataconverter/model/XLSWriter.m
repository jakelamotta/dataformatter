classdef XLSWriter < AbstractWriter
    %XLSWRITER Class responsible for writing dataobjects to a xls-file
    %(excel)
    
    properties
        dataObject
    end
    
    methods (Access = private)
        
        function success = writeToXLS(this)
            xlswrite(fileName,this.dataObject);
            success = exist(fileName,'file');
        end
        
    end
    
end

