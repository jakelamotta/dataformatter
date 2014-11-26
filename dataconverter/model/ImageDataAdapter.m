classdef ImageDataAdapter < DataAdapter
    %IMAGEDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties        
        tempMatrix;
    end
    
    methods (Access = public)
        
        function this = ImageDataAdapter()        
            this.tempMatrix = {'Contrast','Correlation','Energy','homogenity','ent','alpha'};
            this.dobj = DataObject();
        end
        
        function obj = getDataObject(this,paths,varargin)
            tic;
            size_ = size(paths);
            
            inputManager = varargin{2};
            handler = inputManager.getDataManager().getHandler();
            
            images = struct;
            
            for i=1:size_(2)
                idx = strfind(paths{1,i},'\');
                
                try
                    id_ = paths{1,i}(idx(end-2)+1:idx(end-1)-1);
                    
                    if ~isfield(images,id_)
                        images.(strrep(id_,'.','')) = {[];[];[]};
                    end
                    
                catch e
                    errordlg(['Incorrect path was passed to the file reader. Matlab error: ',e.message()]);
                end
                
                rawData = this.fileReader(paths{1,i});
                %h = image(rawData);
                images.(strrep(id_,'.','')) = [images.(strrep(id_,'.','')),{rawData;paths{1,i}(idx(end)+1:end);false}];
            end
            
            fnames = fieldnames(images);
            nrOfFnames = length(fnames);
            
            
            for i=1:nrOfFnames
                fname = images.(fnames{i});
                [ims,cont] = handler.getCroppedImage(fname,paths{1,i});
                %[im,keep] = handler.getCroppedImage(rawData,paths{1,i});
                
                if cont
                    s = size(ims);
                    
                    for i=1:s(2) 
                        im = ims{1,i};
                        keep = ims{3,i};
                        if keep
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

                            this.tempMatrix = [this.tempMatrix;parameters];

                            imwrite(im,[paths{1,i}(1:end-4),'_cropped.jpg']);
                        end 
                    end
                end
            end
            
            this.dobj.setObservation(this.tempMatrix,id_);
            obj = this.dobj;
            toc
        end
        
        function rawData = fileReader(this,path)
            rawData = imread(path); % load image
        end        
    end    
end

