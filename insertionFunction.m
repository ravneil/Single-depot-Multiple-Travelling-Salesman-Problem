function [S] = insertionFunction(x,l, v,n,slotsz)

% 
model=CreateModel(slotsz);

%% Avoiding infeasible solutions
nSalesmen=model.S;
cutoff=floor(((n-1+nSalesmen)/nSalesmen)+1);%9;
cutRange=floor(n/cutoff);
cutRange1=nSalesmen-1;%2
pBreak1=[];
for g = 1:cutRange1    
   pBreak1(g)= cutoff*g;    
end

pBreak = sort(pBreak1);%(1:nBreaks));
rng = [[1 pBreak+1];[pBreak n]]';


F = l;
x_temp = x;    
y=x_temp;

if v>=1 %%v>1 && v<n

 % Swap
 %Two random positions are swapped

    i=randperm(n,2);%randperm randsample
    pos1=i(1);
    pos2=i(2);

     if pos1<=pos2
        temp=x_temp([pos1:pos2]);
        temp=flip(temp);
         x_temp([pos1:pos2])=temp;
     end
     if pos1>pos2
         temp=x_temp([pos2:pos1]);
        temp=flip(temp);
         x_temp([pos2:pos1])=temp;
     end 

        i=randperm(n,2);%randperm randsample
    pos1=i(1);
    pos2=i(2);

     if pos1<=pos2
        temp=x_temp([pos1:pos2]);
        temp=flip(temp);
         x_temp([pos1:pos2])=temp;
     end
     if pos1>pos2
         temp=x_temp([pos2:pos1]);
        temp=flip(temp);
         x_temp([pos2:pos1])=temp;
     end 
   
end
if v>=100%v==1 %v>n
  %%Swap plus shift
  
 i=randperm(n,2);%randperm randsample
    pos1=i(1);
    pos2=i(2); 

 if pos1<=pos2
    temp=x_temp([pos1:pos2]);
    temp=flip(temp);
     x_temp([pos1:pos2])=temp;
 end
 if pos1>pos2
     temp=x_temp([pos2:pos1]);
    temp=flip(temp);
     x_temp([pos2:pos1])=temp;
     
 end 
    
end



if v>=100%v>=5 %%v==0
  %%swap, shift and sysm
 i=randperm(n,2);%randperm randsample
    pos1=i(1);
    pos2=i(2); 
    
  i=randperm(n,2);%randperm randsample 
    
i1=i(1);%%% do both swap and shift
 i2=i(2);
    y([i1 i2])=x_temp([i2 i1]);
    x_temp=y;    

end

 S = x_temp;

