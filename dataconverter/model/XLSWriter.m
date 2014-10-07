classdef XLSWriter
    %XLSWRITER Class responsible for writing dataobjects to a xls-file
    %(excel)
    
    properties
    end
    
    methods (Access = public)
        
        function success = writeToXLS(this,fileName,obj)
            try
                xlswrite(fileName,obj.getMatrix());
                success = exist(fileName,'file');
            
            catch e
                errordlg(e.getReport(),'Error');
            end
        end
        
        function success = appendXLS(this,fname,obj)
            toSave = obj;
            
            try
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
            catch e
                errordlg(e.getReport(),'Error!');
            end
            success = this.writeToXLS(fname,toSave);            
        end        
    end    
end

