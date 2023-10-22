%
% Fitness function
%

function L=TourLength(tour,model)
%     popRoute = zeros(popSize,nBreaks);         % population of routes
n=numel(tour);%51
nSalesmen=model.S;

cutoff=floor(((n-1+nSalesmen)/nSalesmen)+1);%9;
cutRange=floor(n/cutoff);
cutRange1=nSalesmen-1;%2
pBreak1=[];
for g = 1:cutRange1    
   pBreak1(g)= cutoff*g;    
end

% tmpBreaks = randperm(n-cutoff, nSalesmen-1)
% nBreaks = nSalesmen-1;
pBreak = sort(pBreak1);%(1:nBreaks));
rng = [[1 pBreak+1];[pBreak n]]';
 d=zeros(1, nSalesmen);
% tour
firstmatrix=diff(rng,1,2);  
%   model.D
for s = 1:nSalesmen
    
                d(s) = d(s) + model.D(1,tour(rng(s,1))); % Add Start Distance
                 
                for k = rng(s,1):rng(s,2)-1
                    d(s) = d(s)+ model.D(tour(k),tour(k+1));
                end
                d(s) = d(s) + model.D(tour(rng(s,2)),1); % Add End Distance
                
end


%Length
L = sum(d(1:s))    ;
    

end