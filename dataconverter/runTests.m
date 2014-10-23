function runTests()
    output = true;
    output = output & testSpectroAdapter();
    
    if output
        disp('Tests were succesfull!');
    else
        disp('Tests failed');
    end
end

function outp = testSpectroAdapter()
    paths = {'C:\Users\Kristian\Documents\GitHub\dataformatter\dataconverter\test\02-Oct-2014\Blåsippa\positive\2\Spectro\rawData.txt'};
    adapter = SpectroDataAdapter();
    obj = adapter.getDataObject(paths);
    outp = false;
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