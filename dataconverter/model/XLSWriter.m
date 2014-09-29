classdef XLSWriter
    %XLSWRITER Class responsible for writing dataobjects to a xls-file
    %(excel)
    
    properties
    end
    
    methods (Access = public)
        
        function success = writeToXLS(this,fileName,obj)
            xlswrite(fileName,obj.getMatrix());
            success = exist(fileName,'file');
        end
        
        
        function success = appendXLS(this,fname,obj)
            
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

