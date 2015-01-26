classdef ImageDataAdapter < DataAdapter
    %IMAGEDATAADAPTER Class for adapting images to an Observation object
    
    properties       
    end
    
    methods (Access = public)
        
        function this = ImageDataAdapter()        
            this.tempMatrix = {'Contrast','Correlation','Energy','Homogenity','Entropy','Alpha'};
            this.dobj = Observation();
        end
        
        function this = addValues(this,p)
            this.tempMatrix = addValues@DataAdapter(this,p,this.tempMatrix);
        end
        
        %%Function for retrieving a Observation object with
        %%Image data
        %%Input - Cell of paths
        %%Output - Observation object
        function obj = getDataObject(this,paths,varargin)
            tic;
            
            [h,w] = size(paths);
            
            inputManager = varargin{2};
            handler = inputManager.getDataManager().getHandler();
            
            images = struct;
            folders = {};
            
            for i=1:w
                idx = strfind(paths{1,i},'\');
                
                [pathstr,name,ext] = fileparts(paths{1,i});
                
                try
                    id_ = paths{1,i}(idx(end-2)+1:idx(end-1)-1);
                    
                    if ~isfield(images,strrep(id_,'.','__'))
                       images.(strrep(id_,'.','__')) = {[];[];[]};
                       folders{end+1} = pathstr;
                    end
                    
                catch e
                    errordlg(['Incorrect path was passed to the file reader. Matlab error: ',e.message()]);
                end
                
                rawData = this.fileReader(paths{1,i});
                
                images.(strrep(id_,'.','__')) = [images.(strrep(id_,'.','__')),{rawData;paths{1,i}(idx(end)+1:end);false}];
            end
            
            fnames = fieldnames(images);
            nrOfFnames = length(fnames);
            
            for i=1:nrOfFnames
                fname = images.(fnames{i});
                [ims,cont] = handler.getCroppedImage(fname,fnames{i});
                
                if cont
                    s = size(ims);
                    
                    for h=1:s(2) 
                        im = ims{1,h};
                        keep = ims{3,h};
                        
                        if keep
                            [h,w,d] = size(im);
                            
                            if h~=w
                                im = im(max(h,w),max(h,w),:);
                            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Olga script below%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            % calculate parameters
                            k=graycomatrix(im, 'offset', [0 1; -1 1; -1 0; -1 -1],'NumLevels',256);
                            stats = graycoprops(k,{'contrast','homogeneity','Correlation','Energy'});
                            ent = entropy(im);

                            [M N] = size(im);
                            imfft = fftshift(fft2(im));
                            imabs = abs(imfft);
                            abs_av=rotavg(imabs);
                            freq2=0:N/2;

                            if length(freq2) < 10^2
                                xx=log(freq2(10:length(freq2)));
                                yy=log(abs_av(freq2(10:length(freq2))));
                            else
                                xx=log(freq2(10:10^2));
                                yy=log(abs_av(freq2(10:10^2)));
                            end

                            p=polyfit(xx',yy,1);
                            alpha=(-1)*p(1);

                            % get a result of 6 parameters for 1 image
                            parameters = {mean(stats.Contrast),mean(stats.Correlation),mean(stats.Energy),mean(stats.Homogeneity),ent alpha};
                            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Olga script above%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            this.tempMatrix = [this.tempMatrix;parameters];
                            
                            this = this.addValues(paths{1,i});
                            
                            this.dobj.setObservation(this.tempMatrix,strrep(fnames{i},'__','.'));
                            this.tempMatrix = {'Contrast','Correlation','Energy','Homogenity','Entropy','Alpha'};
                            imwrite(im,fullfile(folders{i},['cropped_',ims{2,h}]));
                        end 
                    end
                end
            end            
            
            obj = this.dobj;
            toc
        end
        
        function rawData = fileReader(this,path)
            rawData = imread(path); % load image
        end        
    end    
end

