classdef BehaviorDataAdapter < DataAdapter
    %BEHAVIORDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        tempMatrix;
        varMap;
        size_;
    end
    
    methods (Access = public)
        
        function this = BehaviorDataAdapter()
            global matrixColumns;
            this.tempMatrix = matrixColumns;
            this.dobj = Observation();
            global varmap;
            this.varMap = varmap;
            s = size(this.tempMatrix);
            this.size_ = s(2);
        end
        
        function rawData = fileReader(this,path)
            try
                [~,~,rawData] = xlsread(path);
            catch
                errordlg('Incorrect path, excel file for behavior data could not be read');
            end
        end
        
        function obj = getDataObject(this,paths)
            s = size(paths);
            
            for i=1:s(2)
                if strfind(paths{1,i}(end-3:end),'xls')
                    idx = strfind(paths{1,i},'\');

                    try
                        id_ = paths{1,i}(idx(end-2)+1:idx(end-1)-1);
                    catch
                        errordlg('Incorrect path was passed to the file reader');
                    end

                    if strfind(paths{1,i}(idx(end):end),'template1.xlsx')
                        system(['start ',paths{1,i}]);
                        hdg = helpdlg('Please fill in the template, close it and press OK','Information');
                        waitfor(hdg);
                        
                        toRemove = paths{1,i};
                        newFileName = 'autoNamedfile.xlsx';
                        
                        paths{1,i} = paths{1,i}(1:end-13);
                        paths{1,i} = [paths{1,i},newFileName];
                        
                        copyfile(toRemove,paths{1,i});
                        delete(toRemove);
                    end

                    path = paths{1,i};

                    rawData = this.fileReader(path);
                    this = this.parse(rawData);

                    
                end
                obj = this.dobj.setObservation(this.tempMatrix,id_);
            end
        end        
    end
    
    methods (Access = private)
        function this = parse(this,rawData)
            nrOfRows = size(rawData);
            global matrixColumns;
            this.tempMatrix = matrixColumns;
            for i=1:nrOfRows(1)
                if isnan(rawData{i,6})
                    rawData{i,6} = '';
                end
            end
            
            
            idx = strfind(rawData(:,6),'Behaviour');
            
            for i=1:length(idx)
                if ~isempty(idx{i})
                    idx{i} = i;
                end
            end
            
            idx = idx(~cellfun('isempty',idx));
            
            toAppend = cell(length(idx),this.size_);
            this.tempMatrix = [this.tempMatrix;toAppend];
            disp(length(idx))
            for i=1:length(idx)-1
                obs = [rawData(idx{i}:idx{i+1}-1,6),rawData(idx{i}:idx{i+1}-1,8:9)];
                obsSize = size(obs);
                %disp(i);
                %disp(rawData(idx{i}:idx{i+1}-1,6));
                for k=2:obsSize(1)
                    if ~isnan(obs{k,1})
                        
                        var1 = this.varMap([obs{k,1},'d']);
                        var2 = this.varMap([obs{k,1},'f']);
                        for j=1:this.size_
                            
                            if strcmp(this.tempMatrix{1,j},var1)
                                this.tempMatrix{i+1,j} = obs{i+1,2};
                            end
                            if strcmp(this.tempMatrix{1,j},var2)
                                this.tempMatrix{i+1,j} = obs{i+1,3};
                            end
                        end
                    end
                end
            end
            
            i = length(idx);
            
            obs = [rawData(idx{i}:end,6),rawData(idx{i}:end,8:9)];
            obsSize = size(obs);
            %disp(i);
            %disp(rawData(idx{i}:idx{i+1}-1,6));
            for k=2:obsSize(1)
                if ~isnan(obs{k,1})
                    
                    var1 = this.varMap([obs{k,1},'d']);
                    var2 = this.varMap([obs{k,1},'f']);
                    for j=1:this.size_
                        if strcmp(this.tempMatrix{1,j},var1)
                            this.tempMatrix{i+1,j} = obs{i+1,2};
                        end
                        
                        if strcmp(this.tempMatrix{1,j},var2)
                            this.tempMatrix{i+1,j} = obs{i+1,3};
                        end
                    end
                end
            end
            
            
        end
    end
end

