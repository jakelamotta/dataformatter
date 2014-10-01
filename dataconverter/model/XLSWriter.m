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
            toSave = obj;
            
            if exist(fname,'file');
                [~,~,old] = xlsread(fname);
                
                toAppend = obj.getMatrix();
                s = size(toAppend);
                temp = [];
                
                for i=2:s(1)
                    temp(end+1) = i;
                end
                
                toAppend = toAppend(temp,:);
                
                toSave = toSave.setMatrix([old;toAppend]);
            end
            
            success = this.writeToXLS(fname,toSave);            
        end        
    end    
end

