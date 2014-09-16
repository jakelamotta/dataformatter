classdef XLSWriter
    %XLSWRITER Class responsible for writing dataobjects to a xls-file
    %(excel)
    
    properties
        dataObject
    end
    
    methods (Static)
        
        
        function success = writeToXLS(fileName)
            xlswrite(fileName,obj.xlsMatrix);
            success = exist(fileName,'file');
        end
        
        
        function success = appendXLS(fname,obj)
            
            if exist(fname,'file');
                [~,old,~] = xlsread(fname);
                toSave = [old;obj.xlsMatrix];
            else
                toSave = obj.xlsMatrix;
            end
            
            success = writeToXLS(fname,toSave);            
        end
        
    end
    
end

