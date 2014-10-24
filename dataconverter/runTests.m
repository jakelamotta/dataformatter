function runTests()
    output = true;
    
    funcMap = {@testfilters,@testxlswriter,@testSpectroAdapter,@testDataManager};
    
    l = length(funcMap);
    
    for i=1:l
        temp = funcMap{1,i};
        output = output & temp();
        if ~temp()
            disp([char(temp),' failed']);
        end
    end
    
%     [temp,obj] = testSpectroAdapter();
%     output = output & testxlswriter(obj);
%     output = output & temp;
%     
%     output = output & testfilters(output,obj);
    
    if output
        disp('Tests were succesfull!');
    %else
    %    disp('Tests failed');
    end
end

function output = testfilters()
    [~,obj] = testSpectroAdapter();
    output = true & testSpectroFilter(obj);
    
    ad = WeatherDataAdapter();
    obj = ad.getDataObject({'C:\Users\Kristian\Documents\GitHub\dataformatter\dataconverter\data\02-Oct-2014\Blåsippa\positive\2\Weather\Uppsala_temp_rh_p_aug_sep_2014.dat'});
    output = output & testWeatherFilter(obj);
    
    ad = AbioticDataAdapter();
    obj = ad.getDataObject({'C:\Users\Kristian\Documents\GitHub\dataformatter\dataconverter\data\02-Oct-2014\Blåsippa\positive\1\Abiotic\abtest.txt'});
    output = output & testAbioticfilter(obj);
    
end
function [outp,obj] = testSpectroAdapter()
    paths = {'C:\Users\Kristian\Documents\GitHub\dataformatter\dataconverter\test\02-Oct-2014\Blåsippa\positive\2\Spectro\rawData.txt'};
    adapter = SpectroDataAdapter();
    obj = adapter.getDataObject(paths);
    
    if strcmp(class(obj),'DataObject')
        outp = true;
    else
        outp = false;
        disp(class(obj));
    end
    
    mat = obj.getMatrix();
    
    outp = outp && mat{2,10} < 463;
    outp = outp && mat{2,10} > 461;
    outp = outp && mat{2,11} < 1149;
    outp = outp && mat{2,11} > 1147;        
end

function output = testDataManager()
    m = DataManager(InputManager());
    
    paths = {'C:\Users\Kristian\Documents\GitHub\dataformatter\dataconverter\test\02-Oct-2014\Blåsippa\positive\2\Spectro\rawData.txt'};
    m.appendObject('awer',paths);
    
    spectro = m.getObject().getSpectroData();
    mat = m.getObject().getMatrix();
    
    output = ~isempty(spectro.obs1.x);
    output = output & ~isempty(mat{2,10});
    output = output & ~isempty(mat{2,11});
    
    
end


function output = testxlswriter()
    w = XLSWriter();
    obj = DataObject();
    output = true;
    [~,~,t] = xlsread('C:\Users\Kristian\Documents\GitHub\dataformatter\dataconverter\data\a');
    fname = 'C:\Users\Kristian\Documents\GitHub\dataformatter\dataconverter\test\testa';
    obj.setMatrix(t);
    tic;
    
    
    s= w.writeToXLS(fname,obj);
        
    a = toc;
    output = output & s;
    
    output = output & (1>=a);    
    
end

function outp = testAbioticfilter(obj)
filter = AbioticFilter();
    
    filtered = filter.filter(obj,'average');
    outp= strcmp(class(filtered),'DataObject');
    
        
    mat = filtered.getMatrix();
    outp = outp & ~isempty(mat{2,7});
        outp = outp & ~isempty(mat{2,8});
        outp = outp & ~isempty(mat{2,9});
    
end

function outp = testSpectroFilter(obj)

    filter = SpectroFilter();
    
    filtered = filter.filter(obj,'sample',60);
    outp= strcmp(class(filtered),'DataObject');
    
    outp = outp & ~(length(filtered.getMatrix()) < 10);
        
    mat = filtered.getMatrix();
    if length(mat) > 120
        outp = outp & ~isempty(mat{2,40});
        outp = outp & ~isempty(mat{2,85});
        outp = outp & ~isempty(mat{2,120});
    else
       outp = false; 
    end
end

function outp = testWeatherFilter(obj)

    filter = WeatherFilter();
    
    filtered = filter.filter(obj,'sample');
    outp= strcmp(class(filtered),'DataObject');
    
        
    mat = filtered.getMatrix();
    
    outp = outp & ~isempty(mat{2,4});
    outp = outp & ~isempty(mat{2,5});
    outp = outp & ~isempty(mat{2,6});
    
end