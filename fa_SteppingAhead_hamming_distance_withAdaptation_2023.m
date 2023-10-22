%
%
%

clc;
clear;
close all;

%% Problem Definition
for you=1:1%2%%%User update
    global slotsz;
    slotsz= you;
%storing in file
fileID = fopen('resultsFireflyModified_tsp_Final2023_new2023.txt','a+');
fprintf(fileID,'Problem %12.8f\r\n',slotsz);
Q=5;

 Analysis_output=[];  
 Analysis_iteration=[];
 run=30;  
%Update me with number of runs needed.    
for me=1:run%%%%User update
    
    
% if slotsz==1
model=CreateModel(slotsz);

CostFunction=@(x) TourLength(x,model);

nSalesmen=model.S;
nVar=model.n- 1

VarMin= 1;              % Decision Variables Lower Bound
VarMax= nVar;           % Decision Variables Upper Bound

VarSize=[1 nVar];       % Decision Variables Matrix Size

%% Firefly Algorithm Parameters

MaxIt=1000;         % Maximum Number of Iterations

nPop=50;            % Number of Fireflies (Swarm Size)

gamma=0.95;            % Light Absorption Coefficient

beta0=2;            % Attraction Coefficient Base Value

alpha=0.99;          % Mutation Coefficient

alpha_damp=0.90;    % Mutation Coefficient Damping Ratio

delta=0.05*(VarMax-VarMin);     % Uniform Mutation Range

m=2;

if isscalar(VarMin) && isscalar(VarMax)
    dmax = (VarMax-VarMin)*sqrt(nVar);
else
    dmax = norm(VarMax-VarMin);
end

%% Initialization

% Empty Firefly Structure
firefly.Position=[];
firefly.Cost=[];
firefly.Step=[];

% Initialize Population Array
pop=repmat(firefly,nPop,1);

% Initialize Best Solution Ever Found
BestSol.Cost=inf;

% Create Initial Fireflies
for i=1:nPop
   pop(i).Position=randperm([nVar])+1;
   pop(i).Cost=CostFunction(pop(i).Position);
      if pop(i).Cost<BestSol.Cost
       BestSol=pop(i);
      end
     
end



% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);


%% Firefly Algorithm Main

trigger=0;
T=0.1;
for it=1:MaxIt
    
    newpop=repmat(firefly,nPop,1);
    for i=1:nPop
        newpop(i).Cost = inf;
        for j=1:nPop
            if pop(j).Cost <= pop(i).Cost %|| (pop(j).Cost-pop(i).Cost)<=Q
%                 rij=norm(pop(i).Position-pop(j).Position)/dmax;
                rij=hammingDistance(pop(j).Position,pop(i).Position);
                b = rij * gamma^it;
                 a=1;
                 v = round(a + (b-a) * rand);
                [Seet] = insertionFunction(pop(i).Position,pop(i).Cost, v,nVar, slotsz); 
                newsol.Position = Seet;%q;                
                newsol.Cost=CostFunction(newsol.Position);
                newsol.Step=[];
                 rij=hammingDistance(pop(j).Position,newsol.Position);
                 b = rij * gamma^it;
                 a=1;
                 v = round(a + (b-a) * rand);
                    if (newsol.Cost-pop(j).Cost)>=Q || (newsol.Cost==pop(j).Cost)%% activate stepping ahead
                     [Seet] = insertionFunction(pop(j).Position,pop(j).Cost, v,nVar, slotsz); 
                    end
                    
                 newsol1.Position = Seet;%q;                
                newsol1.Cost=CostFunction(newsol1.Position);
                newsol1.Step=[];
    if newsol1.Cost < newsol.Cost
        newsol=newsol1;
    end
                if newsol.Cost < newpop(i).Cost 
                    newpop(i) = newsol;
                    if newpop(i).Cost<BestSol.Cost
                        BestSol=newpop(i);
                    end
                end 
                
            end
        end
    end
   
    
      [~, ia1,c1] = unique([pop.Cost]);
      for i=1:size(ia1,1)
        pop(i)=pop(ia1(i));
      end %
      [~, ia1,c1] = unique([newpop.Cost]);
      for i=1:size(ia1,1)
        newpop(i)=newpop(ia1(i));
      end %
%         [~, SortOrder]=sort([pop.Cost]);
%         pop=pop(SortOrder);
        ii=randperm(nPop);%random slots picked 
        for i = 1:nPop
            if newpop(ii(i)).Cost <= pop(ii(i)).Cost
                pop(ii(i)) = newpop(ii(i));       
            else      
                if rand <=(exp(-((newpop(ii(i)).Cost-pop(ii(i)).Cost)/pop(ii(i)).Cost)/T)) %|| (newpop(i).Cost-pop(i).Cost)<=Q   
                    pop(ii(i)) = newpop(ii(i));
                end
            end              
        end 
     
    % Truncate
    pop=pop(1:nPop);
    [~, SortOrder]=sort([pop.Cost]);
    pop=pop(SortOrder);
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Cost;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);

        if it > 100
           if BestCost(it) == BestCost(it-99)
%             
             break;
           end
        end

%     pause(0.01);
T = T*alpha;
Q=(Q+alpha)*rand;
end

%% Results
% fprintf(fileID,'%6s %12s\r\n','Run','Fitness');
fprintf(fileID,'%6.2f %e\r\n',me,BestCost(it));

Analysis_output(me)=BestCost(it);
Analysis_iteration(me)=it-99;


if (me==run)
 Mean_Output = mean(Analysis_output);
 Median_Output = median(Analysis_output);
 Max_Output = max(Analysis_output);
 Min_Output = min(Analysis_output);
 val = sum(Analysis_output == Min_Output);
 numc= sum(Analysis_output(:) == Min_Output);
 
 idx=find(Analysis_output==Min_Output)
 Best_Iteration = Analysis_iteration(idx(1));
 Mean_iterationOverall=mean(Analysis_iteration);
 
  fprintf(fileID,'Min %12.8f\r\n',Min_Output);
 fprintf(fileID,'Median %12.8f\r\n',Median_Output);
 fprintf(fileID,'Max %12.8f\r\n',Max_Output);
 fprintf(fileID,'Mean %12.8f\r\n',Mean_Output);
 fprintf(fileID,'No. of Iteratation for Best  %12.8f\r\n',Best_Iteration);
 fprintf(fileID,'Count Max %5.5f\r\n',val); 
end

end

figure;
plot(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;

s2 = '.png';
s1 = num2str(you);
s = strcat('',s1,s2,'');
saveas(gcf,s)
end
