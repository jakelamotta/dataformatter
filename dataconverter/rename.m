%f=dir('/Users/olgadyakovOlgaa/Documents/natural_scenes/naturalscenes_new');
f = dir();
length(f)

 

for k=3:length(f)

    
    t=[num2str(k) ,'.odt'];

%    if isdir( f(k).name)

    copyfile(f(k).name,t)

%     delete(f(k).name)

%    end

 

end