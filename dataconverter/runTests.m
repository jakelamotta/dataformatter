function runTests()
    clear all;
    clear classes;
    
    
    output = true;
    
    funcMap = {@testfilters,@testxlswriter,@testSpectroAdapter,@testBehaviorAD,@testPadMatrix,@testcombine2,@testmerge2};
    
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
    else
        disp('Tests failed');
    end
end

function output = testPadMatrix()
    output = true;
    
    a = {1,2,3;4,5,6};
    b = {1,2,3,4,5,6,7;8,9,10,11,12,13,14};
    
    
    test1 = {1,2,3,4,5,6,7;4,5,6,[],[],[],[]};
    test2 = {};
    
    [a,b] = Utilities.padMatrix(a,b);
    
    output = output & (a{1,1} == test1{1,1});
    output = output & (a{1,5} == test1{1,5});
    output = output & (isempty(a{2,4}) & isempty(test1{2,4}));
    output = output & (a{2,3} == test1{2,3});
    output = output & (a{1,3} == test1{1,3});
    
    [a,b] = Utilities.padMatrix({},{});
    output = output & (length(a) == length(test2));

end

function output = testcombine2()
    a = {'are','ID','some','no','empty';12,'wef',[],[],'aw'};
    b = {'are','ID','some','no','empty';[],'wef',[],3,'aw';[],'bef',[],[1,2,3],[]};
    ipm = InputManager();
    
    man = DataManager(ipm);
    obj1 = DataObject();
    obj1.setMatrix(b);
    
    man.setObject(obj1);
    
    obj2 = DataObject();
    obj2.setMatrix(a);
    
    ut = man.combine2(obj2,'wef');
    c = ut.getMatrix();
    output = true;
    s = size(c);
    output = output & (s(1) == 2);
    output = output & strcmp(c{2,2},'wef');
    output = output & (c{2,1} == 12);
    output = output & (isempty(c{2,3}));
end

function output = testmerge2()
    ipm = InputManager();
    
    man = DataManager(ipm);
    
    a = {'are','ID','some','no','empty';12,'tef',[],[],'aw'};
    b = {'are','ID','some','no','empty';[],'wef',[],3,'aw';[],'bef',[],[1,2,3],[]};
    
    obj1 = DataObject();
    obj1.setMatrix(b);
    
    man.setObject(obj1);
    
    obj2 = DataObject();
    obj2.setMatrix(a);
    
    man.setUnfObject(obj2);
    
    man.merge2();
    obj = man.getObject().getMatrix();
    
    output = true;
    output = output & (man.getObject().getNumRows() == 4);
    output = output & (strcmp(obj{4,2},'tef'));
    output = output & (strcmp(obj{2,2},'wef'));
    
end

function output = testBehaviorAD()
    
    paths = {'C:\Users\Kristian\Documents\GitHub\dataformatter\dataconverter\test\02-Oct-2014\Bl�sippa\positive\2\Behavior\behave'};
    
    ad = BehaviorDataAdapter();
    obj = ad.getDataObject(paths);
    
    output = isa(obj,'DataObject');
    mat = obj.getMatrix();
    output = ~output;
    for i=1:length(mat)
        
        if strcmp(mat{1,i},'B_Hover_dur')
            output = (mat{2,i} == 5.5);
            output = ~output;
        end
        
        if strcmp(mat{1,i},'B_Lsit_freq')
            output = (mat{2,i} == 7);
        end 
    end
    
end

function output = testfilters()
    [~,obj] = testSpectroAdapter();
    output = true & testSpectroFilter(obj);
    
    ad = WeatherDataAdapter();
    obj = ad.getDataObject({'C:\Users\Kristian\Documents\GitHub\dataformatter\dataconverter\data\02-Oct-2014\Bl�sippa\positive\2\Weather\Uppsala_temp_rh_p_aug_sep_2014.dat'});
    output = output & testWeatherFilter(obj);
    
    ad = AbioticDataAdapter();
    obj = ad.getDataObject({'C:\Users\Kristian\Documents\GitHub\dataformatter\dataconverter\data\02-Oct-2014\Bl�sippa\positive\1\Abiotic\abtest.txt'});
    output = output & testAbioticfilter(obj);
    
end
function [outp,obj] = testSpectroAdapter()
    paths = {'C:\Users\Kristian\Documents\GitHub\dataformatter\dataconverter\test\02-Oct-2014\Bl�sippa\positive\2\Spectro\rawData.txt'};
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
    
    paths = {'C:\Users\Kristian\Documents\GitHub\dataformatter\dataconverter\test\02-Oct-2014\Bl�sippa\positive\2\Spectro\rawData.txt'};
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
        outp = outp & ~isempty(mat{2,40+18});
        outp = outp & ~isempty(mat{2,85+18});
        outp = outp & ~isempty(mat{2,120+18});
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